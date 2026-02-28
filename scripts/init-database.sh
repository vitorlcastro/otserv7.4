#!/bin/bash

# Tibia Server Database Initialization Script
# This script initializes the MySQL database with the Tibia 7.4 schema

set -e

# Configuration
MYSQL_HOST="${MYSQL_HOST:-localhost}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-tibia}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-tibia_password}"
MYSQL_DATABASE="${MYSQL_DATABASE:-tibia}"
MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-tibia_root_password}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Tibia Server Database Initialization...${NC}"

# Wait for MySQL to be ready
echo -e "${YELLOW}Waiting for MySQL to be ready...${NC}"
for i in {1..30}; do
    if mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" &> /dev/null; then
        echo -e "${GREEN}MySQL is ready!${NC}"
        break
    fi
    echo "Attempt $i/30 - MySQL not ready yet, waiting..."
    sleep 2
done

# Check if database exists
echo -e "${YELLOW}Checking if database exists...${NC}"
if mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE $MYSQL_DATABASE" 2>/dev/null; then
    echo -e "${GREEN}Database $MYSQL_DATABASE already exists${NC}"
else
    echo -e "${YELLOW}Creating database $MYSQL_DATABASE...${NC}"
    mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    echo -e "${GREEN}Database created successfully${NC}"
fi

# Import schema
echo -e "${YELLOW}Importing schema...${NC}"
if [ -f "src/tfs/schema.sql" ]; then
    mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < src/tfs/schema.sql
    echo -e "${GREEN}Schema imported successfully${NC}"
else
    echo -e "${RED}schema.sql not found!${NC}"
    exit 1
fi

# Create test account
echo -e "${YELLOW}Creating test account...${NC}"
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" << EOF
INSERT INTO accounts (name, password, type, premdays, email, creation) 
VALUES ('testaccount', SHA1('testpassword'), 1, 0, 'test@tibia.local', UNIX_TIMESTAMP())
ON DUPLICATE KEY UPDATE password=SHA1('testpassword');
EOF
echo -e "${GREEN}Test account created (username: testaccount, password: testpassword)${NC}"

# Create test player
echo -e "${YELLOW}Creating test player...${NC}"
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" << EOF
INSERT INTO players (name, group_id, account_id, level, vocation, health, healthmax, experience, looktype, town_id, posx, posy, posz, cap, sex, skill_fist, skill_club, skill_sword, skill_axe, skill_dist, skill_shielding, skill_fishing)
VALUES ('TestPlayer', 1, 1, 1, 1, 150, 150, 0, 136, 1, 32369, 32241, 7, 400, 0, 10, 10, 10, 10, 10, 10, 10)
ON DUPLICATE KEY UPDATE level=1;
EOF
echo -e "${GREEN}Test player created (character: TestPlayer)${NC}"

# Set proper permissions
echo -e "${YELLOW}Setting database permissions...${NC}"
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u root -p"$MYSQL_ROOT_PASSWORD" << EOF
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES;
EOF
echo -e "${GREEN}Permissions set successfully${NC}"

echo -e "${GREEN}Database initialization completed successfully!${NC}"
echo -e "${YELLOW}Test Account Details:${NC}"
echo "  Username: testaccount"
echo "  Password: testpassword"
echo "  Character: TestPlayer"
