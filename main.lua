local conf, lib = require( "conf" ), require( "lib" )
--------------------------------------------------------------------------------
-- conf

--------------------------------------------------------------------------------
-- lib

-- function lib.do_gui(x, y, z)
--     lib.types(x, "function")
--     lib.types(y, "function")
--     lib.types(z, "function")
--     function love.load() x end
--     function love.update(dt) y end
--     function love.draw() z end
-- end

--------------------------------------------------------------------------------

local function application()
    lib.do_print_table(lib)
    -- lib.do_gui()
end application()

