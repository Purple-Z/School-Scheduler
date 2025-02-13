import smtplib, ssl

class sendMail:
    def send(receiver_email, message):

        port = 465
        smtp_server = "smtp.gmail.com"
        sender_email = "clipcraze.assistant@gmail.com"
        password = "vshx fyxj ckkm pmux "

        context = ssl.create_default_context()
        with smtplib.SMTP_SSL(smtp_server, port, context=context) as server:
            server.login(sender_email, password)
            server.sendmail(sender_email, receiver_email, message)