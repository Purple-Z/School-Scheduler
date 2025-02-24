from flask import Flask, request, jsonify
import secrets, string, threading
from datetime import datetime, timedelta
from itertools import groupby
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
    roles = []


    sql = "SELECT role_id FROM users_roles WHERE user_id = " + str(user_id)

    result = db.fetchSQL(sql)
    if result:
        roles_ids = result[0]
        for role_id in roles_ids:
            roles.append(getRoleInformation(role_id))
    #print("roles: " + str(roles))

    if user_password_hash == password:
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

    sql_insert = f'''
        INSERT INTO roles
        (name, 
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
        delete_own_booking)
    VALUES (
        '{name}', 
        '{description}', 
        {view_users}, 
        {edit_users}, 
        {create_users}, 
        {delete_users}, 
        {view_own_user}, 
        {edit_own_user}, 
        {create_own_user}, 
        {delete_own_user}, 
        {view_roles}, 
        {edit_roles}, 
        {create_roles}, 
        {delete_roles}, 
        {view_availability}, 
        {edit_availability}, 
        {create_availability}, 
        {delete_availability}, 
        {view_resources}, 
        {edit_resources}, 
        {create_resources}, 
        {delete_resources}, 
        {view_booking}, 
        {edit_booking}, 
        {create_booking}, 
        {delete_booking}, 
        {view_own_booking}, 
        {edit_own_booking}, 
        {create_own_booking}, 
        {delete_own_booking}
    );
    '''

    try:
        #print('sql, ' + sql_insert)
        db.executeSQL(sql_insert)
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


    sql = f'''
        SELECT * FROM roles WHERE id = {str(role_id)}
    '''    
    user_id = getIdFromEmail(email)



    try:
        result = db.fetchSQL(sql)
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

    sql_update = f'''
    UPDATE roles SET
        name = '{name}',
        description = '{description}',
        view_users = {view_users},
        edit_users = {edit_users},
        create_users = {create_users},
        delete_users = {delete_users},
        view_own_user = {view_own_user},
        edit_own_user = {edit_own_user},
        create_own_user = {create_own_user},
        delete_own_user = {delete_own_user},
        view_roles = {view_roles},
        edit_roles = {edit_roles},
        create_roles = {create_roles},
        delete_roles = {delete_roles},
        view_availability = {view_availability},
        edit_availability = {edit_availability},
        create_availability = {create_availability},
        delete_availability = {delete_availability},
        view_resources = {view_resources},
        edit_resources = {edit_resources},
        create_resources = {create_resources},
        delete_resources = {delete_resources},
        view_booking = {view_booking},
        edit_booking = {edit_booking},
        create_booking = {create_booking},
        delete_booking = {delete_booking},
        view_own_booking = {view_own_booking},
        edit_own_booking = {edit_own_booking},
        create_own_booking = {create_own_booking},
        delete_own_booking = {delete_own_booking}
    WHERE id = {role_id}
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
        sql_delete = f'''
        DELETE FROM roles
        WHERE id = {str(role_id)}
        '''

        db.executeSQL(sql_delete)
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
        sql = "SELECT role_id FROM users_roles WHERE user_id = " + str(user[0])
        role_ids = db.fetchSQL(sql)
        if len(role_ids) != 0:
            for role in role_ids:
                sql = "SELECT name FROM roles WHERE id = " + str(role[0])
                result = db.fetchSQL(sql)
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
def add_users():
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
        sql_insert = f'''
        INSERT INTO users
        (id, name, surname, email, password_hash, token)
        VALUES (
            0,
            '{new_name}', 
            '{new_surname}', 
            '{new_email}', 
            '{password}', 
            ' '
        )
        '''
        db.executeSQL(sql_insert)

        new_user_id = getIdFromEmail(new_email)

        for new_role in new_roles:
            sql = "SELECT id FROM roles WHERE name = '" + new_role + "'"
            new_role_id = db.fetchSQL(sql)[0][0]
            

            sql_insert = f'''
            INSERT INTO users_roles
            (id, user_id, role_id)
            VALUES (
                0,
                {new_user_id}, 
                {new_role_id}
            )
            '''
            db.executeSQL(sql_insert)

        emailSenderThread = threading.Thread(target=sendEmail, args=(new_email, subject, body))
        emailSenderThread.start()
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
        sql = f'''
            SELECT * FROM users WHERE id = '{new_user_id}'
        '''    
        result = db.fetchSQL(sql)
        user_content = result[0]

        sql = "SELECT role_id FROM users_roles WHERE user_id = " + str(user_content[0])
        role_ids = db.fetchSQL(sql)
        user_roles = []
        if len(role_ids) != 0:
            for role in role_ids:
                sql = "SELECT name FROM roles WHERE id = " + str(role[0])
                result = db.fetchSQL(sql)
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

    sql_update = f'''
    UPDATE users SET
        name = '{new_name}',
        surname = '{new_surname}'
    WHERE id = {new_user_id}
    '''


    sql_delete = f"DELETE FROM users_roles WHERE user_id = {new_user_id}"
    db.executeSQL(sql_delete)



    for new_role in new_roles:
        sql = "SELECT id FROM roles WHERE name = '" + new_role + "'"
        new_role_id = db.fetchSQL(sql)[0][0]
        

        sql_insert = f'''
        INSERT INTO users_roles
        (id, user_id, role_id)
        VALUES (
            0,
            {new_user_id}, 
            {new_role_id}
        )
        '''
        db.executeSQL(sql_insert)


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
    
@app.route('/reset-password', methods=['POST']) ## to be restored
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

@app.route('/delete-user', methods=['POST']) ## to be restored
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
        sql_insert = f'''
        INSERT INTO types
        (id, name, description)
        VALUES (
            0,
            '{name}', 
            '{description}'
        )
        '''
        db.executeSQL(sql_insert)

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
        sql = f'''
            SELECT * FROM types WHERE id = '{type_id}'
        '''    
        result = db.fetchSQL(sql)
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

    sql_update = f'''
    UPDATE types SET
        name = '{name}',
        description = '{description}'
    WHERE id = {type_id}
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
    
