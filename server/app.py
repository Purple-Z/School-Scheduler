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
        sql_insert = f'''
        INSERT INTO places
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
        sql = f'''
            SELECT * FROM places WHERE id = '{place_id}'
        '''    
        result = db.fetchSQL(sql)
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

    sql_update = f'''
    UPDATE places SET
        name = '{name}',
        description = '{description}'
    WHERE id = {place_id}
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
        sql_delete = f'''
        DELETE FROM places
        WHERE id = {place_id}
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
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

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
        sql_insert = f'''
        INSERT INTO activities
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
        sql = f'''
            SELECT * FROM activities WHERE id = '{activity_id}'
        '''    
        result = db.fetchSQL(sql)
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

    sql_update = f'''
    UPDATE activities SET
        name = '{name}',
        description = '{description}'
    WHERE id = {activity_id}
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
        sql_delete = f'''
        DELETE FROM activities
        WHERE id = {activity_id}
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
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401

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
        sql = f'''
            SELECT name FROM types WHERE id = '{resource[4]}'
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

    sql = "SELECT id FROM types WHERE name = '" + type + "'"
    result = db.fetchSQL(sql)
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 501
    
    type_id = result[0][0]

    sql = "SELECT id FROM places WHERE name = '" + place + "'"
    result = db.fetchSQL(sql)
    place_id = None
    if len(result) != 0:
        place_id = result[0][0]

    sql = "SELECT id FROM activities WHERE name = '" + activity + "'"
    result = db.fetchSQL(sql)
    activity_id = None
    if len(result) != 0:
        activity_id = result[0][0]
    
    if slot == -1:
        slot = None

    try:
        sql_insert = f'''
        INSERT INTO resources
        (id, name, description, quantity, type_id, place_id, activity_id, slot, auto_accept, overbooking)
        VALUES (
            0,
            '{name}', 
            '{description}',
            {quantity}, 
            {type_id},
            {'null' if place_id is None else place_id},
            {'null' if activity_id is None else activity_id},
            {'null' if slot is None else slot},
            {auto_accept},
            {over_booking}
        )
        '''
        db.executeSQL(sql_insert)

        resource_id = db.fetchSQL(
                f'''SELECT id FROM resources WHERE name = '{name}\''''
            )[0][0]
        

        for role in resource_permissions.keys():
            role_id = db.fetchSQL(
                f'''SELECT id FROM roles WHERE name = '{role}\''''
            )[0][0]

            sql_insert = f'''
            INSERT INTO permissions
            VALUES (
                0,
                {resource_permissions[role][0]}, 
                {resource_permissions[role][1]},
                {resource_permissions[role][2]}, 
                {resource_permissions[role][3]},
                {resource_permissions[role][4]},
                {role_id},
                {resource_id}
            )
            '''
            db.executeSQL(sql_insert)


        for referent in referents.keys():

            referent_id = getIdFromEmail(referent)

            sql_insert = f'''
            INSERT INTO referents
            VALUES (
                0,
                {referents[referent]}, 
                {referent_id},
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
            SELECT name FROM types WHERE id = '{resource_content[4]}'
        '''    
        result = db.fetchSQL(sql)
        type_name = result[0][0]

        sql = f'''
            SELECT name FROM places WHERE id = '{resource_content[5]}'
        '''    
        result = db.fetchSQL(sql)
        place_name = ''
        if len(result) != 0:
            place_name = result[0][0]

        sql = f'''
            SELECT name FROM activities WHERE id = '{resource_content[6]}'
        '''    
        result = db.fetchSQL(sql)
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

        sql = f'''
            SELECT * FROM referents WHERE resource_id = '{resource_id}'
        '''    
        result = db.fetchSQL(sql)

        referents = {}

        for record in result:
            referent_id = record[2]

            sql = "SELECT email FROM users WHERE id = " + str(referent_id)
            result = db.fetchSQL(sql)
            if len(result) == 0:
                continue
            user_email = result[0][0]
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

    sql = "SELECT id FROM types WHERE name = '" + type + "'"
    result = db.fetchSQL(sql)
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 501
    
    type_id = result[0][0]


    sql = "SELECT id FROM places WHERE name = '" + place + "'"
    result = db.fetchSQL(sql)
    place_id = None
    if len(result) != 0:
        place_id = result[0][0]

    sql = "SELECT id FROM activities WHERE name = '" + activity + "'"
    result = db.fetchSQL(sql)
    activity_id = None
    if len(result) != 0:
        activity_id = result[0][0]

    if slot == -1:
        slot = None


    sql_update = f'''
    UPDATE resources SET
        name = '{name}',
        description = '{description}',
        quantity = {quantity},
        type_id = {type_id},
        auto_accept = {auto_accept},
        overbooking = {over_booking},
        place_id = {'null' if place_id is None else place_id},
        activity_id = {'null' if activity_id is None else activity_id},
        slot = {'null' if slot is None else slot}
    WHERE id = {resource_id}
    '''


    try:
        db.executeSQL(sql_update)

        sql_delete = f'''
        DELETE FROM permissions WHERE resource_id = {resource_id}
        '''
        db.executeSQL(sql_delete)

        for role in resource_permissions.keys():
            role_id = db.fetchSQL(
                f'''SELECT id FROM roles WHERE name = '{role}\''''
            )[0][0]

            sql_insert = f'''
            INSERT INTO permissions
            VALUES (
                0,
                {resource_permissions[role][0]}, 
                {resource_permissions[role][1]},
                {resource_permissions[role][2]}, 
                {resource_permissions[role][3]},
                {resource_permissions[role][4]},
                {role_id},
                {resource_id}
            )
            '''
            db.executeSQL(sql_insert)

        
        sql_delete = f'''
        DELETE FROM referents WHERE resource_id = {resource_id}
        '''
        db.executeSQL(sql_delete)


        for referent in referents.keys():

            referent_id = getIdFromEmail(referent)

            sql_insert = f'''
            INSERT INTO referents
            VALUES (
                0,
                {referents[referent]}, 
                {referent_id},
                {resource_id}
            )
            '''
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
        role_id = db.fetchSQL(
            f'''SELECT id FROM roles WHERE name = '{role}\''''
        )[0][0]

        permission = db.fetchSQL(
            f'''SELECT * FROM permissions WHERE role_id = {role_id} and resource_id = {resource_id}'''
        )

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
    
    if not checkUserPermission(email, 'view_resources'):
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 401
    
    user_id = getIdFromEmail(email)

    roles_id = db.fetchSQL(
        f'''
            SELECT role_id FROM users_roles WHERE user_id = {user_id}
        '''
    )

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
        resource = db.fetchSQL(
            f'''
                SELECT * FROM resources WHERE id = {resource_id}
            '''
        )[0]

        type_name = db.fetchSQL(
            f'''
                SELECT name FROM types WHERE id = {resource[4]}
            '''
        )[0][0]
        
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

    roles_id = db.fetchSQL(
        f'''
            SELECT role_id FROM users_roles WHERE user_id = {user_id}
        '''
    )

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
        sql = f'''
            SELECT * FROM resources WHERE id = '{resource_id}'
        '''    
        result = db.fetchSQL(sql)
        resource_content = result[0]

        sql = f'''
            SELECT name FROM types WHERE id = '{resource_content[4]}'
        '''    
        result = db.fetchSQL(sql)
        type_name = result[0][0]

        place_name = resource_content[5] if resource_content[5] != None else ''
        if resource_content[5] != None:
            sql = f'''
                SELECT name FROM places WHERE id = '{resource_content[5]}'
            '''    
            result = db.fetchSQL(sql)
            place_name = result[0][0]


        activity_name = resource_content[6] if resource_content[6] != None else ''
        if resource_content[6] != None:
            sql = f'''
                SELECT name FROM activities WHERE id = '{resource_content[6]}'
            '''    
            result = db.fetchSQL(sql)
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

        content = {
            'start': start.isoformat(),
            'end': end.isoformat(),
            'shifts': shifts,
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
    
    sql = f'''
            SELECT * FROM resources WHERE id = '{resource_id}'
        '''    
    result = db.fetchSQL(sql)
    if len(result) == 0:
        return jsonify(
            {
                "token": token_for(user_id)
            }
        ), 500
    
    print(result[0][5])
    

    place = '' if place == None else place
    place_name = '' if result[0][5] != None else place
    sql = "SELECT id FROM places WHERE name = '" + place_name + "'"
    place_result = db.fetchSQL(sql)
    place_id = None
    if len(place_result) != 0:
        place_id = place_result[0][0]

    print('activity:' , activity)
    activity = '' if activity == None else activity
    activity_name = '' if result[0][6] != None else activity
    sql = "SELECT id FROM activities WHERE name = '" + activity_name + "'"
    activity_result = db.fetchSQL(sql)
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
        


        sql_insert = f'''
        INSERT INTO bookings
        (id, start, end, quantity, resource_id, user_id, status, place_id, activity_id)
        VALUES (
            0,
            '{start}', 
            '{end}',
            {quantity}, 
            {resource_id},
            {user_id},
            {1 if auto_accept is True else 0},
            {'null' if place_id is None else place_id},
            {'null' if activity_id is None else activity_id}
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

    bookings_content = db.fetchSQL(
        f'''
            SELECT * FROM bookings WHERE status = 0
        '''
    )

    roles_id = db.fetchSQL(
        f'''
            SELECT role_id FROM users_roles WHERE user_id = {user_id}
        '''
    )

    permission = getResourcesPermissions(roles_id)

    bookings = []
    for booking in bookings_content:
        resource_id = booking[5]

        if resource_id not in permission or permission[resource_id][4] != 1:
            continue


        booking = list(booking)
        sql = f'''
            SELECT name FROM resources WHERE id = '{booking[5]}'
        '''    
        result = db.fetchSQL(sql)
        resource_name = result[0][0]

        sql = f'''
            SELECT email FROM users WHERE id = '{booking[4]}'
        '''    
        result = db.fetchSQL(sql)
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

    bookings_content = db.fetchSQL(
        f'''
            SELECT * FROM bookings WHERE id = {request_id}
        '''
    )

    roles_id = db.fetchSQL(
        f'''
            SELECT role_id FROM users_roles WHERE user_id = {user_id}
        '''
    )


    resource_id = bookings_content[0][5]
    permission = getResourcesPermissions(roles_id)[resource_id]
    if permission[4] != 1:
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 402

    sql_update = f'''
        UPDATE bookings SET
            status = 1,
            validator_id = {user_id}
        WHERE id = {request_id}
        '''

    db.executeSQL(sql_update)
    

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

    bookings_content = db.fetchSQL(
        f'''
            SELECT * FROM bookings WHERE id = {request_id}
        '''
    )

    roles_id = db.fetchSQL(
        f'''
            SELECT role_id FROM users_roles WHERE user_id = {user_id}
        '''
    )


    resource_id = bookings_content[0][5]
    permission = getResourcesPermissions(roles_id)[resource_id]
    if permission[4] != 1:
        return jsonify(
            {
                'message': 'Access denied'
            }
            ), 402

    sql_update = f'''
        UPDATE bookings SET
            status = 2,
            validator_id = {user_id}
        WHERE id = {request_id}
        '''

    db.executeSQL(sql_update)
    

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
    bookings = []
    for booking in bookings_content:
        booking = list(booking)
        sql = f'''
            SELECT email FROM users WHERE id = '{booking[4]}'
        '''    
        result = db.fetchSQL(sql)
        user_mail = result[0][0]

        sql = f'''
            SELECT name FROM resources WHERE id = '{booking[5]}'
        '''    
        result = db.fetchSQL(sql)
        resource_name = result[0][0]

        place_name = ''
        if booking[7] != None:
            sql = f'''
                SELECT name FROM places WHERE id = '{booking[7]}'
            '''    
            result = db.fetchSQL(sql)
            place_name = result[0][0]

        activity_name = ''
        if booking[8] != None:
            sql = f'''
                SELECT name FROM activities WHERE id = '{booking[8]}'
            '''    
            result = db.fetchSQL(sql)
            activity_name = result[0][0]

        validator_email = ''
        if booking[9] != None:
            sql = f'''
                SELECT email FROM users WHERE id = '{booking[9]}'
            '''    
            result = db.fetchSQL(sql)
            validator_email = result[0][0]

        booking[1] = booking[1].isoformat()
        booking[2] = booking[2].isoformat()

        booking[4] = user_mail
        booking[5] = resource_name
        booking[7] = place_name
        booking[8] = activity_name
        booking[9] = validator_email

        bookings.append(booking)

    return jsonify(
        {
            "bookings": bookings,
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

def getResourcesPermissions(roles_id):
    permission = {}

    for role_id in roles_id:
        role_id = role_id[0]

        result = db.fetchSQL(
            f'''
                SELECT * FROM permissions WHERE role_id = {role_id}
            '''
        )

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

def selectAvailabilityRecordsFromShift(start, end, resource_id, remove_availability_id=-1):
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

    return shifts_content

def selectAllRecordsFromShift(start, end, resource_id, remove_booking_id=-1):

    sql = f'SELECT * FROM resources WHERE id = {resource_id}'
    result = db.fetchSQL(sql)
    if len(result) == 0:
        return -1
    
    slot = result[0][7]
    auto_accept = result[0][8]==1
    over_booking = result[0][9]==1




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
        if record[0] != remove_booking_id:
            shift = []
            shift.append(record[1])
            shift.append(record[2])
            shift.append(record[3])
            shifts_content.append(shift)

    sql = f'''
    SELECT * FROM bookings WHERE

    (
        (
            (NOT(start > '{end}' AND end > '{end}'))
            AND
            (NOT(start < '{start}' AND end < '{start}'))
        ) AND (
            (status = 1 OR {1 if over_booking is True else 0} = 0) AND ({1 if auto_accept is True else 0} = 0)
            OR 
            ({1 if auto_accept is True else 0} = 1)
        ) AND (status != 2)
    )
    AND
    resource_id = {resource_id}
    '''
    result = db.fetchSQL(sql)

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
    
    sql = f'SELECT quantity FROM resources WHERE id = {resource_id}'
    result = db.fetchSQL(sql)
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

def getMaxBookability(resource_id, start, end, remove_booking_id):
    if end < start:
        return -1
    
    sql = f'SELECT * FROM resources WHERE id = {resource_id}'
    result = db.fetchSQL(sql)
    if len(result) == 0:
        return -1
    
    slot = result[0][7]
    auto_accept = result[0][8]==1
    over_booking = result[0][9]==1


    shifts_content = selectAllRecordsFromShift(start, end, resource_id, remove_booking_id)

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
            if numeric_shift[0] != 0:
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
