import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/quiz_result.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveQuizResult(String userId, QuizResult quizResult) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('scores')
        .add(quizResult.toFirestore());
  }

  Future<List<QuizResult>> getQuizResults(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('scores')
        //.orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Include document ID in the data
      return QuizResult.fromFirestore(data);
    }).toList();
  }

  Future<void> updateQuizResult(
    String userId,
    String resultId,
    QuizResult updatedResult,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('scores')
        .doc(resultId)
        .update(updatedResult.toFirestore());
  }

  Future<void> deleteQuizResult(String userId, String resultId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('scores')
        .doc(resultId)
        .delete();
  }
}
