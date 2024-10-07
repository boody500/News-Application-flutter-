import 'package:flutter/material.dart';
import '../services/account_service_db.dart';

class AuthProvider with ChangeNotifier {
  String? email;

  Future<void> registerUser(String email, String password,String firstname,String lastname) async {
    await DatabaseHelper().insertUser(email, password,firstname,lastname);
    this.email = email;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    Map<String, String>? user = await DatabaseHelper().getUser(email);

    if (user != null && user['password'] == password) {
      this.email = email;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String email) async {
    // Fetch user info from the database
    Map<String, dynamic>? user = await DatabaseHelper().getUserInfo(email);

    // Check if the user info is not null and contains the necessary keys
    return {
      'firstname': user['firstname'] ?? "unknown", // Return the 'firstName'
      'lastname': user['lastname'] ?? "unknown",   // Return the 'lastName'
    };
    }


}
