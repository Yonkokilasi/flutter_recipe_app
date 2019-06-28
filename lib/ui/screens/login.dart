import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/rendering.dart';
import 'package:recipes_app/model/state.dart';
import 'package:recipes_app/state_widget.dart';
import 'package:recipes_app/ui/google_sign_in_button.dart';
import 'package:recipes_app/utils/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  StateModel appState;
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;

  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      setState(() {
        print(
            'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        print(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print("code sent to " + _phoneNumberController.text);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration _buildBackground() {
      return BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/cook3.jpg"), fit: BoxFit.cover),
      );
    }

    Text _buildText() {
      return Text(
        'Recipes',
        style: Theme.of(context).textTheme.headline,
        textAlign: TextAlign.center,
      );
    }

    TextField _buildTextField(String label, TextEditingController controller) {
      return TextField(
        decoration: InputDecoration(
            labelText: label, labelStyle: TextStyle(color: Colors.black)),
        maxLength: 13,
        textAlign: TextAlign.center,
        style: TextStyle(),
        keyboardType: TextInputType.phone,
        controller: controller,
      );
    }

    Padding _buildInputFields() {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Card(
            color: Colors.white,
            elevation: 5.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildTextField(
                        'Phone number', _phoneNumberController)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTextField("Sms code", _smsCodeController),
                ),
              ],
            ),
          ));
    }

    void signInWithPhoneNumber(String smsCode) async {
      FirebaseAuth _auth = FirebaseAuth.instance;
      await FirebaseAuth.instance
          .signInWithPhoneNumber(
              verificationId: verificationId, smsCode: smsCode)
          .then((FirebaseUser user) async {
        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);
        
        // save account
        StateWidget.of(context).signInWithPhone(currentUser);
        print('signed in with phone number successful: user -> $user');
      });
    }

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Container(
        decoration: _buildBackground(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildText(),
              SizedBox(height: 50.0),
              _buildInputFields(),
              RaisedButton(
                child: Text("Verify phone number"),
                onPressed: () => _sendCodeToPhoneNumber(),
              ),
              GoogleSignInButton(
                onPressed: () => signInWithPhoneNumber(_smsCodeController.text),
              )
            ],
          ),
        ),
      ),
    );
  }
}
