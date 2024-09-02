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