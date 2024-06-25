SimpleCompassMenu = SimpleCompassMenu or class(BLTMenu)

function SimpleCompassMenu:Init(root)
    SimpleCompass:Load()
    self:Title({
        text = "menu_simple_compass_title"
    })
    self:Toggle({
        name = "teammate_visible",
        text = "menu_simple_compass_teammate_visible",
        value = SimpleCompass.settings.TeammateVisible,
        callback = callback(self, self, "teammate_visible")
    })
    self:Slider({
        name = "offset_y",
        text = "menu_simple_compass_offset_y",
        value = SimpleCompass.settings.HUDOffsetY,
        min = -100,
        max = 1000,
        step = 1,
        callback = callback(self, self, "offset_y")
    })
    self:Slider({
        name = "teammate_indicator_width",
        text = "menu_simple_compass_team_indicator_width",
        value = SimpleCompass.settings.TeamIndicatorWidth,
        min = 1,
        max = 10,
        step = 1,
        callback = callback(self, self, "team_indicator_width")
    })
end

function SimpleCompassMenu:Close()
    SimpleCompass:Save()
end

function SimpleCompassMenu:teammate_visible(value)
    SimpleCompass.settings.TeammateVisible = value
    if managers.hud then
        managers.hud._compass:set_teammate_panel_visible(value)
    end
end

function SimpleCompassMenu:offset_y(value)
    SimpleCompass.settings.HUDOffsetY = value
    if managers.hud then
        managers.hud._compass:set_offset_y(value)
    end
end

function SimpleCompassMenu:team_indicator_width(value)
    SimpleCompass.settings.TeamIndicatorWidth = value
    if managers.hud then
        managers.hud._compass:set_team_indicator_width(value)
    end
end

Hooks:Add("MenuComponentManagerInitialize", "SimpleCompass.MenuComponentManagerInitialize", function(self)
	RaidMenuHelper:CreateMenu({
		name = "SimpleCompass_options",
		name_id = "menu_simple_compass_title",
		inject_menu = "blt_options",
		class = SimpleCompassMenu
	})
end)