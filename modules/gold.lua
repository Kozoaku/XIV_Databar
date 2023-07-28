local XIVBar = select(2, ...);
local xb = XIVBar;
local L = XIVBar.L;

local GoldModule = xb:NewModule("GoldModule", 'AceEvent-3.0')

local isSessionNegative, isDailyNegative = false, false

---Return text string with suffix to indicate the number of digits.
--   k - number of thousands
--   M - number of millions
--   B - number of billions
---@param num number
---@return string text shortened text string with suffix
local function shortenNumber(num)
  if num < 1000 then
    return tostring(num)
  elseif num < 1000000 then
    return format("%.1f"..L['k'],num/1000)
  elseif num < 1000000000 then
    return format("%.2f"..L['M'],num/1000000)
  else
    return format("%.3f"..L['B'],num/1000000000)
  end
end

---comment
---@param amount number amount to turn into the textured string in copper
---@param showSign boolean? show negative sign if amount is negative
---@return string texturedString string with the approiate icons and textures
local function moneyWithTexture(amount, showSign)
  local negativeSign = "|cffff0000- "

  if not xb.db.profile.modules.gold.showSmallCoins then
    amount = floor(amount / 1e4) * 1e4
  end

  local amountStringTexture = GetCoinTextureString(amount)

  if xb.db.profile.modules.gold.shortThousands then
    local shortGold = shortenNumber(amount)
    amountStringTexture = gsub(amountStringTexture, amount.."|T", shortGold.."|T")
  end

  if showSign then
    amountStringTexture = negativeSign..amountStringTexture or amountStringTexture
  end

  return amountStringTexture
end

---comment
---@param month string | number
---@param day string | number
---@param year string | number
---@return number date
local function ConvertDateToNumber(month, day, year)
  month = gsub(month, "(%d)(%d?)", function(d1, d2) return d2 == "" and "0"..d1 or d1..d2 end) -- converts M to MM
  day = gsub(day, "(%d)(%d?)", function(d1, d2) return d2 == "" and "0"..d1 or d1..d2 end) -- converts D to DD

  return tonumber(year..month..day)
end

local function listAllCharactersByFactionRealm()
  local optTable = {
    header = {
      name = "|cff82c5ff"..xb.constants.playerFactionLocal.." "..xb.constants.playerRealm.."|r",
      type = "header",
      order = 0
    },
    footer = {
      name = "All the characters listed above are currently registered in the gold database. To delete one or several character, plase uncheck the box correponding to the character(s) to delete.\nThe boxes will remain unchecked for the deleted character(s), untill you reload or logout/login",
      type = "description",
      order = -1
    }
  }

  for k in pairs(xb.db.factionrealm) do
    optTable[k]={
      name = k,
      width = "full",
      type = "toggle",
      get = function() return xb.db.factionrealm[k] ~= nil; end,
      set = function(_,val) if not val and xb.db.factionrealm[k] ~= nil then xb.db.factionrealm[k] = nil; end end
    }
  end
  return optTable;
end

local function GetFreeBagSpace()
  local freeSpace = 0
  for i = 0, 4 do
    freeSpace = freeSpace + C_Container.GetContainerNumFreeSlots(i)
  end
  return freeSpace
end

function GoldModule:GetName()
  return BONUS_ROLL_REWARD_MONEY;
end

function GoldModule:OnInitialize()
  if not xb.db.factionrealm[xb.constants.playerName] then
    xb.db.factionrealm[xb.constants.playerName] = { currentMoney = 0, sessionMoney = 0, dailyMoney = 0 }
  end

  if not xb.db.factionrealm[xb.constants.playerName].dailyMoney then
    xb.db.factionrealm[xb.constants.playerName].dailyMoney = 0
  end

  local playerData = xb.db.factionrealm[xb.constants.playerName]

  local curDate = C_DateAndTime.GetCurrentCalendarTime()
  local today = ConvertDateToNumber(curDate.month, curDate.monthDay, curDate.year)

  if playerData.lastLoginDate then
      if playerData.lastLoginDate < today then -- is true, if last time player logged in was the day before or even earlier
          playerData.lastLoginDate = today
          playerData.dailyMoney = 0
      end
  else
    playerData.lastLoginDate = today
  end

  if not playerData.class then
    playerData.class = select(2, UnitClass("player"))
  end

  xb.db.factionrealm[xb.constants.playerName] = playerData
end

function GoldModule:OnEnable()
  if self.goldFrame == nil then
    self.goldFrame = CreateFrame("FRAME", "GoldFrame", xb:GetFrame('bar'))
    xb:RegisterFrame('goldFrame', self.goldFrame)
  end
  self.goldFrame:Show()

  xb.db.factionrealm[xb.constants.playerName].sessionMoney = 0
  xb.db.factionrealm[xb.constants.playerName].currentMoney = GetMoney()

  self:CreateFrames()
  self:RegisterFrameEvents()
  self:Refresh()
  listAllCharactersByFactionRealm()
end

