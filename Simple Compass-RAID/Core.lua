_G.SimpleCompass = _G.SimpleCompass or class()
SimpleCompass.path = ModPath
SimpleCompass.data_path = SavePath .. "simple_compass.json"
SimpleCompass.default_settings = {
	HUDOffsetY = 0,
	TeamIndicatorWidth = 5,
	TeammateVisible = true,
	TeammateIcon = true,
	NumbersVisible = true,
	LettersVisible = true,
	LettersSecondaryVisible = true,
	ObjectivesVisible = true,
	ObjectivesColor = "white",
	ObjectivesIcons = true,
	ObjectivesWidth = 5,
	NumbersColor = "white",
	LettersColor = "yellow",
	LettersSecondaryColor = "light_red",
	Scale = 1,
	Alpha = 1,
	CurveCompass = false,
	UpdateFreq = 1
}
SimpleCompass.settings = clone(SimpleCompass.default_settings)
SimpleCompass.color_table = { -- gracefully stolen from WolfgangHUD with love
	{ color = '#FFFFFF', name = "white" },
	{ color = '#F2F250', name = "light_yellow" },
	{ color = '#F2C24E', name = "light_orange" },
	{ color = '#E55858', name = "light_red" },
	{ color = '#CC55CC', name = "light_purple" },
	{ color = '#00FF00', name = "light_green" },
	{ color = '#00FFFF', name = "light_blue" },
	{ color = '#BABABA', name = "light_gray" },
	{ color = '#FFFF00', name = "yellow" },
	{ color = '#FFA500', name = "orange" },
	{ color = '#FF0000', name = "red" },
	{ color = '#800080', name = "purple" },
	{ color = '#008000', name = "green" },
	{ color = '#0000FF', name = "blue" },
	{ color = '#808080', name = "gray" },
	{ color = '#000000', name = "black" }
}

local level_offsets = {
	["radio_defense"] = 90
}

function SimpleCompass:init(panel)
	self:Load()

	self._waypoints = {}
	self._teammate = {}
	self._spacing = 35 * self.settings.Scale
	self._num = 15
	self._right_shift = 24 * self._spacing
	self._objective_height = 10
	self._teammate_height = 5
	self._counter_i = 0
	self._counter_n = self.settings.UpdateFreq
	self._main_fontsize = 18 * self.settings.Scale
	self._main_font = Utils.GetFontBySize(self._main_fontsize, "din_compressed_outlined")
	self._secondary_fontsize = 16 * self.settings.Scale
	self._secondary_font = Utils.GetFontBySize(self._secondary_fontsize, "din_compressed_outlined")
	self._numbers_fontsize = 16 * self.settings.Scale
	self._numbers_font = Utils.GetFontBySize(self._numbers_fontsize, "din_compressed_outlined")

	self._panel = panel:panel({
		layer = 100,
		w = 500 * self.settings.Scale,
		h = 60 * self.settings.Scale,
		alpha = self.settings.Alpha
	})

	self._center_x = self._panel:w() / 2
	self._center_y = self._panel:h() / 2

	local indicator = self._panel:rect({ --player indicator
		color = Color.white,
		w = 3 * self.settings.Scale,
		h = 6 * self.settings.Scale
	})

	self._panel:set_center(panel:center_x(), panel:top() + 60 + self.settings.HUDOffsetY)
	indicator:set_center_x(self._panel:w() / 2)
	indicator:set_bottom(self._panel:h())-- + 5 * self.settings.Scale)

	for i = 0, 23 do
		local compass = self._panel:panel({
			name = "compass" .. tostring(i),
			w = self._spacing,
			h = self._panel:h()
		})

		compass:set_center(self._center_x, self._center_y)

		if i == 0 and self.settings.LettersVisible then
			self:set_direction_text_main(compass, "N")
		elseif i == 3 and self.settings.LettersSecondaryVisible then
			self:set_direction_text_secondary(compass, "NE")
		elseif i == 6 and self.settings.LettersVisible then
			self:set_direction_text_main(compass, "E")
		elseif i == 9 and self.settings.LettersSecondaryVisible then
			self:set_direction_text_secondary(compass, "SE")
		elseif i == 12 and self.settings.LettersVisible then
			self:set_direction_text_main(compass, "S")
		elseif i == 15 and self.settings.LettersSecondaryVisible then
			self:set_direction_text_secondary(compass, "SW")
		elseif i == 18 and self.settings.LettersVisible then
			self:set_direction_text_main(compass, "W")
		elseif i == 21 and self.settings.LettersSecondaryVisible then
			self:set_direction_text_secondary(compass, "NW")
		else
			local rect = compass:rect({
				name = "compass_number_rect",
				color = Color:from_hex(self:get_color(self.settings.NumbersColor)),
				w = 1,
				h = 4 * self.settings.Scale
			})
			local text = compass:text({
				name = "compass_number",
				vertical = "center",
				valign = "bottom",
				align = "center",
				halign = "center",
				color = Color:from_hex(self:get_color(self.settings.NumbersColor)),
				font = self._numbers_font,
				text = tostring(i * self._num),
				font_size = self._numbers_fontsize,
				visible = self.settings.NumbersVisible
			})

			rect:set_center_x(compass:w() / 2)
			rect:set_top(self._center_y)
			text:set_center(rect:center_x(), rect:bottom() + 10 * self.settings.Scale)
		end
	end
