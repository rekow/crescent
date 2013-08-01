-- Import utility functions.
_ = require '_'

-- Basic class factory. Optionally accepts parent class to inherit from and
-- metatable to set.
return function (parent, name, meta)
  local cls = {}
  if meta then _.extend(cls, meta) end
  if name then cls.__name = name end
  if parent then cls.__super = parent end
  cls.__class, cls.__index = cls, cls
  -- Make class callable and return.
  return setmetatable(cls, {
    __index = parent,
    __call = function(c, ...)
      local new = setmetatable({}, cls)
      return cls.init and cls.init(new, ...) or new
    end
  })
end