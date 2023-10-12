local _, ns = ...

---@class XIV_Databar: AceAddon
local addon = LibStub("AceAddon-3.0"):GetAddon("XIV_Databar")
---@class XIV_Databar_Tradeskill: AceModule, AceConsole-3.0
local module = addon:NewModule("XIV_Databar_Tradeskill")

function module:OnInitialize()
    self:Print("XIV_Databar_Tradeskill OnInitialize function")
end

function module:OnEnable()
    self:Print("XIV_Databar_Tradeskill OnEnable function")
end

function module:OnDisable()
    self:Print("XIV_Databar_Tradeskill OnDisable function")
end