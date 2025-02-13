import 'package:client/app_provider.dart';
import 'package:client/connection.dart';
import 'package:client/pages/account/account_page.dart';
import 'package:client/pages/account/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  final String serverAddr = "192.168.178.32:5000";

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<DataProvider>();
    var accountProvider = context.watch<LoginProvider>();
    var appProvider = context.watch<AppProvider>();
    TextEditingController mailController = TextEditingController();
    TextEditingController passController = TextEditingController();

    return Center(
      child: appProvider.logged ?
      Text("Already Logged"):
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                Text("Login", style: TextStyle(fontSize: 40),),
                Expanded(child: SizedBox()),
              ],
            ),
            Expanded(child: SizedBox()),
            SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              controller: mailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
            ),
            SizedBox(height: 10,),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                prefixIcon: Icon(Icons.key)
              ),
              controller: passController,
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                ElevatedButton(
                  onPressed: (){
                    context.pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary,),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                  ),
                ),
                Expanded(child: SizedBox(width: 15,)),
                ElevatedButton(
                  onPressed: () async {
                    String mailText = mailController.text;
                    String passText = passController.text;
                    print(mailController.text + ", " + passController.text);
                    if (await Connection.login(mailText, passText, appProvider)){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Login success'),
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {},
                          ),
                        ),
                      );
                      context.pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Login failed'),
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {},
                          ),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Log In", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }



}