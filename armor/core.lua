local _, ns = ...
local addon = LibStub("AceAddon-3.0"):GetAddon("XIV_Databar")
local module = addon:NewModule("XIV_Databar_Armor")

function module:OnInitialize()
    self:Print("XIV_Databar_Armor OnInitialize function")
end

function module:OnEnable()
    self:Print("XIV_Databar_Armor OnEnable function")
end

function module:OnDisable()
    self:Print("XIV_Databar_Armor OnDisable function")
end