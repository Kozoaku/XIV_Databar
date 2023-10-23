local _, ns = ...

---@class XIV_Databar: AceAddon
local addon = LibStub("AceAddon-3.0"):GetAddon("XIV_Databar")
---@class XIV_Databar_Talent: AceModule, AceConsole-3.0
local module = addon:NewModule("XIV_Databar_Talent")

function module:OnInitialize()
    self:Print("XIV_Databar_Talent OnInitialize function")
end

function module:OnEnable()
    self:Print("XIV_Databar_Talent OnEnable function")
end

function module:OnDisable()
    self:Print("XIV_Databar_Talent OnDisable function")
end