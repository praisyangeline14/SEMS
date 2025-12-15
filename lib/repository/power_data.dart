import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/new_model.dart';

class PowerRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updatePowerData({
    required String docId,
    required PowerData data,
  }) async {
    await firestore
        .collection("Current")
        .doc(docId)
        .update(data.toMap());  
  }

  Future<void> deletePowerData(String docId) async {
    await firestore
        .collection("Current")
        .doc(docId)
        .delete();
  }
}
