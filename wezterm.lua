local wezterm = require("wezterm")

local utils = require('utils')
local env = require('env')
local prequire = utils.prequire

local IS_SMALL_SCREEN = env.IS_DARWIN -- On MacOs Notebook.

local font_size
if IS_SMALL_SCREEN then
  font_size = 13
else
  font_size = 10
end

local default_program
if env.IS_WINDOWS then
  default_program = { 'pwsh.exe', '-NoLogo' }
end

-- --- Show a notification whenever configuration is reloaded.
-- ---@ref [example in wezterm documentation](https://wezfurlong.org/wezterm/config/lua/window/toast_notification.html?highlight=message#windowtoast_notificationtitle-message--url-timeout_milliseconds)
-- wezterm.on('window-config-reloaded', function(window, pane)
--   window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
-- end)

local ui_is_available, ui = prequire("tab_bar_ui")
local keymappings_is_available, keymappings = prequire("keymappings")
local launch_menu_is_available, launch_menu = prequire("launch_menu")
local wsl_item_utils_is_available, wsl_item_utils = prequire("launch_menu.wsl_item_utils")

-- Fullscreen on startup.
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  -- If you leave fullscreen, stay maximized. Removed because of komorebi.
  -- window:gui_window():maximize()
  window:gui_window():toggle_fullscreen()
end)

local ui_is_available, ui = prequire('tab_bar_ui')
local keymappings_is_available, keymappings = prequire('keymappings')
local launch_menu_is_available, launch_menu = prequire('launch_menu')
local wsl_item_utils_is_available, wsl_item_utils = prequire('launch_menu.wsl_item_utils')

local function tbl_extend(a, b)
    for k, v in pairs(b) do
        a[k] = v
    end

    return a
end

local scheme_modifications = {
    ['Atelier Sulphurpool Light (base16)'] = { tab_bar = ui.tab_bar },
    ['Belafonte Day'] = {
        tab_bar = ui.tab_bar, -- TODO: adapt background for this theme.
        background = "#EDE2CC",
        -- ansi = {
        --     [0] = "#7C6F64",
        -- },
    },
}

local function apply_builtin_scheme_modifications(scheme_modifications)
    local personal_schemes = {}

    for scheme_name, modification in pairs(scheme_modifications) do
        local builtin_scheme = wezterm.color.get_builtin_schemes()[scheme_name]
        -- print(scheme_name)
        -- print(builtin_scheme)

        -- TODO: Needs deep extend.
        personal_schemes['Deadly ' .. scheme_name] = tbl_extend(builtin_scheme, modification)
    end

    return personal_schemes
end

local personal_schemes = apply_builtin_scheme_modifications(scheme_modifications)

local config = {
  -- OpenGL for GPU acceleration, Software for CPU, WebGl for better
  --   but experimental backends (GPU accelerated includes: use
  --   `wezterm.gui.enumerate_gpus()`)
  -- front_end = "WebGpu",

  -- On each system differs, see https://wezfurlong.org/wezterm/config/lua/config/prefer_egl.html
  -- prefer_egl = false,
  -- max_fps = 240,

  -- Number of lines per tab.
  -- scrollback_lines = 3500,

  default_cursor_style = "SteadyBlock",
  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",

  default_prog = env.IS_WINDOWS and { 'pwsh.exe', '-NoLogo' } or { 'bash' },
  -- Set it to [wsl instance](https://wezfurlong.org/wezterm/config/lua/config/default_domain.html) if you use wsl more.
  -- default_domain = 'local',
  tab_and_split_indices_are_zero_based = true, -- Like in tmux.

  window_close_confirmation = 'NeverPrompt',

  leader = { key = 'Space', mods = 'ALT', timeout_mmilliseconds = 1000 },
  disable_default_key_bindings = false,
  -- key_map_preference = "Physical", -- Ctrl+Key doesn't work in vim with custom layout on windows.
  keys = keymappings,

  font = wezterm.font("Iosevka"),
  font_size = font_size,
  -- harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, -- Disable ligatures in most fonts.

  window_decorations = "TITLE | RESIZE", --[[ "RESIZE", ]]

  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },

  -- tab_bar_style = ui.tab_bar_style,
  window_frame = ui.window_frame,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,

  -- Defined custom colorscheme.
  color_schemes = personal_schemes,
  color_scheme = 'Deadly Belafonte Day',
}

-- ?: As far as I remember, items weren't loaded into launch menu when this
-- code chunk was placed in module.
if launch_menu_is_available then
  if wsl_item_utils_is_available and env.IS_WINDOWS then
    wsl_item_utils.load_wsl_distributions_into_launch_menu(launch_menu)
  end

  config.launch_menu = launch_menu
end

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
