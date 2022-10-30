local wezterm = require('wezterm')

local w_act = wezterm.action

local ShowLauncherArgs = w_act.ShowLauncherArgs({
    title = 'New Tab',

    flags = 'LAUNCH_MENU_ITEMS',
})

local leader_keymappings = {
  -- * Window management.
  {
    key = "d",
    action = w_act.CloseCurrentTab({ confirm = false }),
  },

  -- * Split management.
  {
    key = "v",
    action = w_act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "s",
    action = w_act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "x",
    action = w_act.CloseCurrentPane({ confirm = false }),
  },

  { key = 'Space', mods = 'LEADER', action = w_act.ShowLauncher },
  {
    key = 'n',
    action = ShowLauncherArgs
  },

  -- - Navigation.
  {
    key = "h",
    action = w_act.ActivatePaneDirection("Left"),
  },
  {
    key = "j",
    action = w_act.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    action = w_act.ActivatePaneDirection("Up"),
  },
  {
    key = "l",
    action = w_act.ActivatePaneDirection("Right"),
  },
}

for i = 0,7 do
  table.insert(leader_keymappings, {
    key = tostring(i),

    action = wezterm.action_callback(function(window, pane)
       local tabs = window:mux_window():tabs()
       if #tabs < i then
           window:toast_notification('wezterm', 'Tabs does not exist, creating new', nil, 4000)
           window:perform_action(ShowLauncherArgs, pane)
       else
           window:perform_action(w_act.ActivateTab(i), pane)
       end
    end),
  })
end

local keymappings= {
  -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  {
    key = "a",
    mods = "LEADER|CTRL",
    action = w_act.SendString("\x01"),
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

return prepare_keymappings(keymappings, leader_keymappings)
