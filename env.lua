local utils = require('utils')
local is_darwin, is_windows = utils.is_darwin, utils.is_windows

local ENV = {}

ENV.IS_DARWIN = is_darwin()
ENV.IS_WINDOWS = is_windows()

return ENV

