class TimerModel {
  final String startTime;
  final String endTime;
  final bool enabled;

  TimerModel({
    required this.startTime,
    required this.endTime,
    required this.enabled,
  });

  factory TimerModel.fromMap(Map<String, dynamic> map) {
    return TimerModel(
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      enabled: map['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'enabled': enabled,
    };
  }
}
