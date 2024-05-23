local wezterm = require 'wezterm'
local act = wezterm.action

require 'scrollback'

local config = {}

config.font = wezterm.font 'Hack'
config.font_size = 14

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- We switch between just an opacity and a background image based on whether we are fullscreen
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
  set_background(overrides, window:get_dimensions().is_full_screen)
  window:set_config_overrides(overrides)
end)

config.native_macos_fullscreen_mode = true
config.color_scheme = 'Catppuccin Mocha (Gogh)'

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
