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
}