#!/usr/bin/env bash
# Vérifie la règle de dépendance de la Clean Architecture.
# Chaque contrôle doit afficher ✓. Usage : bash tool/check_architecture.sh
set -u
cd "$(dirname "$0")/.."

status=0
P=likelemba_app

check() {
  local title="$1"
  shift
  local output
  output="$("$@" 2>/dev/null)"
  if [ -n "$output" ]; then
    echo "✗ $title"
    echo "$output" | sed 's/^/    /'
    status=1
  else
    echo "✓ $title"
  fi
}

check "1. Le domaine est du Dart pur (seuls core/errors et core/usecase sont admis)" \
  grep -rnE "package:(flutter|material_ui|dio|shared_preferences|get_it|bloc|flutter_bloc|go_router)|$P/features/[^/]+/(data|presentation)|$P/core/(config|di|l10n|network|router|theme|utils|widgets)" lib/features/*/domain

check "2. L'interface n'importe rien de data/" \
  grep -rnE "$P/features/[^/]+/data/" lib/features/*/presentation

check "3. La couche de données ignore l'interface" \
  grep -rnE "package:(flutter_bloc|material_ui|go_router)|$P/features/[^/]+/presentation" lib/features/*/data

check "4. core/ ne dépend d'aucune feature (hors points d'assemblage di/ et router/)" \
  grep -rn "$P/features/" lib/core --exclude-dir=di --exclude-dir=router

check "5. Aucune alerte réduite au silence (hors fichiers générés)" \
  grep -rn --exclude-dir=gen "// ignore" lib test

exit $status
