if EventSystem == nil then
  EventSystem = {}
  EventSystem.events = {}

  EventSystem.EmptyEvent = function() end

  EventSystem.CreatEventData = function(view, eventName)
    local hasView, hasEventName = EventSystem.HasEventData(view, eventName)
    if !hasView then
      EventSystem.events[view] ={}
    end
    if !hasEventName then
      EventSystem.events[view][eventName] ={}
    end
  end

  EventSystem.HasEventData = function(view, eventName)
    local hasView = EventSystem.events[view] != nil
    return hasView, hasView and EventSystem.events[view][eventName] != nil or false
  end

  EventSystem.OverrideView = function(view, eventName)
    if EventSystem.events[view][eventName.."Override"] == nil then
      EventSystem.events[view][eventName.."Override"] = function(...)
        local returnContent = nil
        for k, v in pairs(EventSystem.events[view][eventName]) do
          returnContent = v(...)
        end
        if returnContent ~= nil then return returnContent end
      end
      view[eventName] = EventSystem.events[view][eventName.."Override"]
    end
  end

  EventSystem.AddEvent = function(view, eventName, event, func)
    EventSystem.CreatEventData(view, eventName)
    EventSystem.events[view][eventName][event] = func
    EventSystem.OverrideView(view, eventName)
  end

  EventSystem.HasEvent = function(view, eventName, event)
    if EventSystem.HasEventData(view, eventName) then
      return EventSystem.events[view][eventName][event] != nil
    end
    return false
  end

  EventSystem.RemoveEvent = function(view, eventName, event)
    if EventSystem.HasEventData(view, eventName) and EventSystem.events[view][eventName][event] ~= nil then
      EventSystem.events[view][eventName][event] = nil
      if #EventSystem.events[view][eventName] == 0 then
        view[eventName] = EventSystem.EmptyEvent
        EventSystem.events[view][eventName.."Override"] = nil
      end
    end
  end

  EventSystem.RemoveEvents = function(view, eventName)
    if EventSystem.HasEventData(view, eventName) then
      view[eventName] = EventSystem.EmptyEvent
      EventSystem.events[view][eventName.."Override"] = nil
      table.clear(EventSystem.events[view][eventName])
    end
  end
end

return EventSystem
