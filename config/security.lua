-- Tibia Server Security Configuration
-- Production-ready security settings

-- ============================================================================
-- ACCOUNT SECURITY
-- ============================================================================

-- Password requirements
PASSWORD_MIN_LENGTH = 6
PASSWORD_REQUIRE_UPPERCASE = false
PASSWORD_REQUIRE_NUMBERS = false
PASSWORD_REQUIRE_SPECIAL = false

-- Account lockout settings
MAX_LOGIN_ATTEMPTS = 5
LOGIN_ATTEMPT_TIMEOUT = 15 * 60 * 1000  -- 15 minutes
ACCOUNT_LOCKOUT_DURATION = 30 * 60 * 1000  -- 30 minutes

-- Session management
SESSION_TIMEOUT = 30 * 60 * 1000  -- 30 minutes
MAX_SESSIONS_PER_ACCOUNT = 1
FORCE_LOGOUT_ON_NEW_LOGIN = true

-- ============================================================================
-- IP AND ACCESS CONTROL
-- ============================================================================

-- IP-based restrictions
ENABLE_IP_WHITELIST = false
ENABLE_IP_BLACKLIST = true
MAX_CONNECTIONS_PER_IP = 5

-- DDoS protection
ENABLE_RATE_LIMITING = true
RATE_LIMIT_PACKETS_PER_SECOND = 25
RATE_LIMIT_CONNECTIONS_PER_MINUTE = 10

-- ============================================================================
-- CHAT AND COMMUNICATION SECURITY
-- ============================================================================

-- Chat filtering
ENABLE_CHAT_FILTER = true
ENABLE_PROFANITY_FILTER = true
ENABLE_SPAM_FILTER = true

-- Spam prevention
MAX_MESSAGES_PER_MINUTE = 10
MAX_MESSAGE_LENGTH = 255
CHAT_COOLDOWN_MILLISECONDS = 1000

-- ============================================================================
-- TRADE AND ECONOMY SECURITY
-- ============================================================================

-- Trade restrictions
ENABLE_TRADE_RESTRICTIONS = true
MIN_TRADE_LEVEL = 1
MAX_TRADE_DISTANCE = 3

-- Market security
ENABLE_MARKET_RESTRICTIONS = false
MARKET_TRANSACTION_LOG = true
SUSPICIOUS_TRANSACTION_THRESHOLD = 1000000

-- ============================================================================
-- PLAYER SECURITY
-- ============================================================================

-- Character creation restrictions
ENABLE_CHARACTER_CREATION_RESTRICTIONS = true
MIN_CHARACTER_NAME_LENGTH = 3
MAX_CHARACTER_NAME_LENGTH = 32
CHARACTERS_PER_ACCOUNT = 5

-- Character deletion
CHARACTER_DELETION_DELAY = 7 * 24 * 60 * 60 * 1000  -- 7 days
REQUIRE_PASSWORD_FOR_DELETION = true

-- ============================================================================
-- ANTI-CHEAT MEASURES
-- ============================================================================

-- Movement validation
VALIDATE_MOVEMENT_SPEED = true
MAX_MOVEMENT_SPEED = 300  -- milliseconds between moves
TELEPORT_DETECTION = true

-- Combat validation
VALIDATE_COMBAT_DISTANCE = true
VALIDATE_SPELL_CASTING = true
VALIDATE_ITEM_USAGE = true

-- Inventory security
VALIDATE_INVENTORY_WEIGHT = true
VALIDATE_INVENTORY_SLOTS = true
PREVENT_ITEM_DUPLICATION = true

-- ============================================================================
-- LOGGING AND MONITORING
-- ============================================================================

-- Security logging
ENABLE_SECURITY_LOGGING = true
LOG_FAILED_LOGINS = true
LOG_SUSPICIOUS_ACTIVITY = true
LOG_PLAYER_COMMANDS = true
LOG_TRADE_TRANSACTIONS = true
LOG_ITEM_MOVEMENTS = false  -- Disable for performance

-- Log retention
LOG_RETENTION_DAYS = 90
COMPRESS_OLD_LOGS = true

-- ============================================================================
-- ADMIN AND MODERATOR SECURITY
-- ============================================================================

-- Admin restrictions
REQUIRE_ADMIN_PASSWORD = true
ADMIN_PASSWORD_CHANGE_INTERVAL = 30 * 24 * 60 * 60 * 1000  -- 30 days
LOG_ADMIN_ACTIONS = true

