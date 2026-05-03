#!/usr/bin/env bash
set -euo pipefail

PGHOST="127.0.0.1"
PGPORT="5432"
PGUSER="postgres"
DB_NAME="demodb"
OUTPUT_DIR="/home/nathan/pgdump/demodb"
MAX_BACKUPS=10
LOG_FILE="${OUTPUT_DIR}/backup.log"

mkdir -p "$OUTPUT_DIR"

log() {
    printf '%s : %-5s : %s\n' "$(date +'%y%m%d_%H%M%S')" "$1" "$2" >> "$LOG_FILE"
}

trap 'log "ERROR" "Fallo inesperado en la ejecución del script"' ERR

FILE="${OUTPUT_DIR}/${DB_NAME}_$(date +'%y%m%d_%H%M%S').dump"

pg_dump -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -Fc -d "$DB_NAME" -f "$FILE"

[[ -s "$FILE" ]] && log "OK" "Backup realizado $FILE" || { log "ERROR" "Backup vacío"; exit 1; }

REMOVED=$(find "$OUTPUT_DIR" -maxdepth 1 -type f -name "${DB_NAME}_*.dump" | sort | head -n -"${MAX_BACKUPS}" | wc -l)

find "$OUTPUT_DIR" -maxdepth 1 -type f -name "${DB_NAME}_*.dump" | sort | head -n -"${MAX_BACKUPS}" | xargs -r rm -f

# (( REMOVED > 0 )) && log "INFO" "Eliminados $REMOVED backups antiguos"
