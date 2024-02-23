local wezterm = require('wezterm')

local M = {}

M.prequire = function(module_name)
  local module_loading_error_handler = function(error)
      wezterm.log_info(
        'Error in loading module ' .. module_name .. '!',
        error
      )
  end

  local status_ok, module = xpcall(
    require,
    module_loading_error_handler,
    module_name
  )

  if not status_ok then
    return status_ok
  end

  return status_ok, module
end

M.is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

M.is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

M.is_windows = function()
	return wezterm.target_triple == "x86_64-pc-windows-msvc"
end

return M
