import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/user.dart';

import '../models/scoreboard_entry.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveScoreboardEntry(String userId, ScoreboardEntry entry) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('scores')
        .doc(entry.id)
        .set(entry.toFirestore());
  }

  Future<List<ScoreboardEntry>> getScoreboardEntries({String? id}) async {
    final snapshot = id == null
        ? await _firestore
              .collectionGroup('scores')
              /* .orderBy('timestamp', descending: true) */
              .get()
        : await _firestore
              .collection('users')
              .doc(id)
              .collection('scores')
              .orderBy('timestamp', descending: true)
              .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Include document ID in the data
      return ScoreboardEntry.fromFirestore(data);
    }).toList();
  }

  Future<void> updateScoreboardEntry(
    String userId,
    String resultId,
    ScoreboardEntry updatedResult,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('scores')
        .doc(resultId)
        .update(updatedResult.toFirestore());
  }

  Future<void> deleteScoreboardEntry(String userId, String resultId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('scores')
        .doc(resultId)
        .delete();
  }

  Future<void> saveUserProfile(User user) async {
    final userRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await userRef.get();

    if (userDoc.exists) {
      await userRef.update(user.toMap());
    } else {
      await userRef.set(user.toMap());
    }
  }

  Future<User?> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return User.fromMap(doc.data()!);
    }
    return null;
  }
}
