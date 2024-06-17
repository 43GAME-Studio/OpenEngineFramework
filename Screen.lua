if Screen == nil then
  import("OpenEngineFramework.Math")

  Screen = {}
  Screen.orientation = nil
  Screen.requestedOrientation = 0
  Screen.onOrientationChanged = {}

  Screen.SetRequestedOrientation = function(orientation)
    if orientation ~= Screen.requestedOrientation then
      Screen.requestedOrientation = orientation
      activity.setRequestedOrientation(orientation)
    end
  end

  Screen.DpToPx = function(context, dp)
    local scale = context.getResources().getDisplayMetrics().density
    return Math.Round(dp * scale)
  end

  Screen.PxToDp = function(context, px)
    local scale = context.getResources().getDisplayMetrics().density
    return Math.Round(px / scale)
  end

  Screen.SpToPx = function(context, sp)
    local scale = context.getResources().getDisplayMetrics().scaledDensity
    return Math.Round(sp * scale)
  end

  Screen.PxToSp = function(context, px)
    local scale = context.getResources().getDisplayMetrics().scaledDensity
    return Math.Round(px / scale)
  end

  Screen.OnConfigurationChanged = function(newConfig)
    if Screen.orientation ~= newConfig.orientation then
      Screen.orientation = newConfig.orientation
      for k, v in pairs(Screen.onOrientationChanged) do
        v(Screen.orientation)
      end
    end
  end
end

if onConfigurationChanged == nil or onConfigurationChanged != Screen.OnConfigurationChanged then
  onConfigurationChanged = Screen.OnConfigurationChanged
end

return Screen
