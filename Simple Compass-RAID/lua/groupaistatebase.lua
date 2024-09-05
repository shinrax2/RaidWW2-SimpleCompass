
Hooks:PostHook(GroupAIStateBase, "register_criminal", "GTFO_Compass_Teammate_Panel_Setup", function(self, unit)
	if unit:base().is_local_player then
		return
	end

	if managers.hud._compass and unit then
		local key = unit:key()
		managers.hud._compass._teammate[key] = {
			unit = unit,
			panel = managers.hud._compass._panel:panel({
				visible = managers.hud._compass.settings.TeammateVisible,
				w = managers.hud._compass._spacing,
				h = managers.hud._compass._panel:h()
			})
		}

		local teammate_panel = managers.hud._compass._teammate[key].panel
		teammate_panel:set_center(managers.hud._compass._center_x, managers.hud._compass._center_y)
		
		local teammate_rect = teammate_panel:rect({ -- team dots
			name = "compass_teammate_rect",
			visible = not managers.hud._compass.settings.TeammateIcon,
			w = managers.hud._compass.settings.TeamIndicatorWidth * managers.hud._compass.settings.Scale,
			h = managers.hud._compass._teammate_height  * managers.hud._compass.settings.Scale
		})

		local teammate_icon = teammate_panel:bitmap({ -- team icons
			name = "compass_teammate_icon",
			visible = managers.hud._compass.settings.TeammateIcon,
			w = 32 * 0.6 * managers.hud._compass.settings.Scale,
			h = 32 * 0.6 * managers.hud._compass.settings.Scale
		})
		
		teammate_rect:set_center_x(teammate_panel:w() / 2)
		teammate_rect:set_bottom(teammate_panel:center_y())
		teammate_rect:set_color(tweak_data.chat_colors[#tweak_data.chat_colors]) -- very hacky fix for teamai dots being white sometimes

		teammate_icon:set_center_x(teammate_panel:w() / 2)
		teammate_icon:set_bottom(teammate_panel:center_y())
		teammate_icon:set_color(tweak_data.chat_colors[#tweak_data.chat_colors]) -- very hacky fix for teamai dots being white sometimes
	end
end)

Hooks:PostHook(GroupAIStateBase, "unregister_criminal", "GTFO_Compass_Teammate_Panel_Unsetup", function(self, unit)
	if unit:base().is_local_player then
		return
	end
	if managers.hud._compass and unit then
		local key = unit:key()
		local hud_panel = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN).panel
		if hud_panel and managers.hud._compass._teammate[key] then
			local data = managers.hud._compass._teammate[key]
			data.panel:set_visible(false)
			hud_panel:remove(data.panel)
			managers.hud._compass._teammate[key] = nil
		end
	end
end)