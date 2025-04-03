import mysql.connector

class setupDB():
    host = "localhost"
    user = "root"
    password = "admin"
    database = "school_scheduler"
    db = mysql.connector.connect(
        host = host,
        user = user,
        password = password,
        database = database
    )
    mycursor = db.cursor()

    def __init__(self, isFirstTime = True):
        try:
            mydb = mysql.connector.connect(
                host = self.host,
                user = self.user,
                password = self.password,
                database = self.database
            )

            mycursor = mydb.cursor()
            

            # CREATE TABLE   - - -   roles   - - -
            mycursor.execute('''
                    CREATE TABLE IF NOT EXISTS roles (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        name VARCHAR(255) UNIQUE NOT NULL,
                        description TEXT,
                             
                        view_users BOOLEAN DEFAULT FALSE,
                        edit_users BOOLEAN DEFAULT FALSE,
                        create_users BOOLEAN DEFAULT FALSE,
                        delete_users BOOLEAN DEFAULT FALSE,
                             
                        view_own_user BOOLEAN DEFAULT FALSE,
                        edit_own_user BOOLEAN DEFAULT FALSE,
                        create_own_user BOOLEAN DEFAULT FALSE,
                        delete_own_user BOOLEAN DEFAULT FALSE,
                             
                        view_roles BOOLEAN DEFAULT FALSE,
                        edit_roles BOOLEAN DEFAULT FALSE,
                        create_roles BOOLEAN DEFAULT FALSE,
                        delete_roles BOOLEAN DEFAULT FALSE,
                             
                        view_availability BOOLEAN DEFAULT FALSE,
                        edit_availability BOOLEAN DEFAULT FALSE,
                        create_availability BOOLEAN DEFAULT FALSE,
                        delete_availability BOOLEAN DEFAULT FALSE,
                             
                        view_resources BOOLEAN DEFAULT FALSE,
                        edit_resources BOOLEAN DEFAULT FALSE,
                        create_resources BOOLEAN DEFAULT FALSE,
                        delete_resources BOOLEAN DEFAULT FALSE,
                             
                        view_booking BOOLEAN DEFAULT FALSE,
                        edit_booking BOOLEAN DEFAULT FALSE,
                        create_booking BOOLEAN DEFAULT FALSE,
                        delete_booking BOOLEAN DEFAULT FALSE,
                             
                        view_own_booking BOOLEAN DEFAULT FALSE,
                        edit_own_booking BOOLEAN DEFAULT FALSE,
                        create_own_booking BOOLEAN DEFAULT FALSE,
                        delete_own_booking BOOLEAN DEFAULT FALSE
                    );
            ''')

            # CREATE TABLE   - - -   users   - - -
            mycursor.execute('''
                    CREATE TABLE IF NOT EXISTS users (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        name VARCHAR(255) NOT NULL,
                        surname VARCHAR(255) NOT NULL,
                        email VARCHAR(255) UNIQUE NOT NULL,
                        password_hash VARCHAR(255) NOT NULL,
                        token VARCHAR(255),
                        language VARCHAR(5) DEFAULT 'it'
                    );
            ''')

            # CREATE TABLE   - - -   users_roles   - - -
            mycursor.execute('''
                    CREATE TABLE IF NOT EXISTS users_roles (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        user_id INT,
                        role_id INT,
                        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                        FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
                    );
            ''')

            # CREATE TABLE   - - -   types   - - -
            mycursor.execute('''
                    CREATE TABLE IF NOT EXISTS types (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        name VARCHAR(255) NOT NULL,
                        description TEXT
                    );
            ''')

            # CREATE TABLE   - - -   places   - - -
            mycursor.execute('''
                    CREATE TABLE IF NOT EXISTS places (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        name VARCHAR(255) NOT NULL,
                        description TEXT
                    );
            ''')

            # CREATE TABLE   - - -   activities   - - -
            mycursor.execute('''
                    CREATE TABLE IF NOT EXISTS activities (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        name VARCHAR(255) NOT NULL,
                        description TEXT
                    );
            ''')

            # CREATE TABLE   - - -   resources   - - -
            mycursor.execute('''
                    CREATE TABLE IF NOT EXISTS resources (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        name VARCHAR(255) NOT NULL,
                        description TEXT,
                        quantity INT NOT NULL,
                        type_id INT,
                        place_id INT,
                        activity_id INT,
                        slot INT,
                        auto_accept BOOLEAN,
                        overbooking BOOLEAN,
                        FOREIGN KEY (type_id) REFERENCES types(id) ON DELETE SET NULL,
                        FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE SET NULL,
                        FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE SET NULL
                    );
            ''')

            # CREATE TABLE   - - -   referents   - - -
            mycursor.execute('''
                    CREATE TABLE IF NOT EXISTS referents (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        notify BOOLEAN DEFAULT TRUE,
                        user_id INT,
                        resource_id INT,
                        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                        FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE
                    );
            ''')

            # CREATE TABLE   - - -   permissions   - - -
            mycursor.execute('''
                    CREATE TABLE IF NOT EXISTS permissions (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        view BOOLEAN DEFAULT FALSE,
                        remove BOOLEAN DEFAULT FALSE,
                        edit BOOLEAN DEFAULT FALSE,
                        book BOOLEAN DEFAULT FALSE,
                        can_accept BOOLEAN,
                        role_id INT,
                        resource_id INT,
                        FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
                        FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE
                    );
            ''')

            # CREATE TABLE   - - -   availability   - - -
            mycursor.execute('''
                    CREATE TABLE IF NOT EXISTS availability (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        start DATETIME NOT NULL,
                        end DATETIME NOT NULL,
                        quantity INT NOT NULL,
                        resource_id INT,
                        FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE
                    );
            ''')

            # CREATE TABLE   - - -   bookings   - - -
            mycursor.execute('''
                    CREATE TABLE IF NOT EXISTS bookings (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        start DATETIME NOT NULL,
                        end DATETIME NOT NULL,
                        quantity INT NOT NULL,
                        user_id INT,
                        resource_id INT,
                        status INT DEFAULT 0,
                        place_id INT,
                        activity_id INT,
                        validator_id INT,
                        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                        FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE,
                        FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE SET NULL,
                        FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE SET NULL,
                        FOREIGN KEY (validator_id) REFERENCES users(id) ON DELETE CASCADE
                    );
            ''')

            ## CREATE TABLE   - - -   notifications   - - -
            #mycursor.execute('''
            #        CREATE TABLE IF NOT EXISTS notifications (
            #            id INT AUTO_INCREMENT PRIMARY KEY,
            #            notificated BOOLEAN DEFAULT TRUE,
            #            user_id INT,
            #            booking_id INT,
            #            time_anticipation INT,
            #            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
            #            FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
            #        );
            #''')
        




        except:
            mydb = mysql.connector.connect(
            host = self.host,
            user = self.user,
            password = self.password,
            )

            mycursor = mydb.cursor()

            # Crea il database school_scheduler
            mycursor.execute("CREATE DATABASE if not exists school_scheduler")

            # Seleziona il database register
            mycursor.execute("USE school_scheduler")

            # Crea la tabella users
            if isFirstTime:
                self.__init__(False)
            print('database creato')

    def remove(self):
        # Elimina il database mydatabase
        self.mycursor.execute("DROP DATABASE school_scheduler")
        self.db.commit()

    def clear(self):
        sql = "DELETE FROM users"
        self.mycursor.execute(sql)
        self.db.commit()

    def fetchSQL(self, sql):
        self.mycursor.execute(sql)
        result = self.mycursor.fetchall()
        self.db.commit()

        return result

    def executeSQL(self, sql):
        self.mycursor.execute(sql)
        self.db.commit()