function GoldModule:OnDisable()
  self.goldFrame:Hide()
  self:UnregisterEvent('PLAYER_MONEY')
  self:UnregisterEvent('BAG_UPDATE')
end

function GoldModule:Refresh()
  local db = xb.db.profile
  if self.goldFrame == nil then return; end
  if not db.modules.gold.enabled then self:Disable(); return; end

  if InCombatLockdown() then
    self.goldText:SetFont(xb:GetFont(db.text.fontSize))
    self.goldText:SetText(self:FormatCoinText(GetMoney()))
    if db.modules.gold.showFreeBagSpace then
      self.bagText:SetFont(xb:GetFont(db.text.fontSize))
      self.bagText:SetText('('..tostring(GetFreeBagSpace())..')')
    end
    return
  end

  local iconSize = db.text.fontSize + db.general.barPadding
  self.goldIcon:SetTexture(xb.constants.mediaPath..'datatexts\\gold')
  self.goldIcon:SetSize(iconSize, iconSize)
  self.goldIcon:SetPoint('LEFT')
  self.goldIcon:SetVertexColor(xb:GetColor('normal'))

  self.goldText:SetFont(xb:GetFont(db.text.fontSize))
  self.goldText:SetTextColor(xb:GetColor('normal'))
  self.goldText:SetText(self:FormatCoinText(GetMoney()))
  self.goldText:SetPoint('LEFT', self.goldIcon, 'RIGHT', 5, 0)

  local bagWidth = 0
  if db.modules.gold.showFreeBagSpace then
    self.bagText:SetFont(xb:GetFont(db.text.fontSize))
    self.bagText:SetTextColor(xb:GetColor('normal'))
    self.bagText:SetText('('..tostring(GetFreeBagSpace())..')')
    self.bagText:SetPoint('LEFT', self.goldText, 'RIGHT', 5, 0)
    bagWidth = self.bagText:GetStringWidth()
  else
	self.bagText:SetFont(xb:GetFont(db.text.fontSize))
    self.bagText:SetText('')
    self.bagText:SetSize(0, 0)
  end

  self.goldButton:SetSize(self.goldText:GetStringWidth() + iconSize + 10 + bagWidth, iconSize)
  self.goldButton:SetPoint('LEFT')

  self.goldFrame:SetSize(self.goldButton:GetSize())

  local relativeAnchorPoint = 'LEFT'
  local xOffset = db.general.moduleSpacing
  local parentFrame = xb:GetFrame('travelFrame')
  if not true then --xb.db.profile.modules.travel.enabled
    parentFrame = self.goldFrame:GetParent()
    relativeAnchorPoint = 'RIGHT'
    xOffset = 0
  end
  self.goldFrame:SetPoint('RIGHT', parentFrame, relativeAnchorPoint, -(xOffset), 0)
end

function GoldModule:CreateFrames()
  self.goldButton = self.goldButton or CreateFrame("BUTTON", "GoldButton", self.goldFrame)
  self.goldIcon = self.goldIcon or self.goldButton:CreateTexture("Icon", 'OVERLAY')
  self.goldText = self.goldText or self.goldButton:CreateFontString("Text", "OVERLAY")
  self.bagText = self.bagText or self.goldButton:CreateFontString("Bag", "OVERLAY")
end

function GoldModule:RegisterFrameEvents()
  self.goldButton:EnableMouse(true)
  self.goldButton:RegisterForClicks("AnyUp")

  self:RegisterEvent('PLAYER_MONEY')
  self:RegisterEvent('BAG_UPDATE', 'Refresh')

  self.goldButton:SetScript('OnEnter', function()
    if InCombatLockdown() then return; end
    self.goldText:SetTextColor(unpack(xb:HoverColors()))
    self.bagText:SetTextColor(unpack(xb:HoverColors()))

    GameTooltip:SetOwner(GoldModule.goldFrame, 'ANCHOR_'..xb.miniTextPosition, 0, 0)
    local r, g, b, _ = unpack(xb:HoverColors())
    GameTooltip:AddLine("|cFFFFFFFF[|r"..BONUS_ROLL_REWARD_MONEY.."|cFFFFFFFF - |r"..xb.constants.playerFactionLocal.." "..xb.constants.playerRealm.."|cFFFFFFFF]|r", r, g, b)
    if not xb.db.profile.modules.gold.showSmallCoins then
      GameTooltip:AddLine(L["Gold rounded values"], 1, 1, 1)
    end
    GameTooltip:AddLine(" ")

    GameTooltip:AddDoubleLine(L['Session Total'], moneyWithTexture(math.abs(xb.db.factionrealm[xb.constants.playerName].sessionMoney), isSessionNegative), r, g, b, 1, 1, 1)
    GameTooltip:AddDoubleLine(L['Daily Total'], moneyWithTexture(math.abs(xb.db.factionrealm[xb.constants.playerName].dailyMoney), isDailyNegative), r, g, b, 1, 1, 1)
    GameTooltip:AddLine(" ")

    local totalGold = 0
    for charName, goldData in pairs(xb.db.factionrealm) do
      local cc_r, cc_g, cc_b = xb:GetClassColors() and 1, 1, 1
      GameTooltip:AddDoubleLine(charName, moneyWithTexture(goldData.currentMoney), cc_r, cc_g, cc_b, 1, 1, 1)
      totalGold = totalGold + goldData.currentMoney
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(TOTAL, GoldModule:FormatCoinText(totalGold), r, g, b, 1, 1, 1)
    GameTooltip:AddDoubleLine('<'..L['Left-Click']..'>', L['Toggle Bags'], r, g, b, 1, 1, 1)
    GameTooltip:Show()
  end)

  self.goldButton:SetScript('OnLeave', function()
    if InCombatLockdown() then return; end
    self.goldText:SetTextColor(xb:GetColor('normal'))
    self.bagText:SetTextColor(xb:GetColor('normal'))
    GameTooltip:Hide()
  end)

  self.goldButton:SetScript('OnClick', function(_, button)
    if InCombatLockdown() then return; end
    ToggleAllBags()
  end)

  self:RegisterMessage('XIVBar_FrameHide', function(_, name)
    if name == 'travelFrame' then
      self:Refresh()
    end
  end)

  self:RegisterMessage('XIVBar_FrameShow', function(_, name)
    if name == 'travelFrame' then
      self:Refresh()
    end
  end)
