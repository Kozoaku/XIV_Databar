local _, ns = ...

local options = ns.Options

---@class XIV_Databar: AceAddon, AceConsole-3.0
local addon = LibStub("AceAddon-3.0"):NewAddon("XIV_Databar", "AceConsole-3.0")

function addon:OnInitialize()
    self:Print("XIV_Databar OnInitialize function")
    LibStub("AceConfig-3.0"):RegisterOptionsTable("XIV_Databar", options:getDefaultOptions())
end

function addon:OnEnable()
    self:Print("XIV_Databar OnEnable function")
end

function addon:OnDisable()
    self:Print("XIV_Databar OnDisable function")
end