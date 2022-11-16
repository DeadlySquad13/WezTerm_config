local wezterm = require("wezterm")

local prequire = require("utils").prequire

-- Manually set variables.
-- TODO: Move them to ansible.
IS_SMALL_SCREEN = true -- On MacOs Notebook.
IS_WINDOWS = false

local font_size
if IS_SMALL_SCREEN then
  font_size = 13
else
  font_size = 10
end

local default_program
if IS_WINDOWS then
  default_program = { 'pwsh.exe', '-NoLogo' }
end

-- Fullscreen on startup.
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

-- --- Show a notification whenever configuration is reloaded.
-- ---@ref [example in wezterm documentation](https://wezfurlong.org/wezterm/config/lua/window/toast_notification.html?highlight=message#windowtoast_notificationtitle-message--url-timeout_milliseconds)
-- wezterm.on('window-config-reloaded', function(window, pane)
--   window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
-- end)

local ui_is_available, ui = prequire("tab_bar_ui")
local keymappings_is_available, keymappings = prequire("keymappings")
local launch_menu_is_available, launch_menu = prequire("launch_menu")
local wsl_item_utils_is_available, wsl_item_utils = prequire("launch_menu.wsl_item_utils")

local scheme = wezterm.color.get_builtin_schemes()["Atelier Sulphurpool Light (base16)"]
scheme.tab_bar = ui.tab_bar

local config = {
  -- OpenGL for GPU acceleration, Software for CPU
  front_end = "OpenGL",
  -- On each system differs, see https://wezfurlong.org/wezterm/config/lua/config/prefer_egl.html
  -- prefer_egl = false,
  max_fps = 240,
  default_cursor_style = "SteadyBlock",
  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",

  default_prog = default_program,
  -- Set it to [wsl instance](https://wezfurlong.org/wezterm/config/lua/config/default_domain.html) if you use wsl more.
  default_domain = "local",
  launch_menu = launch_menu,
  tab_and_split_indices_are_zero_based = true, -- Like in tmux.

  leader = { key = "Space", mods = "ALT", timeout_mmilliseconds = 1000 },
  disable_default_key_bindings = false,
  keys = keymappings,

  font = wezterm.font("Iosevka"),
  font_size = font_size,

  window_decorations = "TITLE | RESIZE", --[[ "RESIZE", ]]

  window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 0,
  },

  -- tab_bar_style = ui.tab_bar_style,
  window_frame = ui.window_frame,
  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = false,

  -- Defined custom colorscheme.
  color_schemes = {
    ["Deadly Atelier Sulphurpool Light (base16)"] = scheme,
  },
  color_scheme = "Deadly Atelier Sulphurpool Light (base16)",
}

if launch_menu_is_available then
  if wsl_item_utils_is_available and wezterm.target_triple == "x86_64-pc-windows-msvc" then
    wsl_item_utils.load_wsl_distributions_into_launch_menu(launch_menu)
  end

  config.launch_menu = launch_menu
end

-- if not ui_is_available then

-- local config = {}

-- local mux = wezterm.mux

-- wezterm.on("gui-startup", function(cmd)
--   local _, _, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

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

return config