@app.route('/delete-type', methods=['POST']) ## to be restored
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
        sql_delete = f'''
        DELETE FROM types
        WHERE id = {type_id}
        '''

        db.executeSQL(sql_delete)
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
        sql = f'''
            SELECT name FROM types WHERE id = '{resource[len(resource)-1]}'
        '''    
        result = db.fetchSQL(sql)
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
    type = data.get('type')
    
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

    sql = "SELECT id FROM types WHERE name = '" + type + "'"
    result = db.fetchSQL(sql)
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 501
    
    type_id = result[0][0]


    try:
        sql_insert = f'''
        INSERT INTO resources
        (id, name, description, quantity, type_id)
        VALUES (
            0,
            '{name}', 
            '{description}',
            {quantity}, 
            {type_id}
        )
        '''
        db.executeSQL(sql_insert)

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
        sql = f'''
            SELECT * FROM resources WHERE id = '{resource_id}'
        '''    
        result = db.fetchSQL(sql)
        resource_content = result[0]

        sql = f'''
            SELECT name FROM types WHERE id = '{resource_content[len(resource_content)-1]}'
        '''    
        result = db.fetchSQL(sql)
        type_name = result[0][0]

        resource = []
        for quality in resource_content:
            resource.append(quality)

        resource[len(resource)-1] = type_name

        return jsonify(
        {
            "resource": resource,
            "token": token_for(user_id)
        }
    ), 200
    except:
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
    resource_id = data.get('resource_id')
    name = data.get('name')
    description = data.get('description')
    quantity = data.get('quantity')
    type = data.get('type')

    
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

    sql = "SELECT id FROM types WHERE name = '" + type + "'"
    result = db.fetchSQL(sql)
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 501
    
    type_id = result[0][0]

    sql_update = f'''
    UPDATE resources SET
        name = '{name}',
        description = '{description}',
        quantity = {quantity},
        type_id = {type_id}
    WHERE id = {resource_id}
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
    
@app.route('/delete-resource', methods=['POST']) ## to be restored
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
        sql_delete = f'''
        DELETE FROM resources
        WHERE id = {resource_id}
        '''

        db.executeSQL(sql_delete)
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

    availabilities_content = db.fetchSQL(
        f'''
            SELECT * FROM availability WHERE resource_id = {resource_id}
        '''
    )
    availabilities = []
    for availability in availabilities_content:
        availability = list(availability)
        sql = f'''
            SELECT name FROM resources WHERE id = '{availability[len(availability)-1]}'
        '''    
        result = db.fetchSQL(sql)
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
        sql_insert = f'''
        INSERT INTO availability
        (id, start, end, quantity, resource_id)
        VALUES (
            0,
            '{start}', 
            '{end}',
            {quantity}, 
            {resource_id}
        )
        '''
        db.executeSQL(sql_insert)

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
        sql = f'''
            SELECT * FROM availability WHERE id = '{availability_id}'
        '''    
        result = db.fetchSQL(sql)
        availability_content = result[0]

        sql = f'''
            SELECT name FROM resources WHERE id = '{availability_content[len(availability_content)-1]}'
        '''    
        result = db.fetchSQL(sql)
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

    sql = "SELECT resource_id FROM availability WHERE id = " + str(availability_id)
    result = db.fetchSQL(sql)
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 501

    resource_id = result[0][0]
    

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

    sql_update = f'''
    UPDATE availability SET
        start = '{start}',
        end = '{end}',
        quantity = {quantity}
    WHERE id = {availability_id}
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
        ), 500
    
