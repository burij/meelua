local f = {}
-- https://lua-docs.vercel.app
--------------------------------------------------------------------------------

function f.select(x, y, z)
    -- returns one of variables, depending on condition
    f.types(x, "boolean") -- condition
    f.types(y, "any") -- option 1
    f.types(z, "any") -- optiin 2
    local var
    if x then 
        var = y
    else 
        var = z
    end
    return var
end    

--------------------------------------------------------------------------------

function f.globalize(x)
    -- loads content of a module to a global space
    f.types( x, "dictionary" ) -- modul which needs to be loaded globaly
    for k, v in pairs(x) do
        _G[k] = v
    end
end

--------------------------------------------------------------------------------

function f.write_file(x, y)
    f.types(x, 'string')   -- filename
    f.types(y, 'string')   -- content to write
    local file = io.open(x, "w")
    if file then
        file:write(y)
        file:close()
    else
        error("Unable to open file for writing: " .. x)
    end
end
f.do_write_file = f.write_file
--------------------------------------------------------------------------------

function f.types(x, y)
    -- returns var x, if type is matching y
    local special_types = {
        list = true,
        dictionary = true,
        path = true,
        email = true,
        url = true,
        any = true
    }
    
    if not special_types[y] then
        if type(x) ~= y then
            error("expected a " .. y .. ", got " .. type(x), 2)
        end
        return x
    end

    if y == "any" then
        if x == nil then
            error("expected a value, got nil", 2)
        end
        return x
    end

    if y == "path" then
        if type(x) ~= "string" then
            error("expected a path string, got " .. type(x), 2)
        end
        local file = io.open(x, "r")
        if not file then
            error("path does not exist or is not accessible: " .. x, 2)
        end
        file:close()
        return x
    end

    if y == "email" then
        if type(x) ~= "string" then
            error("expected an email string, got " .. type(x), 2)
        end
        local pattern = "^[%w%.%%%+%-]+@[%w%.%%%+%-]+%.%w+$"
        if not string.match(x, pattern) then
            error("invalid email format: " .. x, 2)
        end
        return x
    end

    if y == "url" then
        if type(x) ~= "string" then
            error("expected a URL string, got " .. type(x), 2)
        end
        local pattern = "^https?://[%w%.%%%+%-]+%.[%w%.%%%+%-]+[%w%.%%%+%-/%?=&#]+$"
        if not string.match(x, pattern) then
            error("invalid URL format: " .. x, 2)
        end
        return x
    end
    
    if type(x) ~= "table" then
        error("expected a " .. y .. ", got " .. type(x), 2)
    end

    if y == "list" then
        local len = #x
        for k, _ in pairs(x) do
            local is_not_number = type(k) ~= "number"
            local is_out_of_bounds = k > len or k <= 0
            local is_not_integer = math.floor(k) ~= k
            if is_not_number or is_out_of_bounds or is_not_integer then
                error("expected a list, got " .. type(x), 2)
            end
        end
    end

    if y == "dictionary" then
        local has_non_numeric_key = false
        local numeric_keys = {}
        for k, _ in pairs(x) do
            if type(k) ~= "number" then
                has_non_numeric_key = true
                break
            end
            table.insert(numeric_keys, k)
        end
        if not has_non_numeric_key and #numeric_keys > 0 then
            table.sort(numeric_keys)
            for i = 1, #numeric_keys do
                if numeric_keys[i] ~= i then
                    has_non_numeric_key = true
                    break
                end
            end
            if not has_non_numeric_key then
                error("expected a dictionary, got " .. type(x), 2)
            end
        end
    end

    return x
end

--------------------------------------------------------------------------------

function f.read(x)
    -- asks question and stores user input in a variable
    f.types(x, "string")   -- question
    print(x)
    local var = io.read()
    return var
end
f.do_user_input = f.read

--------------------------------------------------------------------------------

function f.flatten_table(x)
    -- stores values of a nested table in simple list
    f.types(x, "table")   -- nested ( k = v ) table
    local tbl = {}
    for _, t in pairs(x) do
        for _, v in pairs(t) do
            table.insert(tbl, v)
        end
    end
    return tbl
end

--------------------------------------------------------------------------------

