import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentModel {
  final double totalCurrent;
  final double totalVoltage;
  final Timestamp timestamp;

  CurrentModel({
    required this.totalCurrent,
    required this.totalVoltage,
    required this.timestamp,
  });

  factory CurrentModel.fromMap(Map<String, dynamic> map) {
    return CurrentModel(
      totalCurrent: map['totalCurrent'] ?? 0.0,
      totalVoltage: map['totalVoltage'] ?? 0.0,
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalCurrent': totalCurrent,
      'totalVoltage': totalVoltage,
      'timestamp': timestamp,
    };
  }
}
