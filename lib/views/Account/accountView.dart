import 'package:flutter/material.dart';
import 'package:hagora/views/Auth/sign_in_page.dart';

import 'package:provider/provider.dart';

import '../../providers/cache_account_provider.dart';
class AccountPage extends StatelessWidget {

  late final String currentUser;
  String firstname = "Guest";
  String lastname = "Guest";
  AccountPage(String user,String fname,String lname, {super.key}){
    currentUser = user;
    if(currentUser != "Guest"){
      firstname = fname;
      lastname = lname;
    }

  }
  @override
  Widget build(BuildContext context) {

      return Scaffold(
    appBar: AppBar(
      title: const Text("Your Account"),
      backgroundColor: Colors.red,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle:  TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),


    ),
    body: Container(
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.red.shade50

          ],
        ),
      ),
      padding: const EdgeInsets.all(16),

      child:  Center(
        child: Column(

          children: [
            TextFormField(
              initialValue: "First Name: $firstname",
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF5FCF9),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0 * 1.5, vertical: 16.0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius:
                  BorderRadius.all(Radius.circular(50)),
                ),
              ),
              enabled: false,
            ),
            TextFormField(
              initialValue: "Last Name: $lastname",
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF5FCF9),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0 * 1.5, vertical: 16.0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius:
                  BorderRadius.all(Radius.circular(50)),
                ),
              ),
              enabled: false,
            ),
            TextFormField(
              initialValue: "Email: $currentUser",
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF5FCF9),

                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,

                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              enabled: false,
            ),
            ElevatedButton(
              onPressed: () async{
                try {

                  // Navigate to Home Page or other after successful sign-in
                  if(currentUser != "Guest"){
                    await Provider.of<CacheAccountProvider>(context,listen: false).deleteUser(currentUser);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signed out successfully")));

                  }
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));


                }

                catch (error)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("An error occurred: $error")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: const StadiumBorder(),
              ),
              child: Text(currentUser != "Guest" ?"Sign out":"Sign in")),
            const SizedBox(height: 16.0),
          ],
        ),
      )
    
    )

      );
  }
}

