Crescent v0.0.1
===============
A thin webserver written in Lua. Crescent is in very early development,
and currently only fit for dev purposes.

Usage
-----
    $ git clone https://github.com/davidrekow/crescent.git
    $ cd crescent
    $ ./crescent

That's it! Open your browser and visit `localhost:8880`

Features
--------
- Serves files from a directory.

That's it so far.

Roadmap
-------
 - Support other HTTP methods than `GET`.

That's...also it so far. VERY early development.


Why 'Crescent'?
---------------
Lua (moon) `+` a very *thin* server

Why Crescent?
-------------
 - It serves files from a directory
 - Doesn't overwhelm you with dozens of 'features'
 - It's written in Lua
 - FILES. From a DIRECTORY.

Why Lua?
--------
Because [LuaRocks](http://luarocks.org/)! But really, Lua is a tiny and extremely extensible scripting language that doesn't get much love in the webapp world, and I wanted to see how a Lua webserver would perform.

Benchmark Results
-----------------
Still too many features left to build before it's worthwhile to benchmark.