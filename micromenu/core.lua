local _, ns = ...

---@class XIV_Databar: AceAddon
local addon = LibStub("AceAddon-3.0"):GetAddon("XIV_Databar")
---@class XIV_Databar_MicroMenu: AceModule, AceConsole-3.0
local module = addon:NewModule("XIV_Databar_MicroMenu")

function module:OnInitialize()
    self:Print("XIV_Databar_MicroMenu OnInitialize function")
end

function module:OnEnable()
    self:Print("XIV_Databar_MicroMenu OnEnable function")
end

function module:OnDisable()
    self:Print("XIV_Databar_MicroMenu OnDisable function")
end