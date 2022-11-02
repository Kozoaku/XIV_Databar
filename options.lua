local title, namespace = ...;

local XIV_Databar = namespace.addon; ---@class XIV_Databar: AceAddon, AceConsole-3.0
local L = namespace.locale; ---@type XIV_DatabarLocale

function XIV_Databar:GetDefaults()
    local fontSize = 12;
    local padding = 3;

    local defaults = {
        profile = {
            general = {
                text = {
                    fontSize = fontSize,
                    smallFontSize = 10,
                    font = "Homizio Bold";
                },
                bar = {
                    position = "BOTTOM",
                    width = GetScreenWidth(),
                    height = (fontSize * 2) + padding,
                    padding = padding,
                    color = {
                        r = 0.094,
                        g = 0.094,
                        b = 0.094,
                        a = 0.75
                    }
                },
            },
        },
    };

    return defaults
end

function XIV_Databar:GetOptions()
    ---@type AceConfigOptionsTable
    local options = {
        name = title,
        handler = XIV_Databar,
        type = "group",
        args = {
            barHeader = {
                name = L["Bar Settings"],
                type = "header",
                order = 1,
            },
            positioning = {
                name = L["Bar Position"],
                type = "select",
                style = "dropdown",
                values = {
                    TOP = L["Top"],
                    BOTTOM = L["Bottom"],
                },
                get = "GetBarPosition",
                set = "SetBarPosition",
            },
            color = {
                name = L["Color"],
                type = "color",
                hasAlpha = true,
                get = "GetBarColor",
                set = "SetBarColor",
            }
        },
    };

    return options;
end

function XIV_Databar:GetModuleStub()
    ---@type AceConfigOptionsTable
    local modules = {
        name = L["Modules"],
        handler = XIV_Databar,
        type = "group",
        args = { },
    };

    return modules;
end

function XIV_Databar:GetBarPosition(info)
    return self.db.profile.general.bar.position;
end

function XIV_Databar:SetBarPosition(info, value)
    self.db.profile.general.bar.position = value;
    self.frames.bar:ClearAllPoints();
    self.frames.bar:SetPoint(value);

    if value == "TOP" then
        self:OffsetUIParent();
    end
end

function XIV_Databar:GetBarColor(info)
    return self.db.profile.general.bar.color;
end

function XIV_Databar:SetBarColor(info, r, g, b, a)
    self.db.profile.general.bar.color.r = r;
    self.db.profile.general.bar.color.g = g;
    self.db.profile.general.bar.color.b = b;
    self.db.profile.general.bar.color.a = a;

    for i, region in ipairs(self.frames.bar:GetRegions()) do
        region:SetVertexColor(r, g, b, a);
    end
end
