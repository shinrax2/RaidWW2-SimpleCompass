SimpleCompassMenu = SimpleCompassMenu or class(BLTMenu)

function SimpleCompassMenu:Init(root)
    SimpleCompass:Load()
    local color_select_items = {
        { text = managers.localization:text("menu_simple_compass_color_white"), value = "white"},
        { text = managers.localization:text("menu_simple_compass_color_light_yellow"), value = "light_yellow"},
        { text = managers.localization:text("menu_simple_compass_color_light_orange"), value = "light_orange"},
        { text = managers.localization:text("menu_simple_compass_color_light_red"), value = "light_red"},
        { text = managers.localization:text("menu_simple_compass_color_light_purple"), value = "light_purple"},
        { text = managers.localization:text("menu_simple_compass_color_light_green"), value = "light_green"},
        { text = managers.localization:text("menu_simple_compass_color_light_blue"), value = "light_blue"},
        { text = managers.localization:text("menu_simple_compass_color_light_gray"), value = "light_gray"},
        { text = managers.localization:text("menu_simple_compass_color_yellow"), value = "yellow"},
        { text = managers.localization:text("menu_simple_compass_color_orange"), value = "orange"},
        { text = managers.localization:text("menu_simple_compass_color_red"), value = "red"},
        { text = managers.localization:text("menu_simple_compass_color_purple"), value = "purple"},
        { text = managers.localization:text("menu_simple_compass_color_green"), value = "green"},
        { text = managers.localization:text("menu_simple_compass_color_blue"), value = "blue"},
        { text = managers.localization:text("menu_simple_compass_color_gray"), value = "gray"},
        { text = managers.localization:text("menu_simple_compass_color_black"), value = "black"}
    }
    self:Title({
        text = "menu_simple_compass_title"
    })
    self:Slider({
        name = "scale",
        text = "menu_simple_compass_scale",
        value = SimpleCompass.settings.Scale,
        min = 0.5,
        max = 5,
        value_format = "%.1f",
        callback = callback(self, self, "scale"),
        desc = "menu_simple_compass_scale_desc"
    })
    self:Slider({
        name = "alpha",
        text = "menu_simple_compass_alpha",
        value = SimpleCompass.settings.Alpha,
        min = 0.3,
        max = 1,
        value_format = "%.1f",
        callback = callback(self, self, "alpha"),
        desc = "menu_simple_compass_alpha_desc"
    })
    self:Slider({
        name = "offset_y",
        text = "menu_simple_compass_offset_y",
        value = SimpleCompass.settings.HUDOffsetY,
        min = -120,
        max = 2000,
        value_format = "%.0f",
        callback = callback(self, self, "offset_y"),
        desc = "menu_simple_compass_offset_y_desc"
    })
    self:Toggle({
        name = "numbers_visible",
        text = "menu_simple_compass_numbers_visible",
        value = SimpleCompass.settings.NumbersVisible,
        callback = callback(self, self, "numbers_visible"),
        desc = "menu_simple_compass_numbers_visible_desc"
    })
    self:MultiChoice({
        name = "numbers_color",
        text = "menu_simple_compass_numbers_color",
        callback = callback(self, self, "numbers_color"),
        value = SimpleCompass.settings.NumbersColor,
        items = color_select_items,
        desc = "menu_simple_compass_numbers_color_desc"
    })
    self:Toggle({
        name = "letters_visible",
        text = "menu_simple_compass_letters_visible",
        value = SimpleCompass.settings.LettersVisible,
        callback = callback(self, self, "letters_visible"),
        desc = "menu_simple_compass_letters_visible_desc"
    })
    self:MultiChoice({
        name = "letters_color",
        text = "menu_simple_compass_letters_color",
        callback = callback(self, self, "letters_color"),
        value = SimpleCompass.settings.LettersColor,
        items = color_select_items,
        desc = "menu_simple_compass_letters_color_desc"
    })
    self:Toggle({
        name = "letters_secondary_visible",
        text = "menu_simple_compass_letters_secondary_visible",
        value = SimpleCompass.settings.LettersSecondaryVisible,
        callback = callback(self, self, "letters_secondary_visible"),
        desc = "menu_simple_compass_letters_secondary_visible_desc"
    })
    self:MultiChoice({
        name = "letters_secondary_color",
        text = "menu_simple_compass_letters_secondary_color",
        callback = callback(self, self, "letters_secondary_color"),
        value = SimpleCompass.settings.LettersSecondaryColor,
        items = color_select_items,
        desc = "menu_simple_compass_letters_secondary_color_desc"
    })
    self:Toggle({
        name = "teammate_visible",
        text = "menu_simple_compass_teammate_visible",
        value = SimpleCompass.settings.TeammateVisible,
        callback = callback(self, self, "teammate_visible"),
        desc = "menu_simple_compass_teammate_visible_desc"
    })
    self:Toggle({
        name = "teammate_icon",
        text = "menu_simple_compass_teammate_icon",
        value = SimpleCompass.settings.TeammateIcon,
        callback = callback(self, self, "teammate_icon"),
        desc = "menu_simple_compass_teammate_icon_desc"
    })
    self:Slider({
        name = "teammate_indicator_width",
        text = "menu_simple_compass_team_indicator_width",
        value = SimpleCompass.settings.TeamIndicatorWidth,
        min = 1,
        max = 10,
        value_format = "%.0f",
        callback = callback(self, self, "team_indicator_width"),
        desc = "menu_simple_compass_team_indicator_width_desc"
    })
    self:Toggle({
        name = "objectives_visible",
        text = "menu_simple_compass_objectives_visible",
        value = SimpleCompass.settings.ObjectivesVisible,
        callback = callback(self, self, "objectives_visible"),
        desc = "menu_simple_compass_objectives_visible_desc"
    })
    self:Toggle({
        name = "objectives_icons",
        text = "menu_simple_compass_objectives_icons",
        value = SimpleCompass.settings.ObjectivesIcons,
        callback = callback(self, self, "objectives_icons"),
        desc = "menu_simple_compass_objectives_icons_desc"
    })
    self:Slider({
        name = "objectives_indicator_width",
        text = "menu_simple_compass_objectives_indicator_width",
        value = SimpleCompass.settings.ObjectivesWidth,
        min = 1,
        max = 10,
        value_format = "%.0f",
        callback = callback(self, self, "objectives_indicator_width"),
        desc = "menu_simple_compass_objectives_indicator_width_desc"
    })
    self:MultiChoice({
        name = "objectives_color",
        text = "menu_simple_compass_objectives_color",
        callback = callback(self, self, "objectives_color"),
        value = SimpleCompass.settings.ObjectivesColor,
        items = color_select_items,
        desc = "menu_simple_compass_objectives_color_desc"
    })
    self:LongRoundedButton2({
		name = "reset",
		text = "menu_simple_compass_reset",
		callback = callback(self, self, "Reset"),
		ignore_align = true,
		y = 832,
		x = 1472
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

function SimpleCompassMenu:letters_visible(value)
    SimpleCompass.settings.LettersVisible = value
    if managers.hud then
        managers.hud._compass:set_letters_main_visible(value)
    end
end

function SimpleCompassMenu:letters_color(selected, item)
    SimpleCompass.settings.LettersColor = selected.value
    if managers.hud then
        managers.hud._compass:set_letters_main_color(selected.value)
    end
end

function SimpleCompassMenu:letters_secondary_visible(value)
    SimpleCompass.settings.LettersSecondaryVisible = value
    if managers.hud then
        managers.hud._compass:set_letters_secondary_visible(value)
    end
end

function SimpleCompassMenu:letters_secondary_color(selected, item)
    SimpleCompass.settings.LettersSecondaryColor = selected.value
    if managers.hud then
        managers.hud._compass:set_letters_secondary_color(selected.value)
    end
end

function SimpleCompassMenu:numbers_visible(value)
    SimpleCompass.settings.NumbersVisible = value
    if managers.hud then
        managers.hud._compass:set_numbers_visible(value)
    end
end

function SimpleCompassMenu:numbers_color(selected, item)
    SimpleCompass.settings.NumbersColor = selected.value
    if managers.hud then
        managers.hud._compass:set_numbers_color(selected.value)
    end
end

function SimpleCompassMenu:offset_y(value)
    SimpleCompass.settings.HUDOffsetY = value
    if managers.hud then
        managers.hud._compass:set_offset_y(value)
    end
end

function SimpleCompassMenu:scale(value)
    SimpleCompass.settings.Scale = value
end

function SimpleCompassMenu:alpha(value)
    SimpleCompass.settings.Alpha = value
    if managers.hud then
        managers.hud._compass:set_compass_alpha(value)
    end
end

function SimpleCompassMenu:team_indicator_width(value)
    SimpleCompass.settings.TeamIndicatorWidth = value
    if managers.hud then
        managers.hud._compass:set_team_indicator_width(value)
    end
end

function SimpleCompassMenu:objectives_visible(value)
    SimpleCompass.settings.ObjectivesVisible = value
    if managers.hud then
        managers.hud._compass:set_objectives_visible(value)
    end
end

function SimpleCompassMenu:objectives_indicator_width(value)
    SimpleCompass.settings.ObjectivesWidth = value
    if managers.hud then
        managers.hud._compass:set_objectives_indicator_width(value)
    end
end

function SimpleCompassMenu:objectives_color(selected, item)
    SimpleCompass.settings.ObjectivesColor = selected.value
    if managers.hud then
        managers.hud._compass:set_objectives_color(selected.value)
    end
end

function SimpleCompassMenu:objectives_icons(value)
    SimpleCompass.settings.ObjectivesIcons = value
end

function SimpleCompassMenu:teammate_icon(value)
    SimpleCompass.settings.TeammateIcon = value
end

function SimpleCompassMenu:Reset(value, item)
	QuickMenu:new(
		managers.localization:text("menu_simple_compass_reset"),
		managers.localization:text("menu_simple_compass_reset_confirm"),
		{
			[1] = {
				text = managers.localization:text("dialog_no"),
				is_cancel_button = true,
			},
			[2] = {
				text = managers.localization:text("dialog_yes"),
				callback = function()
                    SimpleCompass.settings = clone(SimpleCompass.default_settings)
                    SimpleCompass:Save()
                    self:teammate_visible(SimpleCompass.settings.TeammateVisible)
                    self:team_indicator_width(SimpleCompass.settings.TeamIndicatorWidth)
                    self:offset_y(SimpleCompass.settings.HUDOffsetY)
                    self:letters_visible(SimpleCompass.settings.LettersVisible)
                    self:letters_secondary_visible(SimpleCompass.settings.LettersSecondaryVisible)
                    self:numbers_visible(SimpleCompass.settings.NumbersVisible)
                    self:numbers_color({value = SimpleCompass.settings.NumbersColor})
                    self:letters_secondary_color({value = SimpleCompass.settings.LettersSecondaryColor})
                    self:letters_color({value = SimpleCompass.settings.LettersColor})
                    self:scale(SimpleCompass.settings.Scale)
                    self:alpha(SimpleCompass.settings.Alpha)
                    self:objectives_color({value = SimpleCompass.settings.ObjectivesColor})
                    self:objectives_indicator_width(SimpleCompass.settings.ObjectivesWidth)
                    self:objectives_visible(SimpleCompass.settings.ObjectivesVisible)
                    self:objectives_icons(SimpleCompass.settings.ObjectivesIcons)
                    self:teammate_icon(SimpleCompass.settings.TeammateIcon)
                    self:ReloadMenu()
				end,
			},
		},
		true
	)
end

Hooks:Add("MenuComponentManagerInitialize", "SimpleCompass.MenuComponentManagerInitialize", function(self)
	RaidMenuHelper:CreateMenu({
		name = "SimpleCompass_options",
		name_id = "menu_simple_compass_title",
		inject_menu = "blt_options",
		class = SimpleCompassMenu
	})
end)