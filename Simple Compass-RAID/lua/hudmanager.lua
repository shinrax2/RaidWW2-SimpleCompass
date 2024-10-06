Hooks:PostHook(HUDManager, "setup", "GTFO_Compass_Setup", function(self)
	local hud_script = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN)
	local panel = hud_script and hud_script.panel
	if alive(panel) and not self._compass then
		self._compass = SimpleCompass:new(panel)
	end
end)

Hooks:PostHook(HUDManager, "update", "GTFO_Compass_Update", function(self, t, dt)
	self._compass:update(t, dt)
end)

Hooks:PostHook(HUDManager, "add_waypoint", "GTFO_Compass_Add_Waypoint", function(self, id, data)
	if self._compass and data.waypoint_type == "objective" then
		self._compass:_add_waypoint(id, data)
	end
end)
Hooks:PostHook(HUDManager, "remove_waypoint", "GTFO_Compass_Remove_Waypoint", function(self, id)
	if self._compass then
		self._compass:_remove_waypoint(id)
	end
end)

Hooks:PostHook(HUDManager, "add_mugshot", "GTFO_Compass_add_mugshot", function(self, data)
	local ai = managers.criminals:character_data_by_name(data.character_name_id).ai or false
	local unit = managers.criminals:character_unit_by_name(data.character_name_id)
	local color_id = managers.criminals:character_color_id_by_unit(unit)
	if WolfgangHUD then
		color_id = WolfgangHUD:character_color_id(unit, self._id)
	end
	local crim_color = tweak_data.chat_colors[color_id] or tweak_data.chat_colors[#tweak_data.chat_colors]
	if unit then
		local k = unit:key()
		managers.hud._compass._teammate[k].nationality = data.character_name_id
		local panel = managers.hud._compass._teammate[k].panel
		if managers.hud._compass.settings.TeammateIcon then
			local icon = tweak_data.gui:get_full_gui_data("nationality_small_" .. data.character_name_id)
			panel:child("compass_teammate_icon"):set_image(icon.texture, unpack(icon.texture_rect))
			panel:child("compass_teammate_icon"):set_color(crim_color)
		end
		panel:child("compass_teammate_rect"):set_color(crim_color)
	end
end)