abstract class PowerState {}

class PowerInitial extends PowerState {}

class PowerLoading extends PowerState {}

class PowerSuccess extends PowerState {}

class PowerError extends PowerState {
  final String message;
  PowerError(this.message);
}
