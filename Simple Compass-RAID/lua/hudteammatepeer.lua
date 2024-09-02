Hooks:PostHook(HUDTeammatePeer, "set_name", "GTFO_Compass_Set_Peer_Name_Color", function(self, name)
    local unit = managers.criminals:character_unit_by_peer_id(self._peer_id)
    if unit then
        local key = unit:key()
        local panel = managers.hud._compass._teammate[key] and managers.hud._compass._teammate[key].panel

        if panel then
            local color_id = managers.criminals:character_color_id_by_unit(unit)
            if WolfgangHUD then
                color_id = WolfgangHUD:character_color_id(unit, self._id)
            end
            local crim_color = tweak_data.chat_colors[color_id] or tweak_data.chat_colors[#tweak_data.chat_colors]
            panel:child("compass_teammate_rect"):set_color(crim_color)
            panel:child("compass_teammate_icon"):set_color(crim_color)
        end
    end
end)

Hooks:PostHook(HUDTeammatePeer, "set_nationality", "GTFO_Compass_Set_Ai_Name_Color", function(self, nationality)
    local unit = managers.criminals:character_unit_by_peer_id(self._peer_id)
    if unit then
        for k, v in pairs(managers.hud._compass._teammate) do
            if k == unit:key() then
                managers.hud._compass._teammate[k].nationality = nationality
                if managers.hud._compass.settings.TeammateIcon then
                    local panel = managers.hud._compass._teammate[k].panel
                    local icon = tweak_data.gui:get_full_gui_data("nationality_small_" .. nationality)
                    panel:child("compass_teammate_icon"):set_image(icon.texture, unpack(icon.texture_rect))
                end
                return
            end
        end
    end
end)