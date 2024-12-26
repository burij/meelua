local conf, f = require( "conf" ), require( "lib" )

--------------------------------------------------------------------------------
local function application()

    local function run_script()
        conf = f.reload_module( "conf" )
        f.msg(f)
    end
    
    local function edit_conf()
        os.execute("nano ./conf.lua")
    end
    
    local menu = {
        title = conf.window_title,
        message = "Use arrow keys to navigate, 'enter' to select",
        options = {
            { text = "Avaible functions", action = run_script },
            { text = "Settings", action = edit_conf },
            { text = "Exit", action = function() os.exit() end }
        },
        selected = 1
    } 
    f.do_draw_menu(menu)
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
application()
