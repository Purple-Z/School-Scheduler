from flask import Flask, request, jsonify
import secrets, string, threading
from setup import setupDB
from mail import sendMail


db = setupDB()
app = Flask(__name__)


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')
    
    sql = "SELECT * FROM users WHERE email = '" + email + "'"
    result = db.fetchSQL(sql)
    if len(result) != 1:
        return jsonify(), 400

    user = result[0]

    user_id = user[0]
    user_name = user[1]
    user_surname = user[2]
    user_email = user[3]
    user_password_hash = user[4]
    user_admin = user[5]
    user_leader = user[6]
    user_professor = user[7]
    user_student = user[8]

    if user_password_hash == password:
        return jsonify(
            {
                "name": user_name,
                "surname": user_surname,
                "email": user_email,
                "admin": user_admin,
                "leader": user_leader,
                "professor": user_professor,
                "student": user_student,
                "token": token_for(user_id)
            }
        ), 200
    else:
        return jsonify(), 401

@app.route('/get-users', methods=['POST'])
def get_users():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not isAdmin(email, token):
        return jsonify(), 400
    user_id = getIdFromEmail(email)

    users = db.fetchSQL("SELECT * FROM users")

    return jsonify(
        {
            "users": users,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/add-user', methods=['POST'])
def add_users():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    new_name = data.get('new_name')
    new_surname = data.get('new_surname')
    new_email = data.get('new_email')
    new_admin = data.get('new_admin')
    new_leader = data.get('new_leader')
    new_professor = data.get('new_professor')
    new_student = data.get('new_student')
    
    if not isAdmin(email, token):
        return jsonify({}), 400
    user_id = getIdFromEmail(email)

    password = generate_password()
    subject = "School Scheduler Activation"
    body = f"""
    Here your password for the School Scheduler account.

    Your password: {password}

    Use this password hust for login once and then set a new password.

    Best regards,
    School Scheduler
    """
    

    sql_insert = f'''
    INSERT INTO users
    (id, name, surname, email, password_hash, admin, leader, professor, student, token)
    VALUES (
        0,
        '{new_name}', 
        '{new_surname}', 
        '{new_email}', 
        '{password}', 
        {new_admin}, 
        {new_leader}, 
        {new_professor}, 
        {new_student}, 
        ' '
    )
    '''

    try:
        db.executeSQL(sql_insert)
        emailSenderThread = threading.Thread(target=sendEmail, args=(new_email, subject, body))
        emailSenderThread.start()
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 200
    except:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 401

@app.route('/get-user', methods=['POST'])
def get_user():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    new_user_id = data.get('user_id')

    if not isAdmin(email, token):
        return jsonify(), 400
    user_id = getIdFromEmail(email)


    sql = f'''
        SELECT * FROM users WHERE id = '{new_user_id}'
    '''    


    try:
        result = db.fetchSQL(sql)
        user = result[0]
        return jsonify(
        {
            "user": user,
            "token": token_for(user_id)
        }
    ), 200
    except:
        return jsonify(
        {
            "token": token_for(user_id)
        }
    ), 401
    
@app.route('/update-user', methods=['POST'])
def update_user():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    new_user_id = data.get('user_id')
    new_name = data.get('new_name')
    new_surname = data.get('new_surname')
    new_admin = data.get('new_admin')
    new_leader = data.get('new_leader')
    new_professor = data.get('new_professor')
    new_student = data.get('new_student')
    
    if not isAdmin(email, token):
        return jsonify(), 400

    user_id = getIdFromEmail(email)

    sql_update = f'''
    UPDATE users SET
        name = '{new_name}',
        surname = '{new_surname}',
        admin = {new_admin},
        leader = {new_leader},
        professor = {new_professor},
        student = {new_student}
    WHERE id = {new_user_id}
    '''


    try:
        db.executeSQL(sql_update)
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 200
    except:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 401
    
@app.route('/reset-password', methods=['POST'])
def reset_password():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    new_user_id = data.get('user_id')
    
    if not isAdmin(email, token):
        return jsonify(), 400
    user_id = getIdFromEmail(email)


    password = generate_password()
    subject = "School Scheduler Password Recovery"
    body = f"""
    Here your password for the School Scheduler account.

    Your password: {password}

    Use this password hust for login once and then set a new password.

    Best regards,
    School Scheduler
    """

    sql_update = f'''
    UPDATE users SET
        password_hash = '{password}'
    WHERE id = {new_user_id}
    '''

    sql_fetch = f'''
        SELECT * FROM users WHERE id = '{new_user_id}'
    '''    


    result = db.fetchSQL(sql_fetch)
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 401
    user = result[0]
    new_email = user[3]


    try:
        db.executeSQL(sql_update)
        emailSenderThread = threading.Thread(target=sendEmail, args=(new_email, subject, body))
        emailSenderThread.start()
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 200
    except:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 401

@app.route('/delete-user', methods=['POST'])
def delete_user():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    new_user_id = data.get('user_id')
    
    if not isAdmin(email, token):
        return jsonify(), 400
    user_id = getIdFromEmail(email)


    subject = "School Scheduler Account Deleted"
    body = """
    You account has been eliminated.

    Best regards,
    School Scheduler
    """


    sql_fetch = f'''
        SELECT * FROM users WHERE id = '{new_user_id}'
    '''    

    result = db.fetchSQL(sql_fetch)
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 401
    user = result[0]
    new_email = user[3]

    print('till herfe ok')

    try:
        sql_delete = f'''
        DELETE FROM users
        WHERE id = {new_user_id}
        '''

        db.executeSQL(sql_delete)
        emailSenderThread = threading.Thread(target=sendEmail, args=(new_email, subject, body))
        emailSenderThread.start()
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 200
    except:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 401

def isAdmin(email, token):
    #collecting data...
    sql = "SELECT * FROM users WHERE email = '" + email + "'"
    result = db.fetchSQL(sql)
    if len(result) != 1:
        return False

    user = result[0]

    user_admin = user[5]
    user_token = user[9]

    #checking the user...
    if token != user_token:
        return False
    #the token is valid

    #checking the permission...
    if user_admin != True:
        return False
    #the user is admin

    return True

def getIdFromEmail(email):
    #collecting data...
    sql = "SELECT * FROM users WHERE email = '" + email + "'"
    result = db.fetchSQL(sql)
    if len(result) != 1:
        return None

    user = result[0]

    user_id = user[0]


    return user_id

def sendEmail(email, subject, body):
    message = f"Subject: {subject}\n\n{body}"

    sendMail.send(email, message)

def token_for(id):
    token = secrets.token_hex() 
    result = db.fetchSQL("SELECT * FROM users WHERE token = '" + token + "'")
    if len(result) > 0:
        return token_for(id)
    
    db.executeSQL("UPDATE users SET token = '" + token + "' WHERE id = " + str(id))
    return token

def generate_password(length=12):
    characters = string.ascii_letters + string.digits
    password = ''.join(secrets.choice(characters) for _ in range(length))
    return password

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
