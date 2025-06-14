from flask import Flask, request, jsonify
import threading, time
import secrets, string, threading
from datetime import datetime, timedelta
from itertools import groupby
from setup import setupDB
from resource_prediction import ResourcePrediction
from mail import sendMail
import pytz, bcrypt, random
import matplotlib.pyplot as plt

import json

db = setupDB()
app = Flask(__name__)

dataMin = datetime(2000, 1, 1)
dataMax = datetime(2100, 1, 1)

notification_times_delta = [1, 60, 60*24]

mail_content = {}

prediction_models = {}
RP_global = ResourcePrediction()
RP_global.train()

nome_file_json = 'mail_content.json'
rome_tz = pytz.timezone('Europe/Rome')


try:
    with open(nome_file_json, 'r') as file_json:
        dati_json = json.load(file_json)

    mail_content.update(dati_json)


except FileNotFoundError:
    print(f"Error: file '{nome_file_json}' not found")
except json.JSONDecodeError as e:
    print(f"Error: {e}")
except Exception as e:
    print(f"Error: {e}")

def schedule_function():
    while True:
        now = datetime.now(rome_tz)
        if now.second == 30 or now.second == 0 or now.second == 15 or now.second == 45:
            send_notification_thread = threading.Thread(target=check_and_send_notifications, daemon=True)
            send_notification_thread.start()
            time.sleep(1.5)
        time.sleep(0.2)

thread = None
thread_lock = threading.Lock()


with thread_lock:
    if thread is None:
        print("Avvio thread per il monitoraggio del tempo...")
        thread = threading.Thread(target=schedule_function, daemon=True)
        thread.start()


