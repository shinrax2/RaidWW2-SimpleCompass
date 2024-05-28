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
