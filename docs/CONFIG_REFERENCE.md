# Configuration Reference

This document describes all configurable options in your Tibia 7.4 server.

## Main Configuration (config/config.lua)

### Combat Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `worldType` | "pvp" | World type: "pvp", "no-pvp", or "pvp-enforced" |
| `protectionLevel` | 1 | Minimum level for PvP protection |
| `killsToRedSkull` | 3 | Kills needed to get a red skull |
| `killsToBlackSkull` | 6 | Kills needed to get a black skull |
| `pzLocked` | 60000 | Protection zone lock time in milliseconds |
| `removeChargesFromRunes` | true | Remove charges from runes when used |
| `timeToDecreaseFrags` | 86400000 | Time to decrease frags (24 hours in ms) |
| `whiteSkullTime` | 900000 | White skull duration (15 minutes in ms) |
| `stairJumpExhaustion` | 2000 | Exhaustion time for stair jumping |
| `experienceByKillingPlayers` | false | Gain experience from killing players |
| `expFromPlayersLevelRange` | 75 | Level range for player experience gain |

### Connection Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `ip` | "0.0.0.0" | Server IP address (0.0.0.0 for public) |
| `bindOnlyGlobalAddress` | false | Bind only to global address |
| `loginProtocolPort` | 7171 | Login server port |
| `gameProtocolPort` | 7172 | Game server port |
| `statusProtocolPort` | 7171 | Status server port |
| `maxPlayers` | 0 | Maximum players (0 = unlimited) |
| `motd` | "Welcome..." | Message of the day |
| `onePlayerOnlinePerAccount` | true | Only one character per account online |
| `allowClones` | false | Allow multiple same-name characters |
| `serverName` | "Forgotten" | Server name |
| `statusTimeout` | 5000 | Status server timeout |
| `replaceKickOnLogin` | true | Kick existing session on new login |
| `maxPacketsPerSecond` | 25 | Max packets per second per player |

### Death Penalties

| Setting | Default | Description |
|---------|---------|-------------|
| `deathLosePercent` | -1 | Death penalty: -1 (formula), 0 (none), 10 (old formula) |

### House Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `housePriceEachSQM` | 1000 | House price per square meter (-1 to disable) |
| `houseRentPeriod` | "never" | House rent period |

### Item Usage

| Setting | Default | Description |
|---------|---------|-------------|
| `timeBetweenActions` | 200 | Time between actions (ms) |
| `timeBetweenExActions` | 1000 | Time between ex actions (ms) |

### Map Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| `mapName` | "world" | Map name (without .otbm extension) |
| `mapAuthor` | "ond" | Map author |

### Database Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| `mysqlHost` | "127.0.0.1" | MySQL host address |
| `mysqlUser` | "tibia" | MySQL username |
| `mysqlPass` | "tibia_password" | MySQL password |
| `mysqlDatabase` | "tibia" | MySQL database name |
| `mysqlPort` | 3306 | MySQL port |
| `mysqlSock` | "" | MySQL socket (leave empty for TCP) |
| `passwordType` | "sha1" | Password encryption: "sha1", "bcrypt", "argon2" |

### Miscellaneous Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `allowChangeOutfit` | true | Allow players to change outfit |
| `freePremium` | false | Give all players premium |
| `kickIdlePlayerAfterMinutes` | 15 | Kick idle players after N minutes |
| `maxMessageBuffer` | 4 | Maximum message buffer size |
| `emoteSpells` | false | Use emotes for spells |
| `classicEquipmentSlots` | false | Use classic equipment slots |
| `UHTrap` | true | Enable UH trap |
| `heightStackBlock` | true | Can walk over 2 items with height |
| `autoStackItems` | false | Auto-stack items |
| `summonsDropCorpse` | true | Summons drop corpse |
| `displayLootMessage` | false | Display loot messages |

### Experience & Skill Rates

| Setting | Default | Description |
|---------|---------|-------------|
| `rateExp` | 5 | Experience rate multiplier |
| `rateSkill` | 3 | Skill rate multiplier |
| `rateLoot` | 2 | Loot rate multiplier |
| `rateMagic` | 3 | Magic level rate multiplier |
| `rateSpawn` | 1 | Spawn rate multiplier |

### Monster Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `deSpawnRange` | 2 | Despawn range |
| `deSpawnRadius` | 50 | Despawn radius |

### Script Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `warnUnsafeScripts` | true | Warn about unsafe scripts |
| `convertUnsafeScripts` | true | Convert unsafe scripts |

### Startup Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `defaultPriority` | "high" | Process priority (Windows only) |
| `startupDatabaseOptimization` | false | Optimize database on startup |

### Status Server Information

| Setting | Default | Description |
|---------|---------|-------------|
| `ownerName` | "Server Owner" | Server owner name |
| `ownerEmail` | "admin@tibia-server.local" | Server owner email |
| `url` | "https://tibia-server.local/" | Server website URL |
| `location` | "World" | Server location |

## Tibia 7.4 Configuration (config/tibia74.lua)

### Vocations

The game supports four vocations:

