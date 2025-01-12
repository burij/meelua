local conf, f = require( "conf" ), require( "lib" )
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
local function application()
    local menu = {}
    menu.title = conf.window_title
    menu.message = "Use arrow keys to navigate, 'enter' to select"
    menu.selected = 1
    menu.options = {}

    menu.options[1] = {
        text = "Avaible functions",
        action = function()
            conf = f.reload_module( "conf" )
            f.msg(f)
        end
    }

    menu.options[2] = {
        text = "Settings",
        action = function()
            os.execute("nano ./conf.lua")
        end
    }
    
    menu.options[3] = {
        text = "Exit",
        action = function() os.exit() end
    }

    f.do_draw_menu(menu)
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
application()
