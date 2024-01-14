
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'dart:math';

Future<String> sendOtpEmail(String userEmail) async {
  final mailer = Mailer(
      dotenv.env['SENDGRID_API_KEY']!); 
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
  return otp;
}

String generateOTP() {
  // Generate a random 6-digit number
  final random = Random();
  int otp = random.nextInt(900000) + 100000;

  return otp.toString();
}

Future<void> sendWhatsappMessage() async {
  final String otp = generateOTP();
  // print('generated otp is $otp');
  String accountSid = 'AC5032e23794ac79ee6e5591b02aa163b3';
  String authToken = 'eba3bd2a9bf808c2c2078304b9553e1c';
  String twilioNumber = '+14155238886';
  String toNumber = '+919001469811';
  String messageBody = 'hello this is a test message';

  String baseUrl = 'https://api.twilio.com/2010-04-01/Accounts/AC5032e23794ac79ee6e5591b02aa163b3/Messages.json';
  String creds = '$accountSid:$authToken';
  var bytes = utf8.encode(creds);
  var base64Str = base64.encode(bytes);
  print('base64Str is $base64Str');
  var headers = {
    'Authorization': 'Basic $base64Str',
    'Accept': 'application/json'
  };
  var body = {
    'From': 'whatsapp:$twilioNumber',
    'To': 'whatsapp:$toNumber',
    'Body': messageBody,
  };
  try{
    http.Response response = await http.post(Uri.parse(baseUrl), headers: headers, body: body);
    print('response body is ${response.body} and status code is ${response.statusCode}');
  }
  catch(e){
    print('error is $e');
  }
  // http.Response response = await http.post(Uri.parse(baseUrl), headers: headers, body: body);
  // if (response.statusCode == 201) {
  //   print('Message Sent Successfully');
  // } else {
  //   print('Error Happened while Sending WhatsApp Message');
  // }
  // final response = await http.get(url);
  // print(response.body);
}