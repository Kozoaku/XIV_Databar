local _, ns = ...

---@class XIV_Databar: AceAddon
local addon = LibStub("AceAddon-3.0"):GetAddon("XIV_Databar")
---@class XIV_Databar_Volume: AceModule, AceConsole-3.0
local module = addon:NewModule("XIV_Databar_Volume")

function module:OnInitialize()
    self:Print("XIV_Databar_Volume OnInitialize function")
end

function module:OnEnable()
    self:Print("XIV_Databar_Volume OnEnable function")
end

function module:OnDisable()
    self:Print("XIV_Databar_Volume OnDisable function")
end