-- Tibia 7.4 Gameplay Configuration
-- This file contains Tibia 7.4 specific settings and mechanics

-- ============================================================================
-- TIBIA 7.4 SPECIFIC SETTINGS
-- ============================================================================

-- Vocations in Tibia 7.4
VOCATION = {
    NONE = 0,
    SORCERER = 1,
    DRUID = 2,
    PALADIN = 3,
    KNIGHT = 4
}

-- Tibia 7.4 Level Requirements
MIN_LEVEL = 1
MAX_LEVEL = 999
STARTING_LEVEL = 1
STARTING_EXPERIENCE = 0

-- ============================================================================
-- TIBIA 7.4 SPELL SYSTEM
-- ============================================================================

-- Magic level requirements for Tibia 7.4 spells
SPELL_REQUIREMENTS = {
    -- Sorcerer spells
    ["magic missile"] = { level = 4, maglevel = 0 },
    ["find person"] = { level = 8, maglevel = 0 },
    ["light"] = { level = 1, maglevel = 0 },
    ["cure poison"] = { level = 10, maglevel = 0 },
    ["energy bolt"] = { level = 18, maglevel = 0 },
    ["great light"] = { level = 18, maglevel = 0 },
    ["fireball"] = { level = 27, maglevel = 4 },
    ["poison bomb"] = { level = 30, maglevel = 4 },
    ["energy wave"] = { level = 38, maglevel = 7 },
    ["explosion"] = { level = 31, maglevel = 6 },
    ["great fireball"] = { level = 60, maglevel = 11 },
    ["mass healing"] = { level = 60, maglevel = 9 },
    ["energy field"] = { level = 42, maglevel = 8 },
    ["summon creature"] = { level = 25, maglevel = 2 },
    
    -- Druid spells
    ["heal friend"] = { level = 8, maglevel = 1 },
    ["poison field"] = { level = 14, maglevel = 3 },
    ["cure poison"] = { level = 10, maglevel = 0 },
    ["slow"] = { level = 14, maglevel = 4 },
    ["ice wave"] = { level = 38, maglevel = 7 },
    ["ultimate healing"] = { level = 60, maglevel = 9 },
    
    -- Paladin spells
    ["curse"] = { level = 20, maglevel = 4 },
    ["holy missile"] = { level = 4, maglevel = 0 },
    ["protection field"] = { level = 10, maglevel = 3 },
    ["cure poison"] = { level = 10, maglevel = 0 },
    ["slow"] = { level = 14, maglevel = 4 },
    ["holy light"] = { level = 60, maglevel = 9 },
    
    -- Knight spells
    ["berserk"] = { level = 7, maglevel = 0 },
    ["cure poison"] = { level = 10, maglevel = 0 }
}

-- ============================================================================
-- TIBIA 7.4 ITEM SYSTEM
-- ============================================================================

-- Tibia 7.4 equipment slots
EQUIPMENT_SLOTS = {
    HEAD = 1,
    BODY = 2,
    LEGS = 3,
    FEET = 4,
    BACK = 5,
    WEAPON = 6,
    SHIELD = 7,
    AMMO = 8,
    RING = 9,
    AMULET = 10
}

-- Tibia 7.4 item rarity
ITEM_RARITY = {
    COMMON = 0,
    UNCOMMON = 1,
    RARE = 2,
    VERY_RARE = 3,
    LEGENDARY = 4
}

-- ============================================================================
-- TIBIA 7.4 EXPERIENCE TABLE
-- ============================================================================

-- Experience required per level (Tibia 7.4 formula)
function getExperienceForLevel(level)
    if level <= 1 then return 0 end
    if level <= 8 then return 50 * level end
    return 50 * level + (level - 8) * 100 * (level - 8)
end

-- ============================================================================
-- TIBIA 7.4 SKILL SYSTEM
-- ============================================================================

SKILLS = {
    FIST = 0,
    CLUB = 1,
    SWORD = 2,
    AXE = 3,
    DISTANCE = 4,
    SHIELDING = 5,
    FISHING = 6
}

-- Skill level requirements
SKILL_REQUIREMENTS = {
    [SKILLS.FIST] = 10,
    [SKILLS.CLUB] = 10,
    [SKILLS.SWORD] = 10,
    [SKILLS.AXE] = 10,
    [SKILLS.DISTANCE] = 10,
    [SKILLS.SHIELDING] = 10,
    [SKILLS.FISHING] = 10
}

-- ============================================================================
-- TIBIA 7.4 COMBAT MECHANICS
-- ============================================================================

