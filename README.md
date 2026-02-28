# Open Tibia Server - Tibia 7.4 Edition

![Tibia 7.4](https://static.tibia.com/images/global/header/tibia-logo-artwork.png)

This project provides a production-ready open Tibia server that emulates the classic Tibia 7.4 experience. It is built upon **The Forgotten Server (TFS)** and containerized with **Docker** for easy deployment and management. This setup is designed for performance, security, and scalability, making it suitable for hosting a public server for you and your friends.

## Features

- **Tibia 7.4 Gameplay**: Authentic mechanics, including spells, items, creatures, and map data from the classic 7.4 era.
- **The Forgotten Server (TFS) 1.5**: A stable and feature-rich server emulator written in C++.
- **Dockerized Environment**: The entire stack (TFS, MySQL) is containerized for portability and simplified deployment.
- **Production-Ready**: Includes scripts for deployment, backups, maintenance, and security hardening.
- **MySQL Database**: A robust and high-performance database for storing all server data.
- **Public Accessibility**: Configured for public access with port forwarding and firewall setup instructions.
- **Comprehensive Documentation**: Detailed guides for deployment, configuration, and management.

## Prerequisites

Before you begin, ensure you have the following software installed on your host machine:

- **Docker**: [Get Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/)
- **Git**: [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Getting Started

Follow these steps to get your Tibia server up and running:

### 1. Clone the Repository

```bash
git clone <repository-url> tibia-server
cd tibia-server
```

### 2. Run the Deployment Script

This script will build the Docker images, start the services, initialize the database, and configure the firewall.

```bash
./scripts/deploy-production.sh
```

### 3. Configure Port Forwarding

To make your server accessible to the public, you need to configure port forwarding on your router. Forward the following TCP ports to the local IP address of your host machine:

- **7171**: Login Server
- **7172**: Game Server
- **8080**: Adminer (optional, for database management)

### 4. Update DNS Records

If you have a domain name, update your DNS records to point to your public IP address.

### 5. Connect to the Server

Your server is now live! You and your friends can connect using a Tibia 7.4 client. The server address is your public IP or domain name.

## Configuration

The server can be configured through the following files:

- **/config/config.lua**: Main server configuration (rates, connection settings, etc.).
- **/config/tibia74.lua**: Tibia 7.4 specific gameplay settings.
- **/config/security.lua**: Security-related settings.
- **/docker/docker-compose.yml**: Docker container orchestration.

## Management

### Backups and Maintenance

The `backup-and-maintain.sh` script performs regular backups, cleanup, and maintenance tasks. You can run it manually or schedule it as a cron job.

```bash
./scripts/backup-and-maintain.sh
```

### Database Management

You can manage the MySQL database using **Adminer**, a web-based database management tool. Access it at `http://<your-server-ip>:8080`.

- **Server**: `mysql`
- **Username**: `tibia`
- **Password**: `tibia_password`
- **Database**: `tibia`

## Security

This project includes several security features to protect your server:

- **Firewall Configuration**: The deployment script sets up firewall rules to restrict access to necessary ports.
- **Security Hardening**: The `security.lua` file provides a range of security settings for account, IP, chat, and trade restrictions.
- **Regular Backups**: The maintenance script ensures your data is backed up regularly.
- **Containerization**: Docker provides an isolated environment for the server, reducing the risk of system-wide compromises.

## Troubleshooting

- **Connection Issues**: Ensure that your ports are correctly forwarded and that your firewall is not blocking the connection.
- **Server Not Starting**: Check the Docker logs for errors: `docker-compose logs -f tfs`.
- **Database Issues**: Verify that the MySQL container is running and healthy: `docker-compose ps`.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
