local _, ns = ...

---@class XIV_Databar: AceAddon, AceConsole-3.0
local addon = LibStub("AceAddon-3.0"):GetAddon("XIV_Databar")
---@class XIV_Databar_Armor: AceModule, AceConsole-3.0
local module = addon:NewModule("XIV_Databar_Armor", "AceConsole-3.0")

function module:OnInitialize()
    self:Print("XIV_Databar_Armor OnInitialize function")
end

function module:OnEnable()
    self:Print("XIV_Databar_Armor OnEnable function")
end

function module:OnDisable()
    self:Print("XIV_Databar_Armor OnDisable function")
end