@app.after_request
def add_headers(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')


    return response

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')
    
    sql = "SELECT * FROM users WHERE email = %s"
    result = db.fetchSQL(sql, (email,))
    if len(result) != 1:
        return jsonify(), 400

    user = result[0]

    user_id = user[0]
    user_name = user[1]
    user_surname = user[2]
    user_email = user[3]
    user_password_hash = user[4]
    roles = []


    sql = "SELECT role_id FROM users_roles WHERE user_id = %s"
    result = db.fetchSQL(sql, (user_id,))
    if result:
        roles_ids = result[0]
        for role_id in roles_ids:
            roles.append(getRoleInformation(role_id))
    #print("roles: " + str(roles))

    if verify_password(user_password_hash, password):
        return jsonify(
            {
                "name": user_name,
                "surname": user_surname,
                "email": user_email,
                "roles": roles,
                "token": token_for(user_id)
            }
        ), 200
    else:
        return jsonify(), 401

@app.route('/reload', methods=['POST'])
def reload():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400

    
    sql = "SELECT * FROM users WHERE email = '" + email + "'"
    result = db.fetchSQL(sql)

    sql = "SELECT * FROM users WHERE email = %s"
    result = db.fetchSQL(sql, (email,))


    if len(result) != 1:
        return jsonify(), 400

    user = result[0]

    user_id = user[0]
    user_name = user[1]
    user_surname = user[2]
    user_email = user[3]
    roles = []


    sql = "SELECT role_id FROM users_roles WHERE user_id = %s"
    result = db.fetchSQL(sql, (user_id,))
    if result:
        roles_ids = result[0]
        for role_id in roles_ids:
            roles.append(getRoleInformation(role_id))
    #print("roles: " + str(roles))


    return jsonify(
        {
            "name": user_name,
            "surname": user_surname,
            "email": user_email,
            "roles": roles,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/update-own-user', methods=['POST'])
def update_own_user():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    new_name = data.get('new_name')
    new_surname = data.get('new_surname')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'edit_own_user'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    sql_update = '''
        UPDATE users SET
            name = %s,
            surname = %s
        WHERE email = %s
    '''


    try:
        db.executeSQL(sql_update, (new_name, new_surname, email))
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
        ), 402

@app.route('/change-password', methods=['POST'])
def change_password():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    password = data.get('password')
    new_password = data.get('new_password')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    sql = "SELECT * FROM users WHERE email = %s"
    result = db.fetchSQL(sql, (email,))
    if len(result) != 1:
        return jsonify(), 400

    user_id = getIdFromEmail(email)


    if not verify_password(result[0][4], password):
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 401
    
    



    sql_update = '''
        UPDATE users SET
            password_hash = %s
        WHERE email = %s
    '''

    sql_fetch = '''
        SELECT * FROM users WHERE email = %s
    '''
    result = db.fetchSQL(sql_fetch, (email,))
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 401


    try:
        db.executeSQL(sql_update, (hash_password(new_password), email))
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

# - - -   roles   - - -

@app.route('/get-roles', methods=['POST'])
def get_roles():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_roles'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    roles = db.fetchSQL("SELECT * FROM roles")

    return jsonify(
        {
            "roles": roles,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/add-role', methods=['POST'])
def add_role():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    name = data.get('name')
    description = data.get('description')
    view_users = data.get('view_users')
    edit_users = data.get('edit_users')
    create_users = data.get('create_users')
    delete_users = data.get('delete_users')
    view_own_user = data.get('view_own_user')
    edit_own_user = data.get('edit_own_user')
    create_own_user = data.get('create_own_user')
    delete_own_user = data.get('delete_own_user')
    view_roles = data.get('view_roles')
    edit_roles = data.get('edit_roles')
    create_roles = data.get('create_roles')
    delete_roles = data.get('delete_roles')
    view_availability = data.get('view_availability')
    edit_availability = data.get('edit_availability')
    create_availability = data.get('create_availability')
    delete_availability = data.get('delete_availability')
    view_resources = data.get('view_resources')
    edit_resources = data.get('edit_resources')
    create_resources = data.get('create_resources')
    delete_resources = data.get('delete_resources')
    view_booking = data.get('view_booking')
    edit_booking = data.get('edit_booking')
    create_booking = data.get('create_booking')
    delete_booking = data.get('delete_booking')
    view_own_booking = data.get('view_own_booking')
    edit_own_booking = data.get('edit_own_booking')
    create_own_booking = data.get('create_own_booking')
    delete_own_booking = data.get('delete_own_booking')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'create_roles'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    roles = db.fetchSQL("SELECT * FROM roles")

    sql_insert = '''
        INSERT INTO roles (
            name, 
            description, 
            view_users, 
            edit_users, 
            create_users, 
            delete_users, 
            view_own_user, 
            edit_own_user, 
            create_own_user, 
            delete_own_user, 
            view_roles, 
            edit_roles, 
            create_roles, 
            delete_roles, 
            view_availability, 
            edit_availability, 
            create_availability, 
            delete_availability, 
            view_resources, 
            edit_resources, 
            create_resources, 
            delete_resources, 
            view_booking, 
            edit_booking, 
            create_booking, 
            delete_booking, 
            view_own_booking, 
            edit_own_booking, 
            create_own_booking, 
            delete_own_booking
        ) VALUES (
            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 
            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 
            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
        );
    '''

    parameters = (
        name, 
        description, 
        view_users, 
        edit_users, 
        create_users, 
        delete_users, 
        view_own_user, 
        edit_own_user, 
        create_own_user, 
        delete_own_user, 
        view_roles, 
        edit_roles, 
        create_roles, 
        delete_roles, 
        view_availability, 
        edit_availability, 
        create_availability, 
        delete_availability, 
        view_resources, 
        edit_resources, 
        create_resources, 
        delete_resources, 
        view_booking, 
        edit_booking, 
        create_booking, 
        delete_booking, 
        view_own_booking, 
        edit_own_booking, 
        create_own_booking, 
        delete_own_booking
    )

    try:
        #print('sql, ' + sql_insert)
        db.executeSQL(sql_insert, parameters)
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
        ), 500
    
@app.route('/get-role', methods=['POST'])
def get_role():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    role_id = data.get('role_id')

    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_roles'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401


    sql = '''
        SELECT * FROM roles WHERE id = %s
    '''
    user_id = getIdFromEmail(email)



    try:
        result = db.fetchSQL(sql, (role_id,))
        role = result[0]
        return jsonify(
        {
            "role": role,
            "token": token_for(user_id)
        }
    ), 200
    except:
        return jsonify(
        {
            "token": token_for(user_id)
        }
    ), 500

@app.route('/update-role', methods=['POST'])
def update_role():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    role_id = data.get('role_id')
    name = data.get('name')
    description = data.get('description')
    view_users = data.get('view_users')
    edit_users = data.get('edit_users')
    create_users = data.get('create_users')
    delete_users = data.get('delete_users')
    view_own_user = data.get('view_own_user')
    edit_own_user = data.get('edit_own_user')
    create_own_user = data.get('create_own_user')
    delete_own_user = data.get('delete_own_user')
    view_roles = data.get('view_roles')
    edit_roles = data.get('edit_roles')
    create_roles = data.get('create_roles')
    delete_roles = data.get('delete_roles')
    view_availability = data.get('view_availability')
    edit_availability = data.get('edit_availability')
    create_availability = data.get('create_availability')
    delete_availability = data.get('delete_availability')
    view_resources = data.get('view_resources')
    edit_resources = data.get('edit_resources')
    create_resources = data.get('create_resources')
    delete_resources = data.get('delete_resources')
    view_booking = data.get('view_booking')
    edit_booking = data.get('edit_booking')
    create_booking = data.get('create_booking')
    delete_booking = data.get('delete_booking')
    view_own_booking = data.get('view_own_booking')
    edit_own_booking = data.get('edit_own_booking')
    create_own_booking = data.get('create_own_booking')
    delete_own_booking = data.get('delete_own_booking')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'edit_roles'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    sql_update = '''
        UPDATE roles SET
            name = %s,
            description = %s,
            view_users = %s,
            edit_users = %s,
            create_users = %s,
            delete_users = %s,
            view_own_user = %s,
            edit_own_user = %s,
            create_own_user = %s,
            delete_own_user = %s,
            view_roles = %s,
            edit_roles = %s,
            create_roles = %s,
            delete_roles = %s,
            view_availability = %s,
            edit_availability = %s,
            create_availability = %s,
            delete_availability = %s,
            view_resources = %s,
            edit_resources = %s,
            create_resources = %s,
            delete_resources = %s,
            view_booking = %s,
            edit_booking = %s,
            create_booking = %s,
            delete_booking = %s,
            view_own_booking = %s,
            edit_own_booking = %s,
            create_own_booking = %s,
            delete_own_booking = %s
        WHERE id = %s
    '''

    parameters = (
        name,
        description,
        view_users,
        edit_users,
        create_users,
        delete_users,
        view_own_user,
        edit_own_user,
        create_own_user,
        delete_own_user,
        view_roles,
        edit_roles,
        create_roles,
        delete_roles,
        view_availability,
        edit_availability,
        create_availability,
        delete_availability,
        view_resources,
        edit_resources,
        create_resources,
        delete_resources,
        view_booking,
        edit_booking,
        create_booking,
        delete_booking,
        view_own_booking,
        edit_own_booking,
        create_own_booking,
        delete_own_booking,
        role_id
    )

    try:
        db.executeSQL(sql_update, parameters)
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
        ), 500
    
@app.route('/delete-role', methods=['POST'])
def delete_role():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    role_id = data.get('role_id')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'delete_roles'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    

    user_id = getIdFromEmail(email)


    try:
        sql_delete = '''
            DELETE FROM roles
            WHERE id = %s
        '''
        db.executeSQL(sql_delete, (role_id,))
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

@app.route('/get-role-list', methods=['POST'])
def get_role_list():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_roles'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    roles = db.fetchSQL("SELECT name, description FROM roles")

    return jsonify(
        {
            "roles": roles,
            "token": token_for(user_id)
        }
    ), 200

# - - -   users   - - -

@app.route('/get-users', methods=['POST'])
def get_users():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_users'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    users_content = db.fetchSQL("SELECT * FROM users")

    users = []
    for user_content in users_content:
        user = []
        for quality in user_content:
            user.append(quality)
        user_roles = []
        sql = "SELECT role_id FROM users_roles WHERE user_id = %s"
        role_ids = db.fetchSQL(sql, (user[0],))
        if len(role_ids) != 0:
            for role in role_ids:
                sql = "SELECT name FROM roles WHERE id = %s"
                result = db.fetchSQL(sql, (role[0],))
                if len(result) == 0:
                    continue
                user_roles.append(result[0][0])

        user.append(user_roles)
        users.append(user)



    return jsonify(
        {
            "users": users,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/add-user', methods=['POST'])
def add_user():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    new_name = data.get('new_name')
    new_surname = data.get('new_surname')
    new_email = data.get('new_email')
    new_roles = data.get('new_roles')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'create_users'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    if addUser(new_name, new_surname, new_email, new_roles):
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 200
    else:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500
    
@app.route('/add-users', methods=['POST'])
def add_users():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    users = data.get('users')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'create_users'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    try:

        user_id = getIdFromEmail(email)


        fail_count = 0

        for user in users:
            new_name = user[0]
            new_surname = user[1]
            new_email = user[2]
            new_roles = user[3]
            if not addUser(new_name, new_surname, new_email, new_roles):
                fail_count += 1


        return jsonify(
            {
                "token": token_for(user_id),
                "fail_count": fail_count
            }
        ), 200
    except e:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500

@app.route('/get-user', methods=['POST'])
def get_user():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    new_user_id = data.get('user_id')

    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_users'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    user_id = getIdFromEmail(email)




    try:
        sql = '''
            SELECT * FROM users WHERE id = %s
        '''
        result = db.fetchSQL(sql, (new_user_id,))
        user_content = result[0]

        sql = "SELECT role_id FROM users_roles WHERE user_id = %s"
        role_ids = db.fetchSQL(sql, (user_content[0],))
        user_roles = []
        if len(role_ids) != 0:
            for role in role_ids:
                sql = "SELECT name FROM roles WHERE id = %s"
                result = db.fetchSQL(sql, (role[0],))
                if len(result) == 0:
                    continue
                user_roles.append(result[0][0])
        user = []
        for quality in user_content:
            user.append(quality)
        user.append(user_roles)

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
    new_roles = data.get('new_roles')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'edit_users'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    sql_update = '''
        UPDATE users SET
            name = %s,
            surname = %s
        WHERE id = %s
    '''


    sql_delete = "DELETE FROM users_roles WHERE user_id = %s"
    db.executeSQL(sql_delete, (new_user_id,))



    for new_role in new_roles:
        sql = "SELECT id FROM roles WHERE name = %s"
        new_role_id = db.fetchSQL(sql, (new_role,))[0][0]
        

        sql_insert = '''
            INSERT INTO users_roles (id, user_id, role_id)
            VALUES (%s, %s, %s)
        '''
        db.executeSQL(sql_insert, (0, new_user_id, new_role_id))


    try:
        db.executeSQL(sql_update, (new_name, new_surname, new_user_id))
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
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'edit_users'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
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

    sql_update = '''
        UPDATE users SET
            password_hash = %s
        WHERE id = %s
    '''

    sql_fetch = '''
        SELECT * FROM users WHERE id = %s
    '''
    result = db.fetchSQL(sql_fetch, (new_user_id,))
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 401
    user = result[0]
    new_email = user[3]


    try:
        db.executeSQL(sql_update, (hash_password(password), new_user_id))
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
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'delete_users'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)


    subject = "School Scheduler Account Deleted"
    body = """
    You account has been eliminated.

    Best regards,
    School Scheduler
    """


    sql_fetch = '''
        SELECT * FROM users WHERE id = %s
    '''
    result = db.fetchSQL(sql_fetch, (new_user_id,))
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 401
    user = result[0]
    new_email = user[3]


    try:
        sql_delete = '''
            DELETE FROM users
            WHERE id = %s
        '''
        db.executeSQL(sql_delete, (new_user_id,))
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

@app.route('/disconnect-users', methods=['POST'])
def disconnect_users():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'edit_users'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    try:

        user_id = getIdFromEmail(email)

        sql_fetch = '''
            SELECT id FROM users WHERE NOT id = %s
        '''
        result = db.fetchSQL(sql_fetch, (user_id,))

        for user in result:
            token_for(user[0])


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

# - - -   types   - - -

@app.route('/get-types', methods=['POST'])
def get_types():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    types_content = db.fetchSQL("SELECT * FROM types")




    return jsonify(
        {
            "types": types_content,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/add-type', methods=['POST'])
def add_type():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    name = data.get('name')
    description = data.get('description')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'create_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)


    try:
        sql_insert = '''
            INSERT INTO types (id, name, description)
            VALUES (%s, %s, %s)
        '''
        db.executeSQL(sql_insert, (0, name, description))

        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 200
    except Exception as e:
        print(e)
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500

@app.route('/get-type', methods=['POST'])
def get_type():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    type_id = data.get('type_id')

    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    user_id = getIdFromEmail(email)




    try:
        sql = '''
            SELECT * FROM types WHERE id = %s
        '''
        result = db.fetchSQL(sql, (type_id,))
        type_content = result[0]

        return jsonify(
        {
            "type": type_content,
            "token": token_for(user_id)
        }
    ), 200
    except:
        return jsonify(
        {
            "token": token_for(user_id)
        }
    ), 401
    
@app.route('/update-type', methods=['POST'])
def update_type():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    type_id = data.get('type_id')
    name = data.get('name')
    description = data.get('description')

    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'edit_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    sql_update = '''
        UPDATE types SET
            name = %s,
            description = %s
        WHERE id = %s
    '''


    try:
        db.executeSQL(sql_update, (name, description, type_id))
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
    
@app.route('/delete-type', methods=['POST'])
def delete_type():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    type_id = data.get('type_id')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'delete_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)




    try:
        sql_delete = '''
            DELETE FROM types
            WHERE id = %s
        '''
        db.executeSQL(sql_delete, (type_id,))
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

@app.route('/get-type-list', methods=['POST'])
def get_type_list():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    types = db.fetchSQL("SELECT name, description FROM types")

    return jsonify(
        {
            "types": types,
            "token": token_for(user_id)
        }
    ), 200


# - - -   places   - - -

@app.route('/get-places', methods=['POST'])
def get_places():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    places_content = db.fetchSQL("SELECT * FROM places")




    return jsonify(
        {
            "places": places_content,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/add-place', methods=['POST'])
def add_place():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    name = data.get('name')
    description = data.get('description')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'create_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)


    try:
        sql_insert = '''
            INSERT INTO places (id, name, description)
            VALUES (%s, %s, %s)
        '''
        db.executeSQL(sql_insert, (0, name, description))

        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 200
    except Exception as e:
        print(e)
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500

@app.route('/get-place', methods=['POST'])
def get_place():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    place_id = data.get('place_id')

    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    user_id = getIdFromEmail(email)




    try:
        sql = '''
            SELECT * FROM places WHERE id = %s
        '''
        result = db.fetchSQL(sql, (place_id,))
        place_content = result[0]

        return jsonify(
        {
            "place": place_content,
            "token": token_for(user_id)
        }
    ), 200
    except:
        return jsonify(
        {
            "token": token_for(user_id)
        }
    ), 401
    
@app.route('/update-place', methods=['POST'])
def update_place():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    place_id = data.get('place_id')
    name = data.get('name')
    description = data.get('description')

    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'edit_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    sql_update = '''
        UPDATE places SET
            name = %s,
            description = %s
        WHERE id = %s
    '''


    try:
        db.executeSQL(sql_update, (name, description, place_id))
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
    
@app.route('/delete-place', methods=['POST'])
def delete_place():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    place_id = data.get('place_id')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'delete_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)




    try:
        sql_delete = '''
            DELETE FROM places
            WHERE id = %s
        '''
        db.executeSQL(sql_delete, (place_id,))
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

@app.route('/get-place-list', methods=['POST'])
def get_place_list():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400


    user_id = getIdFromEmail(email)

    types = db.fetchSQL("SELECT name, description FROM places")

    return jsonify(
        {
            "places": types,
            "token": token_for(user_id)
        }
    ), 200


# - - -   activities   - - -

@app.route('/get-activities', methods=['POST'])
def get_activities():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    activities_content = db.fetchSQL("SELECT * FROM activities")




    return jsonify(
        {
            "activities": activities_content,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/add-activity', methods=['POST'])
def add_activity():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    name = data.get('name')
    description = data.get('description')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'create_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)


    try:
        sql_insert = '''
            INSERT INTO activities (id, name, description)
            VALUES (%s, %s, %s)
        '''
        db.executeSQL(sql_insert, (0, name, description))

        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 200
    except Exception as e:
        print(e)
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500

@app.route('/get-activity', methods=['POST'])
def get_activity():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    activity_id = data.get('activity_id')

    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    user_id = getIdFromEmail(email)



    try:
        sql = '''
            SELECT * FROM activities WHERE id = %s
        '''
        result = db.fetchSQL(sql, (activity_id,))
        activity_content = result[0]

        return jsonify(
        {
            "activity": activity_content,
            "token": token_for(user_id)
        }
    ), 200
    except:
        return jsonify(
        {
            "token": token_for(user_id)
        }
    ), 402
    
@app.route('/update-activity', methods=['POST'])
def update_activity():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    activity_id = data.get('activity_id')
    name = data.get('name')
    description = data.get('description')

    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'edit_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    sql_update = '''
        UPDATE activities SET
            name = %s,
            description = %s
        WHERE id = %s
    '''


    try:
        db.executeSQL(sql_update, (name, description, activity_id))
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
    
@app.route('/delete-activity', methods=['POST'])
def delete_activity():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    activity_id = data.get('activity_id')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'delete_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)




    try:
        sql_delete = '''
            DELETE FROM activities
            WHERE id = %s
        '''
        db.executeSQL(sql_delete, (activity_id,))
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

@app.route('/get-activity-list', methods=['POST'])
def get_activity_list():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    

    user_id = getIdFromEmail(email)

    activities = db.fetchSQL("SELECT name, description FROM activities")

    return jsonify(
        {
            "activities": activities,
            "token": token_for(user_id)
        }
    ), 200


# - - -   resources   - - -

@app.route('/get-resources', methods=['POST'])
def get_resources():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    resources_content = db.fetchSQL("SELECT * FROM resources")
    resources = []
    for resource in resources_content:
        resource = list(resource)
        sql = '''
            SELECT name FROM types WHERE id = %s
        '''
        result = db.fetchSQL(sql, (resource[4],))
        type_name = result[0][0]

        resource[len(resource)-1] = type_name
        resources.append(resource)

    return jsonify(
        {
            "resources": resources,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/add-resource', methods=['POST'])
def add_resource():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    name = data.get('name')
    description = data.get('description')
    quantity = data.get('quantity')
    auto_accept = data.get('auto_accept')
    over_booking = data.get('over_booking')
    type = data.get('type')
    place = data.get('place')
    activity = data.get('activity')
    slot = data.get('slot')
    referents = data.get('referents')
    resource_permissions = data.get('resource_permissions')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'create_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    resource_id_sql = "SELECT id FROM types WHERE name = %s"
    result = db.fetchSQL(resource_id_sql, (type,))
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 501
    
    type_id = result[0][0]

    resource_id_sql = "SELECT id FROM places WHERE name = %s"
    result = db.fetchSQL(resource_id_sql, (place,))
    place_id = None
    if len(result) != 0:
        place_id = result[0][0]

    resource_id_sql = "SELECT id FROM activities WHERE name = %s"
    result = db.fetchSQL(resource_id_sql, (activity,))
    activity_id = None
    if len(result) != 0:
        activity_id = result[0][0]
    
    if slot == -1:
        slot = None

    try:
        sql_insert = '''
            INSERT INTO resources
            (id, name, description, quantity, type_id, place_id, activity_id, slot, auto_accept, overbooking)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        '''

        parameters = (
            0,
            name,
            description,
            quantity,
            type_id,
            place_id,
            activity_id,
            slot,
            auto_accept,
            over_booking
        )

        db.executeSQL(sql_insert, parameters)

        resource_id_sql = "SELECT id FROM resources WHERE name = %s"
        resource_id = db.fetchSQL(resource_id_sql, (name,))[0][0]
        

        for role in resource_permissions.keys():
            role_id_sql = "SELECT id FROM roles WHERE name = %s"
            role_id = db.fetchSQL(role_id_sql, (role,))[0][0]

            sql_insert = '''
                INSERT INTO permissions
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            '''

            parameters = (
                0,
                resource_permissions[role][0],
                resource_permissions[role][1],
                resource_permissions[role][2],
                resource_permissions[role][3],
                resource_permissions[role][4],
                role_id,
                resource_id
            )

            db.executeSQL(sql_insert, parameters)


        for referent in referents.keys():

            referent_id = getIdFromEmail(referent)

            sql_insert = '''
                INSERT INTO referents
                VALUES (%s, %s, %s, %s)
            '''
            parameters = (
                0,
                referents[referent],
                referent_id,
                resource_id
            )
            db.executeSQL(sql_insert, parameters)

        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 200
    except Exception as e:
        print(e)
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500

@app.route('/get-resource', methods=['POST'])
def get_resource():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    resource_id = data.get('resource_id')

    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    user_id = getIdFromEmail(email)




    try:
        sql = '''
            SELECT * FROM resources WHERE id = %s
        '''
        result = db.fetchSQL(sql, (resource_id,))
        resource_content = result[0]

        sql = '''
            SELECT name FROM types WHERE id = %s
        '''
        result = db.fetchSQL(sql, (resource_content[4],))
        type_name = result[0][0]

        sql = '''
            SELECT name FROM places WHERE id = %s
        '''
        result = db.fetchSQL(sql, (resource_content[5],))
        place_name = ''
        if len(result) != 0:
            place_name = result[0][0]

        sql = '''
            SELECT name FROM activities WHERE id = %s
        '''
        result = db.fetchSQL(sql, (resource_content[6],))
        activities_name = ''
        if len(result) != 0:
            activities_name = result[0][0]

        resource = []
        for quality in resource_content:
            resource.append(quality)

        resource[4] = type_name
        resource[5] = place_name
        resource[6] = activities_name
        resource[8] = resource[8]==1
        resource[9] = resource[9]==1

        sql = '''
            SELECT * FROM referents WHERE resource_id = %s
        '''
        result = db.fetchSQL(sql, (resource_id,))

        referents = {}

        for record in result:
            referent_id = record[2]

            sql = "SELECT email FROM users WHERE id = %s"
            referent_result = db.fetchSQL(sql, (referent_id,))
            if len(referent_result) == 0:
                continue
            user_email = referent_result[0][0]
            referents[user_email] = record[1]

        resource.append(referents)


        return jsonify(
        {
            "resource": resource,
            "token": token_for(user_id)
        }
    ), 200
    except Exception as e:
        print(e)
        return jsonify(
        {
            "token": token_for(user_id)
        }
    ), 401
    
@app.route('/update-resource', methods=['POST'])
def update_resource():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    name = data.get('name')
    resource_id = data.get('resource_id')
    description = data.get('description')
    quantity = data.get('quantity')
    auto_accept = data.get('auto_accept')
    over_booking = data.get('over_booking')
    type = data.get('type')
    place = data.get('place')
    activity = data.get('activity')
    slot = data.get('slot')
    referents = data.get('referents')
    resource_permissions = data.get('resource_permissions')
    

    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'edit_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    role_id_sql = "SELECT * FROM resources WHERE id = %s"
    result = db.fetchSQL(role_id_sql, (resource_id,))
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 501
    
    old_resource = result[0]


    role_id_sql = "SELECT id FROM types WHERE name = %s"
    result = db.fetchSQL(role_id_sql, (type,))
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 501
    
    type_id = result[0][0]


    role_id_sql = "SELECT id FROM places WHERE name = %s"
    result = db.fetchSQL(role_id_sql, (place,))
    place_id = None
    if len(result) != 0:
        place_id = result[0][0]

    role_id_sql = "SELECT id FROM activities WHERE name = %s"
    result = db.fetchSQL(role_id_sql, (activity,))
    activity_id = None
    if len(result) != 0:
        activity_id = result[0][0]

    if slot == -1:
        slot = None

    old_activity_id = old_resource[6]
    old_place_id = old_resource[5]
    old_auto_accept = old_resource[8] == 1
    old_over_booking = old_resource[9] == 1

    if old_auto_accept != auto_accept:
        #has changed
        role_id_sql = "SELECT * FROM bookings WHERE resource_id = %s AND status = %s"
        result = db.fetchSQL(role_id_sql, (resource_id, 0))
        if len(result) != 0:
            return jsonify(
                {
                    "token": token_for(user_id)
                }
            ), 502
        
    if old_over_booking != over_booking:
        #has changed
        if not over_booking:
            max_b = getMaxBookability(resource_id, dataMin, dataMax, do_not_consider_over_booking=True)


            #commento di manutenzione
            max_b = 0
            if max_b < 0:
                return jsonify(
                    {
                        "token": token_for(user_id)
                    }
                ), 503

    if (activity_id != None) != (old_activity_id != None):
        sql_update = '''
            UPDATE bookings SET
                activity_id = %s
            WHERE resource_id = %s
        '''
        db.executeSQL(sql_update, (old_activity_id, resource_id))

    if (place_id != None) != (old_place_id != None):
        sql_update = '''
            UPDATE bookings SET
                place_id = %s
            WHERE resource_id = %s
        '''
        db.executeSQL(sql_update, (old_place_id, resource_id))


    sql_update = '''
        UPDATE resources SET
            name = %s,
            description = %s,
            quantity = %s,
            type_id = %s,
            auto_accept = %s,
            overbooking = %s,
            place_id = %s,
            activity_id = %s,
            slot = %s
        WHERE id = %s
    '''

    parameters = (
        name,
        description,
        quantity,
        type_id,
        auto_accept,
        over_booking,
        place_id,
        activity_id,
        slot,
        resource_id
    )


    try:
        db.executeSQL(sql_update, parameters)

        sql_delete = '''
            DELETE FROM permissions WHERE resource_id = %s
        '''
        db.executeSQL(sql_delete, (resource_id,))

        for role in resource_permissions.keys():
            role_id_sql = "SELECT id FROM roles WHERE name = %s"
            role_id = db.fetchSQL(role_id_sql, (role,))[0][0]

            sql_insert = '''
                INSERT INTO permissions
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            '''
            parameters = (
                0,
                resource_permissions[role][0],
                resource_permissions[role][1],
                resource_permissions[role][2],
                resource_permissions[role][3],
                resource_permissions[role][4],
                role_id,
                resource_id
            )
            db.executeSQL(sql_insert, parameters)

        
        sql_delete = '''
            DELETE FROM referents WHERE resource_id = %s
        '''
        db.executeSQL(sql_delete, (resource_id,))


        for referent in referents.keys():

            referent_id = getIdFromEmail(referent)

            sql_insert = '''
                INSERT INTO referents
                VALUES (%s, %s, %s, %s)
            '''
            parameters = (
                0,
                referents[referent],
                referent_id,
                resource_id
            )
            db.executeSQL(sql_insert, parameters)

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
    
@app.route('/delete-resource', methods=['POST'])
def delete_resource():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    resource_id = data.get('resource_id')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'delete_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)



    try:
        sql_delete = '''
            DELETE FROM resources
            WHERE id = %s
        '''
        db.executeSQL(sql_delete, (resource_id,))
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

@app.route('/get-resource-permission', methods=['POST'])
def get_resource_permission():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    roles = data.get('roles')
    resource_id = data.get('resource_id')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    if not checkUserPermission(email, 'view_roles'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    user_id = getIdFromEmail(email)

    roles_permission = {}

    for role in roles:
        role_id_sql = "SELECT id FROM roles WHERE name = %s"
        role_id = db.fetchSQL(role_id_sql, (role,))[0][0]

        permission_sql = '''
            SELECT * FROM permissions WHERE role_id = %s AND resource_id = %s
        '''
        permission = db.fetchSQL(permission_sql, (role_id, resource_id))

        view = False
        remove = False
        edit = False
        book = False
        can_accept = False

        if len(permission) != 0:
            permission = permission[0]

            view = permission[1]==1
            remove = permission[2]==1
            edit = permission[3]==1
            book = permission[4]==1
            can_accept = permission[5]==1

        

        roles_permission[role] = [view, remove, edit, book, can_accept]


    

    return jsonify(
        {
            "roles_permission": roles_permission,
            "token": token_for(user_id)
        }
    ), 200

# - - -   availabilities   - - -

@app.route('/get-availabilities', methods=['POST'])
def get_availabilities():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    resource_id = data.get('resource_id')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_availability'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    availabilities_content_sql = '''
        SELECT * FROM availability WHERE resource_id = %s
    '''
    availabilities_content = db.fetchSQL(availabilities_content_sql, (resource_id,))
    availabilities = []
    for availability in availabilities_content:
        availability = list(availability)
        sql = "SELECT name FROM resources WHERE id = %s"
        result = db.fetchSQL(sql, (availability[-1],))
        resource_name = result[0][0]

        availability[1] = availability[1].isoformat()
        availability[2] = availability[2].isoformat()

        availability[len(availability)-1] = resource_name
        availabilities.append(availability)

    return jsonify(
        {
            "availabilities": availabilities,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/add-availability', methods=['POST'])
def add_availability():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    start = data.get('start')
    end = data.get('end')
    quantity = data.get('quantity')
    resource_id = data.get('resource_id')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'create_availability'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    start = datetime.fromisoformat(start)
    end = datetime.fromisoformat(end)

    if end < start:
        return jsonify(
            {
                'message': 'Shift not correct',
                "token": token_for(user_id)
            }
            ), 402

    if quantity <= 0:
        return jsonify(
            {
                'message': 'Invalid quantity',
                "token": token_for(user_id)
            }
            ), 403

    maxAvailability = getMaxAvailability(resource_id, start, end, -1)

    if not maxAvailability:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500

    if int(quantity) > int(maxAvailability):
        return jsonify(
            {
                'message': 'Too much quantity',
                "token": token_for(user_id)
            }
            ), 403
    


    try:
        sql_insert = '''
            INSERT INTO availability
            (id, start, end, quantity, resource_id)
            VALUES (%s, %s, %s, %s, %s)
        '''
        params = (
            0,
            start,
            end,
            quantity,
            resource_id
        )
        db.executeSQL(sql_insert, params)

        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 200
    except Exception as e:
        print(e)
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500

@app.route('/get-availability', methods=['POST'])
def get_availability():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    availability_id = data.get('availability_id')

    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_availability'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401


    user_id = getIdFromEmail(email)


    try:
        sql = "SELECT * FROM availability WHERE id = %s"
        result = db.fetchSQL(sql, (availability_id,))
        availability_content = result[0]

        sql = "SELECT name FROM resources WHERE id = %s"
        result = db.fetchSQL(sql, (availability_content[-1],))
        resource_name = result[0][0]

        availability = []
        for quality in availability_content:
            availability.append(quality)

        availability[len(availability)-1] = resource_name
        availability[1] = availability[1].isoformat()
        availability[2] = availability[2].isoformat()
    
        return jsonify(
        {
            "availability": availability,
            "token": token_for(user_id)
        }
    ), 200
    except:
        return jsonify(
        {
            "token": token_for(user_id)
        }
    ), 401
    
@app.route('/update-availability', methods=['POST'])
def update_availability():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    start = data.get('start')
    end = data.get('end')
    quantity = data.get('quantity')
    availability_id = data.get('availability_id')

    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'edit_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    

    sql = "SELECT * FROM availability WHERE id = %s"
    result = db.fetchSQL(sql, (availability_id,))
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 501

    old_start = result[0][1]
    old_end = result[0][2]
    resource_id = result[0][4]
    

    user_id = getIdFromEmail(email)

    start = datetime.fromisoformat(start)
    end = datetime.fromisoformat(end)

    if end < start:
        return jsonify(
            {
                'message': 'Shift not correct',
                "token": token_for(user_id)
            }
            ), 402

    if quantity <= 0:
        return jsonify(
            {
                'message': 'Invalid quantity',
                "token": token_for(user_id)
            }
            ), 403

    maxAvailability = getMaxAvailability(resource_id, start, end, availability_id)

    if not maxAvailability:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 501

    if int(quantity) > int(maxAvailability):
        return jsonify(
            {
                'message': 'Too much quantity',
                "token": token_for(user_id)
            }
            ), 403    

    maxBookability = getMaxBookability(
        resource_id, 
        old_start, 
        old_end,  
        remove_availability_id=availability_id, 
        shift_set=[[start, end, quantity]]
        )
    

    if maxBookability < 0:
        return jsonify(
            {
                "quantity": 0,
                "token": token_for(user_id)
            }
        ), 502

    sql_update = '''
        UPDATE availability SET
            start = %s,
            end = %s,
            quantity = %s
        WHERE id = %s
    '''

    try:
        db.executeSQL(sql_update, (start, end, quantity, availability_id))
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
        ), 500
    
@app.route('/delete-availability', methods=['POST'])
def delete_availability():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    availability_id = data.get('availability_id')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'delete_availability'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    sql = "SELECT * FROM availability WHERE id = %s"
    result = db.fetchSQL(sql, (availability_id,))
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 501

    old_start = result[0][1]
    old_end = result[0][2]
    resource_id = result[0][4]

    maxBookability = getMaxBookability(
        resource_id, 
        old_start, 
        old_end,  
        remove_availability_id=availability_id,
        )
    

    if maxBookability < 0:
        return jsonify(
            {
                "quantity": 0,
                "token": token_for(user_id)
            }
        ), 502



    try:
        sql_delete = '''
            DELETE FROM availability
            WHERE id = %s
        '''
        db.executeSQL(sql_delete, (availability_id,))
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

@app.route('/check-availabilities-quantity', methods=['POST'])
def check_availabilities_quantity():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    resource_id = data.get('resource_id')
    start = data.get('start')
    end = data.get('end')
    remove_availability_id = data.get('remove_availability_id')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_availability'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    
    user_id = getIdFromEmail(email)

    start = datetime.fromisoformat(start)
    end = datetime.fromisoformat(end)

    if end < start:
        return jsonify(
            {
                'message': 'Shift not correct'
            }
            ), 402
    

    maxAvailability = getMaxAvailability(resource_id, start, end, remove_availability_id)

    if maxAvailability == -1:
        return jsonify(
            {
                "quantity": 0,
                "token": token_for(user_id)
            }
        ), 500


    return jsonify(
        {
            "quantity": maxAvailability,
            "token": token_for(user_id)
        }
    ), 200

# - - -   bookings   - - -

@app.route('/get-resources-feed', methods=['POST'])
def get_resources_feed():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    
    user_id = getIdFromEmail(email)

    roles_id_sql = '''
        SELECT role_id FROM users_roles WHERE user_id = %s
    '''
    roles_id = db.fetchSQL(roles_id_sql, (user_id,))

    permission = getResourcesPermissions(roles_id)
    
    #print(permission)

    resources_id = []
    
    for key in permission.keys():
        if permission[key][0] == 1:
            #I can see the resource
            if key not in resources_id:
                resources_id.append(key)

    resources = []
    for resource_id in resources_id:
        sql = '''
            SELECT * FROM resources WHERE id = %s
        '''
        resource = db.fetchSQL(sql, (resource_id,))[0]

        sql = '''
            SELECT name FROM types WHERE id = %s
        '''
        type_name = db.fetchSQL(sql, (resource[4],))[0][0]
        
        resource = list(resource)

        resource[4] = type_name

        resources.append(resource)

    #print(resources)
    

    return jsonify(
        {
            "resources": resources,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/get-resource-for-booking', methods=['POST'])
def get_resource_for_booking():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    resource_id = data.get('resource_id')
    start = data.get('start')
    end = data.get('end')
    #print(resource_id, start, end)
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    
    user_id = getIdFromEmail(email)

    roles_id_sql = '''
        SELECT role_id FROM users_roles WHERE user_id = %s
    '''
    roles_id = db.fetchSQL(roles_id_sql, (user_id,))

    permission = getResourcesPermissions(roles_id)



    if resource_id not in permission:
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    resource_permission = permission[resource_id]
    if resource_permission[0] != 1:
        #I cannot see
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 402
    


    try:
        sql = '''
            SELECT * FROM resources WHERE id = %s
        '''
        result = db.fetchSQL(sql, (resource_id,))
        resource_content = result[0]

        sql = '''
            SELECT name FROM types WHERE id = %s
        '''
        result = db.fetchSQL(sql, (resource_content[4],))
        type_name = result[0][0]

        place_name = resource_content[5] if resource_content[5] != None else ''
        if resource_content[5] != None:
            sql = '''
                SELECT name FROM places WHERE id = %s
            '''
            result = db.fetchSQL(sql, (resource_content[5],))
            place_name = result[0][0]


        activity_name = resource_content[6] if resource_content[6] != None else ''
        if resource_content[6] != None:
            sql = '''
                SELECT name FROM activities WHERE id = %s
            '''
            result = db.fetchSQL(sql, (resource_content[6],))
            activity_name = result[0][0]

        resource = []
        for quality in resource_content:
            resource.append(quality)

        resource[4] = type_name
        resource[5] = place_name
        resource[6] = activity_name
        resource[8] = resource[8]==1
        resource[9] = resource[9]==1
        



        user_id = getIdFromEmail(email)

        start = datetime.fromisoformat(start)
        end = datetime.fromisoformat(end)

        if end < start:
            return jsonify(
                {
                    'message': 'Shift not correct'
                }
                ), 402
        
        
        shifts_content = selectAllRecordsFromShift(start, end, resource_id)


        shifts = []

        if len(shifts_content) == 0:
            shifts = [[start, end, 0]]
        else:
            shifts = getShiftValue(shifts_content, start, end, slot=resource[7])


        for shift in shifts:
            shift[0] = shift[0].isoformat()
            shift[1] = shift[1].isoformat()

        predict_shifts = getPredictionShifts(start, end, max_quantity=resource[3], resource_id=resource_id)


        content = {
            'start': start.isoformat(),
            'end': end.isoformat(),
            'shifts': shifts,
            'predict_shifts': predict_shifts,
            'resource': resource
        }


        return jsonify(
            {
                "content": content,
                "token": token_for(user_id)
            }
        ), 200
    except Exception as e:
        print(e)
        return jsonify(
        {
            #"token": token_for(user_id)
        }
    ), 403
    
@app.route('/check-bookings-quantity', methods=['POST'])
def check_bookings_quantity():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    resource_id = data.get('resource_id')
    start = data.get('start')
    end = data.get('end')
    remove_booking_id = data.get('remove_booking_id')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_availability'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    if not checkUserPermission(email, 'view_booking'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

    
    user_id = getIdFromEmail(email)

    start = datetime.fromisoformat(start)
    end = datetime.fromisoformat(end)

    if end < start:
        return jsonify(
            {
                'message': 'Shift not correct'
            }
            ), 402
    

    maxBookability = getMaxBookability(resource_id, start, end, remove_booking_id)

    if maxBookability == -1:
        return jsonify(
            {
                "quantity": 0,
                "token": token_for(user_id)
            }
        ), 500


    return jsonify(
        {
            "quantity": maxBookability,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/add-booking', methods=['POST'])
def add_booking():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    start = data.get('start')
    end = data.get('end')
    quantity = data.get('quantity')
    resource_id = data.get('resource_id')
    place = data.get('place')
    activity = data.get('activity')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'create_booking'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    start = datetime.fromisoformat(start)
    end = datetime.fromisoformat(end)

    if end < start:
        return jsonify(
            {
                'message': 'Shift not correct',
                "token": token_for(user_id)
            }
            ), 402

    if quantity <= 0:
        return jsonify(
            {
                'message': 'Invalid quantity',
                "token": token_for(user_id)
            }
            ), 403
    
    sql = '''
        SELECT * FROM resources WHERE id = %s
    '''
    result = db.fetchSQL(sql, (resource_id,))
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500
    
    

    place = '' if place == None else place
    place_name = '' if result[0][5] != None else place
    sql = "SELECT id FROM places WHERE name = %s"
    place_result = db.fetchSQL(sql, (place_name,))
    place_id = None
    if len(place_result) != 0:
        place_id = place_result[0][0]

    activity = '' if activity == None else activity
    activity_name = '' if result[0][6] != None else activity
    sql = "SELECT id FROM activities WHERE name = %s"
    activity_result = db.fetchSQL(sql, (activity_name,))
    activity_id = None
    if len(activity_result) != 0:
        activity_id = activity_result[0][0]
    
    slot = result[0][7]
    auto_accept = result[0][8]==1
    over_booking = result[0][9]==1

    maxBookability = getMaxBookability(resource_id, start, end, -1)

    if not maxBookability:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500

    if int(quantity) > int(maxBookability):
        return jsonify(
            {
                'message': 'Too much quantity',
                "token": token_for(user_id)
            }
            ), 403
    


    try:
        


        sql_insert = '''
            INSERT INTO bookings
            (id, start, end, quantity, resource_id, user_id, status, place_id, activity_id)
            VALUES (
                0, %s, %s, %s, %s, %s, %s, %s, %s
            )
        '''
        parameters = (
            start,
            end,
            quantity,
            resource_id,
            user_id,
            1 if auto_accept is True else 0,
            place_id if place_id is not None else None,
            activity_id if activity_id is not None else None
        )

        db.executeSQL(sql_insert, parameters)

        RP = ResourcePrediction(resourceId=resource_id)
        RP.train()
        prediction_models[resource_id] = RP

        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 200
    except Exception as e:
        print(e)
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500
    
@app.route('/cancel-booking', methods=['POST'])
def cancel_booking():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    request_id = data.get('booking_id')
    
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    sql = '''
        SELECT * FROM bookings WHERE id = %s
    '''
    bookings_content = db.fetchSQL(sql, (request_id,))

    user_id = getIdFromEmail(email)
    
    if not (
            checkUserPermission(email, 'delete_booking')
            or
                (
                    checkUserPermission(email, 'delete_own_booking')
                    and
                    (bookings_content[0][4] == user_id)
                )
        ):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    


    sql_update = '''
        UPDATE bookings SET
            status = 3,
            invalidator_id = %s
        WHERE id = %s
    '''
    db.executeSQL(sql_update, (user_id, request_id))
    

    return jsonify(
        {
            "token": token_for(user_id)
        }
    ), 200

@app.route('/get-pending-bookings', methods=['POST'])
def get_pending_bookings():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_booking'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    sql = '''
        SELECT * FROM bookings WHERE status = 0
    '''
    bookings_content = db.fetchSQL(sql)

    sql = '''
        SELECT role_id FROM users_roles WHERE user_id = %s
    '''
    roles_id = db.fetchSQL(sql, (user_id,))

    permission = getResourcesPermissions(roles_id)

    bookings = []
    for booking in bookings_content:
        resource_id = booking[5]

        if resource_id not in permission or permission[resource_id][4] != 1:
            continue


        booking = list(booking)
        sql = '''
            SELECT name FROM resources WHERE id = %s
        '''
        result = db.fetchSQL(sql, (booking[5],))
        resource_name = result[0][0]

        sql = '''
            SELECT email FROM users WHERE id = %s
        '''
        result = db.fetchSQL(sql, (booking[4],))
        user_email = result[0][0]

        booking[1] = booking[1].isoformat()
        booking[2] = booking[2].isoformat()

        booking[4] = user_email
        booking[5] = resource_name
        bookings.append(booking)

    return jsonify(
        {
            "bookings": bookings,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/accept-pending-bookings', methods=['POST'])
def accept_pending_bookings():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    request_id = data.get('request_id')
    
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'edit_booking'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    sql = '''
        SELECT * FROM bookings WHERE id = %s
    '''
    bookings_content = db.fetchSQL(sql, (request_id,))


    sql = '''
        SELECT role_id FROM users_roles WHERE user_id = %s
    '''
    roles_id = db.fetchSQL(sql, (user_id,))


    resource_id = bookings_content[0][5]
    permission = getResourcesPermissions(roles_id)[resource_id]
    if permission[4] != 1:
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 402

    sql_update = '''
        UPDATE bookings SET
            status = 1,
            validator_id = %s
        WHERE id = %s
    '''
    db.executeSQL(sql_update, (user_id, request_id))
    

    return jsonify(
        {
            "token": token_for(user_id)
        }
    ), 200

@app.route('/refuse-pending-bookings', methods=['POST'])
def refuse_pending_bookings():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    request_id = data.get('request_id')
    
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'delete_booking'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    sql = '''
        SELECT * FROM bookings WHERE id = %s
    '''
    bookings_content = db.fetchSQL(sql, (request_id,))

    sql = '''
        SELECT role_id FROM users_roles WHERE user_id = %s
    '''
    roles_id = db.fetchSQL(sql, (user_id,))


    resource_id = bookings_content[0][5]
    permission = getResourcesPermissions(roles_id)[resource_id]
    if permission[4] != 1:
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 402

    sql_update = '''
        UPDATE bookings SET
            status = 2,
            validator_id = %s
        WHERE id = %s
    '''
    db.executeSQL(sql_update, (user_id, request_id))
    

    return jsonify(
        {
            "token": token_for(user_id)
        }
    ), 200

@app.route('/get-bookings', methods=['POST'])
def get_bookings():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not checkUserPermission(email, 'view_booking'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    bookings_content = db.fetchSQL(
        '''
            SELECT * FROM bookings
        '''
    )
    
    bookings = elaborateBookings(bookings_content)

    return jsonify(
        {
            "bookings": bookings,
            "token": token_for(user_id)
        }
    ), 200

@app.route('/get-user-bookings', methods=['POST'])
def get_user_bookings():
    data = request.get_json()
    email = data.get('email')
    token = data.get('token')
    
    if not checkUserToken(email, token):
        return jsonify(
            {
                'message': 'User disconnected'
            }
            ), 400
    
    if not (checkUserPermission(email, 'view_own_booking') or checkUserPermission(email, 'view_booking')):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    sql = '''
        SELECT * FROM bookings WHERE user_id = %s
    '''
    bookings_content = db.fetchSQL(sql, (user_id,))
    
    bookings = elaborateBookings(bookings_content)
    

    return jsonify(
        {
            "bookings": bookings,
            "token": token_for(user_id)
        }
    ), 200

def hash_password(password):
    password_bytes = password.encode('utf-8')
    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(password_bytes, salt)
    return hashed_password.decode('utf-8')

def verify_password(stored_hash, password):
    password_bytes = password.encode('utf-8')
    hashed_bytes = stored_hash.encode('utf-8')
    return bcrypt.checkpw(password_bytes, hashed_bytes)

def addUser(new_name, new_surname, new_email, new_roles):    
    password = generate_password()
    subject = "School Scheduler Activation"
    body = f"""
    Here your password for the School Scheduler account.

    Your password: {password}

    Use this password hust for login once and then set a new password.

    Best regards,
    School Scheduler
    """
    

    try:
        sql_insert = '''
            INSERT INTO users
            (id, name, surname, email, password_hash, token)
            VALUES (
                0, %s, %s, %s, %s, %s
            )
        '''
        parameters = (
            new_name,
            new_surname,
            new_email,
            hash_password(password),
            ' '
        )

        db.executeSQL(sql_insert, parameters)

        

        new_user_id = getIdFromEmail(new_email)

        token_for(new_user_id)

        for new_role in new_roles:
            sql = "SELECT id FROM roles WHERE name = %s"
            new_role_id = db.fetchSQL(sql, (new_role,))[0][0]
            

            sql_insert = '''
                INSERT INTO users_roles
                (id, user_id, role_id)
                VALUES (
                    0, %s, %s
                )
            '''
            db.executeSQL(sql_insert, (new_user_id, new_role_id))

        emailSenderThread = threading.Thread(target=sendEmail, args=(new_email, subject, body))
        emailSenderThread.start()
        return True
    except Exception as e:
        print(e)
        return False

def checkUserToken(email, token):
    #collecting data...
    sql = "SELECT * FROM users WHERE email = %s"
    result = db.fetchSQL(sql, (email,))
    if len(result) != 1:
        return False

    user = result[0]

    user_token = user[5]

    #checking the user...
    if token != user_token:
        return False
    #the token is valid

    return True

def checkUserPermission(email, permission):
    #collecting data...
    sql = "SELECT id FROM users WHERE email = %s"
    result = db.fetchSQL(sql, (email,))
    if len(result) != 1:
        return False

    user_id = result[0][0]


    sql = "SELECT role_id FROM users_roles WHERE user_id = %s"
    result = db.fetchSQL(sql, (user_id,))
    if len(result) == 0:
        return False
    
    for role_id in result:
        sql = "SELECT " + permission + " FROM roles WHERE id = " + str(role_id[0])
        #print('sql: ' + sql)
        role_permission = db.fetchSQL(sql)[0][0]
        if len(result) == 0:
            continue
        if role_permission == 1:
            return True


    return False

def getRoleInformation(role_id):
    sql = "SELECT * FROM roles WHERE id = %s"
    role_content = db.fetchSQL(sql, (role_id,))[0]
    return {
        'role_name': role_content[1],
        'description': role_content[2],
        'view_users': role_content[3],
        'edit_users': role_content[4],
        'create_users': role_content[5],
        'delete_users': role_content[6],
        'view_own_user': role_content[7],
        'edit_own_user': role_content[8],
        'create_own_user': role_content[9],
        'delete_own_user': role_content[10],
        'view_roles': role_content[11],
        'edit_roles': role_content[12],
        'create_roles': role_content[13],
        'delete_roles': role_content[14],
        'view_availability': role_content[15],
        'edit_availability': role_content[16],
        'create_availability': role_content[17],
        'delete_availability': role_content[18],
        'view_resources': role_content[19],
        'edit_resources': role_content[20],
        'create_resources': role_content[21],
        'delete_resources': role_content[22],
        'view_booking': role_content[23],
        'edit_booking': role_content[24],
        'create_booking': role_content[25],
        'delete_booking': role_content[26],
        'view_own_booking': role_content[27],
        'edit_own_booking': role_content[28],
        'create_own_booking': role_content[29],
        'delete_own_booking': role_content[30]
    }

def getIdFromEmail(email):
    #collecting data...
    sql = "SELECT * FROM users WHERE email = %s"
    result = db.fetchSQL(sql, (email,))
    if len(result) != 1:
        return None

    user = result[0]

    user_id = user[0]


    return user_id

def getEmailFromId(id):
    #collecting data...
    sql = "SELECT * FROM users WHERE id = %s"
    result = db.fetchSQL(sql, (id,))
    if len(result) != 1:
        return None

    user = result[0]

    user_email = user[3]


    return user_email

def getResourcesPermissions(roles_id):
    permission = {}

    for role_id in roles_id:
        role_id = role_id[0]

        sql = '''
            SELECT * FROM permissions WHERE role_id = %s
        '''
        result = db.fetchSQL(sql, (role_id,))

        if len(result) == 0:
            continue

        for record in result:
            resource_id = record[7]
            
            if resource_id in permission:
                permission[resource_id][1] = permission[resource_id][1] or record[1]
                permission[resource_id][2] = permission[resource_id][2] or record[2]
                permission[resource_id][3] = permission[resource_id][3] or record[3]
                permission[resource_id][4] = permission[resource_id][4] or record[4]
                permission[resource_id][5] = permission[resource_id][5] or record[5]
            else:
                new_list_record = []
                for element in record:
                    new_list_record.append(element)



                permission[resource_id] = new_list_record

    for key in permission.keys():
        c = permission[key]
        permission[key] = [c[1], c[2], c[3], c[4], c[5]]

    return permission

def elaborateBookings(bookings_content):
    bookings = []
    for booking in bookings_content:
        booking = list(booking)
        sql = '''
            SELECT email FROM users WHERE id = %s
        '''
        result = db.fetchSQL(sql, (booking[4],))
        user_mail = result[0][0]

        sql = '''
            SELECT name FROM resources WHERE id = %s
        '''
        result = db.fetchSQL(sql, (booking[5],))
        resource_name = result[0][0]

        place_name = ''
        resource_place = False
        if booking[7] == None:
            resource_place = True
            sql = '''
                SELECT place_id FROM resources WHERE id = %s
            '''
            result = db.fetchSQL(sql, (booking[5],))
            booking[7] = result[0][0]
        sql = '''
            SELECT name FROM places WHERE id = %s
        '''
        result = db.fetchSQL(sql, (booking[7],))
        place_name = result[0][0]



        activity_name = ''
        resource_activity = False
        if booking[8] == None:
            resource_activity = True
            sql = '''
                SELECT activity_id FROM resources WHERE id = %s
            '''
            result = db.fetchSQL(sql, (booking[5],))
            booking[8] = result[0][0]

        sql = '''
            SELECT name FROM activities WHERE id = %s
        '''
        result = db.fetchSQL(sql, (booking[8],))
        activity_name = result[0][0]

        validator_email = ''
        if booking[9] != None:
            sql = '''
                SELECT email FROM users WHERE id = %s
            '''
            result = db.fetchSQL(sql, (booking[9],))
            validator_email = result[0][0]

        invalidator_email = ''
        if booking[10] != None:
            sql = '''
                SELECT email FROM users WHERE id = %s
            '''
            result = db.fetchSQL(sql, (booking[10],))
            invalidator_email = result[0][0]

        booking[1] = booking[1].isoformat()
        booking[2] = booking[2].isoformat()

        booking[4] = user_mail
        booking[5] = resource_name
        booking[7] = place_name
        booking[8] = activity_name
        booking[9] = validator_email
        booking[10] = invalidator_email
        booking.append(resource_place)
        booking.append(resource_activity)

        bookings.append(booking)

    return bookings

def selectAvailabilityRecordsFromShift(start, end, resource_id, remove_availability_id=-1):
    sql = '''
        SELECT * FROM availability WHERE
        (
            NOT (start > %s AND end > %s)
            AND
            NOT (start < %s AND end < %s)
        )
        AND
        resource_id = %s
    '''
    params = (end, end, start, start, resource_id)
    result = db.fetchSQL(sql, params)

    shifts_content = []
    for record in result:
        if record[0] != remove_availability_id:
            shift = []
            shift.append(record[1])
            shift.append(record[2])
            shift.append(record[3])
            shifts_content.append(shift)

    return shifts_content

def selectAllRecordsFromShift(start, end, resource_id, remove_booking_id=-1, remove_availability_id=-1, do_not_consider_over_booking=False):

    sql = 'SELECT * FROM resources WHERE id = %s'
    result = db.fetchSQL(sql, (resource_id,))
    if len(result) == 0:
        return -1
    
    slot = result[0][7]
    auto_accept = result[0][8]==1
    over_booking = result[0][9]==1

    if do_not_consider_over_booking:
        over_booking = False



    sql = '''
        SELECT * FROM availability WHERE
        (
            NOT (start > %s AND end > %s)
            AND
            NOT (start < %s AND end < %s)
        )
        AND resource_id = %s
    '''
    parameters = (end, end, start, start, resource_id)
    result = db.fetchSQL(sql, parameters)

    shifts_content = []
    for record in result:
        if record[0] != remove_availability_id:
            shift = []
            shift.append(record[1])
            shift.append(record[2])
            shift.append(record[3])
            shifts_content.append(shift)


    sql = '''
        SELECT * FROM bookings WHERE
        (
            (
                NOT (start > %s AND end > %s)
                AND
                NOT (start < %s AND end < %s)
            )
            AND
            (
                (status = 1 OR %s = 0) AND (%s = 0)
                OR 
                (%s = 1)
            )
            AND status != 2
        )
        AND resource_id = %s
    '''

    parameters = (
        end, end, start, start,
        1 if over_booking is True else 0,
        1 if auto_accept is True else 0,
        1 if auto_accept is True else 0,
        resource_id
    )

    result = db.fetchSQL(sql, parameters)

    for record in result:
        if record[0] != remove_booking_id:
            shift = []
            shift.append(record[1])
            shift.append(record[2])
            shift.append(record[3]*-1)
            shifts_content.append(shift)

    return shifts_content

def getMaxAvailability(resource_id, start, end, remove_availability_id):
    if end < start:
        return -1
    
    sql = 'SELECT quantity FROM resources WHERE id = %s'
    result = db.fetchSQL(sql, (resource_id,))
    if len(result) == 0:
        return -1

    maxAvailability = result[0][0]

    shifts_content = selectAvailabilityRecordsFromShift(start, end, resource_id, remove_availability_id)

    shifts = []
    if len(shifts_content) > 0:
        shifts = getShiftValue(shifts_content, start=start, end=end)
    
    maxVal = 0
    if len(shifts) > 0:
        maxVal = shifts[0][2]

        for shift in shifts:
            if shift[2] > maxVal:
                maxVal = shift[2]


    maxAvailability -= maxVal

    return maxAvailability

def getMaxBookability(resource_id, start, end, remove_booking_id=-1, remove_availability_id=-1, shift_set=[], do_not_consider_over_booking=False):
    if end < start:
        return -1
    
    sql = 'SELECT * FROM resources WHERE id = %s'
    result = db.fetchSQL(sql, (resource_id,))
    if len(result) == 0:
        return -1
    
    slot = result[0][7]
    auto_accept = result[0][8]==1
    over_booking = result[0][9]==1


    shifts_content = selectAllRecordsFromShift(start, end, resource_id, remove_booking_id, remove_availability_id, do_not_consider_over_booking=do_not_consider_over_booking)


    for shift in shift_set:
        shifts_content.append(shift)

    shifts = []
    if len(shifts_content) > 0:
        shifts = getShiftValue(shifts_content, start=start, end=end, slot=slot)


    minVal = 0
    if len(shifts) > 0:
        minVal = shifts[0][2]

        for shift in shifts:
            if shift[2] < minVal:
                minVal = shift[2]


    return minVal

def getPredictionShifts(start, end, max_quantity, resource_id):

    RP = RP_global
    if resource_id in prediction_models:
        RP = prediction_models[resource_id]
    else:
        RP = ResourcePrediction(resourceId=resource_id)
        RP.train()
        prediction_models[resource_id] = RP

    predictions = []
    for minute in range((end.day*1440 + end.hour*60 + end.minute) - (start.day*1440 + start.hour*60 + start.minute)):
        date = start + timedelta(minutes=minute)
        predictions.append([date, minute, min(max(RP.predict([minute])[0], 0), 1)*max_quantity])
    

    X_test = []
    Y_pred = []
    for p in predictions:
        X_test.append([p[1]/1440])
        Y_pred.append(p[2])


    for i in range(len(predictions)):
        
        predictions[i] = [predictions[i][0].isoformat(), (predictions[i][0] + timedelta(minutes=1)).isoformat(), predictions[i][2]]


    return predictions



def getShiftValue(shifts, start=False, end=False, slot=None):
    #finding mix and max for function
    minValue = shifts[0][0]
    maxValue = shifts[0][1]

    for shift in shifts:
        if shift[0] < minValue:
            minValue = shift[0]

        if shift[1] > maxValue:
            maxValue = shift[1]

    if not start:
        start = minValue
    elif start < minValue:
        minValue = start

    if not end:
        end = maxValue
    elif end > maxValue:
        maxValue = end

    

    #function values
    total_minutes = int((maxValue - minValue).total_seconds() // 60)
    values = [0] * total_minutes


    for shift in shifts:
        diffecence_by_origin = int((shift[0] - minValue).total_seconds() // 60)

        shift_len = int((shift[1] - shift[0]).total_seconds() // 60)
        
        for i in range(shift_len):
            values[i + diffecence_by_origin] += shift[2]

    start_delta = int((start - minValue).total_seconds() // 60)
    end_delta = int((end - minValue).total_seconds() // 60)

    values = values[start_delta:end_delta]

    #for i in range(len(values)):
    #    print(i, ', ', values[i])


    #create shifts    
    numeric_shifts = [[key, len(list(group))] for key, group in groupby(values)]
    if slot != None:
        new_numeric_shifts = []
        for numeric_shift in numeric_shifts:
            if numeric_shift[0] > 0:
                for _ in range(numeric_shift[1]//slot):
                    new_numeric_shifts.append([numeric_shift[0], slot])

                if numeric_shift[1]%slot != 0:
                    new_numeric_shifts.append([0, numeric_shift[1]%slot])
            else:
                new_numeric_shifts.append(numeric_shift)
        numeric_shifts = new_numeric_shifts
    #print('numeric_shifts', numeric_shifts)

    start_minutes = 0
    shifts = []
    for numeric_shift in numeric_shifts:
        #start time
        start_time = minValue + timedelta(minutes=start_minutes) + timedelta(minutes=start_delta)

        #end time
        start_minutes += numeric_shift[1]
        end_time = minValue + timedelta(minutes=start_minutes) + timedelta(minutes=start_delta)

        shift = [start_time, end_time, numeric_shift[0]]
        shifts.append(shift)


    return shifts

def sendEmail(email, subject, body):
    message = f"Subject: {subject}\n\n{body}"

    sendMail.send(email, message)

def token_for(id):
    token = secrets.token_hex() 
    sql = "SELECT * FROM users WHERE token = %s"
    result = db.fetchSQL(sql, (token,))
    if len(result) > 0:
        return token_for(id)
    
    sql = "UPDATE users SET token = %s WHERE id = %s"
    db.executeSQL(sql, (token, id))
    return token

def generate_password(length=12):
    characters = string.ascii_letters + string.digits
    password = ''.join(secrets.choice(characters) for _ in range(length))
    return password

def check_and_send_notifications():
    #with app.app_context():

    now = datetime.now(rome_tz)


    for notification_time_delta in notification_times_delta:
        time_delta = timedelta(minutes=notification_time_delta)

        notification_time = now + time_delta
        #print('\n'+str(notification_time_delta))
        #print(notification_time)

        sql = '''
            SELECT * FROM bookings
            WHERE 
                DATE(start) = %s
                AND HOUR(start) = %s 
                AND MINUTE(start) = %s 
                AND status = 1
        '''
        parameters = (
            notification_time.date(),
            notification_time.hour,
            notification_time.minute
        )

        result = db.fetchSQL(sql, parameters)
        if len(result) == 0:
            continue


        for record in result:
            #for every booking
            resource_id = record[5]
            referents = {}
            

            user_id = record[4]
            user_email = getEmailFromId(user_id)

            sql = "SELECT * FROM users WHERE id = %s"
            user_content = db.fetchSQL(sql, (user_id,))
            if len(user_content) == 0:
                continue
            user_email = user_content[0][3]
            user_language = user_content[0][6]

            sql = '''
                SELECT name FROM resources WHERE id = %s
            '''
            resource_name = db.fetchSQL(sql, (resource_id,))[0][0]



            sql = '''
                SELECT * FROM referents WHERE resource_id = %s
            '''
            referents_content = db.fetchSQL(sql, (resource_id,))


            for referent in referents_content:
                referent_id = referent[2]

                sql = "SELECT * FROM users WHERE id = %s"
                user_content = db.fetchSQL(sql, (referent_id,))
                if len(user_content) == 0:
                    continue
                referent_email = user_content[0][3]
                referents[referent_email] = user_content[0][6]

            print('mail to user: ', user_email)
            print('mail to referents: ', referents)

            #   - - -   user part   - - -   #

            user_mail_content = mail_content[user_language]['bookings_user_reminder']


            subject = user_mail_content['subject']
            body = user_mail_content['content'] % (
                str(record[3]), 
                resource_name, 
                str(record[1].date()),
                str(record[1].hour)+':'+str(record[1].minute),
                str(record[2].date()),
                str(record[2].hour)+':'+str(record[2].minute)
                )

            emailSenderThread = threading.Thread(
                target=sendEmail, 
                args=(
                    user_email, 
                    subject, 
                    body
                    )
                )
            
            emailSenderThread.start()
            print('\n')
            print('user mail: ', subject, '\n', body)
            print('\n')

            #   - - -   referents part   - - -   #

            for referent_email in referents.keys():
                referent_language = referents[referent_email]
                referent_mail_content = mail_content[referent_language]['bookings_referent_reminder']


                subject = referent_mail_content['subject']
                body = referent_mail_content['content'] % (
                    user_email,
                    str(record[3]), 
                    resource_name, 
                    str(record[1].date()),
                    str(record[1].hour)+':'+str(record[1].minute),
                    str(record[2].date()),
                    str(record[2].hour)+':'+str(record[2].minute)
                )

                emailSenderThread = threading.Thread(
                    target=sendEmail, 
                    args=(
                        referent_email, 
                        subject, 
                        body
                        )
                    )
                
                print('referent mail: ', referent_email, '\n', subject, '\n', body)
                print('\n')
                emailSenderThread.start()


            print(now.minute, record)

    parameters = (
        now,
    )


    sql = '''
        UPDATE bookings
        Set status = 4
        WHERE 
            end <= %s
            AND status = 0
    '''

    db.executeSQL(sql, parameters)

    return

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
