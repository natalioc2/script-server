#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/nathan/repository/howto-sync"
BRANCH="main"
LOG_FILE="/home/nathan/repository/logs/howwto.log"

log() {
    printf '%s | %-5s | %s\n' "$(date +'%y%m%y_%H%M%S')" "$1" "$2" >> "$LOG_FILE"
}

trap 'log "ERROR" "Fallo inesperado en el script"' ERR

cd "$REPO_DIR" || exit 1

# Salir si no hay cambios locales
if [[ -z "$(git status --porcelain=v1)" ]]; then
  log "INFO" "No hay cambios para commitear"
  exit 0
fi

COMMIT_MESSAGE="auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"

git add -A
git commit -m "$COMMIT_MESSAGE"

# Traer cambios remotos sin merge commits
git pull --rebase origin "$BRANCH"

git push origin "$BRANCH"

log "INFO" "Commit y push exitosos : $COMMIT_MESSAGE"
