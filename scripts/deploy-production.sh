#!/bin/bash

# Tibia Server Production Deployment Script
# This script deploys the Tibia server to production with security hardening

set -e

# Configuration
DEPLOYMENT_DIR="${DEPLOYMENT_DIR:-.}"
DOCKER_REGISTRY="${DOCKER_REGISTRY:-localhost}"
SERVER_DOMAIN="${SERVER_DOMAIN:-tibia-server.local}"
SERVER_IP="${SERVER_IP:-0.0.0.0}"
BACKUP_DIR="${BACKUP_DIR:-./backups}"
LOG_DIR="${LOG_DIR:-./logs}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose is not installed"
        exit 1
    fi
    
    log_success "All prerequisites met"
}

# Create necessary directories
create_directories() {
    log_info "Creating necessary directories..."
    
    mkdir -p "$BACKUP_DIR"
    mkdir -p "$LOG_DIR"
    mkdir -p ./data
    mkdir -p ./config
    
    log_success "Directories created"
}

# Backup existing database
backup_database() {
    log_info "Backing up existing database..."
    
    BACKUP_FILE="$BACKUP_DIR/tibia_backup_$(date +%Y%m%d_%H%M%S).sql"
    
    if docker-compose ps mysql &> /dev/null; then
        docker-compose exec -T mysql mysqldump -u tibia -ptibia_password tibia > "$BACKUP_FILE"
        log_success "Database backed up to $BACKUP_FILE"
    else
        log_warning "MySQL container not running, skipping backup"
    fi
}

# Build Docker images
build_images() {
    log_info "Building Docker images..."
    
    docker-compose build --no-cache
    
    log_success "Docker images built successfully"
}

# Start services
start_services() {
    log_info "Starting services..."
    
    docker-compose up -d
    
    log_success "Services started"
}

# Wait for services to be healthy
wait_for_services() {
    log_info "Waiting for services to be healthy..."
    
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if docker-compose ps | grep -q "healthy"; then
            log_success "Services are healthy"
            return 0
        fi
        
        echo "Attempt $attempt/$max_attempts - Waiting for services..."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    log_error "Services failed to become healthy"
    return 1
}

# Initialize database
initialize_database() {
    log_info "Initializing database..."
    
    if [ -f "scripts/init-database.sh" ]; then
        bash scripts/init-database.sh
        log_success "Database initialized"
    else
        log_warning "init-database.sh not found, skipping initialization"
    fi
}

# Configure firewall rules
configure_firewall() {
    log_info "Configuring firewall rules..."
    
    if command -v ufw &> /dev/null; then
        log_info "Enabling UFW firewall..."
        sudo ufw default deny incoming
        sudo ufw default allow outgoing
        sudo ufw allow 22/tcp    # SSH
        sudo ufw allow 7171/tcp  # Tibia Login
        sudo ufw allow 7172/tcp  # Tibia Game
        sudo ufw allow 8080/tcp  # Adminer (optional)
        sudo ufw enable
        log_success "Firewall configured"
    elif command -v firewall-cmd &> /dev/null; then
        log_info "Configuring firewalld..."
        sudo firewall-cmd --permanent --add-port=7171/tcp
        sudo firewall-cmd --permanent --add-port=7172/tcp
        sudo firewall-cmd --permanent --add-port=8080/tcp
        sudo firewall-cmd --reload
        log_success "Firewall configured"
    else
        log_warning "No firewall found, skipping firewall configuration"
    fi
}

# Set up SSL/TLS (optional)
setup_ssl() {
    log_info "Setting up SSL/TLS..."
    
    if command -v certbot &> /dev/null; then
        log_info "Certbot found, you can use it to generate certificates"
        log_info "Run: sudo certbot certonly --standalone -d $SERVER_DOMAIN"
    else
        log_warning "Certbot not found, skipping SSL setup"
    fi
}

# Configure monitoring
setup_monitoring() {
    log_info "Setting up monitoring..."
    
    # Create monitoring script
    cat > "$LOG_DIR/monitor.sh" << 'EOF'
#!/bin/bash
# Simple monitoring script
while true; do
    echo "=== Tibia Server Status $(date) ===" >> monitor.log
    docker-compose ps >> monitor.log
    docker stats --no-stream >> monitor.log 2>&1
    sleep 300
done
EOF
    
    chmod +x "$LOG_DIR/monitor.sh"
    log_success "Monitoring script created"
}

# Generate configuration report
generate_report() {
    log_info "Generating configuration report..."
    
    cat > "$LOG_DIR/deployment_report.txt" << EOF
Tibia Server 7.4 - Production Deployment Report
================================================
Date: $(date)
Server Domain: $SERVER_DOMAIN
Server IP: $SERVER_IP
Deployment Directory: $DEPLOYMENT_DIR

Services Status:
$(docker-compose ps)

Docker Images:
$(docker images | grep tibia)

Volumes:
$(docker volume ls | grep tibia)

Network Configuration:
$(docker network ls | grep tibia)

Backup Location: $BACKUP_DIR
Log Directory: $LOG_DIR

Important Ports:
- 7171: Tibia Login Server
- 7172: Tibia Game Server
- 8080: Adminer (Database Management)
- 22: SSH

Next Steps:
1. Configure port forwarding on your router
2. Update DNS records to point to your server IP
3. Configure SSL/TLS certificates
4. Set up automated backups
5. Monitor server performance

For more information, see the documentation.
EOF
    
    log_success "Configuration report generated: $LOG_DIR/deployment_report.txt"
}

# Main deployment flow
main() {
    log_info "Starting Tibia Server Production Deployment"
    
    check_prerequisites
    create_directories
    backup_database
    build_images
    start_services
    wait_for_services
    initialize_database
    configure_firewall
    setup_ssl
    setup_monitoring
    generate_report
    
    log_success "Production deployment completed successfully!"
    log_info "Server is now running and ready for connections"
    log_info "Access Adminer at: http://localhost:8080"
    log_info "Backup location: $BACKUP_DIR"
    log_info "Logs location: $LOG_DIR"
}

# Run main function
main "$@"
