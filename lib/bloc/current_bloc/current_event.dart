import 'package:flutter_application_1/model/new_model.dart';

abstract class PowerEvent {}

class UpdatePowerEvent extends PowerEvent {
  final String docId;
  final PowerData data;

  UpdatePowerEvent({required this.docId, required this.data});
}
    
class DeletePowerEvent extends PowerEvent {
  final String docId;

  DeletePowerEvent(this.docId);
}
