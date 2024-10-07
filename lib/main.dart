import 'package:flutter/material.dart';
import 'package:hagora/providers/account_provider.dart';
import 'package:hagora/providers/cache_account_provider.dart';
import 'package:hagora/providers/new_provider_db.dart';
import 'package:hagora/providers/news_provider_api.dart';
import 'package:hagora/views/Auth/sign_in_page.dart';
import 'package:hagora/views/Favorites/news_local_view.dart';
import 'package:hagora/views/News/home_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProviderApi()),
        ChangeNotifierProvider(create: (_) => NewsProviderDb()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CacheAccountProvider())
      ],
      child: MaterialApp(
        title: 'News',
        debugShowCheckedModeBanner: false,
        home: Switcher(),
      ),
    );
  }
}

class Switcher extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CacheAccountProvider>(context);
    return FutureBuilder(
      future: _checkInternetAndUser(provider),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        else if (snapshot.hasData) {
          var result = snapshot.data!;
          bool hasInternet = result['hasInternet'] as bool;
          String user = result['user'] as String;

          // Handle the case when there's no internet
          if (!hasInternet) {
            return NewsLocalPage(user); // Navigate to NewsLocalPage with the cached user
          }

          // Handle the case when there's internet and check if user exists
          if (user == "empty") {
            return SignInPage(); // Navigate to Sign-in Page if no user is found
          }

          else {
            return NewsPage(user); // Navigate to Home Page if user exists
          }
        }

        else {
          return SignInPage(); // Default to sign-in page
        }
      },
    );


  }
  Future<Map<String, dynamic>> _checkInternetAndUser(CacheAccountProvider provider) async {
    bool hasInternet = false;
    String cachedUser = await provider.getCurrentUser();
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));


      // Check if the response is successful
      if (response.statusCode == 200) {
        hasInternet = true;
        // Internet is available
      }

    }
    catch (e) {
      // Handle exceptions
      // No internet connection
    }// No internet connection
    return {
      'hasInternet': hasInternet,
      'user': cachedUser,
    };
  }

}