@app.route('/delete-availability', methods=['POST']) ## to be restored
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



    try:
        sql_delete = f'''
        DELETE FROM availability
        WHERE id = {availability_id}
        '''

        db.executeSQL(sql_delete)
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

    if not getMaxAvailability:
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


def checkUserToken(email, token):
    #collecting data...
    sql = "SELECT * FROM users WHERE email = '" + email + "'"
    result = db.fetchSQL(sql)
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
    sql = "SELECT id FROM users WHERE email = '" + email + "'"
    result = db.fetchSQL(sql)
    if len(result) != 1:
        return False

    user_id = result[0][0]


    sql = "SELECT role_id FROM users_roles WHERE user_id = " + str(user_id)
    result = db.fetchSQL(sql)
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
    sql = "SELECT * FROM roles WHERE id = " + str(role_id)
    role_content = db.fetchSQL(sql)[0]
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
    sql = "SELECT * FROM users WHERE email = '" + email + "'"
    result = db.fetchSQL(sql)
    if len(result) != 1:
        return None

    user = result[0]

    user_id = user[0]


    return user_id

def getMaxAvailability(resource_id, start, end, remove_availability_id):
    if end < start:
        return False

    sql = f'SELECT quantity FROM resources WHERE id = {resource_id}'
    result = db.fetchSQL(sql)
    if len(result) == 0:
        return False

    maxAvailability = result[0][0]

    sql = f'''
    SELECT * FROM availability WHERE

    (
        (NOT(start > '{end}' AND end > '{end}'))
        AND
        (NOT(start < '{start}' AND end < '{start}'))
    )
    AND
    resource_id = {resource_id}
    '''
    result = db.fetchSQL(sql)

    shifts_content = []
    for record in result:
        if record[0] != remove_availability_id:
            shift = []
            shift.append(record[1])
            shift.append(record[2])
            shift.append(record[3])
            shifts_content.append(shift)

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

def getShiftValue(shifts, start=False, end=False):
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
