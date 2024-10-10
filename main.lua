local conf, lib = require( "conf" ), require( "lib" )
--------------------------------------------------------------------------------
-- conf

--------------------------------------------------------------------------------
-- lib

-- function lib.do_gui()
--    local callbacks = {
--        load = lib.load,
--        update = lib.update,
--        draw = lib.draw
--    }
--    for name, func in pairs(callbacks) do
--        love[name] = func
--    end
-- end

--------------------------------------------------------------------------------

local function application()
    lib.do_print_table(lib)
    -- lib.do_gui()
end application()

