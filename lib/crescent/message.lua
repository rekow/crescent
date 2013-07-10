--[[ 
  @TODO:
    - nested/grouped messages, i.e. 'CONFIG.CUSTOM' -> {config = {custom = ''}}
    - modular HTTP headers, i.e. not just Content-Type + CRLFx2
]]

-- Initialize message table.
local messages = {}

-- String-formattable server messages.
--
-- Horizontal rule.
messages.HR = string.rep(':', 80)

-- Config loading.
messages.CONFIG_CUSTOM = ':: Found custom config. Loading from %s.'
messages.CONFIG_DEFAULT = ':: No config file found. Using default from conf/default.'

-- Server init.
messages.INIT = messages.HR .. '\n' .. [[
:::::::::::::::            %s web server v%s            :::::::::::::::
:::::::::::::::       (c) 2013 David Rekow @ momentum labs       :::::::::::::::
]] .. messages.HR

-- Server start.
messages.RUN = ':: Running on %s at port %d.\n' .. messages.HR

-- Server request.
messages.REQUEST = ':: Received %s request at %s'

-- Response chunks.
messages.CRLF = '\r\n'
messages.BEGIN_RESPONSE = 'HTTP/1.1 200/OK' .. messages.CRLF .. 'Server: %s' .. messages.CRLF
messages.CONTENT_TYPE = 'Content-Type:%s' .. messages.CRLF:rep(2)

-- Return formatter.
return function(name, ...)
  local msg = messages[name] or ''
  return msg:format(...)
end