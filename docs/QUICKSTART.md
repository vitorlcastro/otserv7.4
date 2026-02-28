# Quick Start Guide - Get Your Server Running in 5 Minutes

This guide will get your Tibia 7.4 server running quickly. For detailed information, see the [Deployment Guide](DEPLOYMENT_GUIDE.md).

## Step 1: Install Prerequisites

Ensure Docker and Docker Compose are installed:

```bash
# Check Docker
docker --version

# Check Docker Compose
docker-compose --version
```

If not installed, visit [docker.com](https://docker.com) for installation instructions.

## Step 2: Clone and Navigate

```bash
git clone <repository-url> tibia-server
cd tibia-server
```

## Step 3: Start the Server

```bash
# Build Docker images
docker-compose build

# Start services
docker-compose up -d

# Initialize database
./scripts/init-database.sh
```

## Step 4: Verify Everything is Running

```bash
docker-compose ps
```

You should see three containers running: `tibia-mysql`, `tibia-server`, and `tibia-adminer`.

## Step 5: Connect to Your Server

### Local Connection (Same Network)

Use a Tibia 7.4 client and connect to:
- **Address**: `localhost` or your machine's local IP
- **Port**: `7171`

### Remote Connection (Over Internet)

1. Get your public IP: `curl ifconfig.me`
2. Configure port forwarding on your router (ports 7171 and 7172 to your local machine)
3. Connect using your public IP address

## Test Account

A test account has been created for you:

- **Username**: `testaccount`
- **Password**: `testpassword`
- **Character**: `TestPlayer`

## Managing Your Server

### View Logs

```bash
# Server logs
docker-compose logs -f tfs

# Database logs
docker-compose logs -f mysql
```

### Stop the Server

```bash
docker-compose down
```

### Restart the Server

```bash
docker-compose restart
```

### Backup Your Data

```bash
./scripts/backup-and-maintain.sh
```

## Database Management

Access Adminer (web-based database tool) at `http://localhost:8080`:

- **Server**: `mysql`
- **Username**: `tibia`
- **Password**: `tibia_password`

## Common Issues

| Issue | Solution |
|-------|----------|
| Containers won't start | Run `docker-compose logs` to see errors |
| Can't connect locally | Ensure `docker-compose ps` shows all containers as "Up" |
| Can't connect remotely | Check port forwarding and firewall settings |
| Database errors | Restart MySQL: `docker-compose restart mysql` |

## Next Steps

1. **Configure Rates**: Edit `config/config.lua` to adjust experience, skill, and loot rates
2. **Customize Server**: Edit `config/tibia74.lua` for Tibia 7.4 specific settings
3. **Add Content**: Add custom maps, creatures, and items to the `data/` directory
4. **Set Up Backups**: Schedule regular backups using `crontab -e`
5. **Enable SSL**: Follow the [Deployment Guide](DEPLOYMENT_GUIDE.md) for SSL setup

## Need Help?

- Check the [Deployment Guide](DEPLOYMENT_GUIDE.md) for detailed instructions
- Review server logs: `docker-compose logs`
- Visit [OTLand](https://otland.net/) for community support

Enjoy your Tibia server!
