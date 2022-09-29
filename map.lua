local addon = select(2,...);
local config = addon.config;
local atlas = addon.SetAtlas;
local shown = addon.SetShown;
local unpack = unpack;
local ipairs = ipairs;
local GetCVar = GetCVar;
local UIParent = UIParent;
local hooksecurefunc = hooksecurefunc;

-- const
local DEFAULT_MINIMAP_WIDTH = Minimap:GetWidth() * 1.36
local DEFAULT_MINIMAP_HEIGHT = Minimap:GetHeight() * 1.36
local BORDER_SIZE = 71*2 * 2^0.5
local blipScale = config.map.blip_scale
local blipDefault = 'interface\\MINIMAP\\OBJECTICONS'

Minimap.BorderTop = Minimap:CreateTexture(nil, 'OVERLAY')
Minimap.BorderTop:SetPoint(unpack(config.map.border_point))
atlas(Minimap.BorderTop, 'ui-hud-minimap-bordertop', true)
Minimap.BorderTop:SetAlpha(config.map.border_alpha)

-- poi
Minimap:SetStaticPOIArrowTexture(addon._dir..'poi-static')
Minimap:SetCorpsePOIArrowTexture(addon._dir..'poi-corpse')
Minimap:SetPOIArrowTexture(addon._dir..'poi-guard')
Minimap:SetPlayerTexture(addon._dir..'poi-player')
Minimap:SetPlayerTextureHeight(config.map.player_arrow_size);
Minimap:SetPlayerTextureWidth(config.map.player_arrow_size);
Minimap:SetBlipTexture(config.map.blip_skin and addon._dir..'objecticons' or blipDefault)

-- mail
MiniMapMailBorder:SetTexture(nil)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint('BOTTOMLEFT', Minimap, 'BOTTOMLEFT', -4, -5)
atlas(MiniMapMailIcon, 'ui-hud-minimap-mail-up', true);

-- pvp
MiniMapBattlefieldIcon:Hide()
MiniMapBattlefieldBorder:Hide()
MiniMapBattlefieldFrame:SetSize(44, 44)
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint('BOTTOMLEFT', Minimap, 0, 18)
MiniMapBattlefieldFrame:SetNormalTexture''
MiniMapBattlefieldFrame:SetPushedTexture''

local faction = strlower(UnitFactionGroup('player'))
atlas(MiniMapBattlefieldFrame:GetNormalTexture(), 'ui-hud-minimap-pvp-'..faction..'-up', true);
atlas(MiniMapBattlefieldFrame:GetPushedTexture(), 'ui-hud-minimap-pvp-'..faction..'-down', true);

MiniMapBattlefieldFrame:SetScript('OnClick', function(self, button)
	GameTooltip:Hide();
	if ( MiniMapBattlefieldFrame.status == "active") then
		if ( button == "RightButton" ) then
			ToggleDropDownMenu(1, nil, MiniMapBattlefieldDropDown, "MiniMapBattlefieldFrame", 0, -5);
		elseif ( IsShiftKeyDown() ) then
			ToggleBattlefieldMinimap();
		else
			ToggleWorldStateScoreFrame();
		end
	elseif ( button == "RightButton" ) then
		ToggleDropDownMenu(1, nil, MiniMapBattlefieldDropDown, "MiniMapBattlefieldFrame", 0, -5);
	end
end)

-- zoom button
atlas(MinimapZoomIn:GetNormalTexture(), 'ui-hud-minimap-zoom-in', true)
atlas(MinimapZoomIn:GetPushedTexture(), 'ui-hud-minimap-zoom-in-down', true)
atlas(MinimapZoomIn:GetDisabledTexture(), 'ui-hud-minimap-zoom-in-down', true)
atlas(MinimapZoomIn:GetHighlightTexture(), 'ui-hud-minimap-zoom-in-mouseover', true)
MinimapZoomIn:GetHighlightTexture():SetAlpha(.4)
MinimapZoomIn:GetHighlightTexture():SetBlendMode('ADD')
MinimapZoomIn:SetSize(20, 19)
MinimapZoomIn:ClearAllPoints()
MinimapZoomIn:SetPoint('CENTER', MinimapBackdrop, 'CENTER', 98, -33)

