return {
  INIT = [[
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::            %s web server v%s            :::::::::::::::
:::::::::::::::       (c) 2013 David Rekow @ momentum labs       :::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
]],
  RUN = ':: Running on %s at port %d\n',
  BEGIN_RESPONSE = 'HTTP/1.1 200/OK\r\nServer: %s\r\n',
  CONTENT_TYPE = 'Content-Type:%s\r\n\r\n',
  CONFIG = {
    CUSTOM = 'Found custom config. Loading from %s',
    DEFAULT = 'No config file found. Using default from %s'
  }
}