-- Moderator restrictions
ENABLE_MODERATOR_COMMANDS = true
MODERATOR_COMMAND_LOG = true
RESTRICT_MODERATOR_POWERS = true

-- ============================================================================
-- DATABASE SECURITY
-- ============================================================================

-- Database encryption
ENABLE_PASSWORD_ENCRYPTION = true
PASSWORD_ENCRYPTION_METHOD = "sha1"  -- or "bcrypt", "argon2"

-- Backup security
ENABLE_ENCRYPTED_BACKUPS = true
BACKUP_RETENTION_DAYS = 30
BACKUP_VERIFICATION = true

-- ============================================================================
-- NETWORK SECURITY
-- ============================================================================

-- SSL/TLS settings
ENABLE_SSL = false  -- Set to true when certificates are configured
SSL_CERTIFICATE_PATH = "/etc/ssl/certs/tibia-server.crt"
SSL_KEY_PATH = "/etc/ssl/private/tibia-server.key"

-- Packet encryption
ENABLE_PACKET_ENCRYPTION = true
ENCRYPTION_METHOD = "RSA"

-- ============================================================================
-- SECURITY HEADERS AND POLICIES
-- ============================================================================

-- Content Security Policy
ENABLE_CSP = true
CSP_POLICY = "default-src 'self'"

-- X-Frame-Options
ENABLE_X_FRAME_OPTIONS = true
X_FRAME_OPTIONS = "DENY"

-- X-Content-Type-Options
ENABLE_X_CONTENT_TYPE_OPTIONS = true
X_CONTENT_TYPE_OPTIONS = "nosniff"

-- ============================================================================
-- INCIDENT RESPONSE
-- ============================================================================

-- Alert thresholds
ALERT_ON_FAILED_LOGINS = 5
ALERT_ON_SUSPICIOUS_TRADES = 10
ALERT_ON_SPAM_MESSAGES = 20

-- Automatic actions
AUTO_BAN_ON_REPEATED_VIOLATIONS = true
AUTO_BAN_DURATION = 24 * 60 * 60 * 1000  -- 24 hours
AUTO_KICK_ON_SUSPICIOUS_ACTIVITY = true

-- ============================================================================
-- COMPLIANCE AND AUDIT
-- ============================================================================

-- GDPR compliance
ENABLE_GDPR_COMPLIANCE = true
ALLOW_DATA_EXPORT = true
ALLOW_ACCOUNT_DELETION = true
DATA_RETENTION_DAYS = 365

-- Audit logging
ENABLE_AUDIT_LOG = true
AUDIT_LOG_RETENTION_DAYS = 365
AUDIT_LOG_ENCRYPTION = true

-- ============================================================================
-- SECURITY FUNCTIONS
-- ============================================================================

-- Function to check if IP is whitelisted
function isIPWhitelisted(ip)
    if not ENABLE_IP_WHITELIST then
        return true
    end
    
    local whitelist = {
        "127.0.0.1",
        "::1"
    }
    
    for _, whitelistedIP in ipairs(whitelist) do
        if ip == whitelistedIP then
            return true
        end
    end
    
    return false
end

-- Function to check if IP is blacklisted
function isIPBlacklisted(ip)
    if not ENABLE_IP_BLACKLIST then
        return false
    end
    
    local blacklist = {}
    
    for _, blacklistedIP in ipairs(blacklist) do
        if ip == blacklistedIP then
            return true
        end
    end
    
    return false
end

-- Function to validate password strength
function isPasswordStrong(password)
    if #password < PASSWORD_MIN_LENGTH then
        return false
    end
    
    if PASSWORD_REQUIRE_UPPERCASE and not password:match("[A-Z]") then
        return false
    end
    
    if PASSWORD_REQUIRE_NUMBERS and not password:match("[0-9]") then
        return false
    end
    
    if PASSWORD_REQUIRE_SPECIAL and not password:match("[!@#$%^&*]") then
        return false
    end
    
    return true
end

-- Function to check rate limiting
function checkRateLimit(ip, action)
    -- Implementation depends on your rate limiting system
    return true
end

return {
    isIPWhitelisted = isIPWhitelisted,
    isIPBlacklisted = isIPBlacklisted,
    isPasswordStrong = isPasswordStrong,
    checkRateLimit = checkRateLimit
}
