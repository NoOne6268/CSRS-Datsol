import 'package:flutter/material.dart';

import 'package:login_signup/services/firebase_authorization.dart';
import 'package:login_signup/services/node_authorization.dart';
import 'package:login_signup/services/twilio&sendgrid.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService authService = AuthService();
  NodeApis nodeApis = NodeApis();
  bool isOtp = false;
  bool obscureText = true;
  bool isEmail = false;
  bool isOtpMatched = true;
  String oTP = 'blhabl';
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            key: const ValueKey('username'),
                            controller: userController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: UnderlineInputBorder(),
                              labelText: 'username',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "username can't be empty";
                              } else if (value.length < 4) {
                                return "min allowed length is 4 chars";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          key: const ValueKey('password'),
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: passwordController,
                            autofocus: true,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon(obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              border: const UnderlineInputBorder(),
                              labelText: 'password',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 6) {
                                return "min length for password is 6 chars";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          key: const ValueKey('email'),
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: emailController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              border: UnderlineInputBorder(),
                              labelText: 'Insti mail id',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onFieldSubmitted: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'email can not be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                            height: isOtp ? 0 : 20,
                            child: isEmail
                                ? Text(
                                    'please enter  valid information',
                                    style: TextStyle(
                                      color: Colors.pink[300],
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                    ),
                                  )
                                : null),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: isOtp
                                ? TextFormField(
                                    controller: otpController,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.lock_outlined),
                                      border: UnderlineInputBorder(),
                                      labelText: 'OTP',
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                : null),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isOtpMatched
                              ? null
                              : Text(
                                  'otp is invalid',
                                  style: TextStyle(
                                    color: Colors.pink[400],
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: const Text('Login instead')),
                                Container(
                                    child: isOtp ?  ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Processing Data')),
                                      );
                                      print('otp filled by user is ${otpController.text}');
                                      if(otpController.text == oTP){
                                        // await authService
                                        //   .signUpWithEmailAndPassword(
                                        //       emailController.text,
                                        //       passwordController.text,
                                        //       userController.text,
                                        //       context);
                                        final userId = await nodeApis.getUserID();
                                        if (!context.mounted) return;
                                        await nodeApis.signUp(
                                            userController.text,
                                            passwordController.text,
                                            emailController.text,
                                            userId,
                                            context);
                                      }
                                      else{
                                        setState(() {
                                          isOtpMatched = false;
                                        });
                                      }

                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(88, 36),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                  ),
                                  child: const Text('Sign up'),
                                ) :
                                     ElevatedButton(
                                        onPressed: () async {

                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isOtp = true;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Processing Data')),
                                            );
                                            String otp = await sendOtpEmail(
                                                emailController.text);
                                            print('otp received is $otp');
                                            setState(() {

                                              oTP = otp;
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          minimumSize: const Size(88, 36),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                        ),
                                        child: const Text('Send OTP'),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


