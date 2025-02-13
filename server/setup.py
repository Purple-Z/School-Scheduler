import mysql.connector

class setupDB():
    host = "localhost"
    user = "root"
    password = "admin"
    database = "school_scheduler"

    def __init__(self, isFirstTime = True):
        try:
            mydb = mysql.connector.connect(
                host = self.host,
                user = self.user,
                password = self.password,
                database = self.database
            )

            mycursor = mydb.cursor()

            try:
                # CREATE TABLE   - - -   users   - - -
                mycursor.execute(
                    '''
                        CREATE TABLE IF NOT EXISTS users (
                            id INT PRIMARY KEY AUTO_INCREMENT,
                            name VARCHAR(50) NOT NULL,
                            surname VARCHAR(50) NOT NULL,
                            email VARCHAR(100) UNIQUE,
                            password_hash VARCHAR(50) NOT NULL,
                            admin BOOL NOT NULL,
                            leader BOOL NOT NULL,
                            professor BOOL NOT NULL,
                            student BOOL NOT NULL,
                            token VARCHAR(64) NOT NULL
                        );
                    '''
                )
                print('Created table users!')
            except Exception as errore:
                pass



        except:
            mydb = mysql.connector.connect(
            host = self.host,
            user = self.user,
            password = self.password,
            )

            mycursor = mydb.cursor()

            # Crea il database school_scheduler
            mycursor.execute("CREATE DATABASE school_scheduler")

            # Seleziona il database register
            mycursor.execute("USE school_scheduler")

            # Crea la tabella users
            if isFirstTime:
                self.__init__(False)
            print('database creato')

    def remove(self):
        mydb = mysql.connector.connect(
        host = self.host,
        user = self.user,
        password = self.password,
        database = self.database
        )

        mycursor = mydb.cursor()

        # Elimina il database mydatabase
        mycursor.execute("DROP DATABASE school_scheduler")
        mydb.commit()

    def clear(self):
        db = mysql.connector.connect(
        host = self.host,
        user = self.user,
        password = self.password,
        database = self.database
        )

        mycursor = db.cursor()
        sql = "DELETE FROM users"
        mycursor.execute(sql)
        db.commit()

    def fetchSQL(self, sql):
        db = mysql.connector.connect(
        host = self.host,
        user = self.user,
        password = self.password,
        database = self.database
        )

        mycursor = db.cursor()
        mycursor.execute(sql)
        result = mycursor.fetchall()
        db.commit()

        return result

    def executeSQL(self, sql):
        db = mysql.connector.connect(
        host = self.host,
        user = self.user,
        password = self.password,
        database = self.database
        )

        mycursor = db.cursor()
        mycursor.execute(sql)
        db.commit()