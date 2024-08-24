Hooks:PostHook(HUDTeammateAI, "set_name", "GTFO_Compass_Set_Ai_Name_Color", function(self, name)
    local unit = managers.criminals:character_unit_by_peer_id(self._peer_id)
    if unit then
        local key = unit:key()
        local panel = managers.hud._compass._teammate[key] and managers.hud._compass._teammate[key].panel
        panel:child("compass_teammate_rect"):set_color(tweak_data.chat_colors[#tweak_data.chat_colors])
    end
end)
