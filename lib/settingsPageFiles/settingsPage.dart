import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import 'package:turkify_bem/mainTools/PermCheckers.dart';

import '../cardSlidingScreenFiles/cardSlider.dart';
import '../filterPageFiles/FilterPage.dart';
import '../filterPageFiles/languageLevel.dart';

class SettingsPage extends StatefulWidget {
  static bool isDarkMode = false;

  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();

  static bool getIsDarkMode() {
    return isDarkMode;
  }
}

class _SettingsPageState extends State<SettingsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? profilePictureUrl;
  bool? isTutor;
  Map<String, dynamic> _userData = {};


  @override
  void initState() {
    super.initState();
    getUserDataa();
  }

  void getUserDataa() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      profilePictureUrl = userSnapshot.data()?['profileImageUrl'];
      isTutor = userSnapshot.data()?['isTutor'];
      getUserData();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsPage.isDarkMode ? const Color.fromARGB(255, 31, 28, 55) : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  image: profilePictureUrl != null
                      ? NetworkImage(profilePictureUrl!)
                      : const AssetImage('assets/defaultProfilePicture.jpeg') as ImageProvider<Object>,
                ),
              ),
              key: ValueKey(profilePictureUrl),
            ),

            const SizedBox(height: 15),
            Text(
              "${_userData['name']} ${_userData['surname']}" ?? "Name Surname",
              style: TextStyle(
                color: textColor(),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            SettingsGroup(
              items: _settingItems(),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.nightlight_round,
                    color: !SettingsPage.isDarkMode ? black : white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Dark Mode",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor(),
                      ),
                    ),
                  )
                ],
              ),
              trailing: Switch(
                value: SettingsPage.isDarkMode,
                onChanged: (value) {
                  setState(() {
                    SettingsPage.isDarkMode = value;
                  });
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScaffoldWidget(
                        title: 'Settings',
                        child: SettingsPage(),
                      ),
                    ),
                  );
                },
              ),
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

            SettingsGroup(
              settingsGroupTitle: "Account",
              settingsGroupTitleStyle: TextStyle(
                color: textColor(),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              items: [
                SettingsItem(
                  onTap: () {
                    logOut();
                    _goToLogin(context);
                  },
                  icons: CupertinoIcons.square_arrow_right,
                  title: "Log Out",
                  titleStyle: TextStyle(
                    color: baseDeepColor,
                    fontWeight: FontWeight.bold,
                  ),
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
    );
  }

  void getUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    Map<String, dynamic> userData = (userDoc.data() as Map<String, dynamic>);
    _userData = userData;
    setState(() {});
  }

  Future<void> _updateProfilePicture() async {
    if (!(await checkPermissionsStorage())) {
      requestPermissionsStorage();
    }

    String? imageUrl = await updateProfilePicture(context);

    if (imageUrl != null) {
      print("successfully uploaded prof pic");
      setState(() {
        profilePictureUrl = imageUrl;
      });
    } else {
      print("profile picture couldn't be uploaded");
    }
  }

  Future<void> _updateName(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController surnameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter new name and surname'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: _userData['name'],
                ),
              ),
              TextField(
                controller: surnameController,
                decoration: InputDecoration(
                  hintText: _userData['surname'],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                String newName = nameController.text;
                String newSurname = surnameController.text;

                // Update name and surname in Firebase
                await updateNameInFirebase(newName, newSurname);

                print('New name: $newName, New surname: $newSurname');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateNameInFirebase(String newName, String newSurname) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'name': newName,
          'surname': newSurname,
        });
        // Update local user data
        _userData['name'] = newName;
        _userData['surname'] = newSurname;
        setState(() {});
        print('Name and surname updated successfully in Firebase.');
      }
    } catch (e) {
      print('Error updating name and surname in Firebase: $e');
      // Handle error
    }
  }

  Future<void> _updateAbout(BuildContext context) async {
    TextEditingController aboutController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update About'),
          content: SizedBox(
            width: double.maxFinite,
            child: TextField(
              controller: aboutController,
              maxLines: null, // Allow multiline input
              decoration: InputDecoration(
                hintText: isTutor! ? _userData['tutorMap']['whoamI'] : _userData['studentMap']['whoamI'],
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 40),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                String newAbout = aboutController.text;
                await updateAboutInFirebase(newAbout);
                print('New about: $newAbout');
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScaffoldWidget(
                      title: 'Settings',
                      child: SettingsPage(),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> updateAboutInFirebase(String newAbout) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
          'tutorMap.whoamI': newAbout,
        });
        print('About updated successfully in Firebase.');
      }
    } catch (e) {
      print('Error updating about in Firebase: $e');
      // Handle error
    }
  }

  Future<String?> updateProfilePicture(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return null;

      File imageFile = File(pickedFile.path);
      String? imageUrl = await showDialog<String?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Preview"),
            content: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(imageFile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(await uploadAndCropImage(imageFile));
                },
                child: const Text("Confirm"),
              ),
            ],
          );
        },
      );

      return imageUrl;
    } catch (e) {
      print("Error updating profile picture: $e");
      return null;
    }
  }

  Future<String?> uploadAndCropImage(File imageFile) async {
    try {
      ui.Image? image = await loadImage(imageFile);
      if (image != null) {
        int size = image.width < image.height ? image.width : image.height;
        ui.Rect square = ui.Rect.fromCenter(
          center: Offset(image.width / 2, image.height / 2),
          width: size.toDouble(),
          height: size.toDouble(),
        );
        ui.Image? croppedImage = await cropImage(image, square);

        // Convert cropped image to bytes
        ByteData? byteData = await croppedImage!.toByteData(format: ui.ImageByteFormat.png);
        Uint8List? imageData = byteData?.buffer.asUint8List();

        if (imageData != null) {
          // BE CAREFUL USER HAS TO BE INITIALIZED - BERK
          Reference ref = FirebaseStorage.instance.ref().child('profile_pictures').child(user?.uid ?? "");
          UploadTask uploadTask = ref.putData(imageData);
          TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

          // Get download URL of uploaded image
          String imageUrl = await snapshot.ref.getDownloadURL();

          await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
            'profileImageUrl': imageUrl,
          });

          return imageUrl;
        }
      }
    } catch (e) {
      print("Error uploading and cropping image: $e");
    }
    return null;
  }

  Future<ui.Image?> loadImage(File imageFile) async {
    Uint8List bytes = await imageFile.readAsBytes();
    ui.Codec codec = await ui.instantiateImageCodec(bytes);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  Future<ui.Image?> cropImage(ui.Image image, ui.Rect cropRect) async {
    int targetWidth = cropRect.width.toInt();
    int targetHeight = cropRect.height.toInt();
    ui.PictureRecorder recorder = ui.PictureRecorder();
    ui.Canvas canvas = ui.Canvas(recorder);
    canvas.drawImageRect(image, cropRect, ui.Rect.fromLTRB(0, 0, targetWidth.toDouble(), targetHeight.toDouble()), Paint());
    ui.Picture picture = recorder.endRecording();
    return await picture.toImage(targetWidth, targetHeight);
  }
  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await FirebaseAuth.instance.signOut();
  }
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/auth')
        .then((_) => false);
  }

  List<SettingsItem> _settingItems(){
    List<SettingsItem> items = [
      SettingsItem(
        onTap: () async {
          _updateProfilePicture();
        },
        icons: CupertinoIcons.profile_circled,
        iconStyle: IconStyle(
          iconsColor: white,
          withBackground: true,
          backgroundColor: baseDeepColor,
        ),
        title: 'Profile Picture',
        subtitle: "Change your profile picture",
        titleMaxLine: 1,
        subtitleMaxLine: 1,
      ),
      SettingsItem(
        onTap: () async {
          _updateName(context);
        },
        icons: CupertinoIcons.pencil,
        iconStyle: IconStyle(
          iconsColor: white,
          withBackground: true,
          backgroundColor: baseDeepColor,
        ),
        title: 'Name',
        subtitle: "Change your name",
        titleMaxLine: 1,
        subtitleMaxLine: 1,
      ),
      if(isTutor ?? false)
      SettingsItem(
        onTap: () async {
          _updateAbout(context);
        },
        icons: Icons.info_outlined,
        iconStyle: IconStyle(
          iconsColor: white,
          withBackground: true,
          backgroundColor: baseDeepColor,
        ),
        title: 'Who am I?',
        subtitle: "Change your abouts",
        titleMaxLine: 1,
        subtitleMaxLine: 1,
      ),
      if(isTutor ?? false)
      SettingsItem(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScaffoldWidget(
                title: '',
                child: LanguageLevel(userData: _userData),
              ),
            ),
          );
        },
        icons: Icons.account_balance,
        iconStyle: IconStyle(
          iconsColor: white,
          withBackground: true,
          backgroundColor: baseDeepColor,
        ),
        title: 'Education Level',
        subtitle: 'Change your preferred level of students',
      ),
      SettingsItem(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScaffoldWidget(
                title: '',
                child: FilterPage(userData: _userData),
              ),
            ),
          );
        },
        icons: Icons.ac_unit_rounded,
        iconStyle: IconStyle(
          iconsColor: white,
          withBackground: true,
          backgroundColor: baseDeepColor,
        ),
        title: 'FILTER PAGE DENEME',
      ),
      SettingsItem(
        onTap: () {},
        icons: Icons.block,
        iconStyle: IconStyle(
          iconsColor: white,
          withBackground: true,
          backgroundColor: baseDeepColor,
        ),
        title: 'Blocked People',
        subtitle: "See blocked accounts",
      ),
    ];
    return items;
  }
}
