import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turkify_bem/APPColors.dart';
import 'package:turkify_bem/constLinks.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  String? profilePictureUrl;
  Map<String, dynamic> _userData = {}; // To store user data

  @override
  void initState(){
    super.initState();
    profilePictureUrl = user?.photoURL;
    getUserData();
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.94),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Make the container a circle
                image: DecorationImage(
                  fit: BoxFit.contain, // Ensure the photo fits within the circular area
                  alignment: Alignment.center, // Center the photo within the circular area
                  image: NetworkImage(
                    profilePictureUrl ?? profileDefault,
                  ),
                ),
              ),
              // Provide a key to the Container for updating the image
              key: ValueKey(profilePictureUrl),
            ),

            SizedBox(height: 15),
            Text(
              _userData['name'] ?? "Name Surname",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () async {
                    _updateProfilePicture();
                  },
                  icons: CupertinoIcons.profile_circled,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: baseDeepColor,
                  ),
                  title: 'Profile Picture',
                  subtitle: "Change your profile picture",
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
            SettingsGroup(
              settingsGroupTitle: "Account",
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
    String? imageUrl = await updateProfilePicture(context);

    if (imageUrl != null) {
      print("successfully uploaded prof pic");
      setState(() {
        profilePictureUrl = imageUrl;
      });
    } else {
      print("profile picture couldnt be uploaded");
    }
  }

  Future<String?> updateProfilePicture(BuildContext context) async {
    try {
      final ImagePicker _picker = ImagePicker();
      // Pick image from gallery
      XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return null;

      // Display the selected image for preview
      File imageFile = File(pickedFile.path);
      String? imageUrl = await showDialog<String?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Preview"),
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
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(await uploadAndCropImage(imageFile));
                },
                child: Text("Confirm"),
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
      // Load the image
      ui.Image? image = await loadImage(imageFile);
      if (image != null) {
        // Crop the image
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

//
//   void _changeProfilePicture(context) async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       // Upload the selected image to Firebase Storage
//       String imageUrl = await uploadImageToFirebase(image);
//
//       // Save the image URL to Firestore
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         String userID = user.uid;
//         await saveProfilePictureUrl(userID, imageUrl);
//
//         // Show a message that the profile picture has been updated
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile picture updated successfully')),
//         );
//       } else {
//         print('User is not logged in');
//       }
//     }
//   }
//
//   Future<String> uploadImageToFirebase(XFile image) async {
//     try {
//       Reference ref = FirebaseStorage.instance.ref().child('profile_images').child(image.name);
//       TaskSnapshot taskSnapshot = await ref.putFile(File(image.path));
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//       return downloadUrl;
//     } catch (e) {
//       print('Error uploading image to Firebase: $e');
//       return ''; // Return empty string on failure
//     }
//   }
//
//   Future<void> saveProfilePictureUrl(String userId, String pictureUrl) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .update({
//         'profilePictureUrl': pictureUrl,
//       });
//       print('Profile picture URL saved successfully');
//     } catch (e) {
//       print('Error saving profile picture URL: $e');
//     }
//   }
//
//   Future<String?> getUserProfilePictureUrl() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       return user.photoURL;
//     } else {
//       throw Exception('User is not logged in');
//     }
//   }
// }