function f.tbl_div(x, y)
    -- Creates a div table between 2 lists
    f.types(x, "table")   -- original table
    f.types(y, "table")   -- new table
    local tbl = { added = {}, removed = {} }
    -- Helper function for deep comparison
    local function deep_equals(a, b)
        if type(a) ~= type(b) then return false end
        if type(a) ~= "table" then return a == b end
        -- Check if tables have same length
        if #a ~= #b then return false end
        -- For array-like tables, compare by index
        for i = 1, #a do
            if not deep_equals(a[i], b[i]) then return false end
        end
        return true
    end
    -- Find added elements (in y but not in x)
    for i = 1, #y do
        local value = y[i]
        local found = false
        for j = 1, #x do
            local orig_value = x[j]
            if deep_equals(value, orig_value) then
                found = true
                break
            end
        end
        if not found then
            table.insert(tbl.added, value)
        end
    end
    -- Find removed elements (in x but not in y)
    for i = 1, #x do
        local value = x[i]
        if value ~= nil then -- Skip nil values
            local found = false
            for j = 1, #y do
                local new_value = y[j]
                if deep_equals(value, new_value) then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(tbl.removed, value)
            end
        end
    end
    return tbl
end

--------------------------------------------------------------------------------

function f.do_draw_menu(x)
    f.types(x, "table")
    local function menu()
        f.do_clear_screen()
        io.write("\r" .. x.title .. "\n")
        for i, option in ipairs(x.options) do
            io.write("\r")
            if i == x.selected then
                io.write("> " .. option.text .. "  \n")
            else
                io.write("  " .. option.text .. "  \n")
            end
        end
        io.write("\r\n" .. x.message .. "\n")
        io.flush()
    end
    os.execute("stty raw -echo")
    while true do
        menu()
        local char = io.read(1)
        if char == '\27' then
            local bracket = io.read(1)
            if bracket == '[' then
                local arrow = io.read(1)
                if arrow == 'A' then -- Up arrow
                    x.selected = x.selected - 1
                    if x.selected < 1 then x.selected = #x.options end
                elseif arrow == 'B' then -- Down arrow
                    x.selected = x.selected + 1
                    if x.selected > #x.options then x.selected = 1 end
                end
            end
        elseif char == "\n" or char == "\r" then -- Enter key
            f.do_clear_screen()
            os.execute("stty cooked echo")
            x.options[x.selected].action()
            if x.selected ~= #x.options then -- If not Exit
                print("\nPress Enter to continue...")
                io.read()
                os.execute("stty raw -echo")
            end
        elseif char == "\3" then           -- Ctrl+C
            os.execute("stty cooked echo") -- Reset terminal mode
            os.exit()
        end
    end
end

--------------------------------------------------------------------------------

function f.do_clear_screen()
    if package.config:sub(1, 1) == '\\' then -- Windows
        os.execute("cls")
    else                                    -- Unix-like
        os.execute("clear")
    end
end

--------------------------------------------------------------------------------

function f.reload_module(x)
    -- reloads modules during runtime
    f.types(x, "string")   -- module name
    package.loaded[x] = nil
    return require(x)
end

--------------------------------------------------------------------------------

function f.msg(x)
    -- debug function, outputs any data type and returns type
    if type(x) == "table" then
        f.do_print_table(x)
    else
        print(x)
    end
    return type(x)
end

--------------------------------------------------------------------------------

function f.compose_list(...)
    -- glues strings and tables to a new table
    local tbl = {}
    for _, v in ipairs({ ... }) do
        if type(v) == "string" then
            table.insert(tbl, v)
        elseif type(v) == "table" then
            for _, str in ipairs(v) do
                if type(str) ~= "string" then
                    error("incorrect table format detected")
                end
                table.insert(tbl, str)
            end
        else
            error("all arguments must be either strings or tables")
        end
    end
    return tbl
end

--------------------------------------------------------------------------------

function f.skipcmd_str_if_false(x, y)
    -- adds skip bash command to a list, if condition false
    f.types(x, "string")
    f.types(y, "boolean")
    if y then
        var = x
    else
        var = ": || skipping " .. x
    end
    return var
end

--------------------------------------------------------------------------------

function f.skipcmd_tbl_if_false(x, y)
    -- adds skip bash command to a list, if condition false
    f.types(x, "table")
    f.types(y, "boolean")
    local tbl = {}
    for _, str in ipairs(x) do
        f.types(str, "string")
        if y then
            table.insert(tbl, str)
        else
            table.insert(tbl, ": || skipping " .. str)
        end
    end
    return tbl
