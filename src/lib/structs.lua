-- Datastructure utilities.

-- Imports.
local _ = require '_'
local Class = require 'class'

-- List-like structures.
--
-- Array.
local Array
Array = Class(nil, nil, {
  -- Mutators.
  --
  -- Appends an item.
  push = function(arr, item)
    arr[#arr + 1] = item
    return #arr
  end,
  -- Removes and returns last item.
  pop = function(arr)
    return table.remove(arr, #arr)
  end,
  -- Prepends an item.
  prepend = function(arr, item)
    table.insert(arr, 1, item)
    return #arr
  end,
  -- Removes and returns first item.
  shift = function(arr)
    return table.remove(arr, 1)
  end,
  -- Mutates array, adding and/or removing items.
  splice = function(arr, i, num, ...)
    if not num or i > #arr then num = 0 end
    local removed = Array()
    if num > 0 then
      for j = i, i + num - 1 do
        removed:push(table.remove(arr, j))
      end
    end
    for k, v in ipairs({...}) do
      table.insert(arr, i, v)
      i = i + 1
    end
    return removed
  end,
  -- Reverses array in place.
  reverse = function(arr)
    local i, j = 1, #arr
    while i < j do
      arr[i], arr[j] = arr[j], arr[i]
      i, j = i + 1, j - 1
    end
    return arr
  end,
  -- Sorts array in place.
  sort = function(arr, fn)
    table.sort(arr, fn)
    return arr
  end,
  -- Accessors.
  --
  -- Returns a copy of all or part of array.
  slice = function(arr, i, j)
    i = i or 0
    j = j or #arr
    local _arr = Array()
    for k = i, j do _arr:push(arr[k]) end
    return _arr
  end,
  -- Returns a copy of array joined with others.
  concat = function(arr, ...)
    local arrs = Array(arr)
    for i, _arr in ipairs({...}) do
      _arr:foreach(function(v) arrs:push(v) end)
    end
    return arrs
  end,
  -- Returns numerical index of an item, or nil.
  indexOf = function(arr, item)
    local i = nil
    for k, v in ipairs(arr) do
      if v == item then i = k; break end
    end
    return i
  end,
  -- Joins array items by delimiter and return string.
  join = function(arr, delim)
    delim = delim or ','
    return table.concat(arr, delim)
  end,
  -- Iterators.
  --
  -- Calls a function for each item in array.
  foreach = function(arr, fn)
    for i, v in ipairs(arr) do fn(v, i, arr) end
  end,
  -- Returns array of return values from calling a function for each item.
  map = function(arr, fn)
    local ret = Array()
    for i, v in ipairs(arr) do ret:push(fn(v, i, arr)) end
    return ret
  end,
  -- Returns array of items for which calling truth function returned true.
  filter = function(arr, fn)
    local ret = Array()
    for i, v in ipairs(arr) do
      if fn(v, i, arr) then ret:push(v) end
    end
    return ret
  end,
  -- Reduces array to a single value.
  reduce = function(arr, fn, initial)
    local ret = initial or 0
    for i, v in ipairs(arr) do ret = fn(ret, v, i, arr) end
    return ret
  end,
  -- Returns true if every item in array passes truth test.
  all = function(arr, fn)
    for i, v in ipairs(arr) do
      if fn(v, i, arr) ~= true then return false end
    end
    return true
  end,
  -- Returns true if at least one item passes truth test.
  some = function(arr, fn)
    for i, v in ipairs(arr) do
      if fn(v, i, arr) == true then return true end
    end
    return false
  end,
  -- Initialize array.
  init = function(arr, tbl)
    if tbl then
      if _.is_list(tbl) then
        for i, v in ipairs(tbl) do arr:push(v) end
      else
        for k, v in pairs(tbl) do arr:push(v) end
      end
    end
  end 
})
return Array