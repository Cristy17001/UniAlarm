import 'package:flutter/material.dart';
import 'constants.dart';
import 'RegisterPage.dart';

import 'Services/database.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn>{
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context){
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: isDark ? darkBackground : lightBackground,
        body: FractionallySizedBox(
            widthFactor:1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                Text("Login", style: TextStyle(color: isDark?darkText : lightText, fontSize: 45)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 25,
                            controller: _emailcontroller,
                            style: TextStyle(
                              color: isDark ? Colors.white:Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark ? darkMainCards : lightMainCards,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                              counterText: "",
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: isDark ? darkHighlights : lightHighlights)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: isDark ? darkHighlights : lightHighlights)),
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: isDark ? darkHighlights : lightHighlights)),
                              focusedErrorBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: isDark ? darkHighlights : lightHighlights)),
                              labelText: "Email",
                              labelStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: TextFormField(
                            obscureText: true,
                            maxLength: 25,
                            controller: _passwordcontroller,
                            style: TextStyle(
                              color: isDark ? Colors.white:Colors.black,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark ? darkMainCards : lightMainCards,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                              counterText: "",
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: isDark ? darkHighlights : lightHighlights)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: isDark ? darkHighlights : lightHighlights)),
                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: isDark ? darkHighlights : lightHighlights)),
                              focusedErrorBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: isDark ? darkHighlights : lightHighlights)),
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: isDark ? darkHighlights : lightHighlights,
                                fontSize: 20,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding:
                            const EdgeInsets.symmetric(horizontal: 6, vertical: 6.0),
                            child: Center(
                              child: SizedBox(
                                width: 900,
                                height: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: isDark ? darkHighlights : lightHighlights, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      String email = _emailcontroller.text;
                                      String password = _passwordcontroller.text;
                                      try {
                                        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                          email: email,
                                          password: password,
                                        );
                                        if (userCredential.user != null) {
                                          user = userCredential.user!;
                                          username = await getUsername();
                                          _emailcontroller.clear();
                                          _passwordcontroller.clear();
                                          autoTheme = await getAutoTheme();
                                          Navigator.of(context).push(_createRoute(false));
                                        } else {
                                          print("Failed to retrieve user");
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text("Invalid email or password!"),
                                          duration: Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                        ));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Please fill input')),
                                      );
                                    }
                                  },
                                  child: const Text('Login',style: TextStyle(fontSize: 35),),
                                ),
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New to UniAlarm?",style: TextStyle(color: isDark?darkText : lightText, fontSize: 15),
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).push(_createRoute(true));
                        },
                        child: Text("Register now!",style: TextStyle(color: isDark?darkHighlights : lightHighlights, fontSize: 15),)
                    ),
                  ],
                )
              ],
            )
        )
    );
  }
}

Route _createRoute(bool register){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => register ? const SignUp(): const currentPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}