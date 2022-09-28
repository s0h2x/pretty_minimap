local addon = select(2,...);
local config = addon.config;
local map = addon._map;
local skin = addon.SetSkin;
local select = select;
local pairs = pairs;
local _G = _G;

function map:OnEvent(event, ...)
	if event == 'PLAYER_LOGIN' then
		if config.map.skin_button then
			for index=1, Minimap:GetNumChildren() do
				skin(select(index, Minimap:GetChildren()))
			end
		end
	elseif event == 'CALENDAR_UPDATE_PENDING_INVITES' or event == 'PLAYER_ENTERING_WORLD' then
		self:SetCalendarDate()
		self:RefreshCollapseExpandButtonState(BUFF_ACTUAL_DISPLAY)
	elseif event == 'UNIT_AURA' then
		self:RefreshCollapseExpandButtonState(BUFF_ACTUAL_DISPLAY)
	end
end

function map:init()
	self:RegisterEvent('PLAYER_LOGIN')
	self:RegisterEvent('UNIT_AURA')
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	self:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES')
	self:SetScript('OnEvent', self.OnEvent)
end
map:init()