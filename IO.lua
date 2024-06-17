local base = {}
base.luaDire = activity.getLuaDir().."/"

base.ScriptToPath = function(path)
  return string.gsub(path, "%.", "/")..".lua"
end

base.DoScript = function(path)
  return dofile(base.luaDire..base.ScriptToPath(path))
end

return base
