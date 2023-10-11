local _, ns = ...
local XIV_Databar = LibStub("AceAddon-3.0"):NewAddon("XIV_Databar", "AceConsole-3.0")

function XIV_Databar:OnInitialize()
    self:Print("XIV_Databar OnInitialize function")
end

function XIV_Databar:OnEnable()
    self:Print("XIV_Databar OnEnable function")
end

function XIV_Databar:OnDisable()
    self:Print("XIV_Databar OnDisable function")
end
