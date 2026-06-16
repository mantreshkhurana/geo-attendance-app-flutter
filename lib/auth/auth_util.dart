import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/screens.dart';

// Convenience accessors for the signed-in user, resolved from whichever
// backend is active (Firebase or mock).
String? get userEmail => backend.currentUser?.email;
String? get userUid => backend.currentUser?.uid;
String? get userdisplayName => backend.currentUser?.name;

Future<bool> login(BuildContext context, String email, String password,
    {String? role}) async {
  try {
    await backend.signIn(email, password, roleOverride: role);
    debugPrint('User logged in.');
    return true;
  } catch (exception) {
    debugPrint('Your credentials were invalid.\nError: $exception');
    if (context.mounted) {
      AppDialog.info(
        context,
        title: 'Invalid Credentials',
        message:
            'Email or password you entered is invalid, please try again.',
        actionLabel: 'Retry',
        isError: true,
      );
    }
    return false;
  }
}

Future forgotPassword(BuildContext context, String email) async {
  try {
    await backend.sendPasswordReset(email);
    debugPrint('Password reset link sent.');
    if (context.mounted) {
      await AppDialog.info(
        context,
        title: 'Link Sent',
        message:
            'We have sent you an email with a link to reset your password.',
        actionLabel: 'Login',
      );
      if (context.mounted) goFront(context, const LoginPage());
    }
  } catch (exception) {
    debugPrint('Your credentials were invalid.\nError: $exception');
    if (context.mounted) {
      AppDialog.info(
        context,
        title: 'Invalid Email',
        message: 'Email you entered is invalid, please try a different email.',
        actionLabel: 'Retry',
        isError: true,
      );
    }
  }
}

Future resetPassword(BuildContext context, String email) async {
  try {
    await backend.sendPasswordReset(email);
    debugPrint('Password reset link sent.');
    if (context.mounted) {
      AppDialog.info(
        context,
        title: 'Link Sent',
        message:
            'We have sent you an email with a link to reset your password.',
      );
    }
  } catch (exception) {
    debugPrint('Your credentials were invalid.\nError: $exception');
    if (context.mounted) {
      AppDialog.info(
        context,
        title: 'Invalid Email',
        message: 'Email you entered is invalid, please try a different email.',
        actionLabel: 'Retry',
        isError: true,
      );
    }
  }
}

Future<bool> register(
    BuildContext context, String email, String password) async {
  try {
    await backend.register(email, password);
    return true;
  } on FirebaseAuthException catch (exception) {
    if (exception.code == 'weak-password') {
      debugPrint('The password provided is too weak.');
      if (context.mounted) {
        AppDialog.info(
          context,
          title: 'Weak Password',
          message:
              'Password you entered is too weak, please try a different password.',
          actionLabel: 'Retry',
          isError: true,
        );
      }
    } else if (exception.code == 'email-already-in-use') {
      debugPrint('The account already exists for that email.');
      if (context.mounted) {
        AppDialog.info(
          context,
          title: 'User Exists',
          message:
              'A user with this email already exists, please try a different email.',
          actionLabel: 'Retry',
          isError: true,
        );
      }
    }
    return false;
  } catch (exception) {
    debugPrint(exception.toString());
    if (context.mounted) {
      AppDialog.info(
        context,
        title: 'Unable to Register',
        message: 'We were unable to register you, please try again.',
        actionLabel: 'Retry',
        isError: true,
      );
    }
    return false;
  }
}

Future<void> signOut(BuildContext context) async {
  final confirmed = await AppDialog.confirm(
    context,
    title: 'Sign Out',
    message: 'Are you sure you want to sign out?',
    confirmLabel: 'Sign Out',
    destructive: true,
  );
  if (!confirmed) return;
  await backend.signOut();
  debugPrint('Logged out.');
  if (context.mounted) goFront(context, const LoginPage());
}
