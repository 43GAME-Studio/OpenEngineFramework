local Object = {}
Object.__index = Object
Object.name = tostring(Object)

function Object:ToString()
  return "Object: "..self.name
end

function Object:Equals(other)
  return self==other
end

function Object:new()
  local object = setmetatable({}, self)
  return object
end

return Object
