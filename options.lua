-- Get the addon name and namespace from the client
local name, ns = ...;

-- Get local copies of Lua functions
local select = select;

-- Get local copies of the WoW API
local UnitName, UnitClass, UnitLevel, UnitFactionGroup = UnitName, UnitClass, UnitLevel, UnitFactionGroup;
local GetRealmName = GetRealmName;
local GetScreenWidth = GetScreenWidth;

local constants = {
    mediaPath = "Interface\\AddOns\\"..name.."\\media\\",
    playerName = UnitName("player"),
    playerClass = select(2, UnitClass("player")),
    playerLevel = UnitLevel("player"),
    playerFactionLocal = select(2, UnitFactionGroup("player")),
    playerRealm = GetRealmName(),
    popupPadding = 10,
}

---  Get the addon constants
---@return table
ns.GetConstants = function()
    return constants;
end

-- Create the default profile
local defaults = {
    profile = {
        general = {
            barPosition = "BOTTOM",
            barPadding = 3,
            moduleSpacing = 30,
            barFullscreen = true,
            barWidth = GetScreenWidth(),
            barHoriz = 'CENTER',
			barCombatHide = false,
            barFlightHide = false,
            useElvUI = true,
        },
        color = {
            barColor = {
                r = 0.094,
                g = 0.094,
                b = 0.094,
                a = 0.75
            },
            normal = {
                r = 0.8,
                g = 0.8,
                b = 0.8,
                a = 0.75
            },
            inactive = {
                r = 1,
                g = 1,
                b = 1,
                a = 0.25
            },
            useCC = false,
			useTextCC = false,
            useHoverCC = true,
            hover = {
				r = RAID_CLASS_COLORS[constants.playerClass].r,
				g = RAID_CLASS_COLORS[constants.playerClass].g,
				b = RAID_CLASS_COLORS[constants.playerClass].b,
				a = RAID_CLASS_COLORS[constants.playerClass].a
			}
        },
        text = {
            fontSize = 12,
            smallFontSize = 11,
            font =  'Homizio Bold'
        },
        modules = {

        }
    }
};

--- Get the profile defaults for AceDB
---@return table
ns.GetDefaults = function()
    return defaults;
end;