atlas(MinimapZoomOut:GetNormalTexture(), 'ui-hud-minimap-zoom-out', true)
atlas(MinimapZoomOut:GetPushedTexture(), 'ui-hud-minimap-zoom-out-down', true)
atlas(MinimapZoomOut:GetDisabledTexture(), 'ui-hud-minimap-zoom-out-down', true)
atlas(MinimapZoomOut:GetHighlightTexture(), 'ui-hud-minimap-zoom-out-mouseover', true)
MinimapZoomOut:GetHighlightTexture():SetAlpha(.4)
MinimapZoomOut:GetHighlightTexture():SetBlendMode('ADD')
MinimapZoomOut:SetSize(20, 10)
MinimapZoomOut:ClearAllPoints()
MinimapZoomOut:SetPoint('CENTER', MinimapBackdrop, 'CENTER', 80, -51)
MinimapZoomOut:SetHitRectInsets(0,0,0,0)

for _,obj in pairs{MinimapZoomIn,MinimapZoomOut} do shown(obj,config.map.zoom_in_out) end

-- noop
MiniMapWorldMapButton:Hide()
MiniMapWorldMapButton:UnregisterAllEvents()
MinimapNorthTag:SetAlpha(0)
MinimapBorder:Hide()
MinimapBorderTop:Hide()
MinimapCompassTexture:SetAlpha(0)

local MINIMAP_POINTS = {}
for i=1, Minimap:GetNumPoints() do
	MINIMAP_POINTS[i] = {Minimap:GetPoint(i)}
end

for _,regions in ipairs {Minimap:GetChildren()} do
	regions:SetScale(1/blipScale)
end

for _,points in ipairs(MINIMAP_POINTS) do
	Minimap:SetPoint(points[1], points[2], points[3], points[4]/blipScale, points[5]/blipScale)
end

function GetMinimapShape() return "ROUND" end

MinimapCluster:SetScale(config.map.scale)
MinimapCluster:EnableMouse(false)
MinimapCluster:ClearAllPoints()
MinimapCluster:SetPoint('TOPRIGHT', -24, -40)
MinimapCluster:SetHitRectInsets(30, 10, 0, 30)
MinimapCluster:SetFrameStrata('BACKGROUND')
MinimapBackdrop:EnableMouse(false)

-- MiniMap
Minimap:SetMaskTexture(addon._dir..'uiminimapmask.tga')
Minimap:SetWidth(DEFAULT_MINIMAP_WIDTH/blipScale)
Minimap:SetHeight(DEFAULT_MINIMAP_HEIGHT/blipScale)
Minimap:SetScale(blipScale)
Minimap:SetFrameLevel(MinimapCluster:GetFrameLevel() + 1)

Minimap.Circle = MinimapBackdrop:CreateTexture(nil, 'ARTWORK')
Minimap.Circle:SetSize(BORDER_SIZE, BORDER_SIZE)
Minimap.Circle:SetPoint('CENTER', Minimap, 'CENTER')
Minimap.Circle:SetTexture(addon._dir..'uiminimapborder.tga')

-- zone text
MinimapZoneText:ClearAllPoints()
MinimapZoneText:SetSize(120, 12)
MinimapZoneText:SetPoint('TOPLEFT', Minimap.BorderTop, 8, -2)
MinimapZoneText:SetFont(config.assets.font, config.map.zonetext_font_size)
MinimapZoneText:SetJustifyH('LEFT')
MinimapZoneText:SetJustifyV('MIDDLE')

MinimapZoneTextButton:ClearAllPoints()
MinimapZoneTextButton:SetPoint('TOPLEFT', Minimap.BorderTop, 8, 0)

-- tracking
MiniMapTracking:ClearAllPoints();
MiniMapTracking:SetPoint('TOPLEFT', Minimap.BorderTop, -28, 7)
MiniMapTrackingButton:ClearAllPoints();
MiniMapTrackingButton:SetPoint('CENTER', MiniMapTracking, 'CENTER')
MiniMapTrackingButtonShine:ClearAllPoints();
MiniMapTrackingButtonShine:SetPoint('CENTER', MiniMapTrackingButton)
MiniMapTrackingButtonBorder:SetTexture(nil)
MiniMapTrackingBackground:SetTexture(nil)