end

--------------------------------------------------------------------------------

function f.do_cmd(x)
    f.types(x, 'string')
    print(x)
    local handle = io.popen(x)
    local str = handle:read("*a")
    handle:close()
    print(str)
    return str
end

--------------------------------------------------------------------------------

function f.do_cmd_list(x)
    f.types(x, 'table')   -- each string will be executed
    for k, v in pairs(x) do
        if type(v) ~= "table" then
            f.do_if_true(x[k], true)
        else
            x[k] = v
        end
    end
end

--------------------------------------------------------------------------------

function f.extend_table(x, y, z)
    f.types(x, 'table')
    f.types(y, 'string')   -- prefix for each string in x
    f.types(z, 'string')   -- suffix for each string in x
    local tbl = {}
    for k, v in pairs(x) do
        if type(v) ~= "table" then
            tbl[k] = y .. tostring(v) .. z
        else
            tbl[k] = v
        end
    end
    return tbl
end

--------------------------------------------------------------------------------

function f.command_and_capture(x, y)
    f.types(x, "string") -- command, which will be executed
    f.types(y, "string") -- value, which be returned, if there is no output
    local handle = io.popen(x)
    local str = ""
    if handle then
        str = handle:read("*a")
        handle:close()
    end
    if str == "" then
        str = y
    end
    str = string.gsub(str, "\n$", "")
    return str
end

--------------------------------------------------------------------------------

function f.do_if_true(x, y)
    f.types(x, "string")   -- command, which will be executed, if true
    f.types(y, "boolean")
    if y then
        local output = f.command_and_capture(x, "done")
        print(x .. "\n" .. output)
    end
end

--------------------------------------------------------------------------------

function f.replace(x, y, z)
    -- replaces string withanother sting inside a string
    f.types(x, "string")
    f.types(y, "string") -- looks for it in x
    f.types(z, "string") -- and replaces y with that
    local str = x
    if str:find(y, 1, true) then
        return str:gsub(y, z)
    else
        return str
    end
end
f.inject_var = f.replace

--------------------------------------------------------------------------------

function f.compose(f, ...)
    local funcs = { ... }
    return function(x)
        x = f(x)
        for i = 1, #funcs do
            x = funcs[i](x)
        end
        return x
    end
end

--------------------------------------------------------------------------------

function f.conditional_prefix(condition, a, b)
    local c
    if condition then
        c = a .. b
    else
        c = b
    end
    return c
end

--------------------------------------------------------------------------------

function f.csv_to_table(csv_string, separator)
    separator = separator or ","
    local tbl = {}
    local headers = {}
    for line in csv_string:gmatch("[^\r\n]+") do
        local row = {}
        local i = 1
        if #headers == 0 then
            for header in line:gmatch('([^' .. separator .. ']+)') do
                headers[i] = header
                i = i + 1
            end
        else
            for value in line:gmatch('([^' .. separator .. ']+)') do
                value = value:gsub('^"(.*)"$', '%1')
                value = value:gsub('""', '"')
                row[headers[i]] = value
                i = i + 1
            end
            table.insert(tbl, row)
        end
    end
    return tbl
end

--------------------------------------------------------------------------------

function f.do_get_file_content(filename)
    -- deprecated, use f.read_file instead
    local file = io.open(filename, "r")
    if file then
        content = file:read("*all")
        file:close()
    else
        content = filename .. " not found or not readable!"
    end
    local b = content
    return b
end

--------------------------------------------------------------------------------

function f.read_file(x)
    -- returns content of given file
    f.types( x, "string" ) -- path to file
    local file = io.open(x, "r")
    if file then
        content = file:read("*all")
        file:close()
    else
        content = filename .. " not found or not readable!"
    end
    local str = content
    return str
end
--------------------------------------------------------------------------------

function f.do_print_table(x)
    f.types(x, 'table')
    local inspect = require("inspect")
    local tbl = inspect(x)
    print(tbl)
end

--------------------------------------------------------------------------------

function f.get_line(x)
    if type(x) == "number" then
        a = string.rep("'", x)
    else
        default = 80
        a = string.rep("'", default)
    end
    return a
