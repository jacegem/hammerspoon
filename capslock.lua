local const = require('modules.const')
local key = require('modules.key')
local window = require('modules.window')
local app = require('modules.app')

local capslock = const.key.capslock
local capslockCmd = const.key.capslockCmd
local capslockShift = const.key.capslockShift
local capslockCmdShift = const.key.capslockCmdShift

-- reload
hs.hotkey.bind(capslock, 'r', function() 
  hs.reload()  
end)
hs.alert.show("HS reloaded")

-- TODO: 캡스락 키 제어
hs.hotkey.bind(capslock, 'y', function() 
  hs.eventtap.event.newKeyEvent(nil, hs.keycodes.map.capslock, true):post()
end)

app:launch(capslock, 'g', const.app.finder)
app:launch(capslock, 't', const.app.iTerm)
app:launch(capslockShift, 'e', 'Evernote')
-- app:launch(capslock, 'w', 'Trello')
app:launch(capslock, 'w', 'Notion')
-- app:launch(capslock, 'n', 'Notion')
app:launch(capslockShift, 'w', 'Google Chrome')
app:launch(capslockShift, 'a', 'Android Studio')
app:launch(capslockShift, 'c', 'Visual Studio Code')
app:launch(capslockShift, 's', 'Slack')
app:launch(capslockCmd, 'p', 'Postman')
app:launch(capslockCmd, '0', 'Postico')

key:bindUp(capslock, 'a', 'cmd', 'a')
key:bindUp(capslock, 'c', 'cmd', 'c')
key:bindUp(capslock, 'v', 'cmd', 'v')
key:bindUp(capslock, 'z', 'cmd', 'z')
key:bindUp(capslock, 'x', 'cmd', 'x')
key:bindUp(capslock, 's', 'cmd', 's')
key:bindUp(capslock, 'f', 'cmd', 'f')


-- 클립보드에서 앞 공백제거 후 붙여넣기
key:bindUp(capslockShift, 'v', function() 
  clipboard = hs.pasteboard.getContents()
  
  minLen = string.len(clipboard)
  isFirst = true
  exceptFirst = false

  for t in clipboard:gmatch("[^\r\n]+") do
    w, s = string.match(t, "(%s*)(.*)")
    wLen = string.len(w)
    sLen = string.len(s)

    if sLen ~= 0 then
      if isFirst == true then
        isFirst = false
        if wLen == 0 then
          exceptFirst = true        
        elseif wLen < minLen then
            minLen = wLen
        end     
      else
        if wLen < minLen then
          minLen = wLen
        end    
      end
    end
  end

  newText = ""
  isFirst = true
  for t in clipboard:gmatch("[^\n]*") do  
    if isFirst == true and exceptFirst == true then
      newText = t .. '\n'
      isFirst = false
    else      
      -- if t:match("%S") ~= nil then        
      if string.find(t,"^%s*$") then        
        r = t  
      else
        r = string.sub(t, minLen + 1, string.len(t))        
      end
      
      newText = newText .. r ..'\n'
    end
  end
  
  result = string.sub(newText, 1, string.len(newText))
  hs.pasteboard.setContents(result)
  hs.eventtap.keyStroke('cmd', 'v')
  hs.eventtap.keyStroke(nil, 'forwarddelete')
end) 


key:bindDown(capslock, 'h', 'cmd', 'left')
key:bindDown(capslockShift, 'h', {"cmd", "shift"}, 'left')
key:bindDown(capslock, ';', 'cmd', 'right')
key:bindDown(capslockShift, ';', {"cmd", "shift"}, 'right')
key:bindDown(capslock, 'm', {}, 'pageup')
key:bindDown(capslockShift, 'm', {"shift"}, 'pageup')
key:bindDown(capslock, ',', {}, 'pagedown')
key:bindDown(capslockShift, ',', {"shift"}, 'pagedown')

key:bindUp(capslock, '1', {}, 'F1', {
  ['Evernote'] = {{'option', 'cmd'}, '1'}
})
key:bindDown(capslock, '2', {}, 'F2')
key:appleScript(capslock, '3', 'tell application "Mission Control" to launch')

key:bindUp(capslock, '[', 'cmd', '[', {
  ['Code'] = {{'ctrl'}, '-'}
})

key:bindUp(capslock, ']', 'cmd', ']', {
  ['Code'] = {{'ctrl', 'shift'}, '-'}
})

key:event(capslock, 'j', {}, 'left')
key:event(capslockCmd, 'j', {'option'}, 'left')
key:event(capslockShift, 'j', {'shift'}, 'left')
key:event(capslockCmdShift, 'j', {'option', 'shift'}, 'left')

key:event(capslock, 'l', {}, 'right')
key:event(capslockCmd, 'l', {'option'}, 'right')
key:event(capslockShift, 'l', {'shift'}, 'right')
key:event(capslockCmdShift, 'l', {'option', 'shift'}, 'right')

key:event(capslock, 'i', {}, 'up')
key:event(capslockCmd, 'i', {'option'}, 'up')
key:event(capslockShift, 'i', {'shift'}, 'up')
key:event(capslockCmdShift, 'l', {'option', 'shift'}, 'up')

key:event(capslock, 'k', {}, 'down')
key:event(capslockCmd, 'k', {'option'}, 'down')
key:event(capslockShift, 'k', {'shift'}, 'down')
key:event(capslockCmdShift, 'k', {'option', 'shift'}, 'down')

key:event(capslock, 'u', {}, 'delete')
key:bindUp(capslockCmd, 'u', function()   
  hs.eventtap.keyStroke({'shift', 'option'}, 'left')
  hs.eventtap.keyStroke(nil, 'delete')
end)
key:event(capslock, 'o', {}, 'forwarddelete')
key:bindUp(capslockCmd, 'o', function()   
  hs.eventtap.keyStroke({'shift', 'option'}, 'right')
  hs.eventtap.keyStroke(nil, 'delete')
end)

