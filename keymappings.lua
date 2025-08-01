local wezterm = require('wezterm')

local w_act = wezterm.action

local ShowLauncherArgs = w_act.ShowLauncherArgs({
  title = 'New Tab',

  flags = 'LAUNCH_MENU_ITEMS',
})

local PANE_SELECT_ALPHABET = "ntaesirh"
local leader_keymappings = {
  -- * Window management.
  {
    key = "q",
    action = w_act.CloseCurrentTab({ confirm = false }),
  },

  -- * Split management.
  {
    key = "h",
    action = w_act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "l",
    action = w_act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "x",
    action = w_act.CloseCurrentPane({ confirm = false }),
  },
  -- Activate pane selection mode.
  {
    key = 'o',
    action = w_act.PaneSelect({
      alphabet = PANE_SELECT_ALPHABET,
    }),
  },
  -- Show the pane selection mode, but have it swap the active and selected panes.
  {
    key = 'p',
    action = w_act.PaneSelect({
      mode = 'SwapWithActive',
      alphabet = PANE_SELECT_ALPHABET,
    }),
  },
  { key = 'Space', action = w_act.ShowLauncher },
  {
    key = "c", -- "Create" like create new window in tmux.
    action = ShowLauncherArgs
  },

  -- - Navigation.
  {
    key = "s",
    action = w_act.ActivatePaneDirection("Left"),
  },
  {
    key = "n",
    action = w_act.ActivatePaneDirection("Down"),
  },
  {
    key = "m",
    action = w_act.ActivatePaneDirection("Up"),
  },
  {
    key = "t",
    action = w_act.ActivatePaneDirection("Right"),
  },
}

for i = 0, 7 do
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

local function prepend_leader_to_keymappings(leader_keymappings)
  for _, leader_keymapping in ipairs(leader_keymappings) do
    if leader_keymapping.mods then
      leader_keymapping.mods = 'LEADER' .. '|' .. leader_keymapping.mods
    else
      leader_keymapping.mods = 'LEADER'
    end
  end

  return leader_keymappings
end

leader_keymappings = prepend_leader_to_keymappings(leader_keymappings)

local keymappings = {
  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = w_act.PasteFrom("Clipboard")
  },
  {
    key = "v",
    mods = "CTRL",
    action = w_act.Nop,
  },
}

local function merge_keymappings(keymappings, leader_keymappings)
  for _, leader_keymapping in ipairs(leader_keymappings) do
    table.insert(keymappings, leader_keymapping)
  end

  return keymappings
end

return merge_keymappings(
  keymappings,
  leader_keymappings
)
