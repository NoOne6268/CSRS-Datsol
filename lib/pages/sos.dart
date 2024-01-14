import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login_signup/pages/home.dart';

class sosScreen extends StatefulWidget {
  const sosScreen({super.key});

  @override
  State<sosScreen> createState() => _sosScreenState();
}

class _sosScreenState extends State<sosScreen> {
  bool isSOS = false;
  Timer _timer = Timer.periodic(Duration(seconds: 1), (timer) {});
  int _start = 10;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            fetchContacts(true);
            isSOS = true;
            timer.cancel();
          });
        } else {
          print('times is running $_start');
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: isSOS ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('SOS initiated , keep calm!! help on the way....' , style: TextStyle(
                fontSize: 30.0,
                // color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
              ),
            ),
            const Text('SOS', style: TextStyle(
              fontSize: 60.0,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
            ),
            SizedBox(height: 40.0,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () {
                ConfirmationAlert(context);

                // Navigator.pushReplacementNamed(context, '/home');
              },
              child:  const Text('I am safe now' ,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
              ),
            ),


          ],
        ) :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SOS will be initiated in...'
            , style: TextStyle(
              fontSize: 20.0,
              color: Colors.redAccent,
            ),
            ),
            Text('$_start' , style: const TextStyle(
              fontSize: 60.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
            ),
            ElevatedButton(
              onPressed: () {
                dispose();
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Cancel SOS'),

            ),
          ],
        ),
        )
    );
  }
}

void ConfirmationAlert(BuildContext context) {
  var alertDialog = AlertDialog(
    title: const Text('Confirmation'),
    content: const Text('Are you sure you are safe?'),
    actions: [
      ElevatedButton(
        onPressed: () {
          fetchContacts(false);
          Navigator.pushReplacementNamed(context, '/home');
        },
        child: const Text('Yes'),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('No'),
      ),
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}