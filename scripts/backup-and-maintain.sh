#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# backup-and-maintain.sh
# Creates a timestamped MySQL dump inside backups/ and prunes old ones.
# Run from the repo root. No local mysql client required.
# ─────────────────────────────────────────────────────────────────────────────
set -e

# Ensure we are always at the repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/.."

# Load .env if present
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

ROOT_PASS="${MYSQL_ROOT_PASSWORD:-tibia_root_password}"
DB="${MYSQL_DATABASE:-tibia}"
BACKUP_DIR="./backups"
LOG_DIR="./logs"
RETENTION_DAYS="${RETENTION_DAYS:-30}"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${YELLOW}[backup]${NC} $1"; }
success() { echo -e "${GREEN}[backup]${NC} $1"; }
error()   { echo -e "${RED}[backup]${NC} $1"; exit 1; }

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/tibia_backup_${TIMESTAMP}.sql.gz"

info "Backing up database → ${BACKUP_FILE}"

docker-compose exec -T mysql mysqldump \
    -u root -p"${ROOT_PASS}" "${DB}" | gzip > "${BACKUP_FILE}"

success "Backup complete: ${BACKUP_FILE} ($(du -sh "${BACKUP_FILE}" | cut -f1))"

# ── Prune old backups ─────────────────────────────────────────────────────────
info "Pruning backups older than ${RETENTION_DAYS} days..."
find "$BACKUP_DIR" -name "tibia_backup_*.sql.gz" -mtime +"${RETENTION_DAYS}" -delete
success "Pruning done."

# ── Health check ─────────────────────────────────────────────────────────────
info "Container status:"
docker-compose ps

DISK=$(df -h . | awk 'NR==2 {print $5}')
info "Disk usage: ${DISK}"

success "Maintenance complete."
