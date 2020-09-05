import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  final auth.User user ;

  EmailVerification({this.user});
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> with WidgetsBindingObserver{

  String _email;
  String _link;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  Widget build(BuildContext context) {
    final snackBarEmailSent = SnackBar(content: Text('Email Sent!'));
    final snackBarEmailNotSent = SnackBar(
      content: Text('Email Not Sent. Error.'),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        if (value.isEmpty) return "Email cannot be empty";
        return null;
      },
      onSaved: (value) => _email = value,
      decoration: InputDecoration(
        hintText: 'Email',
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        color: Colors.lightBlueAccent,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Text("Send Verification Email"),
        onPressed: (() async => await validateAndSave()
            ? _scaffoldKey.currentState.showSnackBar(snackBarEmailSent)
            : _scaffoldKey.currentState.showSnackBar(snackBarEmailNotSent)),
        padding: EdgeInsets.all(12),
      ),
    );

    final loginForm = Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24, right: 24),
        children: <Widget>[
          SizedBox(height: 50),
          email,
          SizedBox(height: 40),
          loginButton
        ],
      ),
    );
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Center(child: loginForm));
  }

  Future<bool> validateAndSave() async {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      bool sent = await _sendSignInWithEmailLink();
      return sent;
    }
    return false;
  }

  Future<bool> _sendSignInWithEmailLink() async {
    final FirebaseAuth user = FirebaseAuth.instance;
    try {
      auth.ActionCodeSettings actionCodeSettings = new auth.ActionCodeSettings(
          url: "https://vwede.page.link/crAckHeAd",
          handleCodeInApp: true,
          );
      user.sendSignInLinkToEmail(email: _email, actionCodeSettings: actionCodeSettings);
    } catch (e) {
      _showDialog(e.toString());
      return false;
    }
    print(_email + "<< sent");
    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _retrieveDynamicLink();
    }
  }

  Future<void> _retrieveDynamicLink() async {
    Uri uri = Uri.parse("https://vwede.page.link/crAckHeAd");
    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getDynamicLink(uri);
    print("dataaaaaaaaaaaa $data");

    final Uri deepLink = data?.link;
    print(deepLink.toString());

    if (deepLink.toString() != null) {
      _link = deepLink.toString();
      print(_email);
      print(_link);
      _signInWithEmailAndLink();
    }
    return deepLink.toString();
  }

  Future<void> _signInWithEmailAndLink() async {
    final FirebaseAuth user = FirebaseAuth.instance;
    bool validLink = user.isSignInWithEmailLink(_link);
    print(validLink);
    if (validLink) {
      try {
        var res = await user.signInWithEmailLink(email: _email, emailLink: _link);
        print("$_email signed innnnnnnnnnnnn");
        print("$res resssssss");
      } catch (e) {
        print(e);
        _showDialog(e.toString());
      }
    }
  }

  void _showDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("Please Try Again.Error code: " + error),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
