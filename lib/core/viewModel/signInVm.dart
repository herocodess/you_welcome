import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vwede/email_verify.dart';

class SignInVm extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  TextEditingController _codeController;
  var smsCode;


  Future phoneAuth(String mobile, BuildContext context) async {
    _isLoading=true;
    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) {
            _auth.signInWithCredential(credential).then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => EmailVerification(user: value.user)
            ));
            notifyListeners();
          }).catchError((onError){
            print(onError);
            notifyListeners();
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
          notifyListeners();
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text("Enter SMS Code"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),

                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Done"),
                    textColor: Colors.white,
                    color: Colors.redAccent,
                    onPressed: () async{
                      smsCode = _codeController.text.trim();

                      AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                      await _auth.signInWithCredential(credential).then((result){
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => EmailVerification(user: result.user)
                        ));
                        notifyListeners();
                      }).catchError((e){
                        print(e);
                        notifyListeners();
                      });
                    },
                  )
                ],
              )
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
        });
  }

//  Future<bool> _sendSignInWithEmailLink() async {
//    final FirebaseAuth user = FirebaseAuth.instance;
//    try {
//      user.sendSignInWithEmailLink(
//          email: _email,
//          androidInstallIfNotAvailable: true,
//          iOSBundleID: "com.example.passwordless_login",
//          androidMinimumVersion: "16",
//          androidPackageName: "com.example.passwordless_login",
//          url: "https://nothisispatrick.page.link/krabby",
//          handleCodeInApp: true);
//    } catch (e) {
//      _showDialog(e.toString());
//      return false;
//    }
//    print(_email + "<< sent");
//    return true;
//  }
//
//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    if (state == AppLifecycleState.resumed) {
//      _retrieveDynamicLink();
//    }
//  }
//
//  Future<void> _retrieveDynamicLink() async {
//    final PendingDynamicLinkData data =
//    await FirebaseDynamicLinks.instance.retrieveDynamicLink();
//
//    final Uri deepLink = data?.link;
//    print(deepLink.toString());
//
//    if (deepLink.toString() != null) {
//      _link = deepLink.toString();
//      _signInWithEmailAndLink();
//    }
//    return deepLink.toString();
//  }
//
//  Future<void> _signInWithEmailAndLink(BuildContext context) async {
//    final FirebaseAuth user = FirebaseAuth.instance;
//    bool validLink = await user.isSignInWithEmailLink(_link);
//    if (validLink) {
//      try {
//        await user.signInWithEmailAndLink(email: _email, link: _link);
//      } catch (e) {
//        print(e);
//        _showDialog(e.toString());
//      }
//    }
//  }
//
//  void _showDialog(String error, BuildContext context) {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: new Text("Error"),
//          content: new Text("Please Try Again.Error code: " + error),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Close"),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
}