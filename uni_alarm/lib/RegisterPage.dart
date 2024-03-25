
import 'package:flutter/material.dart';
import 'constants.dart';
import 'LoginPage.dart';
// import '../models/user.dart';
import '../Services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';



class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _usernamecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();


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
              Text("Register", style: TextStyle(color: isDark?darkText : lightText, fontSize: 45)),
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
                          maxLength: 25,
                          controller: _usernamecontroller,
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
                            labelText: "Username",
                            labelStyle: TextStyle(
                              color: isDark ? darkHighlights : lightHighlights,
                              fontSize: 20,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username is required';
                            } else {
                              return null;
                            }
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
                                  String username= _usernamecontroller.text;
                                  String password = _passwordcontroller.text;
                                  try {
                                    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                                      email: email,
                                      password: password,
                                    );
                                    if (userCredential.user != null) {
                                      setUsername(userCredential.user!.uid,username);
                                      _emailcontroller.clear();
                                      _usernamecontroller.clear();
                                      _passwordcontroller.clear();
                                      Navigator.pop(context);
                                    }
                                  } on FirebaseException catch (e) {
                                    if(e.message=="The email address is already in use by another account.") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(content: Text(
                                            'Email already in use, please choose another!')),
                                      );
                                    }
                                    if(e.message=="Password should be at least 6 characters"){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Password must be at least 6 characters!')),
                                      );
                                    }
                                  }
                                } else {
                                }
                              },
                              child: const Text('Register',style: TextStyle(fontSize: 35),),
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
                  Text("Already have an account?",style: TextStyle(color: isDark?darkText : lightText, fontSize: 15),
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("Login!",style: TextStyle(color: isDark?darkHighlights : lightHighlights, fontSize: 15),)
                  ),
                ],
              )
            ],
          )
      )
      );
    }
}
