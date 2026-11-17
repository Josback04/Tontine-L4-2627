import 'package:equatable/equatable.dart';

abstract interface class UseCase<Result, Params> {
  Future<Result> call(Params params);
}

/// Pour les cas d'usage sans paramètre.
class NoParams extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}
