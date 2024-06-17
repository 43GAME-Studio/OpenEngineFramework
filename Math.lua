local Math = {}

Math.Range = function(v, min, max)
  if v < min then
    return min
   elseif v > max then
    return max
  end
  return v
end

Math.Floor = function(float, range)
  if range == nil then
    return math.floor(float)
   else
    return tonumber(string.format("%."..tostring(range+1).."f", tostring(float)))
  end
end

Math.Lerp = function(v1, v2, t)
  return v1 + Math.Range(t, 0, 1)*(v2-v1)
end

Math.Round = function(v)
  return math.floor(v + 0.5)
end

return Math
