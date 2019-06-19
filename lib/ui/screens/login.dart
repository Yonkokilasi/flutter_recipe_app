import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recipes_app/ui/google_sign_in_button.dart';

class LoginScreen extends StatelessWidget {
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
              GoogleSignInButton(
                // We replace the current page.
                // After navigating to the replacement, it's not possible
                // to go back to the previous screen:
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
