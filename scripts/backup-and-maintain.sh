#!/bin/bash

# Tibia Server Backup and Maintenance Script
# Performs regular backups, cleanup, and maintenance tasks

set -e

# Configuration
BACKUP_DIR="${BACKUP_DIR:-./backups}"
LOG_DIR="${LOG_DIR:-./logs}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"
MYSQL_USER="${MYSQL_USER:-tibia}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-tibia_password}"
MYSQL_DATABASE="${MYSQL_DATABASE:-tibia}"
MYSQL_HOST="${MYSQL_HOST:-mysql}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_DIR/maintenance.log"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_DIR/maintenance.log"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_DIR/maintenance.log"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_DIR/maintenance.log"
}

# Create backup directory
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

# Backup database
backup_database() {
    log_info "Starting database backup..."
    
    BACKUP_FILE="$BACKUP_DIR/tibia_backup_$(date +%Y%m%d_%H%M%S).sql"
    BACKUP_FILE_GZ="${BACKUP_FILE}.gz"
    
    # Backup using docker-compose
    if docker-compose ps mysql &> /dev/null; then
        docker-compose exec -T mysql mysqldump \
            -h "$MYSQL_HOST" \
            -u "$MYSQL_USER" \
            -p"$MYSQL_PASSWORD" \
            "$MYSQL_DATABASE" > "$BACKUP_FILE"
        
        # Compress backup
        gzip "$BACKUP_FILE"
        
        log_success "Database backed up to $BACKUP_FILE_GZ"
        
        # Get file size
        SIZE=$(du -h "$BACKUP_FILE_GZ" | cut -f1)
        log_info "Backup size: $SIZE"
    else
        log_error "MySQL container not running"
        return 1
    fi
}

# Backup configuration files
backup_config() {
    log_info "Backing up configuration files..."
    
    CONFIG_BACKUP="$BACKUP_DIR/config_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    
    tar -czf "$CONFIG_BACKUP" \
        config/ \
        docker/docker-compose.yml \
        docker/Dockerfile.* \
        2>/dev/null || true
    
    log_success "Configuration backed up to $CONFIG_BACKUP"
}

# Backup player data
backup_player_data() {
    log_info "Backing up player data..."
    
    DATA_BACKUP="$BACKUP_DIR/player_data_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    
    if [ -d "data" ]; then
        tar -czf "$DATA_BACKUP" data/ 2>/dev/null || true
        log_success "Player data backed up to $DATA_BACKUP"
    else
        log_warning "Data directory not found"
    fi
}

# Clean old backups
cleanup_old_backups() {
    log_info "Cleaning up old backups (older than $RETENTION_DAYS days)..."
    
    find "$BACKUP_DIR" -type f -mtime +$RETENTION_DAYS -delete
    
    log_success "Old backups cleaned up"
}

# Clean old logs
cleanup_old_logs() {
    log_info "Cleaning up old logs (older than $RETENTION_DAYS days)..."
    
    find "$LOG_DIR" -type f -mtime +$RETENTION_DAYS -delete
    
    log_success "Old logs cleaned up"
}

# Verify database integrity
verify_database() {
    log_info "Verifying database integrity..."
    
    if docker-compose ps mysql &> /dev/null; then
        docker-compose exec -T mysql mysqlcheck \
            -h "$MYSQL_HOST" \
            -u "$MYSQL_USER" \
            -p"$MYSQL_PASSWORD" \
            "$MYSQL_DATABASE" \
            --auto-repair || true
        
        log_success "Database integrity verified"
    else
        log_error "MySQL container not running"
        return 1
    fi
}

# Optimize database
optimize_database() {
    log_info "Optimizing database..."
    
    if docker-compose ps mysql &> /dev/null; then
        docker-compose exec -T mysql mysql \
            -h "$MYSQL_HOST" \
            -u "$MYSQL_USER" \
            -p"$MYSQL_PASSWORD" \
            "$MYSQL_DATABASE" \
            -e "OPTIMIZE TABLE accounts, players, player_items, player_skills, player_spells;" || true
        
        log_success "Database optimized"
    else
        log_error "MySQL container not running"
        return 1
    fi
}

# Check server health
check_server_health() {
    log_info "Checking server health..."
    
    # Check if containers are running
    if docker-compose ps | grep -q "Up"; then
        log_success "All containers are running"
    else
        log_error "Some containers are not running"
        docker-compose ps
        return 1
    fi
    
    # Check disk space
    DISK_USAGE=$(df -h . | awk 'NR==2 {print $5}' | sed 's/%//')
    log_info "Disk usage: ${DISK_USAGE}%"
    
    if [ "$DISK_USAGE" -gt 80 ]; then
        log_warning "Disk usage is above 80%"
    fi
    
    # Check memory usage
    MEMORY_USAGE=$(free | awk 'NR==2 {printf("%.0f", $3/$2 * 100)}')
    log_info "Memory usage: ${MEMORY_USAGE}%"
    
    if [ "$MEMORY_USAGE" -gt 80 ]; then
        log_warning "Memory usage is above 80%"
    fi
}

# Generate maintenance report
generate_report() {
    log_info "Generating maintenance report..."
    
    REPORT_FILE="$LOG_DIR/maintenance_report_$(date +%Y%m%d_%H%M%S).txt"
    
    cat > "$REPORT_FILE" << EOF
Tibia Server Maintenance Report
================================
Date: $(date)
Hostname: $(hostname)

Backup Summary:
$(ls -lh "$BACKUP_DIR" | tail -10)

Disk Usage:
$(df -h)

Memory Usage:
$(free -h)

Docker Containers:
$(docker-compose ps)

Docker Images:
$(docker images | grep tibia)

Recent Logs:
$(tail -20 "$LOG_DIR/maintenance.log")

Server Status:
$(docker-compose logs --tail=20)
EOF
    
    log_success "Maintenance report generated: $REPORT_FILE"
}

# Main maintenance flow
main() {
    log_info "Starting Tibia Server Maintenance"
    
    backup_database
    backup_config
    backup_player_data
    cleanup_old_backups
    cleanup_old_logs
    verify_database
    optimize_database
    check_server_health
    generate_report
    
    log_success "Maintenance completed successfully!"
}

# Run main function
main "$@"
