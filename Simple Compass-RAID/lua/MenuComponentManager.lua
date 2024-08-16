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
        callback = callback(self, self, "teammate_visible"),
        desc = "menu_simple_compass_teammate_visible_desc"
    })
    self:Toggle({
        name = "numbers_visible",
        text = "menu_simple_compass_numbers_visible",
        value = SimpleCompass.settings.NumbersVisible,
        callback = callback(self, self, "numbers_visible"),
        desc = "menu_simple_compass_numbers_visible_desc"
    })
    self:Toggle({
        name = "letters_visible",
        text = "menu_simple_compass_letters_visible",
        value = SimpleCompass.settings.LettersVisible,
        callback = callback(self, self, "letters_visible"),
        desc = "menu_simple_compass_letters_visible_desc"
    })
    self:Slider({
        name = "offset_y",
        text = "menu_simple_compass_offset_y",
        value = SimpleCompass.settings.HUDOffsetY,
        min = -100,
        max = 1000,
        value_format = "%.0f",
        callback = callback(self, self, "offset_y"),
        desc = "menu_simple_compass_offset_y_desc"
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
    self:LongRoundedButton2({
		name = "reset",
		text = "menu_simple_compass_reset",
		callback = callback(self, self, "Reset"),
		ignore_align = true,
		y = 832,
		x = 1472,
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
        managers.hud._compass:set_letters_visible(value)
    end
end
function SimpleCompassMenu:numbers_visible(value)
SimpleCompass.settings.NumbersVisible = value
if managers.hud then
    managers.hud._compass:set_numbers_visible(value)
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
                    self:ReloadMenu()
                    SimpleCompass:Save()
                    self:teammate_visible(SimpleCompass.settings.TeammateVisible)
                    self:team_indicator_width(SimpleCompass.settings.TeamIndicatorWidth)
                    self:offset_y(SimpleCompass.settings.HUDOffsetY)
                    self:letters_visible(SimpleCompass.settings.LettersVisible)
                    self:numbers_visible(SimpleCompass.settings.NumbersVisible)
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