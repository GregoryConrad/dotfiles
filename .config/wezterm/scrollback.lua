local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'

wezterm.on('open-hx-with-scrollback', function(window, pane)
  local scrollback_text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

  local filename = os.tmpname()
  local f = io.open(filename, 'w+')
  f:write(scrollback_text)
  f:flush()
  f:close()

  local editor_command = { 'zsh', '--login', '-c', 'hx ' .. filename }
  local _, new_pane, _ = window:mux_window():spawn_tab { args = editor_command }
  new_pane:send_text('ge')

  -- Wait "enough" time for the editor to read the file before removing it.
  -- (Reading the file is asynchronous and not awaitable.)
  wezterm.sleep_ms(1000)
  os.remove(filename)
end)
