local title, namespace = ...;

local LibStub         = LibStub;
local AceAddon        = LibStub:GetLibrary("AceAddon-3.0"); ---@type AceAddon-3.0
local AceLocale       = LibStub:GetLibrary("AceLocale-3.0"); ---@type AceLocale-3.0
local AceDB           = LibStub:GetLibrary("AceDB-3.0"); ---@type AceDB-3.0
local AceDBOptions    = LibStub:GetLibrary("AceDBOptions-3.0"); ---@type AceDBOptions-3.0
local AceConfig       = LibStub:GetLibrary("AceConfig-3.0"); ---@type AceConfig-3.0
local AceConfigDialog = LibStub:GetLibrary("AceConfigDialog-3.0"); ---@type AceConfigDialog-3.0
local SharedMedia     = LibStub:GetLibrary("LibSharedMedia-3.0"); ---@type LibSharedMedia-3.0

local XIV_Databar = AceAddon:NewAddon(title, "AceConsole-3.0"); ---@class XIV_Databar: AceAddon, AceConsole-3.0
namespace.addon = XIV_Databar

local L = AceLocale:GetLocale(title, true); ---@type XIV_DatabarLocale
namespace.locale = L;

local frames = {};
XIV_Databar.frames = frames;

function XIV_Databar:OnInitialize()
    self.db = AceDB:New("XIVBarDB", self:GetDefaults(), true); ---@type AceDBObject-3.0
    self.db:RegisterDefaults(self:GetDefaults());
    self.db.RegisterCallback(self, "OnProfileChanged", "ReloadFromDatabase");
    self.db.RegisterCallback(self, "OnProfileCopied", "ReloadFromDatabase");
    self.db.RegisterCallback(self, "OnProfileReset", "ReloadFromDatabase");

    local options = self:GetOptions();
    AceConfig:RegisterOptionsTable(title, options, {"xiv options", "xdb options"});
    AceConfigDialog:AddToBlizOptions(title);

    local modules = self:GetModuleStub();
    AceConfig:RegisterOptionsTable(title.."Modules", modules, {"xiv mods", "xdb mods"});
    AceConfigDialog:AddToBlizOptions(title.."Modules", "Modules", title);

    local profiles = AceDBOptions:GetOptionsTable(self.db);
    AceConfig:RegisterOptionsTable(title.."Profiles", profiles, {"xiv profile", "xdb profile"});
    AceConfigDialog:AddToBlizOptions(title.."Profiles", "Profiles", title);

    local mediaPath = "Interface\\AddOns\\"..title.."\\media\\";
    SharedMedia:Register(SharedMedia.MediaType.FONT, "Homizio Bold", mediaPath.."homizio_bold.ttf");
end

function XIV_Databar:OnEnable()
    if self.frames.bar == nil then
        local anchor = self.db.profile.general.bar.position;
        local width  = self.db.profile.general.bar.width;
        local height = self.db.profile.general.bar.height;

        local bar = CreateFrame("Frame", title, UIParent);
        bar:SetPoint(anchor);
        bar:SetSize(width, height);

        local background = bar:CreateTexture(nil, "BACKGROUND");
        local color = self.db.profile.general.bar.color;
        background:SetAllPoints();
        background:SetColorTexture(color.r, color.g, color.b, color.a);

        frames.bar = bar;

        if anchor == "TOP" then
            self:OffsetUIParent();
        end
    end

    self.frames.bar:Show();
end

function XIV_Databar:OnDisable()
    self.frames.bar:Hide();
end

function XIV_Databar:ReloadFromDatabase()
    if self.frames.bar == nil then return end

    local anchor = self.db.profile.general.bar.position;
    local width  = self.db.profile.general.bar.width;
    local height = self.db.profile.general.bar.height;

    self.frames.bar:ClearAllPoints();
    self.frames.bar:SetPoint(anchor);
    self.frames.bar:SetSize(width, height);

    for i, region in ipairs(self.frames.bar:GetRegions()) do
        local color = self.db.profile.general.bar.color;
        region:SetVertexColor(color.r, color.g, color.b, color.a);
    end
end

function XIV_Databar:OffsetUIParent()
    local offset = self.frames.bar:GetHeight();
end
