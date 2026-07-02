import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quiz_app/services/firestore_service.dart';

class ProfileRepository {
  final FirestoreService firestoreService;
  final FirebaseStorage firebaseStorage;

  ProfileRepository({
    required this.firestoreService,
    FirebaseStorage? firebaseStorage,
  }) : firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    final user = await firestoreService.getUserProfile(userId);
    if (user == null) {
      throw Exception('User not found');
    }

    // Get file extension from path, defaulting to jpg
    final ext = imageFile.path.split('.').last;
    final extension = ext.isNotEmpty ? ext : 'jpg';

    // Construct the storage reference path
    final ref = firebaseStorage.ref().child('profile_images').child(userId).child('profile_image.$extension');
    
    // Upload the file
    await ref.putFile(imageFile);
    
    // Get the download URL
    final downloadUrl = await ref.getDownloadURL();
    
    // Update the user profile
    final updatedUser = user.copyWith(avatarUrl: downloadUrl);
    await firestoreService.updateUserProfile(updatedUser);
    
    return downloadUrl;
  }
}
