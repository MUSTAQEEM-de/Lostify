import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref("lostify");

  /// ✅ Save user information
  Future<void> saveUser(String userId, String name, String email) async {
    await _db.child("users/$userId").set({
      "name": name,
      "email": email,
      "createdAt": DateTime.now().toIso8601String(),
    });
    print("✅ User saved to Realtime Database");
  }

  /// ✅ Save lost/found item details
  Future<void> saveItem({
    required String userId,
    required String name,
    required String description,
    required String location,
    required String date,
    required String imageUrl,
    required String type, // "lost" or "found"
  }) async {
    final newItemRef = _db.child("items").push();
    await newItemRef.set({
      "userId": userId,
      "name": name,
      "description": description,
      "location": location,
      "date": date,
      "imageUrl": imageUrl,
      "type": type,
    });
    print("✅ Item saved to Realtime Database");
  }

  /// ✅ Test function (for your “Save Test Data” button)
  Future<void> testWrite() async {
    await _db.child("testItems").push().set({
      "name": "Test Item",
      "timestamp": DateTime.now().toIso8601String(),
    });
    print("✅ Test item written to Realtime Database");
  }
}
