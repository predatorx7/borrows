import 'package:permission_handler/permission_handler.dart';

Future<void> _askPermissions() async {
  PermissionStatus permissionStatus = await _getContactPermission();
  if (permissionStatus != PermissionStatus.granted) {
    _handleInvalidPermissions(permissionStatus);
  }
}

Future<PermissionStatus> _getContactPermission() async {
  PermissionStatus permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.disabled) {
    Map<PermissionGroup, PermissionStatus> permissionStatus =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.contacts]);
    return permissionStatus[PermissionGroup.contacts] ??
        PermissionStatus.unknown;
  } else {
    return permission;
  }
}

void _handleInvalidPermissions(PermissionStatus permissionStatus) {
  if (permissionStatus == PermissionStatus.denied) {
    throw PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to location data denied",
        details: null);
  } else if (permissionStatus == PermissionStatus.disabled) {
    throw PlatformException(
        code: "PERMISSION_DISABLED",
        message: "Location data is not available on device",
        details: null);
  }
}
