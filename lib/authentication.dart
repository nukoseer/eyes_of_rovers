import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

import 'package:eyes_of_rovers/login_page.dart';
import 'package:eyes_of_rovers/home_page.dart';

class UserInformation {
  static String name = "";
  static String email = "";
  static String profilePictureUrl =
      "https://cdn.pixabay.com/photo/2017/06/13/12/53/profile-2398782_1280.png";
  static String bigProfilePictureUrl =
      "https://cdn.pixabay.com/photo/2017/06/13/12/53/profile-2398782_1280.png";
}

class Authenticate {
  static StreamBuilder handleAuthentication() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        });
  }

  static void facebookSignIn() async {
    final fb = FacebookLogin();

    // Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    // Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in

        // Send access token to server for validation and auth
        final FacebookAccessToken accessToken = res.accessToken!;
        final AuthCredential authCredential =
            FacebookAuthProvider.credential(accessToken.token);
        print('Access token: ${accessToken.token}');

        // Get profile data
        final profile = await fb.getUserProfile();

        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 50);
        final bigImageUrl = await fb.getProfileImageUrl(width: 200);

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();

        UserInformation.name = profile!.name!;
        UserInformation.email = email!;
        UserInformation.profilePictureUrl = imageUrl!;
        UserInformation.bigProfilePictureUrl = bigImageUrl!;

        final result =
            await FirebaseAuth.instance.signInWithCredential(authCredential);

        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  }

  static void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
