import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../screens/screens.dart';

final User? user = FirebaseAuth.instance.currentUser;

String? userEmail = user!.email;
String? userUid = user!.uid;
String? userdisplayName = user!.displayName;
String? phone = user!.phoneNumber;

Widget invalidLogin(BuildContext context) {
  return CupertinoAlertDialog(
    title: const Text('Invalid Credentials'),
    content: const Text(
        'Email or password you entered is invalid, please try again.'),
    actions: <Widget>[
      CupertinoDialogAction(
        child: const Text(
          'Retry',
          style: TextStyle(color: CupertinoColors.systemRed),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

Future<bool> login(BuildContext context, String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    debugPrint('User logged in.');
    return true;
  } catch (exception) {
    debugPrint('Your credentials were invalid.\nError: $exception');
    showCupertinoDialog(context: context, builder: invalidLogin);
    return false;
  }
}

Widget linkSent(BuildContext context) {
  return CupertinoAlertDialog(
    title: const Text('Link Sent'),
    content: const Text(
        'We have sent you an email with a link to reset your password.'),
    actions: <Widget>[
      CupertinoDialogAction(
        child: const Text(
          'Login',
        ),
        onPressed: () {
          Navigator.pop(context);
          goFront(
            context,
            const LoginPage(),
          );
        },
      ),
    ],
  );
}

Widget resetLinkSent(BuildContext context) {
  return CupertinoAlertDialog(
    title: const Text('Link Sent'),
    content: const Text(
        'We have sent you an email with a link to reset your password.'),
    actions: <Widget>[
      CupertinoDialogAction(
        child: const Text(
          'Okay',
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

Widget invalidEmail(BuildContext context) {
  return CupertinoAlertDialog(
    title: const Text('Invalid Email'),
    content:
        const Text('Email you entered is invalid, please try different email.'),
    actions: <Widget>[
      CupertinoDialogAction(
        child: const Text(
          'Retry',
          style: TextStyle(color: CupertinoColors.systemRed),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

Future forgotPassword(BuildContext context, String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    debugPrint('Password reset link sent.');
    showCupertinoDialog(context: context, builder: linkSent);
  } catch (exception) {
    debugPrint('Your credentials were invalid.\nError: $exception');
    showCupertinoDialog(context: context, builder: invalidEmail);
  }
}

Future resetPassword(BuildContext context, String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    debugPrint('Password reset link sent.');
    showCupertinoDialog(context: context, builder: resetLinkSent);
  } catch (exception) {
    debugPrint('Your credentials were invalid.\nError: $exception');
    showCupertinoDialog(context: context, builder: invalidEmail);
  }
}

Widget unableToRegister(BuildContext context) {
  return CupertinoAlertDialog(
    title: const Text('Unable to Register'),
    content: const Text('We were unable to register you, please try again.'),
    actions: <Widget>[
      CupertinoDialogAction(
        child: const Text(
          'Retry',
          style: TextStyle(color: CupertinoColors.systemRed),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

Widget userExists(BuildContext context) {
  return CupertinoAlertDialog(
    title: const Text('User exists'),
    content: const Text(
        'User with this email already exists, please try different email.'),
    actions: <Widget>[
      CupertinoDialogAction(
        child: const Text(
          'Retry',
          style: TextStyle(color: CupertinoColors.systemRed),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

Widget weakPassword(BuildContext context) {
  return CupertinoAlertDialog(
    title: const Text('Weak Password'),
    content: const Text(
        'Password you entered is too weak, please try different password.'),
    actions: <Widget>[
      CupertinoDialogAction(
        child: const Text(
          'Retry',
          style: TextStyle(color: CupertinoColors.systemRed),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

Widget passwordDidNotMatch(BuildContext context) {
  return CupertinoAlertDialog(
    title: const Text('Password did not match'),
    actions: [
      CupertinoDialogAction(
        child: const Text('Try Again'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

Future<bool> register(
    BuildContext context, String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (exception) {
    if (exception.code == 'weak-password') {
      debugPrint('The password provided is too weak.');
      showCupertinoDialog(context: context, builder: weakPassword);
    } else if (exception.code == 'email-already-in-use') {
      debugPrint('The account already exists for that email.');
      showCupertinoDialog(context: context, builder: userExists);
    }
    return false;
  } catch (exception) {
    debugPrint(exception.toString());
    showCupertinoDialog(context: context, builder: unableToRegister);
    return false;
  }
}

Widget confirmSignOut(BuildContext context) {
  return CupertinoAlertDialog(
    title: const Text('Sign Out'),
    content: const Text('Are you sure you want to sign out?'),
    actions: <Widget>[
      CupertinoDialogAction(
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      CupertinoDialogAction(
        child: const Text('Sign Out',
            style: TextStyle(color: CupertinoColors.systemRed)),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          // ignore: use_build_context_synchronously
          Navigator.popUntil(context, ModalRoute.withName("/"));
          // ignore: use_build_context_synchronously
          goFront(context, const LoginPage());
        },
      ),
    ],
  );
}

void signOut(BuildContext context) {
  showCupertinoDialog(context: context, builder: confirmSignOut);
  debugPrint('Logged out.');
  const LoginPage();
}
