# Tibia Server 7.4 - Project Summary

## Overview

This project provides a **production-ready, open-source Tibia 7.4 server** that you can deploy and run from your own host machine. It is built on **The Forgotten Server (TFS)** framework and containerized with **Docker** for easy deployment, management, and scaling.

## What You Have

### Core Components

1. **The Forgotten Server (TFS) 1.5**
   - C++ based MMORPG server emulator
   - Tibia 7.4 compatible
   - Located in `src/tfs/`
   - Includes complete source code, schema, and configuration

2. **MySQL 8.0 Database**
   - Stores all server data (accounts, players, items, etc.)
   - Optimized configuration for game server workloads
   - Automatic backup and maintenance scripts

3. **Docker Containerization**
   - Multi-stage build for TFS compilation
   - Docker Compose for orchestration
   - Easy deployment on any Linux system
   - Isolated environments for security

4. **Production Deployment Scripts**
   - Automated deployment with `deploy-production.sh`
   - Database initialization with `init-database.sh`
   - Backup and maintenance with `backup-and-maintain.sh`
   - Firewall configuration and monitoring setup

5. **Comprehensive Documentation**
   - Quick Start Guide (`docs/QUICKSTART.md`)
   - Detailed Deployment Guide (`docs/DEPLOYMENT_GUIDE.md`)
   - Configuration Reference (`docs/CONFIG_REFERENCE.md`)
   - This project summary

### Project Structure

```
tibia-server/
├── config/                      # Server configuration files
│   ├── config.lua              # Main server config (rates, ports, etc.)
│   ├── tibia74.lua             # Tibia 7.4 specific settings
│   └── security.lua            # Security configurations
│
├── docker/                      # Docker configuration
│   ├── Dockerfile.tfs          # TFS server container
│   ├── Dockerfile.mysql        # MySQL database container
│   ├── docker-compose.yml      # Container orchestration
│   └── mysql.cnf               # MySQL optimization
│
├── scripts/                     # Deployment and maintenance scripts
│   ├── deploy-production.sh    # Full production deployment
│   ├── init-database.sh        # Database initialization
│   └── backup-and-maintain.sh  # Backups and maintenance
│
├── src/                         # Source code
│   └── tfs/                    # The Forgotten Server source
│       ├── src/                # C++ source code
│       ├── server/             # Game data (maps, creatures, etc.)
│       ├── config.lua          # Default configuration
│       ├── schema.sql          # Database schema
│       └── CMakeLists.txt      # Build configuration
│
├── data/                        # Game data directory (populated at runtime)
├── logs/                        # Server logs
├── backups/                     # Database backups
│
├── docs/                        # Documentation
│   ├── QUICKSTART.md           # 5-minute setup guide
│   ├── DEPLOYMENT_GUIDE.md     # Detailed deployment instructions
│   └── CONFIG_REFERENCE.md     # Configuration options
│
├── README.md                    # Project overview
├── LICENSE                      # MIT License
├── .gitignore                   # Git ignore rules
└── PROJECT_SUMMARY.md           # This file
```

## Features

### Server Features

- **Tibia 7.4 Gameplay**: Authentic mechanics including spells, items, creatures, and world
- **Four Vocations**: Sorcerer, Druid, Paladin, Knight with unique abilities
- **PvP System**: Red skulls, black skulls, and protection zones
- **Experience System**: Level-based progression with configurable rates
- **Skill System**: Seven skills (Fist, Club, Sword, Axe, Distance, Shielding, Fishing)
- **Magic System**: Spells with level and magic level requirements
- **Houses**: Player-owned houses with rent system
- **Trade System**: Player-to-player trading with restrictions
- **Creatures**: Monsters with AI, loot, and respawning

### Deployment Features

- **Docker Containerization**: Portable, isolated, and scalable
- **Automated Deployment**: One-command setup with `deploy-production.sh`
- **Database Management**: Web-based Adminer interface at `http://localhost:8080`
- **Backup & Restore**: Automated daily backups with retention policies
- **Firewall Configuration**: Automatic UFW/firewalld setup
- **Monitoring**: Health checks and performance monitoring
- **SSL/TLS Ready**: Support for HTTPS with Let's Encrypt

### Security Features

- **Account Security**: Password requirements, login attempt limiting, session management
- **IP Controls**: Whitelist/blacklist, rate limiting, DDoS protection
- **Chat Filtering**: Profanity filter, spam prevention
- **Anti-Cheat**: Movement validation, combat distance checking, item duplication prevention
- **Logging**: Comprehensive security and audit logging
- **GDPR Compliance**: Data export and deletion capabilities

## Getting Started

### Minimum Requirements

| Component | Requirement |
|-----------|-------------|
| OS | Ubuntu 20.04 LTS or later |
| CPU | 2+ cores (4+ recommended) |
| RAM | 4GB minimum (8GB+ recommended) |
| Storage | 20GB minimum (SSD recommended) |
| Internet | Stable connection (10+ Mbps) |
| Docker | Latest version |
| Docker Compose | 1.29+ |

