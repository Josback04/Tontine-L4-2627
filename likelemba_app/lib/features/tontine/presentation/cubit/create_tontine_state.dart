part of 'create_tontine_cubit.dart';

final class CreateTontineState extends Equatable {
  const new({this.status = FormStatus.initial, this.tontine, this.failure});

  final FormStatus status;
  final Tontine? tontine;
  final Failure? failure;

  @override
  List<Object?> get props => [status, tontine, failure];
}
