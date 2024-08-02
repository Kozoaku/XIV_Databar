local ns = select(2, ...)

do
  ---@class AceAddon-3.0
  local AceAddon = LibStub:GetLibrary("AceAddon-3.0")

  ---@class AceAddon
  local XIV_Databar = AceAddon:GetAddon("XIV_Databar")

  ns.XIV_Databar_Config = XIV_Databar:NewModule("XIV_Databar_Config")
end

---@class AceModule
local XIV_Databar_Config = ns.XIV_Databar_Config