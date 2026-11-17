part of 'tontines_cubit.dart';

final class TontinesState extends Equatable {
  const new({
    this.status = LoadStatus.loading,
    this.tontines = const [],
    this.failure,
  });

  final LoadStatus status;
  final List<Tontine> tontines;
  final Failure? failure;

  @override
  List<Object?> get props => [status, tontines, failure];
}
