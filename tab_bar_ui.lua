local wezterm = require('wezterm')

local window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font({ family = "Roboto", weight = "Bold" }),

  -- The size of the font in the tab bar.
  -- Default to 10. on Windows but 12.0 on other systems
  font_size = 10.0,

  -- The overall color of the tab bar when the window is focused.
  active_titlebar_fg = '#000000',
  active_titlebar_bg = "#fbf2d8",
  -- The overall color of the tab bar when the window is not focused.
  --   (Don't quite understand it).
  inactive_titlebar_bg = "#333333",
  inactive_titlebar_fg = '#eeaaaa',

  inactive_titlebar_border_bottom = '#2b2042',
  active_titlebar_border_bottom = '#2b2042',

  button_fg = '#cccccc',
  button_bg = '#2b2042',

  button_hover_fg = '#ffffff',
  button_hover_bg = '#3b3052',
}

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = '<' --[[ utf8.char(0xe0b2) ]]

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = '>' --[[ utf8.char(0xe0b0) ]]

local tab_bar_style = {
  active_tab_left = wezterm.format {
    { Background = { Color = '#aa0000' } },
    { Foreground = { Color = '#2b2042' } },
    { Text = SOLID_LEFT_ARROW },
  },
  active_tab_right = wezterm.format {
    { Background = { Color = '#0b0022' } },
    { Foreground = { Color = '#2b2042' } },
    { Text = SOLID_RIGHT_ARROW },
  },
  inactive_tab_left = wezterm.format {
    { Background = { Color = '#0b0022' } },
    { Foreground = { Color = '#1b1032' } },
    { Text = SOLID_LEFT_ARROW },
  },
  inactive_tab_right = wezterm.format {
    { Background = { Color = '#0b0022' } },
    { Foreground = { Color = '#1b1032' } },
    { Text = SOLID_RIGHT_ARROW },
  },
}

local tab_bar = {
  -- The color of the strip that goes along the top of the window
  -- (does not apply when fancy tab bar is in use)
  background = '#f5f7ff',

  -- The active tab is the one that has focus in the window
  active_tab = {
    -- The color of the background area for the tab
    bg_color = "#cb4b16",
    -- The color of the text for the tab
    fg_color = '#fdf6e3',

    -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
    -- label shown for this tab.
    -- The default is "Normal"
    intensity = 'Normal',

    -- Specify whether you want "None", "Single" or "Double" underline for
    -- label shown for this tab.
    -- The default is "None"
    underline = 'None',

    -- Specify whether you want the text to be italic (true) or not (false)
    -- for this tab.  The default is false.
    italic = false,

    -- Specify whether you want the text to be rendered with strikethrough (true)
    -- or not for this tab.  The default is false.
    strikethrough = false,
  },

  inactive_tab = {
    fg_color = '#1c6d67',
    bg_color = "#fdf6e3",

    intensity = 'Half',
  },
}

return {
  window_frame = window_frame,
  tab_bar = tab_bar,
  tab_bar_style = tab_bar_style,
}
