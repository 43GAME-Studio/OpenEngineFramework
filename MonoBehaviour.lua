import("OpenEngineFramework.Update")
import("OpenEngineFramework.Object")

local MonoBehaviour = Object:new()
MonoBehaviour.__index = MonoBehaviour
MonoBehaviour.viewObject = nil
MonoBehaviour.parent = nil
MonoBehaviour.name = nil

MonoBehaviour.enabled = true

function MonoBehaviour:ToString()
  return "MonoBehaviour: "..self.name
end

--function MonoBehaviour:Awake() end

--function MonoBehaviour:Start() end

--function MonoBehaviour:Update() end

--function MonoBehaviour:FixedUpdate() end

--function MonoBehaviour:OnDestroy() end

function MonoBehaviour:GetComponent(name)
  return Update.GetComponent(self.viewObject, name)
end

function MonoBehaviour:GetComponents(name)
  return Update.GetComponents(self.viewObject, name)
end

function MonoBehaviour:AddComponent(name)
  return Update.AddComponent(self.viewObject, name)
end

function MonoBehaviour:Destroy()
  self.enabled = false
  Update.RemoveMonoBehaviour(self)
end

function MonoBehaviour:DestroyViewObject()
  local component = Update.GetAllComponent(self.viewObject)
  for k, v in pairs(component) do
    v:Destroy()
  end
  self.parent.removeView(self.viewObject)
end

function MonoBehaviour:SetActive(active)
  local component = Update.GetComponent(self.viewObject)
  for k, v in pairs(component) do
    v.enabled = active
  end
  self.viewObject.setVisibility = active and 0 or 8
end

--function MonoBehaviour:OnScreenOrientationChanged(orientation) end

return MonoBehaviour

