import 'package:flutter/material.dart';

import 'package:csrs/services/authorization.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'dart:math';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService authService = AuthService();
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
                                    child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Processing Data')),
                                      );
                                      await authService
                                          .signUpWithEmailAndPassword(
                                              emailController.text,
                                              passwordController.text,
                                              userController.text,
                                              context);
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
                                ) // hello there
                                    //  ElevatedButton(
                                    //     onPressed: () async {
                                    //       if (emailController.text.isEmpty ||
                                    //           passwordController.text.isEmpty ||
                                    //           userController.text.isEmpty) {
                                    //         setState(() {
                                    //           isEmail = true;
                                    //         });
                                    //       }
                                    //       if (emailController.text.isNotEmpty &&
                                    //           passwordController
                                    //               .text.isNotEmpty &&
                                    //           userController.text.isNotEmpty) {
                                    //         setState(() {
                                    //           isEmail = false;
                                    //           isOtp = !isOtp;
                                    //           sendOtpEmail(emailController.text)
                                    //               .then((result) {
                                    //             print(result);
                                    //             setState(() {
                                    //               oTP = result;
                                    //             });
                                    //           });
                                    //         });
                                    //       }
                                    //     },
                                    //     style: ElevatedButton.styleFrom(
                                    //       backgroundColor: Colors.blue,
                                    //       foregroundColor: Colors.white,
                                    //       minimumSize: const Size(88, 36),
                                    //       padding: const EdgeInsets.symmetric(
                                    //           horizontal: 16),
                                    //       shape: const RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.all(
                                    //             Radius.circular(5)),
                                    //       ),
                                    //     ),
                                    //     child: const Text('Send OTP'),
                                    //   ),
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

Future<String> sendOtpEmail(String userEmail) async {
  final mailer = Mailer(
      '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');
  final String otp = generateOTP();
  print(otp);
  final toAddress = Address(userEmail);
  const fromAddress =
      Address('harshit@kgpian.iitkgp.ac.in', 'Datsol Solutions');
  final content = Content('text/plain',
      'This Mail is sent to confirm your registration with CSRS DATSOL app. your otp is $otp ');
  const subject = 'Confirm your registration ';
  final personalization = Personalization([toAddress]);

  final email =
      Email([personalization], fromAddress, subject, content: [content]);
  mailer.send(email).then((result) {
    print('mail sent succesfully to $toAddress');
    return otp;
  }).onError((error, stackTrace) {
    print('$error  , something went wrong with sendgrid mailer');
    return 'wrongotp';
  });
  return 'wrongotp';
}

String generateOTP() {
  // Generate a random 6-digit number
  final random = Random();
  int otp = random.nextInt(900000) + 100000;

  return otp.toString();
}
