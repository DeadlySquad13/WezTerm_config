local wezterm = require('wezterm')

local windows_items = require('launch_menu.windows_items')
local unix_items = require('launch_menu.unix_items')

local launch_menu = {}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- Can't get wsl items here for some reason.
  --   Seems like a problem with spawning process.
  for _, item in ipairs(windows_items) do
    table.insert(launch_menu, item)
  end
else
  for _, item in ipairs(unix_items) do
    table.insert(launch_menu, item)
  end
end


return launch_menu
