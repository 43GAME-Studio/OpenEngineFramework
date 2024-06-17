if EventSystem == nil then
  EventSystem = {}
  EventSystem.events = {}

  EventSystem.EmptyEvent = function() end

  EventSystem.CreatEventData = function(viewId, eventName)
    local has, hasView, hasEventName = EventSystem.HasEventData(viewId, eventName)
    if !hasView then
      EventSystem.events[viewId] ={}
    end
    if !hasEventName then
      EventSystem.events[viewId][eventName] ={}
    end
  end

  EventSystem.HasEventData = function(viewId, eventName)
    local hasView = EventSystem.events[viewId] != nil
    local hasEventName = hasView and EventSystem.events[viewId][eventName] != nil or false
    return hasView and hasEventName, hasView, hasEventName
  end

  EventSystem.OverrideView = function(view, eventName)
    local viewId = view.getId()
    if EventSystem.events[viewId][eventName.."Override"] == nil then
      EventSystem.events[viewId][eventName.."Override"] = function(...)
        local returnContent = nil
        for k, v in pairs(EventSystem.events[viewId][eventName]) do
          returnContent = v(...)
        end
        if returnContent ~= nil then return returnContent end
      end
      view[eventName] = EventSystem.events[viewId][eventName.."Override"]
    end
  end

  EventSystem.AddEvent = function(view, eventName, event, func)
    local viewId = view.getId()
    EventSystem.CreatEventData(viewId, eventName)
    EventSystem.events[viewId][eventName][event] = func
    EventSystem.OverrideView(view, eventName)
  end

  EventSystem.HasEvent = function(view, eventName, event)
    local viewId = view.getId()
    if EventSystem.HasEventData(viewId, eventName) then
      return EventSystem.events[viewId][eventName][event] ~= nil
    end
    return false
  end

  EventSystem.RemoveEvent = function(view, eventName, event)
    local viewId = view.getId()
    if EventSystem.HasEventData(viewId, eventName) then
      EventSystem.events[viewId][eventName][event] = nil
      if #EventSystem.events[viewId][eventName] == 0 then
        view[eventName] = EventSystem.EmptyEvent
        EventSystem.events[viewId] = nil
      end
    end
  end

  EventSystem.RemoveEvents = function(view, eventName)
    local viewId = view.getId()
    if EventSystem.HasEventData(viewId, eventName) then
      view[eventName] = EventSystem.EmptyEvent
      EventSystem.events[viewId] = nil
    end
  end
end

return EventSystem
