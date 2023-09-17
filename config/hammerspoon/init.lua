local application = require "hs.application"
local spaces = require "hs.spaces"
local window = require "hs.window"
local ipc = require "hs.ipc"

hs.ipc.cliInstall("/opt/homebrew")


targetWindow = nil
hs.hotkey.bind({"ctrl", "shift"}, "t", function()
    local appName = "WezTerm"
    local focusedWindow = window.focusedWindow()

    if focusedWindow:application():name() == appName then
        targetWindow = focusedWindow
    end
end)

local lastFocused = nil
hs.hotkey.bind({"ctrl"}, "t", function()
    if targetWindow == nil then
        return
    end
    
    local focusedWindow = window.focusedWindow()
    if window.frontmostWindow() == targetWindow then
        targetWindow:sendToBack()
        if lastFocused ~= nil and lastFocused:application():name() ~= "WezTerm" then
            lastFocused:focus()
        end
    else
        lastFocused = window.focusedWindow()
        targetWindow:focus()
    end

end)

-- 参考: https://moriso.hatenablog.com/entry/2022/03/20/175922
-- hs.hotkey.bind({"ctrl"}, "t", function()
--     local appName = "WezTerm"
--     local app = application.get(appName)

--     if app == nil then
--         application.launchOrFocus(appName)
--     elseif app:isFrontmost() then
--         app:hide()
--     else
--         -- local active_space = spaces.focusedSpace()
--         -- local alacritty_win = app:focusedWindow()
--         -- print(active_space)
--         -- print(spaces.spaceDisplay(active_space))
--         -- print(alacritty_win:id())
--         -- print(spaces.spaceDisplay(active_space))
--         -- spaces.moveWindowToSpace(alacritty_win, active_space)
--         --
--         app:setFrontmost()
--     end
-- end)

hs.hotkey.bind({"ctrl", "shift"}, "g", function()
    local appName = "Gather"
    local app = application.get(appName)

    if app == nil then
        application.launchOrFocus(appName)
    elseif app:isFrontmost() then
        -- app:hide()
    else
        app:setFrontmost()
    end
end)

-- mouseCircle = nil
-- mouseCircleTimer = nil
--
-- function mouseHighlight()
--     -- Delete an existing highlight if it exists
--     if mouseCircle then
--         mouseCircle:delete()
--         if mouseCircleTimer then mouseCircleTimer:stop() end
--     end
--     -- Get the current co-ordinates of the mouse pointer
--     mousepoint = hs.mouse.absolutePosition()
--     -- Prepare a big red circle around the mouse pointer
--     mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x - 40,
--                                                      mousepoint.y - 40, 80, 80))
--     mouseCircle:setStrokeColor({
--         ["red"] = 0.9,
--         ["blue"] = 0.1,
--         ["green"] = 0.3,
--         ["alpha"] = 0.7
--     })
--     mouseCircle:setFill(false)
--     mouseCircle:setStrokeWidth(5)
--     mouseCircle:show()
--
--     -- Set a timer to delete the circle after 3 seconds
--     mouseCircleTimer = hs.timer.doAfter(3, function()
--         mouseCircle:delete()
--         mouseCircle = nil
--     end)
-- end
--
-- hs.hotkey.bind({"cmd", "alt", "shift"}, "D", mouseHighlight)

local stackline = require "stackline"
stackline:init()
