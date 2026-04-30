#!/usr/bin/env bash
#
# icloud-backup.sh - Sync iCloud Drive to NAS backup
#
# Usage:
#   ./icloud-backup.sh
#

set -euo pipefail

# ─── Paths ───────────────────────────────────────────────────────────────────
ICLOUD_DIR="/Users/tetsuya/Library/Mobile Documents/com~apple~CloudDocs"
NAS_BACKUP_DIR="/Volumes/NAS/Backups/iCloud"

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { printf "${BLUE}[INFO]${NC}  %s\n" "$*"; }
ok()    { printf "${GREEN}[OK]${NC}    %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${NC}  %s\n" "$*"; }
err()   { printf "${RED}[ERR]${NC}   %s\n" "$*" >&2; }
die()   { err "$*"; exit 1; }

# ─── Check macOS ─────────────────────────────────────────────────────────────
if [[ "$(uname -s)" != "Darwin" ]]; then
    die "This script only runs on macOS"
fi

# ─── Check source exists ─────────────────────────────────────────────────────
if [[ ! -d "$ICLOUD_DIR" ]]; then
    die "iCloud Drive not found: $ICLOUD_DIR"
fi

# ─── Check NAS is mounted ────────────────────────────────────────────────────
if [[ ! -d "$NAS_BACKUP_DIR" ]]; then
    die "NAS backup directory not found: $NAS_BACKUP_DIR\nPlease mount NAS first."
fi

# ─── Run rsync ───────────────────────────────────────────────────────────────
info "Starting iCloud backup..."
info "Source: $ICLOUD_DIR"
info "Target: $NAS_BACKUP_DIR"
echo ""

rsync -avh --progress \
    --delete \
    --exclude='.DS_Store' \
    --exclude='.Trash' \
    --exclude='.Spotlight-V100' \
    --exclude='.TemporaryItems' \
    "$ICLOUD_DIR/" \
    "$NAS_BACKUP_DIR/"

echo ""
ok "iCloud backup completed!"
