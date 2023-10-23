local options = {}

do
    local _, ns = ...
    ns.Options = Options
end

do
    ---@type AceConfig.OptionsTable
    local optionsTable = {
        name = "XIV_Databar",
        type = "group",
        childGroups ="tree",
        args = {}
    }

    function options:getDefaultOptions()
        return options
    end
end

setmetatable({}, {__index = Options, __newindex = function() end, __metatable = false})