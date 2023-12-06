from flask import Flask, render_template, request, redirect, url_for, flash, jsonify,session
import datetime
import mysql.connector
import openpyxl
import serial
import threading
from flask_socketio import SocketIO
from datetime import datetime, time
from functools import wraps

app = Flask(__name__)
app.secret_key = 'maha0508@#$'
socketio = SocketIO(app)

# Configure your MySQL connection
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'qrcode',
}

# Establish a connection to MySQL
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

# Create tables if they don't exist
cursor.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        full_name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        mobile BigINT NOT NULL,
        role VARCHAR(255) NOT NULL,
        month VARCHAR(255) NOT NULL,
        uuid_intern VARCHAR(255) UNIQUE NOT NULL
    )
""")

cursor.execute("""
    CREATE TABLE IF NOT EXISTS checkin_records (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT,
        checkin_time DATETIME NOT NULL,
        checkout_time DATETIME,
        FOREIGN KEY (user_id) REFERENCES users(id)
    )
""")
conn.commit()

latest_data = {}  # Global variable to store the latest entry and exit data

def authenticate_user(username, password):
    # Replace this with your actual authentication logic
    users = {
        'jana': {'password': 'jana', 'user_id': 1},
        'acickif': {'password': 'acickif@2023', 'user_id': 2},
        # Add more users as needed
    }

    if username in users and users[username]['password'] == password:
        return users[username]['user_id']
    else:
        return None

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'username' not in session:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # Assuming you have a function authenticate_user that checks the credentials
        user_id = authenticate_user(username, password)

        if user_id is not None:
            # Set user_id in the session
            session['user_id'] = user_id
            session['username'] = username

            return redirect(url_for('dashboard'))
        else:
            return render_template('login.html', error='Invalid username or password')

    return render_template('login.html')
@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('login'))




@app.route('/dashboard')
@requires_auth
def dashboard():
    # Replace the following placeholder data retrieval with your actual database queries

    # Get user information
    cursor.execute("SELECT * FROM users WHERE id = %s", (session['user_id'],))
    user_info = cursor.fetchone()

    # Get total members
    cursor.execute("SELECT COUNT(*) FROM users")
    total_members = cursor.fetchone()[0]

    # Get latest entry for the current user
    cursor.execute("""
        SELECT DATE(checkin_time) as date,
               GROUP_CONCAT(checkin_time ORDER BY checkin_time) as checkin_time,
               GROUP_CONCAT(checkout_time ORDER BY checkin_time) as checkout_time,
               GROUP_CONCAT(TIMEDIFF(checkout_time, checkin_time) ORDER BY checkin_time) as total_time
        FROM checkin_records
        WHERE user_id = %s
        GROUP BY date
        ORDER BY date DESC
        LIMIT 1
    """, (session['user_id'],))
    latest_entry_result = cursor.fetchone()

    latest_entry = None
    if latest_entry_result:
        date = latest_entry_result[0]
        checkin_times = latest_entry_result[1].split(',')
        checkout_times = latest_entry_result[2].split(',')
        total_times = latest_entry_result[3].split(',')

        latest_entry = {
            'date': date,
            'checkin_time': checkin_times[0],  # Assuming the latest entry's first check-in time
            'checkout_time': checkout_times[0],  # Assuming the latest entry's first check-out time
            'total_time': total_times[0]  # Assuming the latest entry's total time
        }

    # Get all members
    cursor.execute("SELECT * FROM users")
    all_members = cursor.fetchall()

    return render_template('dashboard.html', username=user_info[1], email=user_info[2],
                           role=user_info[5], total_members=total_members, latest_entry=latest_entry,
                           all_members=all_members)


@app.route('/')
def index():
    # Fetch latest entry and exit data for each user
    cursor.execute("""
        SELECT users.full_name, checkin_records.checkin_time, checkin_records.checkout_time
        FROM users
        JOIN checkin_records ON users.id = checkin_records.user_id
        ORDER BY checkin_records.checkin_time DESC
        LIMIT 5  # You can adjust the limit as needed
    """)
    entries = cursor.fetchall()

    # Organize data into a list of dictionaries
    latest_entries = []
    for entry in entries:
        user_name, entry_time, exit_time = entry
        latest_entries.append({
            'user_name': user_name,
            'entry_time': entry_time.strftime('%Y-%m-%d %H:%M:%S') if entry_time else None,
            'exit_time': exit_time.strftime('%Y-%m-%d %H:%M:%S') if exit_time else None,
        })

    return render_template('index.html', latest_entries=latest_entries)


@app.route('/check', methods=['POST'])
def check():
    barcode = request.form['barcode']

    # Check if the user with the given barcode exists
    cursor.execute("SELECT * FROM users WHERE uuid_intern = %s", (barcode,))
    user_result = cursor.fetchone()

    if not user_result:
        response = {'status': 'error', 'message': 'User not found.'}
        return jsonify(response)

    user_id, user_name = user_result[0], user_result[1]

    # Check if the user is already checked in for today
    cursor.execute("SELECT * FROM checkin_records WHERE user_id = %s AND DATE(checkin_time) = CURDATE() AND checkout_time IS NULL", (user_id,))
    result = cursor.fetchone()

    current_time = datetime.now()

    # Check if it's after 9 PM
    if current_time.time() >= time(21, 0):
        if result:
            # If already checked in, perform check-out
            cursor.execute("UPDATE checkin_records SET checkout_time = %s WHERE id = %s", (current_time, result[0]))
            conn.commit()

            # Calculate the total time difference in hours, minutes, and seconds
            hours, remainder = divmod((current_time - result[2]).total_seconds(), 3600)
            minutes, seconds = divmod(remainder, 60)

            # Format the total time as "X hours, Y minutes, and Z seconds"
            total_time = f'{int(hours)} hours, {int(minutes)} minutes, and {int(seconds)} seconds'

            response = {
                'status': 'success',
                'message': f'Auto-checked out at {current_time}\nTotal time spent: {total_time} for {user_name}'
            }
        else:
            response = {'status': 'success', 'message': f'No check-in for today after 9 PM for {user_name}'}
    else:
        # If not after 9 PM, proceed with regular check-in/check-out logic
        if result:
            # If already checked in, perform check-out
            cursor.execute("UPDATE checkin_records SET checkout_time = %s WHERE id = %s", (current_time, result[0]))
            conn.commit()

            # Calculate the total time difference in hours, minutes, and seconds
            hours, remainder = divmod((current_time - result[2]).total_seconds(), 3600)
            minutes, seconds = divmod(remainder, 60)

            # Format the total time as "X hours, Y minutes, and Z seconds"
            total_time = f'{int(hours)} hours, {int(minutes)} minutes'

            response = {
                'status': 'success',
                'message': f'{user_name} Checked-OUT at {current_time}\n<br>Total time spent: {total_time}'
            }
        else:
            # If not checked in, perform check-in
            cursor.execute("INSERT INTO checkin_records (user_id, checkin_time) VALUES (%s, %s)", (user_id, current_time))
            conn.commit()

            response = {'status': 'success', 'message': f'{user_name} is Checked-IN \n<br> At {current_time}  '}

    return jsonify(response)

@app.route('/add', methods=['POST'])
@requires_auth
def add_user():
    full_name = request.form['full_name']
    email = request.form['email']
    mobile = request.form['mobile']
    month = request.form['month']
    uuid_intern = request.form['uuid_intern']
    gender=request.form['gender']
    role=request.form['role']
    try:
        # Insert the new user into the 'users' table
        cursor.execute("INSERT INTO users (full_name, email,mobile,month, uuid_intern,gender,role) VALUES (%s, %s, %s, %s,%s,%s)", (full_name, email, mobile, month,uuid_intern,gender,role))
        conn.commit()

        return redirect(url_for('report'))
    except Exception as e:
        # Handle the exception (e.g., duplicate entry)
        return render_template('error.html', message=str(e))

@app.route('/update', methods=['POST'])
@requires_auth
def update_user():
    # Assuming you have the required form fields in your request
    user_id = request.form['id']
    full_name = request.form['full_name']
    email = request.form['email']
    mobile = request.form['mobile']
    role = request.form['role']
    month = request.form['month']
    uuid_intern = request.form['uuid_intern']

    try:
        # Update the user details in the database
        cursor.execute("""
            UPDATE users
            SET full_name = %s, email = %s, mobile = %s,role = %s,month = %s, uuid_intern = %s
            WHERE id = %s
        """, (full_name, email, mobile, role,month,uuid_intern,user_id))
        conn.commit()

        return redirect(url_for('report'))
    except Exception as e:
        # Handle the exception (e.g., duplicate entry)
        return render_template('error.html', message=str(e))

@app.route('/report', methods=['GET'])
@requires_auth
def report():
    # Get the date and user ID from the request parameters
    date_param = request.args.get('date')
    user_id_param = request.args.get('user')

    # Get the list of users for the dropdown
    cursor.execute("SELECT id, full_name,  uuid_intern FROM users")
    users = cursor.fetchall()

    if not date_param or not user_id_param:
        return render_template('report.html', entries={}, users=users)

    try:
        # Parse the date parameter
        report_date = datetime.datetime.strptime(date_param, '%Y-%m-%d').date()
    except ValueError:
        return render_template('report.html', entries={}, users=users, message='Invalid date format.')

    # Retrieve entries for the specified date and user
    cursor.execute("""
        SELECT users.full_name, checkin_records.checkin_time, checkin_records.checkout_time
        FROM users
        JOIN checkin_records ON users.id = checkin_records.user_id
        WHERE DATE(checkin_records.checkin_time) = %s AND users.id = %s
    """, (report_date, user_id_param))
    entries = cursor.fetchall()

    return render_template('report.html', entries=entries, users=users, report_date=report_date, selected_user_id=user_id_param)

@app.route('/log', methods=['GET'])
@requires_auth
def log():
    # Get the user ID from the request parameters
    user_id_param = request.args.get('user_id')

    if not user_id_param:
        return render_template('log.html', entries={}, user_name=None, uuid=None, email=None, month=None, mobile=None, role=None, gender=None)

    # Get user details
    cursor.execute("SELECT * FROM users WHERE id = %s", (user_id_param,))
    user_details = cursor.fetchone()

    # Retrieve all log entries for the specified user
    cursor.execute("""
        SELECT DATE(checkin_time) as date,
               GROUP_CONCAT(checkin_time ORDER BY checkin_time) as checkin_time,
               GROUP_CONCAT(checkout_time ORDER BY checkin_time) as checkout_time,
               GROUP_CONCAT(TIMEDIFF(checkout_time, checkin_time) ORDER BY checkin_time) as total_time
        FROM checkin_records
        WHERE user_id = %s
        GROUP BY date
        ORDER BY date
    """, (user_id_param,))
    entries = cursor.fetchall()

    # Convert entries to a dictionary for easier rendering in the template
    formatted_entries = {}
    for entry in entries:
        date = entry[0]
        checkin_times = entry[1].split(',')
        checkout_times = entry[2].split(',')
        total_times = entry[3].split(',')

        formatted_entries[date] = {
            'checkin_time': checkin_times,
            'checkout_time': checkout_times,
            'total_time': total_times
        }

    return render_template('log.html', entries=formatted_entries, user_name=user_details[1],
                           uuid=user_details[7], email=user_details[2], month=user_details[5], role=user_details[4],
                           mobile=user_details[3], gender=user_details[6])


@app.route('/excel', methods=['GET', 'POST'])
@requires_auth
def excel_upload():
    if request.method == 'POST':
        if 'excel_file' in request.files:
            excel_file = request.files['excel_file']

            if excel_file.filename != '':
                try:
                    # Load the Excel file
                    workbook = openpyxl.load_workbook(excel_file)
                    sheet = workbook.active

                    # Iterate through rows and extract data
                    for row in sheet.iter_rows(min_row=2, values_only=True):
                        full_name, email, mobile,role,month,uuid_intern,gender = row

                        # Insert data into the 'users' table
                        cursor.execute("INSERT INTO users (full_name, email, mobile,role,month, uuid_intern,gender) VALUES (%s, %s, %s,%s,%s,%s,%s)",
                                       (full_name, email, mobile, role, month, uuid_intern,gender))
                        conn.commit()

                    return redirect(url_for('report'))

                except Exception as e:
                    # Handle exceptions (e.g., invalid format, database error)
                    return render_template('error.html', message=str(e))

    # Render the template with the Excel file upload form
    return render_template('excel_upload.html')

if __name__ == '__main__':
    socketio.run(app, debug=True)
