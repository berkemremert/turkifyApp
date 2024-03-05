import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:turkify_bem/APPColors.dart';

class settingsPage extends StatelessWidget {
  const settingsPage({Key? key}) : super(key: key);

  @override
  Widget build (context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white.withOpacity(.94),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              // user card
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width - 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage("https://images.pexels.com/photos/846741/pexels-photo-846741.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Text(
                "Berk Emre Mert",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15,),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.profile_circled,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: baseDeepColor,
                    ),
                    title:
                    'Profile Picture',
                    subtitle:
                    "Change your profile picture",
                    titleMaxLine: 1,
                    subtitleMaxLine: 1,
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.notifications,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: baseDeepColor,
                    ),
                    title: 'Notifications',
                    subtitle: "Change your notifications settings",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.block,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: baseDeepColor,
                    ),
                    title: 'Blocked People',
                    subtitle: "See blocked accounts",
                  ),
                ],
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: baseDeepColor,
                    ),
                    title: 'About',
                    subtitle: "Learn more about Turkify",
                  ),
                ],
              ),
              // You can add a settings title
              SettingsGroup(
                settingsGroupTitle: "Account",
                items: [
                  SettingsItem(
                    onTap: () {
                      _changeEmail(context);
                    },
                    icons: CupertinoIcons.repeat,
                    title: "Change email",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.delete_solid,
                    title: "Delete account",
                    titleStyle: TextStyle(
                      color: baseDeepColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeEmail(BuildContext context) async {
    //User? user = FirebaseAuth.instance.currentUser;

    Map<String, String?>? result = await showDialog(
      context: context,
      builder: (context) => _buildChangeEmailDialog(context),
    );

    if (result != null && result['newEmail'] != null && result['password'] != null) {
      String newEmail = result['newEmail']!;
      String password = result['password']!;
     //try {
        FirebaseAuth.instance.currentUser?.updateEmail(newEmail);
        // Re-authenticate user
        //AuthCredential credential = EmailAuthProvider.credential(
        //    email: user!.email!,
        //    password: password,
        //);

        //UserCredential newCredential = await user.reauthenticateWithCredential(credential);
        //print("Re-authentication successful.");


        // Update email
        //await newCredential.user?.updateEmail(newEmail);
        //print("Email updated successfully to $newEmail.");
      //} catch (e) {
        //print("Error updating email: $e");
      //}
    }
  }


  Widget _buildChangeEmailDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return AlertDialog(
      title: Text('Change Email'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'New Email Address'),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Your Password'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String newEmail = emailController.text.trim();
            String password = passwordController.text.trim();
            if (newEmail.isNotEmpty && password.isNotEmpty) {
              // Pass both the new email and password to the callback
              Navigator.of(context).pop({'newEmail': newEmail, 'password': password});
            } else {
              // Handle case where either email or password is empty
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Email and password are required.')),
              );
            }
          },
          child: Text('Change'),
        ),
      ],
    );
  }


  void reauthenticateUser(String email, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);
        print('User re-authenticated successfully.');
      } else {
        print('User is not signed in.');
      }
    } catch (e) {
      print('Error re-authenticating user: $e');
    }
  }
}