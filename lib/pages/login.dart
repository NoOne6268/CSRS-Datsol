import 'package:flutter/material.dart';
import 'package:csrs/services/authorization.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool obscureText = true;
  AuthService authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log In',
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
        color: Colors.blue[400],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shadowColor: Colors.black,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            key: ValueKey('email'),
                            controller: emailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              border: UnderlineInputBorder(),
                              labelText: 'Insti mail id',
                            ),
                            onFieldSubmitted: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'fields can not be blank';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            key: ValueKey('password'),
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
                            ),
                            validator: (value) {
                              if (value!.length < 6) {
                                return 'password is too short , min 6 chars';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                            height: 100,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/signup');
                                      },
                                      child: const Text('Signup instead')),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('Processing Data')),
                                        );
                                        authService.signInWithEmailAndPassword(
                                            emailController.text,
                                            passwordController.text,
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                    ),
                                    child: const Text('Log In'),
                                  ),
                                ],
                              ),
                            ))
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


