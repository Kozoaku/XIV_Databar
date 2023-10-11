local _, ns = ...
local addon = LibStub("AceAddon-3.0"):NewAddon("XIV_Databar", "AceConsole-3.0")

function addon:OnInitialize()
    self:Print("XIV_Databar OnInitialize function")
end

function addon:OnEnable()
    self:Print("XIV_Databar OnEnable function")
end

function addon:OnDisable()
    self:Print("XIV_Databar OnDisable function")
end
