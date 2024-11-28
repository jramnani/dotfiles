local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- https://github.com/wez/wezterm/discussions/4728
local is_darwin <const> = wezterm.target_triple:find("darwin") ~= nil
local is_linux <const> = wezterm.target_triple:find("linux") ~= nil


-- Color
config.color_scheme = 'Solarized (dark) (terminal.sexy)'


-- Font
config.font = wezterm.font_with_fallback {
  'Source Code Pro',
  'Inconsolata',
  'JetBrains Mono',
}
config.font_size = 14.0


-- Scrolling
config.scrollback_lines = 10000
config.enable_scroll_bar = true


-- Key bindings
config.keys = {
  {
    key = 'LeftArrow',
    mods = 'CMD|SHIFT',
    action = wezterm.action.MoveTabRelative(-1)
  },
  {
    key = 'RightArrow',
    mods = 'CMD|SHIFT',
    action = wezterm.action.MoveTabRelative(1)
  },
}


-- Final
return config
