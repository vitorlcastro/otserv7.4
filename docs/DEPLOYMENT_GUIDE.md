# Tibia Server 7.4 - Complete Deployment Guide

This guide provides step-by-step instructions for deploying your Tibia 7.4 server to production, making it accessible to your friends over the internet.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Setup](#local-setup)
3. [Docker Configuration](#docker-configuration)
4. [Network Configuration](#network-configuration)
5. [Production Deployment](#production-deployment)
6. [Firewall Setup](#firewall-setup)
7. [SSL/TLS Configuration](#ssltls-configuration)
8. [Monitoring and Maintenance](#monitoring-and-maintenance)
9. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure your system meets the following requirements:

| Component | Requirement | Notes |
|-----------|-------------|-------|
| OS | Ubuntu 20.04 LTS or later | Other Linux distributions work similarly |
| CPU | 2+ cores | 4+ cores recommended for 50+ players |
| RAM | 4GB minimum | 8GB+ recommended for optimal performance |
| Storage | 20GB minimum | SSD recommended for better performance |
| Internet | Stable connection | Minimum 10 Mbps upload/download |
| Docker | Latest version | See [Docker Installation](https://docs.docker.com/get-docker/) |
| Docker Compose | 1.29+ | See [Docker Compose Installation](https://docs.docker.com/compose/install/) |

## Local Setup

### Step 1: Clone the Repository

```bash
git clone <repository-url> tibia-server
cd tibia-server
```

### Step 2: Verify Directory Structure

Ensure the project has the following structure:

```
tibia-server/
├── config/
│   ├── config.lua
│   ├── tibia74.lua
│   └── security.lua
├── docker/
│   ├── docker-compose.yml
│   ├── Dockerfile.tfs
│   ├── Dockerfile.mysql
│   └── mysql.cnf
├── scripts/
│   ├── deploy-production.sh
│   ├── init-database.sh
│   └── backup-and-maintain.sh
├── src/
│   └── tfs/
│       ├── config.lua
│       ├── schema.sql
│       ├── server/
│       └── src/
├── data/
├── logs/
├── docs/
└── README.md
```

### Step 3: Set Environment Variables

Create a `.env` file in the project root with the following variables:

```bash
# MySQL Configuration
MYSQL_ROOT_PASSWORD=tibia_root_password
MYSQL_USER=tibia
MYSQL_PASSWORD=tibia_password
MYSQL_DATABASE=tibia
MYSQL_HOST=mysql
MYSQL_PORT=3306

# Server Configuration
SERVER_DOMAIN=tibia-server.local
SERVER_IP=0.0.0.0
BACKUP_DIR=./backups
LOG_DIR=./logs
RETENTION_DAYS=30

# Docker Configuration
DOCKER_REGISTRY=localhost
COMPOSE_PROJECT_NAME=tibia
```

## Docker Configuration

### Understanding the Docker Compose Stack

The `docker-compose.yml` file defines three services:

1. **MySQL Database**: Stores all server data (accounts, players, items, etc.).
2. **TFS Server**: The Tibia game server emulator.
3. **Adminer**: A web-based database management tool (optional).

### Building the Docker Images

```bash
docker-compose build --no-cache
```

This command compiles the TFS server from source and prepares the MySQL container.

### Starting the Services

```bash
docker-compose up -d
```

The `-d` flag runs the services in detached mode (background).

### Checking Service Status

```bash
docker-compose ps
```

You should see output similar to:

```
NAME                COMMAND                  SERVICE             STATUS              PORTS
tibia-mysql         "docker-entrypoint.s…"   mysql               Up 2 minutes        0.0.0.0:3306->3306/tcp
tibia-server        "./theforgottenserver"   tfs                 Up 1 minute         0.0.0.0:7171->7171/tcp, 0.0.0.0:7172->7172/tcp
tibia-adminer       "entrypoint.sh php -s…"  adminer             Up 1 minute         0.0.0.0:8080->8080/tcp
```

## Network Configuration

### Understanding Port Forwarding

Your server runs on ports 7171 (login) and 7172 (game). To make it accessible from the internet, you need to forward these ports from your router to your local machine.

### Router Port Forwarding Setup

1. Access your router's admin panel (typically at `192.168.1.1` or `192.168.0.1`).
2. Navigate to the Port Forwarding section.
3. Create two port forwarding rules:

| External Port | Internal IP | Internal Port | Protocol |
|---------------|------------|---------------|----------|
| 7171 | 192.168.x.x | 7171 | TCP |
| 7172 | 192.168.x.x | 7172 | TCP |

Replace `192.168.x.x` with your local machine's IP address.

### Finding Your Public IP

To find your public IP address, use:

```bash
curl ifconfig.me
```

Your server address will be: `<your-public-ip>:7171` (for login).

## Production Deployment

### Running the Deployment Script

The `deploy-production.sh` script automates the entire deployment process:

```bash
./scripts/deploy-production.sh
```

This script performs the following tasks:

1. Checks prerequisites (Docker, Docker Compose).
2. Creates necessary directories.
3. Backs up existing data (if any).
4. Builds Docker images.
5. Starts services.
6. Initializes the database.
7. Configures firewall rules.
8. Sets up monitoring.
9. Generates a deployment report.

### Manual Deployment Steps

If you prefer to deploy manually:

```bash
# 1. Create directories
mkdir -p backups logs data

# 2. Build images
docker-compose build

# 3. Start services
docker-compose up -d

# 4. Initialize database
./scripts/init-database.sh

# 5. Check status
docker-compose ps
```

## Firewall Setup

### UFW (Ubuntu Firewall)

If you're using UFW, the deployment script will configure it automatically. To do it manually:

```bash
# Enable UFW
sudo ufw enable

# Allow SSH (important!)
sudo ufw allow 22/tcp

# Allow Tibia ports
sudo ufw allow 7171/tcp
sudo ufw allow 7172/tcp

# Allow Adminer (optional)
sudo ufw allow 8080/tcp

# Check status
sudo ufw status
```

### Firewalld (CentOS/RHEL)

```bash
# Add ports
sudo firewall-cmd --permanent --add-port=7171/tcp
sudo firewall-cmd --permanent --add-port=7172/tcp
sudo firewall-cmd --permanent --add-port=8080/tcp

# Reload firewall
sudo firewall-cmd --reload

# Check status
sudo firewall-cmd --list-ports
```

## SSL/TLS Configuration

### Obtaining an SSL Certificate

To secure your server with HTTPS for the web interface, obtain an SSL certificate using Let's Encrypt:

```bash
# Install Certbot
sudo apt-get install certbot python3-certbot-nginx

# Generate certificate
sudo certbot certonly --standalone -d your-domain.com

# Certificates are stored in /etc/letsencrypt/live/your-domain.com/
```

### Configuring SSL in Docker

Update the `docker-compose.yml` to mount the certificate:

```yaml
volumes:
  - /etc/letsencrypt/live/your-domain.com/fullchain.pem:/app/certs/cert.pem:ro
  - /etc/letsencrypt/live/your-domain.com/privkey.pem:/app/certs/key.pem:ro
```

## Monitoring and Maintenance

### Running Backups

Create a backup of your database and configuration:

```bash
./scripts/backup-and-maintain.sh
```

### Scheduling Regular Backups

Add a cron job to run backups daily:

```bash
# Edit crontab
crontab -e

# Add this line to run backups at 2 AM daily
0 2 * * * /home/ubuntu/tibia-server/scripts/backup-and-maintain.sh
```

### Checking Server Logs

View real-time server logs:

```bash
docker-compose logs -f tfs
```

View MySQL logs:

```bash
docker-compose logs -f mysql
```

### Database Management

Access Adminer at `http://localhost:8080`:

- **Server**: `mysql`
- **Username**: `tibia`
- **Password**: `tibia_password`
- **Database**: `tibia`

## Troubleshooting

### Server Won't Start

**Symptom**: `docker-compose up -d` fails or containers exit immediately.

**Solution**:

```bash
# Check logs
docker-compose logs tfs
docker-compose logs mysql

# Rebuild images
docker-compose build --no-cache

# Restart services
docker-compose down
docker-compose up -d
```

### Connection Issues

**Symptom**: Cannot connect to the server from a remote machine.

**Solution**:

1. Verify port forwarding is configured correctly.
2. Check firewall rules: `sudo ufw status`.
3. Verify server is running: `docker-compose ps`.
4. Test connectivity: `telnet <your-public-ip> 7171`.

### Database Connection Errors

**Symptom**: Server logs show "MySQL connection failed".

**Solution**:

```bash
# Check MySQL status
docker-compose ps mysql

# Restart MySQL
docker-compose restart mysql

# Check MySQL logs
docker-compose logs mysql
```

### High Memory Usage

**Symptom**: Server uses excessive memory.

**Solution**:

1. Increase container memory limits in `docker-compose.yml`.
2. Optimize database queries.
3. Reduce spawn rates in `config.lua`.

### Slow Performance

**Symptom**: Server is slow or laggy.

**Solution**:

1. Check CPU usage: `docker stats`.
2. Check disk I/O: `iostat -x 1`.
3. Optimize MySQL: `./scripts/backup-and-maintain.sh`.
4. Reduce player count or spawn rates.

## Next Steps

1. **Customize Configuration**: Edit `config/config.lua` to adjust rates, world type, and other settings.
2. **Add Content**: Add custom maps, items, creatures, and quests to the `data/` directory.
3. **Set Up Monitoring**: Configure external monitoring tools like Prometheus and Grafana.
4. **Enable SSL**: Secure your web interface with SSL/TLS certificates.
5. **Create Backups**: Set up automated daily backups.

For more information, see the [README.md](../README.md) and configuration files.
