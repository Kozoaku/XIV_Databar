local title, namespace = ...;

local GetScreenWidth = GetScreenWidth()

local LibStub         = LibStub;
local AceAddon        = LibStub:GetLibrary("AceAddon-3.0"); ---@type AceAddon-3.0
local AceLocale       = LibStub:GetLibrary("AceLocale-3.0"); ---@type AceLocale-3.0
local AceDB           = LibStub:GetLibrary("AceDB-3.0"); ---@type AceDB-3.0
local AceDBOptions    = LibStub:GetLibrary("AceDBOptions-3.0"); ---@type AceDBOptions-3.0
local AceConfig       = LibStub:GetLibrary("AceConfig-3.0"); ---@type AceConfig-3.0
local AceConfigDialog = LibStub:GetLibrary("AceConfigDialog-3.0"); ---@type AceConfigDialog-3.0

local XIV_Databar = AceAddon:NewAddon(title); ---@class XIV_Databar: AceAddon
namespace.addon = XIV_Databar

local L = AceLocale:GetLocale(title, true); ---@type XIV_DatabarLocale
namespace.locale = L;

local defaults = {
    profile = {
        general = {
            bar = {
                position = "Bottom",
                width = GetScreenWidth(),
                height = 64,
            },
        },
    },
};

---@type AceConfigOptionsTable
local options = {
    name = title,
    handler = XIV_Databar,
    type = "group",
    args = {
        general = {
            name = GENERAL_LABEL,
            type = "group",
            args = {
                posistioning = {
                    name = L["Bar Posistion"],
                    type = "select",
                    style = "dropdown",
                    values = {
                        TOP = L["Top"],
                        BOTTOM = L["Bottom"]
                    },
                    get = function() return XIV_Databar.db.profile.general.bar.position; end,
                    set = function(info, value) XIV_Databar.db.profile.general.bar.position = value; end,
                }
            }
        }
    },
};

local frames = {};
XIV_Databar.frames = frames;

function XIV_Databar:OnInitialize()
    self.db = AceDB:New("XIVBarDB", defaults, true);
    options.args.profiles = AceDBOptions:GetOptionsTable(self.db);

    AceConfig:RegisterOptionsTable(title, options, {"xdb"});
    frames.options = AceConfigDialog:AddToBlizOptions(title);
end

function XIV_Databar:OnEnable()
    if self.frames.bar == nil then
        local bar = CreateFrame("Frame", title, UIParent);
        bar:SetPoint(self.db.profile.bar.position);
        bar:SetSize(self.db.profile.bar.width, self.db.profile.bar.height);

        local background = bar:CreateTexture(nil, "BACKGROUND");
        background:SetAllPoints();
        background:SetColorTexture(0.5, 0.5, 0.5, 0.5);

        frames.bar = bar;
    end

    self.frames.bar:Show();
end

function XIV_Databar:OnDisable()
    if self.frames.bar == nil then
        return
    end

    self.frames.bar:Hide();
end
