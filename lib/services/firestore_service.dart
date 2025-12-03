import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/budget.dart';
import 'package:flutter_application_1/model/current.dart';
import 'package:flutter_application_1/model/timer.dart';
import 'package:flutter_application_1/model/users.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Current
  Future<void> setCurrentReading(CurrentModel current) async {
    await _db.collection('current').doc('readings').set(current.toMap());
  }

  Stream<CurrentModel> getCurrentReading() {
    return _db.collection('current').doc('readings').snapshots()
        .map((snapshot) => CurrentModel.fromMap(snapshot.data()!));
  }

  // Users
  Future<void> setUserData(String userId, UserModel user) async {
    await _db.collection('users').doc(userId).set(user.toMap());
  }

  Future<UserModel> getUserData(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return UserModel.fromMap(doc.data()!);
  }

  // Timer
  Future<void> addSchedule(String userId, String scheduleId, TimerModel timer) async {
    await _db.collection('timer').doc(userId)
        .collection('schedule').doc(scheduleId).set(timer.toMap());
  }

  Stream<List<TimerModel>> getSchedules(String userId) {
    return _db.collection('timer').doc(userId)
        .collection('schedule').snapshots()
        .map((snap) => snap.docs.map((doc) => TimerModel.fromMap(doc.data())).toList());
  }

  Future<void> deleteSchedule(String userId, String scheduleId) async {
    await _db.collection('timer').doc(userId)
        .collection('schedule').doc(scheduleId).delete();
  }

  // Budget
  Future<void> setBudget(String userId, BudgetModel budget) async {
    await _db.collection('budget').doc(userId).set(budget.toMap());
  }

  Future<BudgetModel> getBudget(String userId) async {
    final doc = await _db.collection('budget').doc(userId).get();
    return BudgetModel.fromMap(doc.data()!);
  }
}
