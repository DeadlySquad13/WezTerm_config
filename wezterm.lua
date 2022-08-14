local wezterm = require("wezterm")

local ui = require('tab_bar_ui')
local keymappings = require('keymappings')

-- local mux = wezterm.mux

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


local scheme = wezterm.color.get_builtin_schemes()['Atelier Sulphurpool Light (base16)']
scheme.tab_bar = ui.tab_bar

return {
  default_prog = { [[C:\Windows\System32\wsl.exe]] },
  launch_menu = launch_menu,

  leader = { key = "Space", mods = "ALT", timeout_mmilliseconds = 1000 },
  disable_default_key_bindings = false,
  keys = keymappings,

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
