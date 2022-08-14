local wezterm = require("wezterm")

local ui = require('tab_bar_ui')

local mux = wezterm.mux

-- wezterm.on("gui-startup", function(cmd)
--   local _, _, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

local launch_menu = {
  {
    label = 'Default Shell',
    cwd = '~',
    -- args = { 'top' },
  },
  {
    -- Optional label to show in the launcher. If omitted, a label
    -- is derived from the `args`
    label = 'Bash',
    -- The argument array to spawn.  If omitted the default program
    -- will be used as described in the documentation above
    args = { 'bash', '-l' },

    -- You can specify an alternative current working directory;
    -- if you don't specify one then a default based on the OSC 7
    -- escape sequence will be used (see the Shell Integration
    -- docs), falling back to the home directory.
    -- cwd = "/some/path"

    -- You can override environment variables just for this command
    -- by setting this here.  It has the same semantics as the main
    -- set_environment_variables configuration option described above
    -- set_environment_variables = { FOO = "bar" },
  },
}

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

--- Extends a list-like table with the values of another list-like table.
---
--- NOTE: This mutates dst!
---
---@see |vim.tbl_extend()|
---
---@param dst table List which will be modified and appended to
---@param src table List from which values will be inserted
---@param start number Start index on src. Defaults to 1
---@param finish number Final index on src. Defaults to `#src`
---@return table dst
-- function list_extend(dst, src, start, finish)
--   -- vim.validate({
--   --   dst = { dst, 't' },
--   --   src = { src, 't' },
--   --   start = { start, 'n', true },
--   --   finish = { finish, 'n', true },
--   -- })
--   for i = start or 1, finish or #src do
--     table.insert(dst, src[i])
--   end
--   return dst
-- end

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


local scheme = wezterm.color.get_builtin_schemes()['Atelier Sulphurpool Light (base16)']
scheme.tab_bar = ui.tab_bar

return {
  default_prog = { [[C:\Windows\System32\wsl.exe]] },
  launch_menu = launch_menu,

  leader = { key = "Space", mods = "ALT", timeout_mmilliseconds = 1000 },
  disable_default_key_bindings = false,
  keys = prepare_keymappings(keymappings, leader_keymappings),

  font = wezterm.font('Iosevka'),
  font_size = 10.0,

  window_decorations = "RESIZE",

  window_padding = {
    left = 5,
    right = 5,
    top = 4,
    bottom = 0,
  },

  tab_bar_style = ui.tab_bar_style,
  window_frame = ui.window_frame,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,

  -- Defined custom colorscheme.
  color_schemes = {
    ['Deadly Atelier Sulphurpool Light (base16)'] = scheme,
  },
  color_scheme = 'Deadly Atelier Sulphurpool Light (base16)',
}
