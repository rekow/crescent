Crescent v0.0.1
===============
A thin webserver written in Lua. Crescent is in very early development, and currently only fit for dev purposes.

Requirements
------------
 - [Lua](http://www.lua.org) >= 5.1, added to your system's `$PATH`
 - [LuaSocket](https://github.com/diegonehab/luasocket) >= 3.0-rc1

Usage
-----
    $ git clone https://github.com/davidrekow/crescent.git
    $ cd crescent
    $ ./crescent

That's it! Open your browser and visit `localhost:8880`.
For (slightly) more information type:

    $ ./crescent --help

Features
--------
- Serves files from a directory.

That's it so far. VERY early development.

Roadmap
-------
 - Support other HTTP methods than `GET`.
 - Header parsing & sending.
 - Sockets?
 - Coroutines.
 - TEST SUITE.

Why `crescent`?
---------------
*Lua* (moon) + a very *thin* server.

Why Crescent?
-------------
 - It serves files from a directory
 - Doesn't overwhelm you with dozens of 'features'
 - It's written in Lua
 - FILES. From a DIRECTORY.

Why Lua?
--------
Because [LuaRocks](http://luarocks.org)! But really, Lua is a tiny and extremely extensible scripting language that doesn't get much love in the webapp world, and I wanted to see how a Lua webserver would perform.

Benchmark Results
-----------------
Still too many features left to build before it's worthwhile to benchmark.