local function Tracking_Update()
	local texture = GetTrackingTexture();
	if config.map.tracking_icons then
		if texture == 'Interface\\Minimap\\Tracking\\None' then
			atlas(MiniMapTrackingIcon, 'ui-hud-minimap-tracking-up', true);
		else
			MiniMapTrackingIcon:SetSize(20, 20);
			MiniMapTrackingIcon:SetTexture(texture);
			MiniMapTrackingIcon:SetTexCoord(0,0,0,1,1,0,1,1);
		end
	else
		MiniMapTrackingButton:SetNormalTexture'';
		MiniMapTrackingButton:SetPushedTexture'';
		MiniMapTrackingButton:SetSize(17, 15);
		
		MiniMapTrackingIcon:ClearAllPoints();
		MiniMapTrackingIcon:SetPoint('CENTER', MiniMapTracking, 'CENTER', 0, 0);
		
		atlas(MiniMapTrackingIcon, 'ui-hud-minimap-button', true);
		atlas(MiniMapTrackingButton:GetNormalTexture(), 'ui-hud-minimap-tracking-up');
		atlas(MiniMapTrackingButton:GetPushedTexture(), 'ui-hud-minimap-tracking-down');
		atlas(MiniMapTrackingButton:GetHighlightTexture(), 'ui-hud-minimap-tracking-mouseover');
		
		MiniMapTrackingButton:GetHighlightTexture():SetBlendMode('ADD')
	end
	MiniMapTrackingIconOverlay:SetAlpha(0);
end
Tracking_Update();
-- MiniMapTrackingButton:SetScript('OnClick', function()
	-- ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "MiniMapTracking", 44, 11);
	-- PlaySound("igMainMenuOptionCheckBoxOn");
-- end)
MiniMapTrackingButton:HookScript('OnEvent', Tracking_Update)

-- LFG update
if (not IsAddOnLoaded('pretty_actionbar')) then
	MiniMapLFGFrame.eye.texture:SetTexture(addon._dir..'uigroupfinderflipbookeye.tga')
	MiniMapLFGFrameBorder:SetTexture(nil)
end

-- MiniMap rotate
local m_pi = math.pi
local m_cos = math.cos
local m_sin = math.sin
local function RotateBorder()
	local angle = GetPlayerFacing()
	Minimap.Circle:SetTexCoord(
		m_cos(angle + m_pi*3/4) + 0.5, -m_sin(angle + m_pi*3/4) + 0.5,
		m_cos(angle - m_pi*3/4) + 0.5, -m_sin(angle - m_pi*3/4) + 0.5,
		m_cos(angle + m_pi*1/4) + 0.5, -m_sin(angle + m_pi*1/4) + 0.5,
		m_cos(angle - m_pi*1/4) + 0.5, -m_sin(angle - m_pi*1/4) + 0.5
	)
end

local MinimapRotate = CreateFrame("Frame")
MinimapRotate:Hide()
MinimapRotate:SetScript("OnUpdate", RotateBorder)
hooksecurefunc('Minimap_UpdateRotationSetting',function()
	if (GetCVar("rotateMinimap") == "1") then
		MinimapRotate:Show()
		Minimap.Circle:SetSize(200 * 2^0.5, 200 * 2^0.5)
	else
		MinimapRotate:Hide()
		Minimap.Circle:SetTexCoord(0, 1, 0, 1)
		Minimap.Circle:SetSize(BORDER_SIZE, BORDER_SIZE)
	end
end)

-- mousewheel zooming
Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel',function(self, delta)
	if delta > 0 then
		_G.MinimapZoomIn:Click()
	elseif delta < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

-- Fix for minimap ping points not updating as your character moves.
-- Original code taken from AntiRadarJam by Lombra with permission.
do
	MinimapPing:HookScript("OnUpdate", function(self, elapsed)
		if self.fadeOut or self.timer > MINIMAPPING_FADE_TIMER then
			Minimap_SetPing(Minimap:GetPingPosition())
		end
	end)
end
