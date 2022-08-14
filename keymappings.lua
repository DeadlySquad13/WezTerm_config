local leader_keymappings = {
  -- * Window management.
  {
    key = "d",
    action = wezterm.action.CloseCurrentTab({ confirm = false }),
  },

  -- * Split management.
  {
    key = "v",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "s",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "x",
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },

  { key = 'Space', mods = 'LEADER', action = wezterm.action.ShowLauncher },
  {
    key = 'n',
    action = wezterm.action.ShowLauncherArgs({
      title = 'New Tab',

      flags = 'LAUNCH_MENU_ITEMS', -- Items from launch_menu options.
    })
  },

  -- - Navigation.

}

-- for i = 1,7 do
--   table.insert(leader_keymappings, {
--     key = tostring(i),
--     -- TODO: Add a prompt to create a new tab if the tab with specified number
--     --   doesn't exist.
--     action = wezterm.action_callback(function(win, pane)
--       wezterm.log_info 'Hello from callback!'
--       -- wezterm.log_info(
--       --   'WindowID:',
--       --   win:window_id(),
--       --   'PaneID:',
--       --   pane:pane_id()
--       -- )
--     end),
--   })
-- end

local keymappings= {
  -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  {
    key = "a",
    mods = "LEADER|CTRL",
    action = wezterm.action.SendString("\x01"),
  },
  {
    key = '1',
    mods = "LEADER",
    -- TODO: Add a prompt to create a new tab if the tab with specified number
    --   doesn't exist.
    action = wezterm.action_callback(function(win, pane)
      wezterm.log_info 'Hello from callback!'
      -- wezterm.log_info(
      --   'WindowID:',
      --   win:window_id(),
      --   'PaneID:',
      --   pane:pane_id()
      -- )
    end),
  },
}

-- Prepends LEADER to every leader_keymapping.
local function prepare_keymappings(keymappings, leader_keymappings)
  for _, leader_keymapping in ipairs(leader_keymappings) do
    if leader_keymapping.mods then
      leader_keymapping.mods = 'LEADER' .. '|' .. leader_keymapping.mods
    else
      leader_keymapping.mods = 'LEADER'
    end

    table.insert(keymappings, leader_keymapping)
  end

  return keymappings
end

return prepare_keymappings(keymappings, leader_keymappings),

