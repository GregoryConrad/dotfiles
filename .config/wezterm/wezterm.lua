local wezterm = require 'wezterm'
local act = wezterm.action

require 'scrollback'

local config = wezterm.config_builder()
config:set_strict_mode(true)

config.font = wezterm.font 'Hack'
config.font_size = 14
config.color_scheme = 'Catppuccin Mocha (Gogh)'
config.colors = {
  split = wezterm.color.get_builtin_schemes()[config.color_scheme].ansi[2],
}

local TITLEBAR_COLOR = '#333333'
config.native_macos_fullscreen_mode = true
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_frame = {
  font = wezterm.font { family = 'Hack', weight = 'Bold' },
  font_size = 13.0,
  active_titlebar_bg = TITLEBAR_COLOR,
  inactive_titlebar_bg = TITLEBAR_COLOR,
}

-- Switch between just an opacity and a background image based on whether we are fullscreen
function set_background(config, is_fullscreen)
  if is_fullscreen then
    config.window_background_opacity = nil
    config.background = {
      {
        source = {
          File = wezterm.home_dir .. '/.config/background.jpg',
        },
        attachment = { Parallax = 0.1 },
        repeat_y = 'Mirror',
        horizontal_align = 'Center',
        opacity = 0.4,
        hsb = {
          hue = 1.0,
          saturation = 0.95,
          brightness = 0.5,
        },
      },
    }
  else
    config.window_background_opacity = 0.85
    config.background = nil
  end
end

wezterm.on('window-resized', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local is_fullscreen = window:get_dimensions().is_full_screen
  set_background(overrides, is_fullscreen)
  window:set_config_overrides(overrides)
end)

wezterm.on('update-status', function(window, pane)
  local cells = {}

  -- Figure out the hostname of the pane on a best-effort basis
  local hostname = wezterm.hostname()
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri and cwd_uri.host then
    hostname = cwd_uri.host
  end
  table.insert(cells, ' ' .. hostname)

  -- Format date/time in this style: "Wed Mar 3 08:14"
  local date = wezterm.strftime ' %a %b %-d %H:%M'
  table.insert(cells, date)

  -- Add an entry for each battery (typically 0 or 1)
  local batt_icons = {'', '', '', '', ''}
  for _, b in ipairs(wezterm.battery_info()) do
    local curr_batt_icon = batt_icons[math.ceil(b.state_of_charge * #batt_icons)]
    table.insert(cells, string.format('%s %.0f%%', curr_batt_icon, b.state_of_charge * 100))
  end

  -- Color palette for each cell
  local text_fg = '#c0c0c0'
  local colors = {
    TITLEBAR_COLOR,
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  local elements = {}
  while #cells > 0 and #colors > 1 do
    local text = table.remove(cells, 1)
    local prev_color = table.remove(colors, 1)
    local curr_color = colors[1]

    table.insert(elements, { Background = { Color = prev_color } })
    table.insert(elements, { Foreground = { Color = curr_color } })
    table.insert(elements, { Text = '' })
    table.insert(elements, { Background = { Color = curr_color } })
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
  end
  window:set_right_status(wezterm.format(elements))
end)

config.keys = {
  { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen, },
  { key = 'q', mods = 'ALT', action = act.QuitApplication, },
  { key = 'o', mods = 'ALT', action = act.EmitEvent 'open-hx-with-scrollback', },

  { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left', },
  { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right', },
  { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down', },
  { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up', },

  { key = 'h', mods = 'SHIFT|ALT', action = act.AdjustPaneSize {'Left', 4}, },
  { key = 'l', mods = 'SHIFT|ALT', action = act.AdjustPaneSize {'Right', 4}, },
  { key = 'j', mods = 'SHIFT|ALT', action = act.AdjustPaneSize {'Down', 4}, },
  { key = 'k', mods = 'SHIFT|ALT', action = act.AdjustPaneSize {'Up', 4}, },

  { key = 'd', mods = 'ALT', action = act.SplitVertical, },
  { key = 'r', mods = 'ALT', action = act.SplitHorizontal, },

  { key = '[', mods = 'ALT', action = act.ActivateTabRelative(-1), },
  { key = ']', mods = 'ALT', action = act.ActivateTabRelative(1), },

  -- Floating panes (not implemented yet)
    -- bind "Alt w" { ToggleFloatingPanes; }
    -- bind "Alt e" { TogglePaneEmbedOrFloating; }
    -- bind "Alt b" { MovePaneBackwards; }

  -- Using defaults for tabs (CMD t, CMD 1-9)
  -- Using defaults for find (CMD f, CTRL-r to toggle case sensitivity & regex modes) 
}

return config
