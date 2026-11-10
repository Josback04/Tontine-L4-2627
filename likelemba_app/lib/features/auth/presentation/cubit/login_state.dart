part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const new({this.status = FormStatus.initial, this.user, this.failure});

  final FormStatus status;
  final User? user;
  final Failure? failure;

  @override
  List<Object?> get props => [status, user, failure];
}
