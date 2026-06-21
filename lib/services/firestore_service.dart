import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<List<ScoreboardEntry>> getScoreboardEntries(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('scores')
        //.orderBy('timestamp', descending: true)
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
}
