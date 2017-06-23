-- configuration loading: http://www.hammerspoon.org/go/#fancy-configuration-reloading
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

-- caffeine: http://www.hammerspoon.org/go/#creating-a-simple-menubar-item
caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    if state then
        caffeine:setTitle("AWAKE")
    else
        caffeine:setTitle("SLEEPY")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- en <-> kana: http://mizoguche.info/2017/01/hammerspoon_for_sierra/
local prevCmdsKeyCode

local function toJa()
  hs.eventtap.keyStroke({}, hs.keycodes.map['kana'])
end

local function toEn()
  hs.eventtap.keyStroke({}, hs.keycodes.map['eisu'])
end

local function handleCmds(e)
  local keyCode = e:getKeyCode()
  if keyCode == hs.keycodes.map['escape'] then
    toEn()
  end

  local isCmdKeyUp = not(e:getFlags()['cmd']) and e:getType() == hs.eventtap.event.types.flagsChanged

  if isCmdKeyUp and prevCmdsKeyCode == hs.keycodes.map['cmd'] then
    toEn()
  elseif isCmdKeyUp and prevCmdsKeyCode == hs.keycodes.map['rightcmd'] then
    toJa()
  end

  prevCmdsKeyCode = keyCode
end

observeCmds = hs.eventtap.new({hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp}, handleCmds)
observeCmds:start()

-- key remapping: http://qiita.com/naoya@github/items/81027083aeb70b309c14
local function keyCode(key, modifiers)
   modifiers = modifiers or {}
   return function()
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
      hs.timer.usleep(1000)
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
   end
end

local function remapKey(modifiers, key, keyCode)
   hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

remapKey({'ctrl'}, '[', keyCode('escape'))
-- remapKey({'ctrl'}, ';', keyCode(';'))
-- remapKey({}, ';', keyCode('return'))

-- semicolon -> enter
local function handleSemi(e)
  if e:getKeyCode() ~= hs.keycodes.map[';'] then
    return
  end

  local flags = e:getFlags()

  if flags['ctrl'] then
    flags['ctrl'] = false
    e:setFlags(flags)
  elseif not flags['shift'] then
    return true, { hs.eventtap.event.newKeyEvent({}, 'return', true) }
  end
end

observeSemi = hs.eventtap.new({hs.eventtap.event.types.keyDown}, handleSemi)
observeSemi:start()
