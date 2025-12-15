import 'package:cloud_firestore/cloud_firestore.dart';

class PowerData {
  final double perUnitCurrent;
  final double totalCurrent;
  final double totalVoltage;
  final int totalCost;
  final double totalFrequency;
  final Timestamp timestamp;

  PowerData({
    required this.perUnitCurrent,
    required this.totalCurrent,
    required this.totalVoltage,
    required this.totalCost,
    required this.totalFrequency,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "perUnitCurrent": perUnitCurrent,
      "totalCurrent": totalCurrent,
      "totalVoltage": totalVoltage,
      "totalCost": totalCost,
      "totalFrequency": totalFrequency,
      "timestamp": timestamp,
    };
  }
}
