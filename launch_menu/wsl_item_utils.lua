local wezterm = require('wezterm')

local function parse_wsl_list(wsl_list)
  local wsl_launch_menu = {}
  -- `wsl.exe -l` has a bug where it always outputs utf16:
  -- https://github.com/microsoft/WSL/issues/4607
  -- So we get to convert it
  wsl_list = wezterm.utf16_to_utf8(wsl_list)

  ---@see [Launch Wezterm Documentation](https://wezfurlong.org/wezterm/config/launch.html).
  for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
    -- Skip the first line of output; it's just a header
    if idx > 1 then
      -- Remove the "(Default)" marker from the default line to arrive
      -- at the distribution name on its own
      local distro = line:gsub(' %(Default%)', '')

      -- Add an entry that will spawn into the distro with the default shell
      table.insert(wsl_launch_menu, {
        label = distro .. ' (WSL default shell)',
        args = { 'wsl.exe', '--distribution', distro },
      })

      -- Here's how to jump directly into some other program; in this example
      -- its a shell that probably isn't the default, but it could also be
      -- any other program that you want to run in that environment
      table.insert(wsl_launch_menu, {
        label = distro .. ' (WSL xonsh login shell)',
        args = {
          'wsl.exe',
          '--distribution',
          distro,
          '--exec',
          '/bin/xonsh',
          '-l',
        },
      })
    end
  end

  return wsl_launch_menu
end

local function load_wsl_distributions_into_launch_menu(launch_menu)
  -- Enumerate any WSL distributions that are installed and add those to the menu.
  local success, wsl_list, wsl_err =
    wezterm.run_child_process { 'wsl.exe', '-l' }

  if not success then
    wezterm.log_error(
      'Could not load wsl list!',
      wsl_err
    )
    return
  end

  for _, wsl_launch_menu_item in ipairs(parse_wsl_list(wsl_list)) do
    table.insert(launch_menu, wsl_launch_menu_item)
  end
end

return {
  load_wsl_distributions_into_launch_menu = load_wsl_distributions_into_launch_menu
}
