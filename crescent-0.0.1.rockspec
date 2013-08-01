-- Super work in process.

package = "Crescent"
version = require './lib/crescent/version'
source = {
  url = ''
}
description = {
  summary = "A lightweight development server.",
  detailed = [[
    Crescent is a first attempt at developing a simple, powerful Lua development
    framework. In its current form it is a simple, synchronous single-threaded
  ]],
  homepage = '',
  license = 'MIT'
}
dependencies = {
  "lua >= 5.1",
  "luasocket ~> scm-0"
}
build = {
  type = "builtin",
  modules = {

  }
}