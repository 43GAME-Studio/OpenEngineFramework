if Time == nil then
  Time = {}
  Time.time = 0
  Time.fixedTime = 0

  Time.deltaTime = 0
  Time.fixedDeltaTime = 0

  Time.timeScale = 1
  Time.timeline = Ticker()
  Time.timeline.Period=1
  Time.timeline.onTick=function()
    Time.time = Time.time + 0.001*Time.timeScale, 10
    Time.fixedTime = Time.fixedTime + 0.001, 10
  end
  Time.timeline.start()
end

return Time
