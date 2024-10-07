import 'package:flutter/material.dart';
import 'package:hagora/views/News/home_page.dart';
import 'package:hagora/providers/account_provider.dart';
import 'package:hagora/providers/cache_account_provider.dart';
import 'package:hagora/views/Auth/register_page.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  // Create controllers to access the field values
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignInPage({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.asset("assets/images/preview.png",height: 100,),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Sign In",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Username',
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
                          keyboardType: TextInputType.text,
                          onSaved: (phone) {
                            // Save it
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            controller: _passwordController ,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: Color(0xFFF5FCF9),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            onSaved: (passaword) {
                              // Save it
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async{
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final email = _emailController.text;
                              final password = _passwordController.text;

                              try {
                                // Call the signIn method
                                bool flag = await Provider.of<AuthProvider>(context, listen: false)
                                    .signIn(email, password);

                                if(!flag){
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("email or password are incorrect")));
                                }
                                else{
                                  await Provider.of<CacheAccountProvider>(context,listen: false).insertUser(email);
                                  // Navigate to Home Page or other after successful sign-in
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Welcome $email")));

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => NewsPage(email)));
                                }

                              }
                              catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("An error occurred: $error")),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Sign in"),
                        ),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(context,MaterialPageRoute(builder: (context) => NewsPage("Guest")),);
                          },
                          child: Text(
                            'Continue as guest',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterPage()),);
                          },
                          child: Text.rich(
                            const TextSpan(
                              text: "Don’t have an account? ",
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
