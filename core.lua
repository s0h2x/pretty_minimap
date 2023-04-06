local unpack = unpack;
local select = select;
local pairs = pairs;
local assert = assert;
local next = next;

local addon = select(2,...);
addon._map = CreateFrame('Frame');
addon._noop = function() return; end

-- white list icons on minimap
local WHITE_LIST = {
	'MiniMapBattlefieldFrame','MiniMapTrackingButton','MiniMapMailFrame','HelpOpenTicketButton',
	'GatherMatePin','HandyNotesPin','TimeManagerClockButton','Archy','GatherNote','MinimMap',
	'Spy_MapNoteList_mini','ZGVMarker','poiWorldMapPOIFrame','WorldMapPOIFrame','QuestMapPOI',
	'GameTimeFrame','ZygorGuidesViewerMapIcon'
}
local BUTTON_POINTS = {}

addon.noop = function(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = addon._noop
	object:Hide()
end

addon.Mixin = function(object, ...)
	local mixins = {...}
	for _, mixin in pairs(mixins) do
		for k,v in next, mixin do
			object[k] = v
		end
	end
	return object
end

addon.atlas_unpack = function(atlas)
	assert(addon.atlasinfo[atlas], 'Atlas ['..atlas..']: failed to unpack')
	return unpack(addon.atlasinfo[atlas])
end

addon.SetAtlas = function(self, atlas, size)
	if not atlas then
		self:SetTexture(nil)
		return
	end
	
	local origWidth, origHeight = self:GetSize()
	local tex, dimension_x, dimension_y, width, height, left, right, top, bottom = addon.atlas_unpack(atlas)
	self:SetTexture(tex)
	self:SetTexCoord(left/dimension_x, right/dimension_x, top/dimension_y, bottom/dimension_y)

	if size then
		self:SetWidth(width)
		self:SetHeight(height)
	else
		self:SetWidth(origWidth)
		self:SetHeight(origHeight)
	end
end

addon.SetShown = function(self, show)
	if show then
		self:Show()
	else
		self:Hide()
	end
end

local function fadein(self) securecall(UIFrameFadeIn, self, 0.2, self:GetAlpha(), 1.0) end
local function fadeout(self) securecall(UIFrameFadeOut, self, 0.2, self:GetAlpha(), 0.2) end

addon.SetSkin = function(button)
	if not button or button:GetObjectType() ~= 'Button' then
		return
	end
	
	local frameName = button:GetName();
	for i,buttons in pairs(WHITE_LIST) do
		if frameName ~= nil then
			if frameName:match(buttons) then return end
		end
	end
	for index=1,button:GetNumRegions() do
		local region = select(index, button:GetRegions());
		if region:GetObjectType() == 'Texture' then
			local name = region:GetTexture()
			if name and (name:find('Border') or name:find('Background') or name:find('AlphaMask')) then
				region:SetTexture(nil)
			else
				region:ClearAllPoints()
				region:SetPoint('TOPLEFT', button, 'TOPLEFT', 2, -2)
				region:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -2, 2)
				region:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				region:SetDrawLayer('ARTWORK')
				if frameName == 'PS_MinimapButton' then
					region.SetPoint = addon._noop
				end
			end
		end
	end
	button:SetPushedTexture(nil)
	button:SetHighlightTexture(nil)
	button:SetDisabledTexture(nil)
	button:SetSize(20, 20)
	
	button.circle = button:CreateTexture(nil, 'OVERLAY')
	button.circle:SetSize(20, 20)
	button.circle:SetPoint('CENTER', button)
	button.circle:SetTexture(addon._dir..'border_buttons.tga')
	
	if addon.config.map.fade_button then
		button:SetAlpha(0.2)
		button:HookScript('OnEnter',fadein)
		button:HookScript('OnLeave',fadeout)
	else
		button:SetAlpha(1)
	end
end