-- Damage types
DAMAGE_TYPE = {
    PHYSICAL = 0,
    FIRE = 1,
    COLD = 2,
    ENERGY = 3,
    POISON = 4,
    HOLY = 5
}

-- Armor types
ARMOR_TYPE = {
    LEATHER = 1,
    CHAIN = 2,
    PLATE = 3,
    MAGIC = 4
}

-- ============================================================================
-- TIBIA 7.4 TOWN INFORMATION
-- ============================================================================

TOWNS = {
    [1] = {
        name = "Thais",
        posX = 32369,
        posY = 32241,
        posZ = 7
    },
    [2] = {
        name = "Carlin",
        posX = 32415,
        posY = 31814,
        posZ = 7
    },
    [3] = {
        name = "Rookgaard",
        posX = 32097,
        posY = 32219,
        posZ = 7
    }
}

-- ============================================================================
-- TIBIA 7.4 CREATURE SETTINGS
-- ============================================================================

-- Creature experience multiplier
CREATURE_EXP_MULTIPLIER = 1.0

-- Creature loot multiplier
CREATURE_LOOT_MULTIPLIER = 1.0

-- Respawn settings
RESPAWN_DELAY = 60000  -- 60 seconds
RESPAWN_RANGE = 5

-- ============================================================================
-- TIBIA 7.4 PLAYER SETTINGS
-- ============================================================================

-- Starting equipment for new characters
STARTING_EQUIPMENT = {
    [VOCATION.SORCERER] = {
        { itemid = 3005, slot = EQUIPMENT_SLOTS.BODY },  -- Robe
        { itemid = 3008, slot = EQUIPMENT_SLOTS.HEAD },  -- Leather Helmet
        { itemid = 3006, slot = EQUIPMENT_SLOTS.LEGS },  -- Leather Legs
        { itemid = 3009, slot = EQUIPMENT_SLOTS.FEET }   -- Leather Boots
    },
    [VOCATION.DRUID] = {
        { itemid = 3005, slot = EQUIPMENT_SLOTS.BODY },
        { itemid = 3008, slot = EQUIPMENT_SLOTS.HEAD },
        { itemid = 3006, slot = EQUIPMENT_SLOTS.LEGS },
        { itemid = 3009, slot = EQUIPMENT_SLOTS.FEET }
    },
    [VOCATION.PALADIN] = {
        { itemid = 3004, slot = EQUIPMENT_SLOTS.BODY },  -- Plate Armor
        { itemid = 3010, slot = EQUIPMENT_SLOTS.HEAD },  -- Steel Helmet
        { itemid = 3007, slot = EQUIPMENT_SLOTS.LEGS },  -- Plate Legs
        { itemid = 3009, slot = EQUIPMENT_SLOTS.FEET }
    },
    [VOCATION.KNIGHT] = {
        { itemid = 3004, slot = EQUIPMENT_SLOTS.BODY },
        { itemid = 3010, slot = EQUIPMENT_SLOTS.HEAD },
        { itemid = 3007, slot = EQUIPMENT_SLOTS.LEGS },
        { itemid = 3009, slot = EQUIPMENT_SLOTS.FEET }
    }
}

-- Starting spells for new characters
STARTING_SPELLS = {
    [VOCATION.SORCERER] = { "magic missile", "light" },
    [VOCATION.DRUID] = { "heal friend", "light" },
    [VOCATION.PALADIN] = { "holy missile", "light" },
    [VOCATION.KNIGHT] = { "berserk" }
}

-- ============================================================================
-- TIBIA 7.4 MARKET/TRADE SETTINGS
-- ============================================================================

-- NPC trade multiplier
NPC_TRADE_MULTIPLIER = 1.0

-- Market tax (if enabled)
MARKET_TAX = 0.05  -- 5% tax

-- ============================================================================
-- TIBIA 7.4 HOUSE SETTINGS
-- ============================================================================

-- House rent period in days
HOUSE_RENT_PERIOD = 30

-- House price per square meter
HOUSE_PRICE_PER_SQM = 1000

-- Maximum houses per player
MAX_HOUSES_PER_PLAYER = 1

return {
    VOCATION = VOCATION,
    SKILLS = SKILLS,
    DAMAGE_TYPE = DAMAGE_TYPE,
    ARMOR_TYPE = ARMOR_TYPE,
    EQUIPMENT_SLOTS = EQUIPMENT_SLOTS,
    TOWNS = TOWNS,
    getExperienceForLevel = getExperienceForLevel
}
