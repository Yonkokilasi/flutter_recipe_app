import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<GoogleSignInAccount> getSignedInAccount(
    GoogleSignIn googleSignIn) async {
  GoogleSignInAccount account = googleSignIn.currentUser;

  if (account == null) {
    try {
      account = await googleSignIn.signInSilently(suppressErrors: true);
    } catch (e) {
      print('$e');
    }
  }
  return account;
}

Future<FirebaseUser> signIntoFirebase(
    GoogleSignInAccount googleSignInAccount) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignInAuthentication googleAuth =
      await googleSignInAccount.authentication;

  return await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));
}

// Future<FirebaseUser> signInWithPhone(
//     GoogleSignInAccount googleSignInAccount) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   GoogleSignInAuthentication googleAuth =
//       await googleSignInAccount.authentication;
//   return await _auth.signInWithPhoneNumber(verificationId: null, smsCode: null);
// }
