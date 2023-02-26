local application = require "hs.application"
local spaces = require "hs.spaces"

-- 参考: https://moriso.hatenablog.com/entry/2022/03/20/175922

hs.hotkey.bind({ "ctrl" }, "t", function()
    local appName = "WezTerm"
    local app = application.get(appName)

    if app == nil then
        application.launchOrFocus(appName)
    elseif app:isFrontmost() then
        app:hide()
    else
        --local active_space = spaces.focusedSpace()
        --local alacritty_win = app:focusedWindow()
        --print(active_space)
        --print(spaces.spaceDisplay(active_space))
        --print(alacritty_win:id())
        --print(spaces.spaceDisplay(active_space))
        --spaces.moveWindowToSpace(alacritty_win, active_space)

        app:setFrontmost()
    end
end)