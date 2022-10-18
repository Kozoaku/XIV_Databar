local title, namespace = ...;

local LibStub   = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0"); ---@type AceLocale-3.0
local L = AceLocale:NewLocale(title, "enUS", true, false); ---@class XIV_DatabarLocale

L["Bar Posistion"] = "Bar Posistion";
L["Top"] = "Top";
L["Bottom"] = "Bottom";