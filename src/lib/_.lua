-- Set up export object.
this = {}

-- Table utilities.
--

-- Prints a table.
this.print = function(tbl)
  if tbl then for k, v in pairs(tbl) do print(k..':\t'..tostring(v)) end end
end

-- Pretty-prints a table. Stubbed, for now just prints.
this.pprint = function(tbl)
  return this.print(tbl)
end

-- Checks if an object is a table.
this.is_table = function(obj)
  return type(obj) == 'table'
end

-- Checks if a table should be considered a list.
this.is_list = function(tbl)
  if not this.is_table(tbl) then return false end
  local count, len = 0, #tbl
  if count == len then return false end
  for k, v in pairs(tbl) do count = count + 1 end
  return count == len
end

-- Checks if a table should be considered a dict.
this.is_dict = function(tbl)
  return this.is_table(tbl) and not this.is_list(tbl)
end

-- Clones a table to preserve data integrity.
this.clone = function(tbl)
  local cloned = {}
  return this.extend(cloned, tbl)
end

-- Extends one table onto another.
this.extend = function(target, src)
  target = target or {}
  if src then for k, v in pairs(src) do target[k] = v end end
  return target
end

-- Merges the second table into the first, considering list vs dict.
this.merge = function(a, b)
  if this.is_list(a) then
    assert(this.is_list(b), 'join() requires both tables to be similarly-indexed, i.e. both numeric')
    for i, v in ipairs(b) do a[#a+1] = v end
    return a
  elseif this.is_dict(a) then
    assert(this.is_dict(b), 'join() requires both tables to be similarly-indexed, i.e. both using string keys')
    return this.extend(a, b)
  else
    error('join() requires both parameters to be tables.')
  end
end

-- Zips two tables together, copying the first item to preserve data.
this.zip = function(a, b)
  local _a = this.clone(a)
  return this.merge(_a, b)
end

-- Converts a table to a JSON string. Does not check for circular references,
-- so use cautiously.
this.toJSON = function(tbl)
  local is_list = this.is_list(tbl)
  local str, iter, i, tuples = nil, nil, 1, {}
  if is_list then
    str, iter = {'[',']'}, ipairs 
  else
    str, iter = {'{','}'}, pairs 
  end
  local i, tuples = 1, {}
  for k, v in iter(tbl) do
    if type(v) ~= 'function' then
      if type(v) == 'table' then
        v = this.toJSON(v)
      else
        v = tostring(v)
      end
      tuples[i] = is_list and v or string.format('"%s":%s', k, v)
      i = i + 1
    end
  end
  return table.concat(str, table.concat(tuples, ','))
end

return this
