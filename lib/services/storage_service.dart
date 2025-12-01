// presentation/services/storage_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads an XFile to Firebase Storage under lostify_images/{userId}/
  /// and returns the download URL.
  Future<String> uploadXFile(XFile file, String userId) async {
    final filename = "${DateTime.now().millisecondsSinceEpoch}_${file.name}";
    final ref = _storage.ref().child('lostify_images/$userId/$filename');

    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      final uploadTask = ref.putData(bytes);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } else {
      final fileForUpload = File(file.path);
      final uploadTask = ref.putFile(fileForUpload);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      return url;
    }
  }
}