### Quick Start (5 Minutes)

```bash
# 1. Clone and navigate
git clone <repository-url> tibia-server
cd tibia-server

# 2. Build and start
docker-compose build
docker-compose up -d

# 3. Initialize database
./scripts/init-database.sh

# 4. Verify
docker-compose ps

# 5. Connect
# Use a Tibia 7.4 client to connect to localhost:7171
# Test account: testaccount / testpassword
```

### Production Deployment

```bash
# Run the automated deployment script
./scripts/deploy-production.sh

# This script will:
# - Build Docker images
# - Start all services
# - Initialize the database
# - Configure firewall rules
# - Set up monitoring
# - Generate a deployment report
```

## Configuration

### Key Configuration Files

1. **config/config.lua**: Main server settings
   - Experience, skill, and loot rates
   - Connection ports and limits
   - PvP settings
   - Database credentials

2. **config/tibia74.lua**: Tibia 7.4 specific settings
   - Vocations and spells
   - Starting equipment and spells
   - Towns and spawn points
   - Experience formula

3. **config/security.lua**: Security settings
   - Account and IP restrictions
   - Chat filtering
   - Anti-cheat measures
   - Logging and monitoring

### Common Configuration Scenarios

**High Experience Server**:
```lua
rateExp = 20
rateSkill = 10
rateLoot = 5
```

**Hardcore PvP**:
```lua
worldType = "pvp-enforced"
protectionLevel = 0
killsToRedSkull = 1
```

**Casual No-PvP**:
```lua
worldType = "no-pvp"
freePremium = true
rateExp = 10
```

## Managing Your Server

### Daily Operations

```bash
# View server status
docker-compose ps

# View server logs
docker-compose logs -f tfs

# Restart server
docker-compose restart tfs

# Stop server
docker-compose down

# Start server
docker-compose up -d
```

### Maintenance

```bash
# Run backups and maintenance
./scripts/backup-and-maintain.sh

# Schedule daily backups (add to crontab)
crontab -e
# Add: 0 2 * * * /home/ubuntu/tibia-server/scripts/backup-and-maintain.sh
```

### Database Management

Access Adminer at `http://localhost:8080`:
- Server: `mysql`
- Username: `tibia`
- Password: `tibia_password`
- Database: `tibia`

## Network Configuration

### Local Connection

Connect using a Tibia 7.4 client:
- Address: `localhost` or your machine's local IP
- Port: `7171`

### Remote Connection (Public Server)

1. Get your public IP: `curl ifconfig.me`
2. Configure port forwarding on your router:
   - Forward port 7171 → your-local-ip:7171
   - Forward port 7172 → your-local-ip:7172
3. Connect using your public IP address

### Firewall Setup

The deployment script configures UFW automatically:
```bash
# Manual firewall setup
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 7171/tcp  # Tibia Login
sudo ufw allow 7172/tcp  # Tibia Game
sudo ufw enable
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Containers won't start | Check logs: `docker-compose logs` |
| Can't connect locally | Ensure containers are running: `docker-compose ps` |
| Can't connect remotely | Verify port forwarding and firewall settings |
| Database errors | Restart MySQL: `docker-compose restart mysql` |
| High memory usage | Reduce spawn rates or player limits in config |
| Slow performance | Optimize database: `./scripts/backup-and-maintain.sh` |

## Documentation

- **README.md**: Project overview and features
- **docs/QUICKSTART.md**: 5-minute setup guide
- **docs/DEPLOYMENT_GUIDE.md**: Detailed deployment instructions
- **docs/CONFIG_REFERENCE.md**: Complete configuration reference

## Support and Community

- **OTLand Forum**: https://otland.net/ - Community support and resources
- **GitHub Issues**: Report bugs and request features
- **Documentation**: Check the docs/ directory for detailed guides

## Next Steps

1. **Deploy Your Server**: Run `./scripts/deploy-production.sh`
2. **Configure Settings**: Edit `config/config.lua` to customize rates and gameplay
3. **Add Content**: Add custom maps, creatures, and items to `data/`
4. **Set Up Backups**: Schedule daily backups using crontab
5. **Enable SSL**: Configure SSL/TLS for secure connections
6. **Invite Friends**: Share your server IP with friends to play together

## License

This project is licensed under the **MIT License**. See the LICENSE file for details.

The Forgotten Server is licensed under the **GNU General Public License v2.0**.

## Credits

- **The Forgotten Server (TFS)**: Community-driven MMORPG server emulator
- **OTLand Community**: Resources, support, and collaboration
- **Docker**: Containerization and deployment platform
- **MySQL**: Database management system

## Project Information

- **Created**: February 2026
- **Version**: 1.0.0
- **Status**: Production Ready
- **Tibia Version**: 7.4
- **TFS Version**: 1.5

---

**Ready to launch your Tibia server?** Start with the [Quick Start Guide](docs/QUICKSTART.md) or run `./scripts/deploy-production.sh` for full production deployment!