end

--------------------------------------------------------------------------------

function f.combine_text(...)
    local args = { ... }
    local result = {}
    local a = ""
    if #args == 0 then
        return a
    end
    for i, v in ipairs(args) do
        f.types(v, 'string')
        table.insert(result, v)
    end
    a = table.concat(result, "\n")
    return a
end

--------------------------------------------------------------------------------

function f.do_sleep(x)
    -- simple waiting
    f.types(x, 'number') -- number of seconds
    sleep_time = x
    local function get_time()
        return os.clock()
    end
    local start_time = get_time()
    while get_time() - start_time < sleep_time do
    end
end

--------------------------------------------------------------------------------

function f.map_data(x, y)
    f.types(x, 'table')
    f.types(y, 'table')
    local tbl = {}
    for i, a in pairs(y) do
        f.types(a, 'string')
        if x[a] then
            tbl[i] = x[a]
        end
    end
    return tbl
end

--------------------------------------------------------------------------------

function f.break_long_text(x, y)
    f.types(x, 'string')
    f.types(y, 'number')
    local lines = {}
    local line = ""
    local words = {}
    for word in x:gmatch("%S+") do
        table.insert(words, word)
    end
    for i, word in ipairs(words) do
        if #line + #word + 1 <= y or #line == 0 then
            if #line > 0 then
                line = line .. " " .. word
            else
                line = word
            end
        else
            table.insert(lines, line)
            line = word
        end
    end
    if #line > 0 then
        table.insert(lines, line)
    end
    local a = table.concat(lines, "\n")
    return a
end

--------------------------------------------------------------------------------

function f.lua_to_json(x)
    f.types(x, "table")
    local parser = require "dkjson"
    local str = parser.encode(x)
    return str
end

--------------------------------------------------------------------------------

function f.json_to_lua(x)
    f.types(x, "string")
    local parser = require "dkjson"
    local tbl = parser.decode(x, 1, nil, nil)
    return tbl
end

--------------------------------------------------------------------------------

function f.read_json(filename)
    -- imports json to a lua table
    f.types(filename, "string")
    local tbl = {}
    local func = f.compose(f.read_file, f.json_to_lua)
    local tbl = func(filename)
    return tbl
end

--------------------------------------------------------------------------------

function f.write_json(x, filename)
    -- exports table to json file
    f.types(filename, "string")
    f.types(x, "table")
    local json_string = f.lua_to_json(x)
    f.write_file(filename, json_string)
end

--------------------------------------------------------------------------------

function f.xml_to_table(a)
    local xml2lua = require("xml2lua")
    local handler = require("xmlhandler.tree"):new()
    local parser = xml2lua.parser(handler)
    if type(a) ~= "string" or not a:find("<.+>") then
        tbl = { a .. " Input of xml_to_table(a) was not valid XML" }
    else
        parser:parse(a)
        tbl = handler.root
    end
    return tbl
end

--------------------------------------------------------------------------------

function f.map(x, y)
    -- call function on every element of a table
    f.types(x, "table")
    f.types(y, "function")
    local tbl = {}
    local is_list = (#x > 0)
    if is_list then
        for i, v in ipairs(x) do
            tbl[i] = y(v)
        end
    else
        for k, v in pairs(x) do
            tbl[k] = y(v)
        end
    end
    return tbl
end

--------------------------------------------------------------------------------

function f.filter(x, y)
    -- filters table elements based on predicate function
    f.types(x, 'table')
    f.types(y, 'function')
    local tbl = {}
    local is_list = (#x > 0)
    if is_list then
        for i, v in ipairs(x) do
            if y(v) then
                table.insert(tbl, v)
            end
        end
    else
        for k, v in pairs(x) do
            if y(v) then
                tbl[k] = v
            end
        end
    end
    return tbl
end

--------------------------------------------------------------------------------

function f.reduce(x, y, var)
    -- reduces table to single value using accumulator function
    f.types(x, 'table')
    f.types(y, 'function')
    local is_list = (#x > 0)
    local accumulator = var
    if is_list then
        for _, v in ipairs(x) do
            accumulator = y(accumulator, v)
        end
    else
        for _, v in pairs(x) do
            accumulator = y(accumulator, v)
        end
    end
    return accumulator
end

--------------------------------------------------------------------------------

return f
