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

Hooks:PostHook(HUDManager, "_add_name_label", "GTFO_Compass_Set_Name_Color", function(self, data)
	local key = data.unit:key()
	local panel = self._compass._teammate[key] and self._compass._teammate[key].panel
	
	if panel then
		local color_id = nil
		if WolfgangHUD then
			color_id = WolfgangHUD:character_color_id(data.unit)
		else
			color_id = managers.criminals:character_color_id_by_unit(data.unit)
		end
		local crim_color = tweak_data.chat_colors[color_id] or tweak_data.chat_colors[#tweak_data.chat_colors]
		panel:child("compass_teammate_rect"):set_color(crim_color)
	end
end)