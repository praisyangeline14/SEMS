import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModel {
  final double monthlyBudget;
  final Timestamp createdAt;

  BudgetModel({required this.monthlyBudget, required this.createdAt});

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      monthlyBudget: map['monthlyBudget'] ?? 0.0,
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'monthlyBudget': monthlyBudget,
      'createdAt': createdAt,
    };
  }
}
