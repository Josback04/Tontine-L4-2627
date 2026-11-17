/// Rythme des cotisations.
enum ContributionFrequency { weekly, monthly }

/// Une tontine : un groupe qui met de l'argent en commun à chaque tour.
class Tontine {
  const Tontine({
    required this.id,
    required this.name,
    required this.contributionAmount,
    required this.frequency,
    required this.startDate,
    required this.createdAt,
  });

  final String id;
  final String name;

  /// Montant versé par chaque membre à chaque tour, en francs congolais.
  final int contributionAmount;
  final ContributionFrequency frequency;
  final DateTime startDate;
  final DateTime createdAt;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'contribution_amount': contributionAmount,
    'frequency': frequency.name,
    'start_date': startDate.toUtc().toIso8601String(),
    'created_at': createdAt.toUtc().toIso8601String(),
  };
}
