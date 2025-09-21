local wezterm = require("wezterm")

local utils = require('utils')
local env = require('env')
local prequire = utils.prequire

local IS_SMALL_SCREEN = env.IS_DARWIN -- On MacOs Notebook.

local font_size
if IS_SMALL_SCREEN then
  font_size = 13
else
  font_size = 12
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
        foreground = "#45363B",
        selection_fg = "#EDE2CC",
        selection_bg = "#958B83",
        ansi = {
            [1] = "#7C6F64",
        }
        -- selection_foreground = "#D4CCB9",
    },
}

local function apply_builtin_scheme_modifications(scheme_modifications)
    local personal_schemes = {}

    for scheme_name, modification in pairs(scheme_modifications) do
        local builtin_scheme = wezterm.color.get_builtin_schemes()[scheme_name]
        -- print(scheme_name)
        -- print(builtin_scheme)

        -- TODO: Needs deep extend.
        -- personal_schemes['Deadly ' .. scheme_name] = tbl_extend(builtin_scheme, modification)
        -- modification.ansi = tbl_extend(builtin_scheme.ansi, modification.ansi)
        if modification.ansi then
            for i, _ in pairs(builtin_scheme.ansi) do
                modification.ansi[i] = modification.ansi[i] or builtin_scheme.ansi[i]
            end
        end
        personal_schemes['Deadly ' .. scheme_name] = tbl_extend(builtin_scheme, modification)
    end

    return personal_schemes
end

local personal_schemes = apply_builtin_scheme_modifications(scheme_modifications)

local config = wezterm.config_builder()
-- OpenGL for GPU acceleration, Software for CPU, WebGl for better
--   but experimental backends (GPU accelerated includes: use
--   `wezterm.gui.enumerate_gpus()`)
-- front_end = "WebGpu",

-- On each system differs, see https://wezfurlong.org/wezterm/config/lua/config/prefer_egl.html
-- prefer_egl = false,
-- config.max_fps = 120

-- Number of lines per tab.
-- scrollback_lines = 3500,
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- nil = default login shell. Works only on Unix.
-- Reference: https://wezfurlong.org/wezterm/config/launch.html#changing-the-default-program
config.default_prog = env.IS_WINDOWS and { 'pwsh.exe', '-NoLogo' } or nil
-- Set it to [wsl instance](https://wezfurlong.org/wezterm/config/lua/config/default_domain.html) if you use wsl more.
-- config.default_domain = 'local'
config.tab_and_split_indices_are_zero_based = true -- Like in tmux.

config.window_close_confirmation = 'NeverPrompt'

config.leader = { key = 'Space', mods = 'ALT', timeout_mmilliseconds = 1000 }
config.disable_default_key_bindings = false

config.keys = keymappings

config.font = wezterm.font("Iosevka")
config.font_size = font_size
-- config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' } -- Disable ligatures in most fonts.

config.window_decorations = "TITLE | RESIZE" --[[ "RESIZE", ]]

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

  -- tab_bar_style = ui.tab_bar_style,
config.window_frame = ui.window_frame
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

  -- Defined custom colorscheme.
config.color_schemes = personal_schemes
config.color_scheme = 'Deadly Belafonte Day'

-- ?: As far as I remember, items weren't loaded into launch menu when this
-- code chunk was placed in module.
if launch_menu_is_available then
  if wsl_item_utils_is_available and env.IS_WINDOWS then
    wsl_item_utils.load_wsl_distributions_into_launch_menu(launch_menu)
  end

  config.launch_menu = launch_menu
end

-- Fixes issue with "ssh-agent not found" on Windows. But this option is
-- available only on wezterm-nightly.
config.mux_enable_ssh_agent = false

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


local capture_scrollback_is_available, capture_scrollback = prequire('capture_scrollback')
if capture_scrollback_is_available then
  capture_scrollback.apply_to_config(config)
end

return config