- **SORCERER** (1): Magic-focused, ranged damage
- **DRUID** (2): Healing and support, ranged damage
- **PALADIN** (3): Balanced damage and defense, ranged attacks
- **KNIGHT** (4): Melee combat, heavy armor

### Spells

Spells have level and magic level requirements. Examples:

| Spell | Min Level | Min Magic Level | Vocation |
|-------|-----------|-----------------|----------|
| Magic Missile | 4 | 0 | Sorcerer |
| Light | 1 | 0 | All |
| Fireball | 27 | 4 | Sorcerer |
| Heal Friend | 8 | 1 | Druid |
| Holy Missile | 4 | 0 | Paladin |
| Berserk | 7 | 0 | Knight |

### Skills

Seven skills are available:

| Skill | Description |
|-------|-------------|
| Fist | Unarmed combat |
| Club | Club weapons |
| Sword | Sword weapons |
| Axe | Axe weapons |
| Distance | Ranged weapons |
| Shielding | Shield defense |
| Fishing | Fishing |

### Experience Formula

Experience required for each level is calculated as:

```
Level 1-8: 50 * level
Level 9+: 50 * level + (level - 8) * 100 * (level - 8)
```

## Security Configuration (config/security.lua)

### Account Security

| Setting | Default | Description |
|---------|---------|-------------|
| `PASSWORD_MIN_LENGTH` | 6 | Minimum password length |
| `MAX_LOGIN_ATTEMPTS` | 5 | Failed login attempts before lockout |
| `LOGIN_ATTEMPT_TIMEOUT` | 900000 | Timeout for login attempts (ms) |
| `ACCOUNT_LOCKOUT_DURATION` | 1800000 | Account lockout duration (ms) |
| `SESSION_TIMEOUT` | 1800000 | Session timeout (ms) |
| `MAX_SESSIONS_PER_ACCOUNT` | 1 | Max concurrent sessions |

### IP and Access Control

| Setting | Default | Description |
|---------|---------|-------------|
| `ENABLE_IP_WHITELIST` | false | Enable IP whitelist |
| `ENABLE_IP_BLACKLIST` | true | Enable IP blacklist |
| `MAX_CONNECTIONS_PER_IP` | 5 | Max connections per IP |
| `ENABLE_RATE_LIMITING` | true | Enable rate limiting |
| `RATE_LIMIT_PACKETS_PER_SECOND` | 25 | Max packets per second |

### Chat Security

| Setting | Default | Description |
|---------|---------|-------------|
| `ENABLE_CHAT_FILTER` | true | Enable chat filtering |
| `ENABLE_PROFANITY_FILTER` | true | Enable profanity filter |
| `ENABLE_SPAM_FILTER` | true | Enable spam filter |
| `MAX_MESSAGES_PER_MINUTE` | 10 | Max messages per minute |
| `MAX_MESSAGE_LENGTH` | 255 | Max message length |

### Anti-Cheat Measures

| Setting | Default | Description |
|---------|---------|-------------|
| `VALIDATE_MOVEMENT_SPEED` | true | Validate movement speed |
| `VALIDATE_COMBAT_DISTANCE` | true | Validate combat distance |
| `VALIDATE_SPELL_CASTING` | true | Validate spell casting |
| `PREVENT_ITEM_DUPLICATION` | true | Prevent item duplication |

## Docker Configuration (docker/docker-compose.yml)

The Docker Compose file defines three services:

### MySQL Service

- **Image**: `mysql:8.0`
- **Port**: `3306`
- **Volume**: `mysql_data` (persistent storage)
- **Environment**: Database name, user, password

### TFS Service

- **Build**: From `Dockerfile.tfs`
- **Port**: `7171` (login), `7172` (game)
- **Depends On**: MySQL
- **Volume**: Configuration, data, logs

### Adminer Service

- **Image**: `adminer:latest`
- **Port**: `8080`
- **Purpose**: Web-based database management

## Modifying Configuration

### During Runtime

To modify configuration while the server is running:

1. Edit the configuration file
2. Restart the server: `docker-compose restart tfs`

### Before Deployment

Edit configuration files before running `docker-compose up`:

```bash
# Edit main config
nano config/config.lua

# Edit Tibia 7.4 config
nano config/tibia74.lua

# Edit security config
nano config/security.lua

# Start server
docker-compose up -d
```

## Common Configuration Scenarios

### High Experience Rate Server

```lua
rateExp = 20
rateSkill = 10
rateLoot = 5
rateMagic = 10
```

### Hardcore PvP Server

```lua
worldType = "pvp-enforced"
protectionLevel = 0
killsToRedSkull = 1
experienceByKillingPlayers = true
```

### Casual No-PvP Server

```lua
worldType = "no-pvp"
freePremium = true
rateExp = 10
rateSkill = 5
```

### High Population Server

```lua
maxPlayers = 500
maxPacketsPerSecond = 50
RATE_LIMIT_CONNECTIONS_PER_MINUTE = 20
```

For more information, see the [Deployment Guide](DEPLOYMENT_GUIDE.md).
