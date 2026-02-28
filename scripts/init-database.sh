#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# init-database.sh
# Seeds the Tibia database with a test account and character.
# Must be run from the repo root AFTER docker-compose up -d.
# No local mysql client required — runs entirely inside the container.
# ─────────────────────────────────────────────────────────────────────────────
set -e

# Load .env if present
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

ROOT_PASS="${MYSQL_ROOT_PASSWORD:-tibia_root_password}"
DB="${MYSQL_DATABASE:-tibia}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${YELLOW}[init-db]${NC} $1"; }
success() { echo -e "${GREEN}[init-db]${NC} $1"; }
error()   { echo -e "${RED}[init-db]${NC} $1"; exit 1; }

# ── Wait for MySQL to be healthy ──────────────────────────────────────────────
info "Waiting for MySQL to be ready..."
for i in $(seq 1 40); do
    if docker-compose exec -T mysql mysqladmin ping -h localhost \
        -u root -p"${ROOT_PASS}" --silent 2>/dev/null; then
        success "MySQL is ready."
        break
    fi
    echo "  Attempt $i/40 — waiting 3 s..."
    sleep 3
    if [ "$i" -eq 40 ]; then
        error "MySQL did not become ready in time. Run: docker-compose logs mysql"
    fi
done

# ── Run seed SQL inside the container ────────────────────────────────────────
info "Seeding database with test account and character..."

docker-compose exec -T mysql mysql -u root -p"${ROOT_PASS}" "${DB}" << 'SQL'

-- Test account (username: testaccount / password: testpassword)
INSERT INTO accounts (name, password, type, premdays, email, creation)
VALUES ('testaccount', SHA1('testpassword'), 1, 0, 'test@localhost', UNIX_TIMESTAMP())
ON DUPLICATE KEY UPDATE password = SHA1('testpassword');

-- Test character
SET @acc_id = (SELECT id FROM accounts WHERE name = 'testaccount' LIMIT 1);

INSERT INTO players
    (name, group_id, account_id, level, vocation,
     health, healthmax, experience,
     looktype, town_id,
     posx, posy, posz,
     cap, sex,
     skill_fist, skill_club, skill_sword, skill_axe,
     skill_dist, skill_shielding, skill_fishing)
VALUES
    ('TestPlayer', 1, @acc_id, 1, 1,
     150, 150, 0,
     136, 1,
     32369, 32241, 7,
     400, 0,
     10, 10, 10, 10, 10, 10, 10)
ON DUPLICATE KEY UPDATE level = 1;

SQL

success "Database seeded successfully!"
echo ""
echo "  ┌─────────────────────────────────────────┐"
echo "  │  Test Account                           │"
echo "  │  Username  : testaccount               │"
echo "  │  Password  : testpassword              │"
echo "  │  Character : TestPlayer                │"
echo "  └─────────────────────────────────────────┘"
echo ""
success "Connect with OTClient → localhost:7171"
