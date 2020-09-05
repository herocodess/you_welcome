import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  final auth.User user ;

  EmailVerification({this.user});
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
