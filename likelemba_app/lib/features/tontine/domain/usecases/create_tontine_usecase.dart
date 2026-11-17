import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/domain/failures/tontine_failures.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';

class CreateTontineParams extends Equatable {
  const new({
    required this.name,
    required this.contributionAmount,
    required this.frequency,
    required this.startDate,
  });

  final String name;
  final int contributionAmount;
  final ContributionFrequency frequency;
  final DateTime startDate;

  @override
  List<Object?> get props => [name, contributionAmount, frequency, startDate];
}

/// Crée une tontine ; son créateur en devient le trésorier.
class CreateTontineUseCase implements UseCase<Tontine, CreateTontineParams> {
  const new(this._repository);

  final TontineRepository _repository;

  @override
  Future<Tontine> call(CreateTontineParams params) {
    final name = params.name.trim();
    // Règles métier vérifiées avant tout appel réseau.
    if (name.length < 3 || params.contributionAmount <= 0) {
      throw const InvalidTontineDataFailure();
    }
    return _repository.createTontine(
      name: name,
      contributionAmount: params.contributionAmount,
      frequency: params.frequency,
      startDate: params.startDate,
    );
  }
}
