if Update == nil then
  import("OpenEngineFramework.Time")
  import("OpenEngineFramework.EventSystem")
  import("OpenEngineFramework.IO")
  import("OpenEngineFramework.Screen")

  Update = {}
  Update.updateList = {}

  Update.targetFrameRate = 30
  Update.timeBefore = 0
  Update.gameUpdater=Ticker()
  Update.gameUpdater.Period=math.floor(1000/Update.targetFrameRate)
  Update.gameUpdater.onTick=function()
    Update.gameUpdater.Period = math.floor(1000/Update.targetFrameRate)
    Time.deltaTime = Time.time - Update.timeBefore

    for k, v in ipairs(Update.updateList) do
      if v.enabled and v.Update ~= nil then
        v:Update()
      end
    end

    Update.timeBefore = Time.time
  end
  Update.gameUpdater.start()

  Update.fixedTimestep = 0.02
  Update.fixedTimeBefore = 0
  Update.fixedUpdater=Ticker()
  Update.fixedUpdater.Period=math.floor(1000 * Update.fixedTimestep/Time.timeScale)
  Update.fixedUpdater.onTick=function()
    if Time.timeScale == 0 then return end

    Update.fixedUpdater.Period=math.floor(1000 * Update.fixedTimestep / Time.timeScale)
    Time.fixedDeltaTime = Time.fixedTime - Update.fixedTimeBefore

    for k, v in ipairs(Update.updateList) do
      if v.enabled and v.FixedUpdate ~= nil then
        v:FixedUpdate()
      end
    end

    Update.fixedTimeBefore = Time.fixedTime
  end
  Update.fixedUpdater.start()

  Update.AddMonoBehaviour = function(monoBehaviour)
    table.insert(Update.updateList, monoBehaviour)
    if monoBehaviour.Start ~= nil then monoBehaviour:Start() end
  end

  Update.RemoveMonoBehaviour = function(monoBehaviour)
    for k, v in ipairs(Update.updateList) do
      if v == monoBehaviour then
        if v.OnDestroy ~= nil then v:OnDestroy() end

        if EventSystem.HasEvent(monoBehaviour) then
          EventSystem.RemoveEvent(monoBehaviour.viewObject, "onClick", monoBehaviour)
        end
        if EventSystem.HasEvent(monoBehaviour) then
          EventSystem.RemoveEvent(monoBehaviour.viewObject, "onTouch", monoBehaviour)
        end
        if EventSystem.HasEvent(monoBehaviour) then
          EventSystem.RemoveEvent(monoBehaviour.viewObject, "onLongClick", monoBehaviour)
        end

        if Screen.onOrientationChanged[monoBehaviour] ~= nil then
          Screen.onOrientationChanged[monoBehaviour] = nil
        end

        table.remove(Update.updateList, k)
      end
    end
  end

  Update.OverrideMonoBehaviour = function(monoBehaviour, override, nilable)
    if override ~= nil then
      for k, v in pairs(override) do
        if !nilable then assert(monoBehaviour[k] ~= nil, "MonoBehaviour Override: Can not found key "..'"'..k..'"'.." with override "..'"'..tostring(v)..'"'.." in "..monoBehaviour:ToString().." ("..tostring(monoBehaviour)..")")end
        monoBehaviour[k] = v
      end
    end
  end

  Update.LoadMonoBehaviour = function(view, path)
    if type(path) ~= "string" then
      return
    end

    local monoBehaviour = IO.DoScript(path)
    monoBehaviour.name = path
    monoBehaviour.viewObject = view
    monoBehaviour.parent = view.getParent()

    if monoBehaviour.OnClick ~= nil then
      EventSystem.AddEvent(monoBehaviour.viewObject, "onClick", monoBehaviour, monoBehaviour.OnClick)
    end
    if monoBehaviour.OnTouch ~= nil then
      EventSystem.AddEvent(monoBehaviour.viewObject, "onTouch", monoBehaviour, monoBehaviour.OnTouch)
    end
    if monoBehaviour.OnLongClick ~= nil then
      EventSystem.AddEvent(monoBehaviour.viewObject, "onLongClick",monoBehaviour, monoBehaviour.OnLongClick)
    end

    if monoBehaviour.OnScreenOrientationChanged ~= nil then
      Screen.onOrientationChanged[monoBehaviour] = monoBehaviour.OnScreenOrientationChanged
    end

    if monoBehaviour.Awake ~= nil then monoBehaviour:Awake() end

    return monoBehaviour
  end

  Update.AddComponent = function(view, monoBehaviour, override, nilable)
    assert(view ~= nil, "AddComponent: Can not add component on nil view object")

    if type(monoBehaviour) == "string" then monoBehaviour = Update.LoadMonoBehaviour(view, monoBehaviour) end

    if nilable == nil then nilable = false end

    Update.OverrideMonoBehaviour(monoBehaviour, override, nilable)
    Update.AddMonoBehaviour(monoBehaviour)

    return monoBehaviour
  end

  Update.GetComponent = function(view, path)
    assert(view ~= nil, "GetCompnent: Get the view object of the component cannot be nil")

    for k, v in ipairs(Update.updateList) do
      if v.viewObject == view and v.name == path then
        return v
      end
    end
    error("There is no component "..'"'..path..'"'.." on the view "..tostring(view))
  end

  Update.GetComponents = function(view, path)
    assert(view ~= nil, "GetComponent: Get the view object of the component cannot be nil")

    local components = {}

    for k, v in ipairs(Update.updateList) do
      if v.viewObject == view and v.name == path then
        table.insert(components, v)
      end
    end
    return #components > 0 and components or nil
  end

  Update.GetAllComponent = function(view)
    assert(view ~= nil, "GetComponent: Get the view object of the component cannot be nil")

    local component = {}

    for k, v in ipairs(Update.updateList) do
      if v.viewObject == view then
        table.insert(component, v)
      end
    end

    return #component > 0 and component or nil
  end
end

return Update
