#!/usr/bin/env bash
set -e

REPO_DIR="/mnt/emmc/repository/howto-sync"
BRANCH="main"

cd "$REPO_DIR" || exit 1

# Salir si no hay cambios locales
if [[ -z "$(git status --porcelain=v1)" ]]; then
  echo "⚠️ No hay cambios para commitear."
  exit 0
fi

COMMIT_MESSAGE="auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"

git add -A
git commit -m "$COMMIT_MESSAGE"

# Traer cambios remotos sin merge commits
git pull --rebase origin "$BRANCH"

git push origin "$BRANCH"

echo "✅ Commit y push exitosos: $COMMIT_MESSAGE"
