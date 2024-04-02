import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissionsAll() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.storage,
    Permission.microphone,
  ].request();

  if (statuses[Permission.camera] == PermissionStatus.granted &&
      statuses[Permission.storage] == PermissionStatus.granted &&
      statuses[Permission.microphone] == PermissionStatus.granted) {
  } else {
  }
}

Future<void> requestPermissionsCamera() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
  ].request();

  if (statuses[Permission.camera] == PermissionStatus.granted) {
  } else {
  }
}

Future<void> requestPermissionsStorage() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  if (statuses[Permission.storage] == PermissionStatus.granted) {
  } else {
  }
}

Future<void> requestPermissionsMic() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.microphone,
  ].request();

  if (statuses[Permission.microphone] == PermissionStatus.granted) {
  } else {
  }
}

Future<bool> checkPermissionsAll() async {
  PermissionStatus cameraStatus = await Permission.camera.status;
  PermissionStatus storageStatus = await Permission.storage.status;
  PermissionStatus microphoneStatus = await Permission.microphone.status;

  return cameraStatus == PermissionStatus.granted &&
      storageStatus == PermissionStatus.granted &&
      microphoneStatus == PermissionStatus.granted;
}

Future<bool> checkPermissionsCamera() async {
  PermissionStatus cameraStatus = await Permission.camera.status;

  return cameraStatus == PermissionStatus.granted;
}

Future<bool> checkPermissionsStorage() async {
  PermissionStatus storageStatus = await Permission.storage.status;

  return storageStatus == PermissionStatus.granted;
}

Future<bool> checkPermissionsMic() async {
  PermissionStatus microphoneStatus = await Permission.microphone.status;

  return microphoneStatus == PermissionStatus.granted;
}