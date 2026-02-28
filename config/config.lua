-- The Forgotten Server 7.4 - Production Configuration
-- Optimized for Tibia 7.4 gameplay

-- ============================================================================
-- COMBAT SETTINGS
-- ============================================================================
-- World type: "pvp", "no-pvp", or "pvp-enforced"
worldType = "pvp"
protectionLevel = 1
killsToRedSkull = 3
killsToBlackSkull = 6
pzLocked = 60000
removeChargesFromRunes = true
timeToDecreaseFrags = 24 * 60 * 60 * 1000
whiteSkullTime = 15 * 60 * 1000
stairJumpExhaustion = 2000
experienceByKillingPlayers = false
expFromPlayersLevelRange = 75

-- ============================================================================
-- CONNECTION CONFIGURATION
-- ============================================================================
-- Server IP (set to 0.0.0.0 for public access)
ip = "0.0.0.0"
bindOnlyGlobalAddress = false
loginProtocolPort = 7171
gameProtocolPort = 7172
statusProtocolPort = 7171

-- Maximum players (0 = unlimited)
maxPlayers = 0
motd = "Welcome to Tibia 7.4 Server!"
onePlayerOnlinePerAccount = true
allowClones = false
serverName = "Tibia 7.4"
statusTimeout = 5000
replaceKickOnLogin = true
maxPacketsPerSecond = 25

-- ============================================================================
-- DEATH PENALTIES
-- ============================================================================
-- -1 = default formula, 10 = old formula, 0 = no loss
deathLosePercent = -1

-- ============================================================================
-- HOUSES
-- ============================================================================
-- -1 = disable house buying
housePriceEachSQM = 1000
houseRentPeriod = "never"

-- ============================================================================
-- ITEM USAGE
-- ============================================================================
timeBetweenActions = 200
timeBetweenExActions = 1000

-- ============================================================================
-- MAP CONFIGURATION
-- ============================================================================
-- Map name without .otbm extension
mapName = "world"
mapAuthor = "ond"

-- ============================================================================
-- DATABASE CONFIGURATION
-- ============================================================================
-- MySQL connection settings
mysqlHost = os.getenv("TFS_MYSQL_HOST") or "127.0.0.1"
mysqlUser = os.getenv("TFS_MYSQL_USER") or "tibia"
mysqlPass = os.getenv("TFS_MYSQL_PASSWORD") or "tibia_password"
mysqlDatabase = os.getenv("TFS_MYSQL_DATABASE") or "tibia"
mysqlPort = tonumber(os.getenv("TFS_MYSQL_PORT") or "3306")
mysqlSock = ""
passwordType = "sha1"

-- ============================================================================
-- MISCELLANEOUS SETTINGS
-- ============================================================================
allowChangeOutfit = true
freePremium = false
kickIdlePlayerAfterMinutes = 15
maxMessageBuffer = 4
emoteSpells = false
classicEquipmentSlots = false
UHTrap = true
heightStackBlock = true
autoStackItems = false
summonsDropCorpse = true
displayLootMessage = false

-- ============================================================================
-- EXPERIENCE & SKILL RATES
-- ============================================================================
-- Experience rates (not used if stages.xml is enabled)
rateExp = 5
rateSkill = 3
rateLoot = 2
rateMagic = 3
rateSpawn = 1

-- ============================================================================
-- MONSTER SETTINGS
-- ============================================================================
deSpawnRange = 2
deSpawnRadius = 50

-- ============================================================================
-- SCRIPT SETTINGS
-- ============================================================================
warnUnsafeScripts = true
convertUnsafeScripts = true

-- ============================================================================
-- STARTUP SETTINGS
-- ============================================================================
-- defaultPriority: "normal", "above-normal", "high" (Windows only)
defaultPriority = "high"
startupDatabaseOptimization = false

-- ============================================================================
-- STATUS SERVER INFORMATION
-- ============================================================================
ownerName = "Server Owner"
ownerEmail = "admin@tibia-server.local"
url = "https://tibia-server.local/"
location = "World"
