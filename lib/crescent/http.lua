--[[
  Crescent - a simple Lua webserver, for development use.
  @fileoverview Lua webserver. In active development.
  @author <a href="https://github.com/davidrekow">David Rekow</a>
  @version 0.0.1
  @license MIT
]]
-- Imports.
local socket = require 'socket'
local MESSAGES = require 'lib/crescent/message'
local MIME = require 'lib/crescent/mime'

-- Logging.
local log = function(...) print(...) end

-- Module information.
local info = {}
info.NAME = 'Crescent'
info.VERSION = '0.0.1'

-- Initialize module items.
local server, client

-- Initialize config.
local config = nil

-- Start web server.
function start(cfg_path)
  -- Show server message.
  log(MESSAGES.INIT:format(info.NAME, info.VERSION))
  -- Create socket on host:port and begin accepting requests.
  local host, port = config.host or '*', config.port or 8880
  server = assert(socket.bind(host, port))
  log(MESSAGES.RUN:format(host, port))
  take_requests()
end

-- Wait for & handle requests.
function take_requests()
  -- Loop while waiting for requests.
  while true do
    client = assert(server:accept())
    client:settimeout(60)
    local request = assert(client:receive())
    serve(request)
  end
end

-- Serve content.
function serve(request)
  -- Attempt to match filename & extension and get mime info.
  local method, file, ext = parse_request(request)
  if not ext then ext = '.txt' end
  local mime, binary = MIME[ext].mime, MIME[ext].bin
  -- Initialize response.
  assert(client:send(MESSAGES.BEGIN_RESPONSE:format(info.NAME)))
  -- Load requested file in appropriate mode.
  local loaded, mode
  if binary == false then mode = 'r' else mode = 'rb' end
  loaded = io.open(config.dir..file, mode)
  -- Send relevant mimetype info.
  if not loaded then mime = MIME['.html'].mime end
  assert(client:send(MESSAGES.CONTENT_TYPE:format(mime)))
  -- Send loaded content or 404 page.
  if loaded then
    local content = loaded:read('*all')
    assert(client:send(content))
  else
    local err = io.open('lib/crescent/404.html', 'r')
    assert(client:send(err:read('*all')))
  end
  client:close()
end

-- Extract parameters from raw HTTP request string.
function parse_request(request)
  local parts = {}
  for match in request:gmatch('[^%s]+') do table.insert(parts, match) end
  local method, file = unpack(parts)
  if string.char(string.byte(file, #file)) == '/' then
    file = file..'index.html'
  end
  local ext = file:match('%.%l%l%l%l?')
  return method, file, ext
end

-- Configure the server with a config object loaded from passed path.
function configure(path, dir, port)
  local _cfg, cfg = config, nil
  if (path) then cfg = require(path) end
  if cfg then
    log(MESSAGES.CONFIG.CUSTOM:format(path))
    config = cfg
  else
    log(MESSAGES.CONFIG.DEFAULT:format 'conf/default' )
    config = _cfg or require 'conf/default'
  end
  if dir then config.dir = dir end
  if port then config.port = port end
end

-- Init server with command line options if present.
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
    if dir and port then configure(nil, dir, port) else configure(dir) end
    start()
  end
end

-- If run from command line, invoke with flags.
if (arg) then
  main(arg)
-- If imported via interpreter, silence logging and return module.
else
  log = function() end
  return {
    start = start,
    configure = configure,
    parse_request = parse_request,
    NAME = info.NAME,
    VERSION = info.VERSION
  }
end