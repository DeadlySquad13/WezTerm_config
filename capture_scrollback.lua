local wezterm = require('wezterm')
local io = require('io')
local os = require('os')
local act = wezterm.action

local M = {}

local function add_capture_scrollback_event()
  wezterm.on('trigger-vim-with-scrollback', function(window, pane)
    -- Retrieve the text from the pane.
    local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

    -- Create a temporary file to pass to vim.
    local name = os.tmpname()
    local f = io.open(name, 'w+')
    f:write(text)
    f:flush()
    f:close()

    -- Open a new window running vim and tell it to open the file.
    window:perform_action(
      act.SpawnCommandInNewWindow {
        args = { 'nvim', name },
      },
      pane
    )

    -- Wait "enough" time for vim to read the file before we remove it.
    -- The window creation and process spawn are asynchronous wrt. running
    -- this script and are not awaitable, so we just pick a number.
    --
    -- Note: We don't strictly need to remove this file, but it is nice
    -- to avoid cluttering up the temporary directory.
    wezterm.sleep_ms(1000)
    os.remove(name)
  end)
end

M.config = {
  keys = {
    -- Actually Ctrl+Shift+E.
    {
      key = 'E',
      mods = 'CTRL',
      action = act.EmitEvent 'trigger-vim-with-scrollback',
    },
  },
}

local function merge_keymappings(keymappings, arg)
  for _, keymappings_to_add in ipairs(arg) do
    for _, keymapping_to_add in ipairs(keymappings_to_add) do
      table.insert(keymappings, keymapping_to_add)
    end
  end

  return keymappings
end

function M.apply_to_config(config)
  add_capture_scrollback_event()

  config.keys = merge_keymappings(config.keys, { M.config.keys }) 
end

return M
