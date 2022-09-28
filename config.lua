local addon = select(2,...);
addon._dir = [[Interface\AddOns\pretty_minimap\assets\]];
addon.config = {
	map = {
	-- @desc: main map settings
	-- @param: boolean, value
		scale = 1.15,						--; minimap scale (i don't recommend increasing too much).
		border_point = {'CENTER', 0, 100}, 	--; top border position.
		border_alpha = 1, 					--; top border alpha (0 for hide).
		blip_scale = 1.12,					--; scale for object icons on minimap.
		blip_skin = true,					--; new style for object icons.
		player_arrow_size = 40, 			--; player arrow on minimap center.
		tracking_icons = false, 			--; show current tracking icons (old style).
		skin_button = true, 				--; circle skin for addon buttons.
		fade_button = false, 				--; fading for addon buttons.
		zonetext_font_size = 12,			--; zone text on top border.
		zoom_in_out = false,				--; show zoom buttons (+/-).
	},

	times = {
	-- @desc: time settings
	-- @param: boolean, number
		clock = true,				--; show clock.
		calendar = true,			--; show calendar.
		clock_font_size = 11,		--; clock numbers size.
	},
	
	assets = {
	-- @desc: media folder
	-- @param: path
		font = addon._dir..'expressway.ttf', --; main theme font.
	}
};