end

function SimpleCompass:set_direction_text_main(panel, text)
	local rect = panel:rect({
		name = "compass_letter_main_rect",
		color = Color:from_hex(self:get_color(self.settings.LettersColor)),
		w = 3 ,
		h = 4 * self.settings.Scale
	})

	local text_panel = panel:text({ -- N, S, E, W
		name = "compass_letter_main",
		vertical = "center",
		valign = "bottom",
		align = "center",
		halign = "center",
		font = self._main_font,
		color = Color:from_hex(self:get_color(self.settings.LettersColor)),
		text = text,
		font_size = self._main_fontsize,
		visible = self.settings.LettersVisible
	})
	rect:set_center_x(panel:w() / 2)
	rect:set_top(self._center_y)
	text_panel:set_center(rect:center_x(), rect:bottom() + 10 * self.settings.Scale)
end

function SimpleCompass:set_direction_text_secondary(panel, text)
	local rect = panel:rect({
		name = "compass_letter_secondary_rect",
		color = Color:from_hex(self:get_color(self.settings.LettersSecondaryColor)),
		w = 2,
		h = 4 * self.settings.Scale
	})

	local text_panel = panel:text({ -- NW, NE, SW, SE
		name = "compass_letter_secondary",
		vertical = "center",
		valign = "bottom",
		align = "center",
		halign = "center",
		font = self._secondary_font,
		color = Color:from_hex(self:get_color(self.settings.LettersSecondaryColor)),
		text = text,
		font_size = self._secondary_fontsize,
		visible = self.settings.LettersSecondaryVisible
	})
	rect:set_center_x(panel:w() / 2)
	rect:set_top(self._center_y)
	text_panel:set_center(rect:center_x(), rect:bottom() + 10 * self.settings.Scale)
end

