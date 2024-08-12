_G.SimpleCompass = _G.SimpleCompass or class()
SimpleCompass.path = ModPath
SimpleCompass.data_path = SavePath .. "simple_compass.json"
SimpleCompass.default_settings = {
	HUDOffsetY = 0,
	TeamIndicatorWidth = 5,
	TeammateVisible = true
}
SimpleCompass.settings = clone(SimpleCompass.default_settings)

local level_offsets = {
	["radio_defense"] = 90
}

function SimpleCompass:init(panel)
	self:Load()
	self._panel = panel:panel({
		layer = 100,
		w = 500,
		h = 50
	})

	self._center_x = self._panel:w() / 2
	self._center_y = self._panel:h() / 2

	local indicator = self._panel:rect({
		color = Color.white,
		w = 3,
		h = 6
	})

	self._spacing = 35
	self._num = 15
	self._right_shift = 24 * self._spacing

	self._panel:set_center(panel:center_x(), panel:top() + 60 + self.settings.HUDOffsetY)
	indicator:set_center_x(self._panel:w() / 2)
	indicator:set_bottom(self._panel:h())
	self._teammate = {}
	self.criminals_num = 0

	for i = 0, 23 do
		local compass = self._panel:panel({
			name = "compass" .. tostring(i),
			w = self._spacing,
			h = self._panel:h()
		})

		compass:set_center(self._center_x, self._center_y)

		if i == 0 then
			self:set_direction_text(compass, "N")
		elseif i == 6 then
			self:set_direction_text(compass, "E")
		elseif i == 12 then
			self:set_direction_text(compass, "S")
		elseif i == 18 then
			self:set_direction_text(compass, "W")
		else
			local rect = compass:rect({
				color = Color.white,
				w = 1,
				h = 4
			})

			local text = compass:text({
				vertical = "center",
				valign = "bottom",
				align = "center",
				halign = "center",
				font = tweak_data.gui.fonts.din_compressed_outlined_20,
				text = tostring(i * self._num),
				font_size = 16,
			})

			rect:set_center_x(compass:w() / 2)
			rect:set_top(compass:center_y())
			text:set_center(rect:center_x(), rect:bottom() + 10)
		end
	end
end

function SimpleCompass:set_direction_text(panel, text)
	local rect = panel:rect({
		color = Color.yellow,
		w = 3,
		h = 4
	})

	local text_panel = panel:text({ -- N, S, E, W
		vertical = "center",
		valign = "bottom",
		align = "center",
		halign = "center",
		font = tweak_data.gui.fonts.din_compressed_outlined_20,
		color = Color.yellow,
		text = text,
		font_size = 18,
	})
	rect:set_center_x(panel:w() / 2)
	rect:set_top(panel:center_y())
	text_panel:set_center(rect:center_x(), rect:bottom() + 10)
end

function SimpleCompass:update(t, dt)
	local offset = managers.raid_job and level_offsets[managers.raid_job:current_job()] or 0
	local current_camera = managers.viewport:get_current_camera()
	if current_camera then
		local camera = current_camera
		local yaw = camera:rotation():yaw() - offset
		local camera_rot_x = yaw < 0 and yaw or yaw - 360

		for i = 0, 23 do
			local pos_x = self._spacing / self._num * camera_rot_x + i * self._spacing + self._center_x
			if pos_x > self._right_shift - 10 then
				pos_x = pos_x - self._right_shift
			elseif pos_x < -340 then
				pos_x = pos_x + 340 + self._panel:w()
			end

			local left_shift = -math.abs(self._center_x - pos_x)
			local pos_y = (left_shift < -self._spacing * 2 and (left_shift + self._spacing * 2) / 50 or 0) +
				self._center_y
			local compass_hud = self._panel:child("compass" .. tostring(i))
			compass_hud:set_center_x(pos_x)
			compass_hud:set_center_y(pos_y)
		end

		if self.settings.TeammateVisible then
			for _, data in pairs(self._teammate) do
				local look_at_x = camera_rot_x -
					Rotation:look_at(camera:position(), data.unit:position(), Vector3(0, 0, 1)):yaw() + offset
				local team_pos_x = self._spacing / self._num * look_at_x + self._center_x

				if team_pos_x > self._right_shift - 10 then
					team_pos_x = team_pos_x - self._right_shift
				elseif team_pos_x < -340 then
					team_pos_x = team_pos_x + 340 + self._panel:w()
				end

				local left_shift = -math.abs(self._center_x - team_pos_x)
				local team_pos_y = (left_shift < -self._spacing * 2 and (left_shift + self._spacing * 2) / 50 or 0) +
					self._center_y
				data.panel:set_center_x(team_pos_x)
				data.panel:set_center_y(team_pos_y)
			end
		end
	end
end

function SimpleCompass:set_teammate_panel_visible(value)
	if self._teammate then
		for _, data in pairs(self._teammate) do
			data.panel:set_visible(value)
		end
	end
end

function SimpleCompass:set_offset_y(value)
	local hud_panel = managers.hud:script(PlayerBase.INGAME_HUD_FULLSCREEN).panel
	self._panel:set_center(hud_panel:center_x(), hud_panel:top() + 60 + value)
end

function SimpleCompass:set_team_indicator_width(value)
	if self._teammate then
		for _, data in pairs(self._teammate) do
			data.panel:child("compass_teammate_rect"):set_width(value)
		end
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
