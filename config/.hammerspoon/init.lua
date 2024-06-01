require("string")

----------------------------------------------------------------
-- Config reloading
----------------------------------------------------------------

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
  hs.reload()
end)
hs.alert.show("Config loaded")

----------------------------------------------------------------
-- Toggle bluetooth on sleep or awake
----------------------------------------------------------------

---@param exitCode integer
---@param stdout string
---@param stderr string
function checkBluetoothResult(exitCode, stdout, stderr)
  if exitCode ~= 0 then
    print(
      string.format("Unexpected result executing `blueutil`: exit=%d stderr=%s stdout=%s", exitCode, stderr, stdout)
    )
  end
end

---@param enabled boolean
function enableBluetooth(enabled)
  local power = enabled and "on" or "off"
  print("Setting bluetooth to " .. power)
  local t = hs.task.new("~/.nix-profile/bin/blueutil", checkBluetoothResult, { "--power", power })
  t:start()
end

sleepWatcherForBt = hs.caffeinate.watcher.new(function(event)
  if event == hs.caffeinate.watcher.systemWillSleep then
    enableBluetooth(false)
  elseif event == hs.caffeinate.watcher.screensDidWake then
    enableBluetooth(true)
  end
end)
sleepWatcherForBt:start()

----------------------------------------------------------------
-- Caffeine
----------------------------------------------------------------

caffeine = hs.menubar.new()

---@param state boolean|nil
function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle("AWAKE")
  else
    caffeine:setTitle("SLEEPY")
  end
end

if caffeine then
  caffeine:setClickCallback(function()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
  end)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end
