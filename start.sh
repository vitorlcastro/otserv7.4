#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# start.sh — One-command launcher for Tibia 7.4 Server
#
# Usage (from the repo root):
#   ./start.sh          → first-time setup + start
#   ./start.sh start    → start containers (already built)
#   ./start.sh stop     → stop containers
#   ./start.sh restart  → restart containers
#   ./start.sh logs     → tail server logs
#   ./start.sh status   → show container status
#   ./start.sh backup   → run a database backup
#   ./start.sh reset    → stop + remove volumes (WIPES DATA)
# ─────────────────────────────────────────────────────────────────────────────
set -e

# Always run from the repo root
cd "$(dirname "${BASH_SOURCE[0]}")"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

banner() {
cat << 'BANNER'
  _____ _ _     _         _____ _  _   
 |_   _(_) |__ (_) __ _  |___  | || |  
   | | | | '_ \| |/ _` |    / /| || |_ 
   | | | | |_) | | (_| |   / / |__   _|
   |_| |_|_.__/|_|\__,_|  /_/     |_|  
  Open Tibia Server — Tibia 7.4
BANNER
}

info()    { echo -e "${CYAN}[tibia]${NC} $1"; }
success() { echo -e "${GREEN}[tibia]${NC} $1"; }
warn()    { echo -e "${YELLOW}[tibia]${NC} $1"; }
error()   { echo -e "${RED}[tibia]${NC} $1"; exit 1; }

# ── Prerequisite check ────────────────────────────────────────────────────────
check_deps() {
    command -v docker >/dev/null 2>&1 || error "Docker is not installed. Install it from https://docs.docker.com/get-docker/"
    docker info >/dev/null 2>&1       || error "Docker daemon is not running. Start Docker and try again."

    # Support both 'docker compose' (v2) and 'docker-compose' (v1)
    if docker compose version >/dev/null 2>&1; then
        DC="docker compose"
    elif command -v docker-compose >/dev/null 2>&1; then
        DC="docker-compose"
    else
        error "Docker Compose is not installed. Install it from https://docs.docker.com/compose/install/"
    fi
    export DC
}

# ── First-time setup ──────────────────────────────────────────────────────────
first_run() {
    banner
    echo ""
    info "First-time setup detected. Building and starting the server..."
    echo ""

    # Create runtime directories
    mkdir -p backups logs

    info "Building Docker images (this takes a few minutes on first run)..."
    $DC build

    info "Starting containers..."
    $DC up -d

    info "Waiting for MySQL to be ready..."
    bash scripts/init-database.sh

    echo ""
    success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    success " Server is UP and ready to play!"
    success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo -e "  ${BOLD}Login Server  :${NC} localhost:7171"
    echo -e "  ${BOLD}Game Server   :${NC} localhost:7172"
    echo -e "  ${BOLD}DB Manager    :${NC} http://localhost:8080"
    echo ""
    echo -e "  ${BOLD}Test Account  :${NC} testaccount"
    echo -e "  ${BOLD}Test Password :${NC} testpassword"
    echo -e "  ${BOLD}Character     :${NC} TestPlayer"
    echo ""
    echo -e "  ${BOLD}Client        :${NC} OTClient v4.0"
    echo -e "  ${BOLD}Download      :${NC} https://github.com/opentibiabr/otclient/releases"
    echo -e "  ${BOLD}Protocol      :${NC} Set to 7.4 in OTClient options"
    echo ""
    echo -e "  ${BOLD}Public IP     :${NC} $(curl -s --max-time 3 ifconfig.me 2>/dev/null || echo 'run: curl ifconfig.me')"
    echo ""
    info "To share with friends, forward ports 7171 and 7172 on your router."
    info "Run './start.sh logs' to watch the server output."
    echo ""
}

# ── Subcommands ───────────────────────────────────────────────────────────────
cmd_start() {
    info "Starting containers..."
    $DC up -d
    success "Server started. Connect to localhost:7171"
}

cmd_stop() {
    info "Stopping containers..."
    $DC down
    success "Server stopped."
}

cmd_restart() {
    info "Restarting containers..."
    $DC restart
    success "Server restarted."
}

cmd_logs() {
    info "Tailing server logs (Ctrl+C to exit)..."
    $DC logs -f tfs
}

cmd_status() {
    $DC ps
}

cmd_backup() {
    bash scripts/backup-and-maintain.sh
}

cmd_reset() {
    warn "This will STOP all containers and DELETE all data (players, accounts, etc.)."
    read -rp "Are you sure? Type YES to confirm: " CONFIRM
    if [ "$CONFIRM" = "YES" ]; then
        $DC down -v
        success "All containers and volumes removed."
    else
        info "Reset cancelled."
    fi
}

# ── Main ──────────────────────────────────────────────────────────────────────
check_deps

CMD="${1:-}"

case "$CMD" in
    start)   cmd_start   ;;
    stop)    cmd_stop    ;;
    restart) cmd_restart ;;
    logs)    cmd_logs    ;;
    status)  cmd_status  ;;
    backup)  cmd_backup  ;;
    reset)   cmd_reset   ;;
    "")
        # No argument: auto-detect first run vs normal start
        if ! $DC ps --services --filter "status=running" 2>/dev/null | grep -q "tfs"; then
            first_run
        else
            info "Server is already running."
            cmd_status
        fi
        ;;
    *)
        echo "Usage: $0 [start|stop|restart|logs|status|backup|reset]"
        exit 1
        ;;
esac
