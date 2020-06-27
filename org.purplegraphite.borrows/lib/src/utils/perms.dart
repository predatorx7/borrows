import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Perms {
  static Map<Permission, PermissionStatus> _requestedResult;
  static final Permission _contactsAccessPerm = Permission.contacts;

  // TODO: make a dialog to describe why we need permission
  /// Asking permissions
  static Future<void> request() async {
    WidgetsFlutterBinding.ensureInitialized();
    var status = await _contactsAccessPerm.status;
    if (status.isUndetermined) {
      // We didn't ask for permission yet.
      await _requestPermission();
    }
  }

  static Future<void> _requestPermission() async {
    //Requesting multiple permissions at once.
    _requestedResult = await [_contactsAccessPerm].request();
    // Iterating map to check permissions
    _requestedResult.forEach((perm, permStatus) async {
      if (await perm.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      } else {
        // Not granted.
        _handleInvalidPermissions(permStatus);
      }
    });
  }

  static void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus != PermissionStatus.granted) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to contacts data denied",
          details: null);
    }
  }
}
