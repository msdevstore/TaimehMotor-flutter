import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<String> registerWithEmail(params) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: params['email'], password: params['password']);
      return 'NEED_EMAIL_VERIFY';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'WEAK';
      } else if (e.code == 'email-already-in-use') {
        return 'DUPLICATED';
      }
      return 'FAILED';
    } catch (e) {
      rethrow;
    }
  }

  emailVerify() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      return 'SENT_VERIFY';
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');
    await prefs.setString('displayName', '');
    await prefs.setString('username', '');
    await prefs.setString('firstname', '');
    await prefs.setString('lastname', '');
    await prefs.setString('photo', '');
    // await prefs.setString('phone', '');
    await prefs.setString('accountType', '');
    await prefs.setString('status', '');
    await prefs.setBool('loggedin', false);
    await prefs.setString('uid', '');
    await _auth.signOut();
  }

  // Future<void> signOutFromFacebook() async {
  //   await _facebookLogin.logOut();
  //   await _auth.signOut();
  // }

  // User getCurrentUser() {
  //   User _user = FirebaseAuth.instance.currentUser!;
  //   return _user;
  // }

  Future<String> signInWithGoogle() async {
    signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredit = await _auth.signInWithCredential(credential);
      print(userCredit.user);
      if (userCredit.user?.displayName != null) {
        print(userCredit.additionalUserInfo?.profile);
        var text = '';
        if (userCredit.additionalUserInfo?.profile?['email'] != null &&
            userCredit.additionalUserInfo?.profile != null &&
            userCredit.additionalUserInfo != null) {
          await prefs.setString(
              'email', userCredit.additionalUserInfo?.profile?['email'] ?? '');
          await prefs.setString(
              'username', userCredit.additionalUserInfo?.username ?? '');
          await prefs.setString('firstname',
              userCredit.additionalUserInfo?.profile?['given_name'] ?? '');
          await prefs.setString('lastname',
              userCredit.additionalUserInfo?.profile?['family_name'] ?? '');
          await prefs.setString('photoURL', userCredit.user?.photoURL ?? '');
          print('photoURL:${prefs.getString('photoURL')}');
          // await prefs.setString('phone', userCredit.user?.phoneNumber ?? '');
          await prefs.setString('uid', userCredit.user?.uid ?? '');
          await prefs.setString(
              'displayName', userCredit.user?.displayName ?? '');
          await prefs.setBool('loggedin', true);
          var user = await users
              .where('email', isEqualTo: prefs.getString('email'))
              .get()
              .then((QuerySnapshot querySnapshot) {
            if (querySnapshot.docs.isEmpty) {
              print('not registered');
              text = 'NOT_REGISTERED';
            } else {
              querySnapshot.docs.forEach((doc) async {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                await prefs.setString('accountType', data['accountType']);
                await prefs.setString('status', data['status']);
                await prefs.setString('uid', doc.id);
                await prefs.setString(
                    'displayName', userCredit.user?.displayName ?? '');
              });
              text = 'SUCCESS';
            }
          });
          print('user:${user}');
        }
        if (text == '') {
          return 'UNKNOWN ACCOUNT';
        } else {
          return text;
        }
      } else {
        return 'FAILED';
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Future<User> signInWithApple({List<Scope> scopes = const []}) async {
  //   // 1. perform the sign-in request
  //   final result = await TheAppleSignIn.performRequests(
  //       [AppleIdRequest(requestedScopes: scopes)]);
  //   // 2. check the result
  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       final appleIdCredential = result.credential!;
  //       final oAuthProvider = OAuthProvider('apple.com');
  //       final credential = oAuthProvider.credential(
  //         idToken: String.fromCharCodes(appleIdCredential.identityToken!),
  //         accessToken:
  //         String.fromCharCodes(appleIdCredential.authorizationCode!),
  //       );
  //       final userCredential =  await _auth.signInWithCredential(credential);
  //       final firebaseUser = userCredential.user!;
  //       if (scopes.contains(Scope.fullName)) {
  //         final fullName = appleIdCredential.fullName;
  //         if (fullName != null &&
  //             fullName.givenName != null &&
  //             fullName.familyName != null) {
  //           final displayName = '${fullName.givenName} ${fullName.familyName}';
  //           await firebaseUser.updateDisplayName(displayName);
  //         }
  //       }
  //       return firebaseUser;
  //     case AuthorizationStatus.error:
  //       throw PlatformException(
  //         code: 'ERROR_AUTHORIZATION_DENIED',
  //         message: result.error.toString(),
  //       );
  //
  //     case AuthorizationStatus.cancelled:
  //       throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Sign in aborted by user',
  //       );
  //     default:
  //       throw UnimplementedError();
  //   }
  // }
  Future<String> signInWithEmail(
      {required String email, required String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser?.reload();
      if (_auth.currentUser?.emailVerified == true) {
        await prefs.setString('email', email);
        await prefs.setBool('loggedin', true);
        String uid = _auth.currentUser?.uid ?? "";
        print(uid);
        await prefs.setString('uid', uid);
        return 'VERIFIED';
      } else {
        await prefs.setString('email', email);
        await prefs.setBool('loggedin', true);
        String uid = _auth.currentUser?.uid ?? "";
        print(uid);
        await prefs.setString('uid', uid);
        return 'NOT_VERIFIED';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'USER_NOT_FOUND';
      } else if (e.code == 'wrong-password') {
        return 'WRONG_PASSWORD';
      } else if (e.code == 'invalid-email') {
        return 'INVALID_EMAIL';
      } else if (e.code == 'user-disabled') {
        return 'USER_DISABLED';
      } else {
        return 'FAILED';
      }
    }
    // return null;
  }

  Future<String> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
    return 'EMAIL_SENT';
  }

// Future<String> checkVerify() async {
//   await _auth.currentUser?.reload();
//   if (_auth.currentUser?.emailVerified == true) {
//     return 'VERIFIED';
//   } else {
//     return 'NOT_VERIFIED';
//   }
// }
//
// checkUser() async {
//   try {
//     await _auth.currentUser?.reload();
//     return _auth.currentUser;
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'user-not-found') {
//       return 'USER_NOT_FOUND';
//     } else if (e.code == 'wrong-password') {
//       return 'WRONG_PASSWORD';
//     } else if (e.code == 'invalid-email') {
//       return 'INVALID_EMAIL';
//     } else if (e.code == 'user-disabled') {
//       return 'USER_DISABLED';
//     }
//   }
// }
}
