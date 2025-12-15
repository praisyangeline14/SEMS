import 'package:flutter_application_1/bloc/current_bloc/current_event.dart';
import 'package:flutter_application_1/bloc/current_bloc/current_state.dart';
import 'package:flutter_application_1/repository/power_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PowerBloc extends Bloc<PowerEvent, PowerState> {
  final PowerRepository repository;

  PowerBloc(this.repository) : super(PowerInitial()) {

    on<UpdatePowerEvent>((event, emit) async {
      emit(PowerLoading());
      try {
        await repository.updatePowerData(
          docId: event.docId,
          data: event.data,
        );
        emit(PowerSuccess());
      } catch (e) {
        emit(PowerError(e.toString()));
      }
    });

    on<DeletePowerEvent>((event, emit) async {
      emit(PowerLoading());
      try {
        await repository.deletePowerData(event.docId);
        emit(PowerSuccess());
      } catch (e) {
        emit(PowerError(e.toString()));
      }
    });

  }
}
