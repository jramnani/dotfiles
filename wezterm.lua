local wezterm = require 'wezterm'

local config = wezterm.config_builder()

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


-- Final
return config
