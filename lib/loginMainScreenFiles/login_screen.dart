import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:turkify_bem/APPColors.dart';
import 'constants.dart';
import 'custom_route.dart';
import '../dashboard_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
  }

  static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 225);

  Future<String?> _loginUser(LoginData data) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );

      if (userCredential.user?.emailVerified == false) {
        return "Email verification pending. Please verify your email address.";
      }

      String name = data.name;
      return null;
    } catch (e) {
      return e.toString(); // Return error message if login fails
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      // Check if email and password are provided
      if (data.name == null || data.password == null || data.name!.isEmpty || data.password!.isEmpty) {
        return "Email and password are required.";
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );

      // email verification
      await userCredential.user?.sendEmailVerification();

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'username': data.additionalSignupData?['Username'],
        'name': data.additionalSignupData?['Name'],
        'surname': data.additionalSignupData?['Surname'],
        'phoneNumber': data.additionalSignupData?['phone_number'],
        'friends': [],
      });

      return "Your account is created but you need to verify your email first.";
    } catch (e) {
      return e.toString(); // ERROR MESSAGE
    }
  }


  Future<String?> _recoverPassword(String name) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
      return "Password reset link has been sent. Please check your emails.";
    } catch (e) {
      return "$e";
    }
  }

  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: Constants.appName,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      onConfirmRecover: _signupConfirm,
      loginAfterSignUp: false,
      termsOfService: [
        TermOfService(
          id: 'general-term',
          mandatory: true,
          text: 'Term of services',
          linkUrl: 'https://github.com/berkemremert/turkifyApp',
        ),
      ],
      additionalSignupFields: [
        const UserFormField(
          keyName: 'Username',
          icon: Icon(FontAwesomeIcons.userLarge),
        ),
        const UserFormField(keyName: 'Name'),
        const UserFormField(keyName: 'Surname'),
        UserFormField(
          keyName: 'phone_number',
          displayName: 'Phone Number',
          userType: LoginUserType.phone,
          fieldValidator: (value) {
            final phoneRegExp = RegExp(
              '^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}\$',
            );
            if (value != null &&
                value.length < 7 &&
                !value.startsWith("0") &&
                !phoneRegExp.hasMatch(value)) {
              return "This isn't a valid phone number";
            }
            return null;
          },
        ),
      ],
      // scrollable: true,
      // hideProvidersTitle: false,
      // loginAfterSignUp: false,
      // hideForgotPasswordButton: true,
      // hideSignUpButton: true,
      // disableCustomPageTransformer: true,
      // messages: LoginMessages(
      //   userHint: 'User',
      //   passwordHint: 'Pass',
      //   confirmPasswordHint: 'Confirm',
      //   loginButton: 'LOG IN',
      //   signupButton: 'REGISTER',
      //   forgotPasswordButton: 'Forgot huh?',
      //   recoverPasswordButton: 'HELP ME',
      //   goBackButton: 'GO BACK',
      //   confirmPasswordError: 'Not match!',
      //   recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
      //   recoverPasswordDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
      //   recoverPasswordSuccess: 'Password rescued successfully',
      //   flushbarTitleError: 'Oh no!',
      //   flushbarTitleSuccess: 'Success!',
      //   providersTitle: 'login with'
      // ),
      theme: LoginTheme(
        primaryColor: baseDeepColor,
        pageColorLight: baseLightColor,
        pageColorDark: baseDeepColor,
        footerBackgroundColor: baseDeepColor,
        primaryColorAsInputLabel: false,
        accentColor: baseDeepColor,
        errorColor: Colors.red,
        logoWidth: 0.80,
        titleStyle: TextStyle(
          color: Color.fromRGBO(240, 230, 230, 1.0),
          fontFamily: 'NotoSans',
          letterSpacing: 2,
          fontWeight: FontWeight.w600,
        ),
        buttonTheme: LoginButtonTheme(
          backgroundColor: Colors.red,
          splashColor: darkRed,
          highlightColor:baseLightColor,
          elevation: 5.0,
        ),
        // beforeHeroFontSize: 50,
        // afterHeroFontSize: 20,
        ),
      //   buttonTheme: LoginButtonTheme(
      //     splashColor: Colors.purple,
      //     backgroundColor: Colors.pinkAccent,
      //     highlightColor: Colors.lightGreen,
      //     elevation: 9.0,
      //     highlightElevation: 6.0,
      //     shape: BeveledRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
      //     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      //   ),
      // ),
      userValidator: (value) {
        if (!value!.contains('@') || (!value.endsWith('.com') & !value.endsWith('.edu.tr'))){
          return "Email must contain '@' and end with '.com or .ku.edu.tr'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name: ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('Name: ${signupData.name}');
        debugPrint('Password: ${signupData.password}');

        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
        });
        if (signupData.termsOfService.isNotEmpty) {
          debugPrint('Terms of service: ');
          for (final element in signupData.termsOfService) {
            debugPrint(
              ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}',
            );
          }
        }
        return _signupUser(signupData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          FadePageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      },
      onRecoverPassword: (name) {
        return _recoverPassword(name);
        // Show new password dialog
      },
      //headerWidget: const IntroWidget(),
    );
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Please enter your username and password.",
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        Row(
          children: <Widget>[
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(Constants.appName),
            ),
            Expanded(child: Divider()),
          ],
        ),
      ],
    );
  }
}
