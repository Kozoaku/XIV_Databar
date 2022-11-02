local title, namespace = ...;

local LibStub   = LibStub;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0"); ---@type AceLocale-3.0
local L = AceLocale:NewLocale(title, "enUS", true, false); ---@class XIV_DatabarLocale

--[[ Blizzard Interface Options Panel ]]--

-- General Panel --
L["Bar Settings"] = "Bar Settings";
L["Bar Position"] = "Bar Position";
L["Top"] = "Top";
L["Bottom"] = "Bottom";
L["Color"] = "Color";

-- Module Panel --
L["Modules"] = "Modules";