function SimpleCompass:update(t, dt)
	local offset = managers.raid_job and level_offsets[managers.raid_job:current_job_id()] or 0
	local current_camera = managers.viewport:get_current_camera()
	if self._counter_n == self._counter_i then
		self._counter_i = 0
		if current_camera then
			local camera = current_camera
			local yaw = camera:rotation():yaw() - offset
			local camera_rot_x = yaw < 0 and yaw or yaw - 360

			for i = 0, 23 do
				local pos_x = self._spacing / self._num * camera_rot_x + i * self._spacing + self._center_x
				if pos_x > self._right_shift - 10 then
					pos_x = pos_x - self._right_shift
				elseif pos_x < -340 * self.settings.Scale then
					pos_x = pos_x + 340 * self.settings.Scale + self._panel:w()
				end

				local left_shift = -math.abs(self._center_x - pos_x) * self.settings.Scale
				local pos_y = (left_shift < -self._spacing * 2 and self.settings.CurveCompass and (left_shift + self._spacing * 2) / 50 or 0) + self._center_y
				local compass_hud = self._panel:child("compass" .. tostring(i))
				compass_hud:set_center_x(pos_x)
				compass_hud:set_center_y(pos_y)
			end

			if self.settings.TeammateVisible then
				for _, data in pairs(self._teammate) do --
					local look_at_x = camera_rot_x -
						Rotation:look_at(camera:position(), data.unit:position(), Vector3(0, 0, 1)):yaw() + offset
					local team_pos_x = self._spacing / self._num * look_at_x + self._center_x

					if team_pos_x > self._right_shift - 10 then
						team_pos_x = team_pos_x - self._right_shift
					elseif team_pos_x < -340 * self.settings.Scale then
						team_pos_x = team_pos_x + 340 * self.settings.Scale + self._panel:w()
					end

					local left_shift = -math.abs(self._center_x - team_pos_x) * self.settings.Scale
					local team_pos_y = (left_shift < -self._spacing * 2 and self.settings.CurveCompass and (left_shift + self._spacing * 2) / 50 or 0) + self._center_y
					data.panel:set_center_x(team_pos_x)
					data.panel:set_center_y(team_pos_y)
				end
			end

			if self.settings.ObjectivesVisible then
				for _, data in pairs(self._waypoints) do --
					local look_at_x = camera_rot_x -
						Rotation:look_at(camera:position(), data.pos, Vector3(0, 0, 1)):yaw() + offset
					local obj_pos_x = self._spacing / self._num * look_at_x + self._center_x

					if obj_pos_x > self._right_shift - 10 then
						obj_pos_x = obj_pos_x - self._right_shift
					elseif obj_pos_x < -340 * self.settings.Scale then
						obj_pos_x = obj_pos_x + 340 * self.settings.Scale + self._panel:w()
					end

					local left_shift = -math.abs(self._center_x - obj_pos_x) * self.settings.Scale
					local obj_pos_y = (left_shift < -self._spacing * 2 and self.settings.CurveCompass and (left_shift + self._spacing * 2) / 50 or 0) + self._center_y
					data.panel:set_center_x(obj_pos_x)
					data.panel:set_center_y(obj_pos_y)
				end
			end
		end
	end
	self._counter_i = self._counter_i + 1
end

function SimpleCompass:set_teammate_panel_visible(value)
	if self._teammate then
		for _, data in ipairs(self._teammate) do
			data.panel:set_visible(value)
		end
	end
end

function SimpleCompass:set_numbers_visible(value)
	local list = {1, 2, 4, 5, 7, 8, 10, 11, 13, 14, 16, 17, 19, 20, 22, 23}
	for _, i in ipairs(list) do
		local compass_hud = self._panel:child("compass" .. i):child("compass_number")
		if compass_hud then
			compass_hud:set_visible(value)
		end
	end
end

function SimpleCompass:set_numbers_color(value)
	local list = {1, 2, 4, 5, 7, 8, 10, 11, 13, 14, 16, 17, 19, 20, 22, 23}
	for _, i in ipairs(list) do
		local compass_hud = self._panel:child("compass" .. i):child("compass_number")
		if compass_hud then
			compass_hud:set_color(Color:from_hex(self:get_color(value)))
		end
		local compass_hud = self._panel:child("compass" .. i):child("compass_number_rect")
		if compass_hud then
			compass_hud:set_color(Color:from_hex(self:get_color(value)))
		end
	end
end

function SimpleCompass:set_letters_main_color(value)
	local list = {0, 6, 12, 18}
	for _, i in ipairs(list) do
		local compass_hud = self._panel:child("compass" .. i):child("compass_letter_main")
		if compass_hud then
			compass_hud:set_color(Color:from_hex(self:get_color(value)))
		end
		local compass_hud = self._panel:child("compass" .. i):child("compass_letter_main_rect")
		if compass_hud then
			compass_hud:set_color(Color:from_hex(self:get_color(value)))
		end
	end
end

function SimpleCompass:set_letters_secondary_color(value)
	local list = {3, 9, 15, 21}
	for _, i in ipairs(list) do
		local compass_hud = self._panel:child("compass" .. i):child("compass_letter_secondary")
		if compass_hud then
			compass_hud:set_color(Color:from_hex(self:get_color(value)))
		end
		local compass_hud = self._panel:child("compass" .. i):child("compass_letter_secondary_rect")
		if compass_hud then
			compass_hud:set_color(Color:from_hex(self:get_color(value)))
		end
	end
end

