--[[
  Crescent - a simple Lua webserver, for development use.
  @fileoverview Lua webserver. In active development.
  @author <a href="https://github.com/davidrekow">David Rekow</a>
  @version 0.0.1
  @license MIT
]]
-- Imports.
local socket = require 'socket'
local msg = require 'lib/crescent/message'
local MIME = require 'lib/crescent/mime'
local VERSION = require 'lib/crescent/version'

-- Logging.
local log = function(...) print(...) end

-- Module information.
local info = {}
info.NAME = 'Crescent'
info.VERSION = VERSION

-- Initialize module objects.
local server, client = {}

-- Initialize config.
local config = nil

-- Starts web server.
function server:start(cfg_path)
  -- Show server message.
  log(msg('INIT', info.NAME, info.VERSION))
  -- Create socket on host:port and begin accepting requests.
  local host, port = config.host or '*', config.port or 8880
  self.server = assert(socket.bind(host, port))
  log(msg('RUN', host, port))
  self:take_requests()
end

-- Waits for incoming requests.
function server:take_requests()
  -- Loop + timeout to wait.
  while true do
    self.client = assert(self.server:accept())
    self.client:settimeout(60)
    local request = assert(self.client:receive())
    self:serve(request)
  end
end

-- Serves content.
function server:serve(request)
  -- Attempt to match filename & extension and get mime info.
  local method, url, file, ext = self.parse_request(request)
  log(msg('REQUEST', method, url))
  if not ext then ext = '.txt' end
  local mime, binary = MIME[ext].mime, MIME[ext].bin
  -- Initialize response.
  assert(self.client:send(msg('BEGIN_RESPONSE', info.NAME)))
  -- Load requested file in appropriate mode.
  local loaded, mode
  if binary == false then mode = 'r' else mode = 'rb' end
  loaded = io.open(config.dir..file, mode)
  -- Send relevant mimetype info.
  if not loaded then mime = MIME['.html'].mime end
  assert(self.client:send(msg('CONTENT_TYPE', mime)))
  -- Send loaded content or 404 page.
  if loaded then
    local content = loaded:read('*all')
    assert(self.client:send(content))
  else
    local err = io.open('lib/crescent/404.html', 'r')
    assert(self.client:send(err:read('*all')))
  end
  self.client:close()
end

-- Extracts parameters from raw HTTP request string.
function server.parse_request(request)
  local parts = {}
  for match in request:gmatch('[^%s]+') do table.insert(parts, match) end
  local method, url = unpack(parts)
  local file = url
  if string.char(string.byte(file, #file)) == '/' then
    file = file..'index.html' end
  local ext = file:match('%.%l%l%l%l?')
  return method, url, file, ext
end

-- Configures the server with a config object loaded from passed path.
function server:configure(path, dir, port)
  local _cfg, cfg = config, nil
  if (path) then cfg = require(path) end
  if cfg then
    log(msg('CONFIG_CUSTOM', path))
    config = cfg
  else
    log(msg 'CONFIG_DEFAULT')
    config = _cfg or require 'conf/default'
  end
  if dir then config.dir = dir end
  if port then config.port = port end
end

-- make server class callable.
server = setmetatable(server, {
  __call = function()
    return setmetatable({}, { __index = server })
  end
})

-- Inits server with command line options if present.
local function main(args)
  -- Handle man page requests.
  if args[1] == '--help' or args[1] == '-h' then
    local man = require 'lib/crescent/man'
    log(man)
  -- Handle server info requests.
  elseif args[1] == '--info' or args[1] == '-i' then
    for k, v in pairs(info) do print(k, v) end
  -- Handle version requests.
  elseif args[1] == '--version' or args[1] == '-v' then
    print(info.VERSION)
  else    -- Init webserver.
    local dir, port = unpack(args)
    local _server = server()
    if dir and port then _server:configure(nil, dir, port) else _server:configure(dir) end
    _server:start()
  end
end

-- If run from command line, invokes server with flags.
if (arg) then
  main(arg)
-- If imported, returns module callable.
else
  return server
end
