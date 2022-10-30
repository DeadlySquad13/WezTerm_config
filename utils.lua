local wezterm = require('wezterm')

local function prequire(module_name)
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

return {
  prequire = prequire,
}
