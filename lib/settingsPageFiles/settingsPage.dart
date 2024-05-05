import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turkify_bem/mainTools/APPColors.dart';
import 'package:turkify_bem/mainTools/PermCheckers.dart';

import '../DashboardScreen.dart';
import '../cardSlidingScreenFiles/cardSlider.dart';
import '../loginMainScreenFiles/custom_route.dart';

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
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  String? profilePictureUrl;
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
      setState(() {
        profilePictureUrl = userSnapshot.data()?['profileImageUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("AAAAAAAAAAAAAA $isDarkMode");
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
              _userData['name'] ?? "Name Surname",
              style: TextStyle(
                color: textColor(),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            SettingsGroup(
              items: [
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
                    _updateProfilePicture();
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
                SettingsItem(
                  onTap: () {},
                  icons: Icons.notifications,
                  iconStyle: IconStyle(
                    iconsColor: white,
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
                    iconsColor: white,
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
              settingsGroupTitle: "Account",
              settingsGroupTitleStyle: TextStyle(
                color: textColor(),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              items: [
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
    Map<String, dynamic> userData = (userDoc.data() as Map<String, dynamic>) ?? {};
    setState(() {
      _userData = userData; // Update user data in the state
    });
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

  Future<String?> updateProfilePicture(BuildContext context) async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
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
}