end

function GoldModule:PLAYER_MONEY()
  local gdb = xb.db.factionrealm[xb.constants.playerName]
  local curMoney = gdb.currentMoney
  local tmpMoney = GetMoney()
  local moneyDiff = tmpMoney - curMoney

  xb.db.factionrealm[xb.constants.playerName].sessionMoney = gdb.sessionMoney + moneyDiff
  xb.db.factionrealm[xb.constants.playerName].dailyMoney = gdb.dailyMoney + moneyDiff

  isSessionNegative = gdb.sessionMoney < 0
  isDailyNegative = gdb.dailyMoney < 0
  gdb.currentMoney = tmpMoney
  self:Refresh()
end

function GoldModule:FormatCoinText(money)
  local showSC = xb.db.profile.modules.gold.showSmallCoins
  if money == 0 then
	return showSC and string.format("%s"..GOLD_AMOUNT_SYMBOL.." %s"..SILVER_AMOUNT_SYMBOL.." %s"..COPPER_AMOUNT_SYMBOL,0,0,0) or money..GOLD_AMOUNT_SYMBOL
  end

  local shortThousands = xb.db.profile.modules.gold.shortThousands
  local g, s, c = self:SeparateCoins(money)

  if showSC then
	return (shortThousands and shortenNumber(g) or BreakUpLargeNumbers(g))..GOLD_AMOUNT_SYMBOL..' '..s..SILVER_AMOUNT_SYMBOL..' '..c..COPPER_AMOUNT_SYMBOL
  else
	return g > 0 and (shortThousands and shortenNumber(g)..GOLD_AMOUNT_SYMBOL) or BreakUpLargeNumbers(g)..GOLD_AMOUNT_SYMBOL
  end
end

function GoldModule:SeparateCoins(money)
  local gold, silver, copper = floor(abs(money / 10000)), floor(abs(mod(money / 100, 100))), floor(abs(mod(money, 100)))
  return gold, silver, copper
end

function GoldModule:GetDefaultOptions()
  return 'gold', {
      enabled = true,
      showSmallCoins = false,
      showFreeBagSpace = true,
      shortThousands = false
    }
end

function GoldModule:GetConfig()
  return {
    name = self:GetName(),
    type = "group",
    args = {
      enable = {
        name = ENABLE,
        order = 0,
        type = "toggle",
        get = function() return xb.db.profile.modules.gold.enabled; end,
        set = function(_, val)
          xb.db.profile.modules.gold.enabled = val
          if val then
            self:Enable()
          else
            self:Disable()
          end
        end,
        width = "full"
      },
      showSmallCoins = {
        name = L['Always Show Silver and Copper'],
        order = 1,
        type = "toggle",
        get = function() return xb.db.profile.modules.gold.showSmallCoins; end,
        set = function(_, val) xb.db.profile.modules.gold.showSmallCoins = val; self:Refresh(); end
      },
      showFreeBagSpace = {
        name = DISPLAY_FREE_BAG_SLOTS,
        order = 1,
        type = "toggle",
        get = function() return xb.db.profile.modules.gold.showFreeBagSpace; end,
        set = function(_, val) xb.db.profile.modules.gold.showFreeBagSpace = val; self:Refresh(); end
      },
      shortThousands = {
        name = L['Shorten Gold'],
        order = 1,
        type = "toggle",
        get = function() return xb.db.profile.modules.gold.shortThousands; end,
        set = function(_, val) xb.db.profile.modules.gold.shortThousands = val; self:Refresh(); end
      },
      listPlayers = {
        name = "Registered characters",
        type = "group",
        order = 1,
        args = listAllCharactersByFactionRealm()
      }
    }
  }
end
