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

if (is_linux) then
  config.keys = {
    {
      key = '1',
      mods = 'ALT',
      action = wezterm.action.ActivateTab(0)
    },
    {
      key = '2',
      mods = 'ALT',
      action = wezterm.action.ActivateTab(1)
    },
    {
      key = '3',
      mods = 'ALT',
      action = wezterm.action.ActivateTab(2)
    },
    {
      key = '4',
      mods = 'ALT',
      action = wezterm.action.ActivateTab(3)
    },
    {
      key = '5',
      mods = 'ALT',
      action = wezterm.action.ActivateTab(4)
    },
    {
      key = '6',
      mods = 'ALT',
      action = wezterm.action.ActivateTab(5)
    },
    {
      key = '7',
      mods = 'ALT',
      action = wezterm.action.ActivateTab(6)
    },
    {
      key = '8',
      mods = 'ALT',
      action = wezterm.action.ActivateTab(7)
    },
    {
      key = '9',
      mods = 'ALT',
      action = wezterm.action.ActivateTab(-1)
    },
  }
end

-- Final
return config