function SimpleCompass:set_letters_secondary_visible(value)
	local list = {3, 9, 15, 21}
	for _, i in ipairs(list) do
		local compass_hud = self._panel:child("compass" .. i):child("compass_letter_secondary")
		if compass_hud then
			compass_hud:set_visible(value)
		end
	end
end

function SimpleCompass:set_letters_main_visible(value)
	local list = {0, 6, 12, 18}
	for _, i in ipairs(list) do
		local compass_hud = self._panel:child("compass" .. i):child("compass_letter_main")
		if compass_hud then
			compass_hud:set_color(Color:from_hex(self:get_color(value)))
		end
		local compass_hud = self._panel:child("compass" .. i):child("compass_letter_main_rect")
		if compass_hud then
			compass_hud:set_color(Color:from_hex(self:get_color(value)))
		end
	end
end

function SimpleCompass:set_offset_y(value)
	local hud_panel = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN).panel
	self._panel:set_center(hud_panel:center_x(), hud_panel:top() + 60 + value)
end

function SimpleCompass:set_team_indicator_width(value)
	if self._teammate then
		for _, data in ipairs(self._teammate) do
			data.panel:child("compass_teammate_rect"):set_width(value * self.settings.Scale)
		end
	end
end

function SimpleCompass:get_color(color_name)
	local color = "#000000"
	if color_name and color_name ~= "" then
		for _, v in ipairs(self.color_table) do
			if v.name == color_name then
				return v.color
			end
		end
	end
	return color
end

function SimpleCompass:set_compass_alpha(value)
	if self._panel then
		self._panel:set_alpha(value)
	end
end

function SimpleCompass:Load()
	local file = io.open(self.data_path, "r")
	if file then
		local options = json.decode(file:read("*all"))
		for key, ops in pairs(options) do
			self.settings[key] = ops
		end
		file:close()
	end
end

function SimpleCompass:Save()
	local file = io.open(self.data_path, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function SimpleCompass:_remove_waypoint(id)
	if id then
		local hud_panel = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN).panel
		if hud_panel and self._waypoints[id] then
			local data = self._waypoints[id]
			data.panel:set_visible(false)
			hud_panel:remove(data.panel)
			self._waypoints[id] = nil
		end
	end
end

function SimpleCompass:_add_waypoint(id, data)
	if id and data then
		if self._waypoints[id] then
			self:_remove_waypoint(id)
		end
		local icon, texture_rect, _ = managers.hud:_get_raid_icon(data.icon)
		self._waypoints[id] = {
			pos = data.position,
			id = id,
			icon = icon,
			texture_rect =  texture_rect,
			panel = self._panel:panel({
				visible = self.settings.ObjectivesVisible,
				w = self._spacing,
				h = self._panel:h()
			})
		}

		local objective_panel = self._waypoints[id].panel
		local objective_rect
		objective_panel:set_center(self._center_x, self._center_y)
		if self.settings.ObjectivesIcons then
			objective_rect = objective_panel:bitmap({ -- 
				name = "compass_objective_rect",
				texture = icon,
				texture_rect = texture_rect,
				w = texture_rect[3] * 0.6 * self.settings.Scale,
				h = texture_rect[4] * 0.6 * self.settings.Scale
			})
		else
			objective_rect = objective_panel:rect({ -- 
				name = "compass_objective_rect",
				w = self.settings.ObjectivesWidth * self.settings.Scale,
				h = self._objective_height  * self.settings.Scale
			})
		end
		objective_rect:set_center_x(objective_panel:w() / 2)
		objective_rect:set_bottom(objective_panel:center_y())
		objective_rect:set_color(Color:from_hex(self:get_color(self.settings.ObjectivesColor)))
	end
end

function SimpleCompass:set_objectives_indicator_width(value)
	if self._waypoints and not self.settings.ObjectivesIcons then
		for _, data in ipairs(self._waypoints) do
			data.panel:child("compass_objective_rect"):set_width(value * self.settings.Scale)
		end
	end
end

function SimpleCompass:set_objectives_color(value)
	if self._waypoints then
		for _, data in ipairs(self._waypoints) do
			data.panel:child("compass_objective_rect"):set_color(Color:from_hex(self:get_color(value)))
		end
	end
end

function SimpleCompass:set_objectives_visible(value)
	if self._waypoints then
		for _, data in ipairs(self._waypoints) do
			data.panel:set_visible(value)
		end
	end
end