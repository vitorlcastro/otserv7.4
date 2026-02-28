# Tibia 7.4 Open Server

A production-ready Tibia 7.4 server powered by [The Forgotten Server (TFS) 1.5](https://github.com/mattyx14/theforgottenserver-7.4), fully containerised with Docker and MySQL. Clone, run one command, and play.

---

## Requirements

| Tool | Minimum Version | Install |
|---|---|---|
| **Docker** | 20.x | https://docs.docker.com/get-docker/ |
| **Docker Compose** | v2 (plugin) or v1 | https://docs.docker.com/compose/install/ |
| **Git** | any | https://git-scm.com/ |

No other dependencies are needed. The server compiles and runs entirely inside Docker.

---

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/vitorlcastro/otserv7.4.git
cd otserv7.4

# 2. Start everything (builds images, starts containers, seeds the database)
./start.sh
```

That is it. The first run takes a few minutes to compile TFS from source. Subsequent starts are instant.

---

## Connecting with a Client

Download **OTClient v4.0** (free, open-source, cross-platform):

> https://github.com/opentibiabr/otclient/releases/tag/4.0

Open OTClient → **Options → Game** → set Protocol to **7.4** → connect to `localhost:7171`.

**Test credentials:**

| Field | Value |
|---|---|
| Username | `testaccount` |
| Password | `testpassword` |
| Character | `TestPlayer` |

---

## Playing with Friends (Public Server)

1. Find your public IP: `curl ifconfig.me`
2. On your router, forward **TCP ports 7171 and 7172** to your machine.
3. Share your public IP with friends.
4. Friends open OTClient, set protocol 7.4, and connect to your IP.

---

## Server Management

All commands are run from the repo root:

```bash
./start.sh              # First-time setup OR start if stopped
./start.sh start        # Start containers
./start.sh stop         # Stop containers
./start.sh restart      # Restart containers
./start.sh logs         # Tail live server logs
./start.sh status       # Show container status
./start.sh backup       # Create a database backup
./start.sh reset        # Wipe all data and volumes (DESTRUCTIVE)
```

---

## Configuration

All settings live in the `.env` file at the repo root. Edit it before the first run, or restart after changes:

```dotenv
# Rates
RATE_EXP=5
RATE_SKILL=3
RATE_LOOT=2
RATE_MAGIC=3

# World
WORLD_TYPE=pvp          # pvp | no-pvp | pvp-enforced
SERVER_NAME=Tibia 7.4
MOTD=Welcome to Tibia 7.4!

# Database credentials
MYSQL_ROOT_PASSWORD=tibia_root_password
MYSQL_PASSWORD=tibia_password
```

See `docs/CONFIG_REFERENCE.md` for the full list of options.

---

## Database Manager

Adminer (web-based database UI) is available at:

> http://localhost:8080

| Field | Value |
|---|---|
| Server | `mysql` |
| Username | `tibia` |
| Password | `tibia_password` |
| Database | `tibia` |

---

## Project Structure

```
otserv7.4/
├── start.sh                  ← single entry point
├── docker-compose.yml        ← container orchestration (run from here)
├── .env                      ← all configurable settings
│
├── docker/
│   ├── Dockerfile.tfs        ← compiles TFS from source
│   ├── entrypoint.sh         ← generates config.lua at runtime
│   └── mysql.cnf             ← MySQL tuning
│
├── scripts/
│   ├── init-database.sh      ← seeds test account/character
│   └── backup-and-maintain.sh
│
├── src/tfs/                  ← The Forgotten Server source
│   ├── src/                  ← C++ source code
│   ├── server/               ← game data (map, monsters, spells)
│   └── schema.sql            ← database schema
│
└── docs/                     ← detailed guides
    ├── QUICKSTART.md
    ├── DEPLOYMENT_GUIDE.md
    ├── CONFIG_REFERENCE.md
    └── CLIENT_SETUP_GUIDE.md
```

---

## Troubleshooting

**Server won't start**
```bash
./start.sh logs          # view TFS output
docker compose logs mysql  # view MySQL output
```

**Can't connect from client**
- Verify the server is running: `./start.sh status`
- Ensure OTClient protocol is set to **7.4**
- Check that no firewall is blocking port 7171

**Database error on first run**
```bash
./start.sh stop
./start.sh reset         # wipes volumes
./start.sh               # fresh start
```

---

## License

- **This project**: MIT License
- **The Forgotten Server**: GNU GPL v2.0
- **MySQL**: GNU GPL v2.0
- **OTClient**: MIT License