key:event(capslock, 'q', {}, 'delete')
key:event(capslock, 'e', {}, 'forwarddelete')

function blockquoteFunc()
  bq = "<blockquote><cite></cite></blockquote>"
  hs.eventtap.keyStrokes(bq)
  left(26)
end

key:bindDown(capslock, 'b', capslock, 'b', {
  ['Code'] = { nil, "F12"}, -- follow
  -- ['PyCharm'] = {nil, 'F3'},  -- toggle bookmark
  ['Android Studio'] = {nil, 'F3'},  -- toggle bookmark
})

key:bindUp(capslock, 'b', capslock, 'b', {  
  ['Code'] = { nil, "F12"},
  ['PyCharm'] = {'cmd', 'b'},
  ['Android Studio'] = {'cmd', 'b'},
  ['Google Chrome'] = blockquoteFunc,
})


function codeFunc()
  bq = [[<code>

</code>]]
  -- hs.eventtap.keyStrokes(bq)  
  hs.pasteboard.writeObjects(bq)
  hs.eventtap.keyStroke("cmd", "v")
  -- keyRepeat('enter', 2)
  -- left(7)
  keyRepeat('up', 1)

end

key:bindUp(capslock, 'd', capslock, 'd', {    
  ['Google Chrome'] = codeFunc,
})

key:bindDown(capslockShift, 'b', capslockShift, 'b', {  
  ['PyCharm'] = {'cmd', 'F3'},  -- toggle bookmark
  ['Android Studio'] = {'cmd', 'F3'},  -- toggle bookmark
})

key:bindDown(capslock, 'delete', function() 
  hs.eventtap.keyStroke('cmd', 'right')
  hs.eventtap.keyStroke({'shift', 'cmd'}, 'left')
  hs.eventtap.keyStroke(nil, 'delete')
end) 

key:bindDown(capslock, 'space', nil, 'F13')  -- 한영전환


-- key:bindUp(capslock, ',', capslock, ',', {
--   ['Evernote'] = {"←"}
-- })

key:bindUp(capslock, '.', capslock, '.', {
  ['PyCharm'] = {"option", "return"},
  ['Android Studio'] = {"option", 'return'},
  ['Chrome'] = {'---->'},
  ['Code'] = {"cmd", "."},
  ['Evernote'] = {"→"}
})

key:bindUp(capslockShift, '.', function()
  hs.eventtap.keyStrokes('·')
end)

key:bindDown(capslock, '/', capslock, '/', {
  ['Google Chrome'] = {'---->>'},
})

function dateFunc()
  local date = os.date("%Y-%m-%d") 
  hs.eventtap.keyStrokes(date)
end

function dateFuncShort()
  weekNames = { "일", "월", "화", "수", "목", "금", "토" }
  cNow = os.date("*t")
  wday = weekNames[cNow["wday"]]
  local date = os.date("%y년 %m월 %d일")
  date = "#### " .. date .. " " .. "(" .. wday .. ")"
  hs.eventtap.keyStrokes(date)
end


function keyRepeat(key, times)
  for i=1, times, 1 do
    hs.eventtap.event.newKeyEvent(nil, key, true):post()
    hs.eventtap.event.newKeyEvent(nil, key, false):post()
  end
end

function left(times)
  for i=1, times, 1 do
    hs.eventtap.event.newKeyEvent(nil, "left", true):post()
    hs.eventtap.event.newKeyEvent(nil, "left", false):post()
  end
end

function todoFunc()
  now=os.time()
  days = 7  
  numberOfDays = now + days * 24 * 3600
  dateAfterNumberOfDays = os.date("%Y-%m-%d",numberOfDays)
  todo = "- <todo due:" .. dateAfterNumberOfDays .. "></todo>"
  hs.eventtap.keyStrokes(todo)
  left(7)
end


key:bindDown(capslock, '2', capslock, '2', {
  ['Code'] = {nil, 'F2'},
  ['PyCharm'] = {'shift', 'F6'},  
  ['Google Chrome'] = dateFuncShort,  
  ['Notion'] = dateFunc, 
  ['XD'] = dateFunc,  
})

key:bindDown(capslock, '3', capslock, '3', {  
  ['PyCharm'] = {nil, 'F2'},  
  ['Android Studio'] = {nil, 'F2'}, 
  ['Google Chrome'] = todoFunc,   
})

key:bindDown(capslock, '4', capslock, '4', {
  ['Code'] = { '$$ $$' },
})

key:bindDown(capslock, '6', capslock, '6', {  
  ['Android Studio'] = {'shift', 'F6'},
  ['PyCharm'] = {'shift', 'F6'},
})

key:bindDown(capslock, '9', capslock, '9', {  
  ['Chrome'] = {'←'},  
})

key:bindDown(capslock, '0', capslock, '0', {
  ['PyCharm'] = {'cmd', 'F3'},  -- show bookmark list
  ['Chrome'] = {'→'},
})


key:bindDown(capslock, '-', capslock, '-', {
  ['PyCharm'] = {'shift', 'F2'},  -- show bookmark list
  ['Chrome'] = {{'ctrl', 'shift'}, 'tab'},
})

key:bindDown(capslock, '=', capslock, '=', {
  ['PyCharm'] = {nil, 'F2'},  -- show bookmark list
  ['Chrome'] = {{'ctrl'}, 'tab'},
})

    
hs.hotkey.bind(capslock, "Left", window:move("left"))
hs.hotkey.bind(capslock, "Right", window:move("right"))
hs.hotkey.bind(capslock, "Up", window:move("up"))
hs.hotkey.bind(capslock, "Down", window:move("down"))

