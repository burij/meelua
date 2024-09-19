local lib = {}

--------------------------------------------------------------------------------

function lib.compose(f, ...)
    local funcs = {...}
    return function(x)
        x = f(x)
        for i = 1, #funcs do
            x = funcs[i](x)
        end
        return x
    end
end

--------------------------------------------------------------------------------

function lib.conditional_prefix(condition, a, b)
	local c
	if condition then
		c = a .. b
	else
		c = b
	end
	return c
end

--------------------------------------------------------------------------------

function lib.do_write_file (filename, a)
    file = io.open(filename, "w")
	file:write(a)
    file:close()
end

--------------------------------------------------------------------------------

function lib.true_or_not(a, b)
	return a == b
end

--------------------------------------------------------------------------------

function lib.do_user_input(a, f)
	f()
	local question = a
	print(question)
	local answer = io.read()
	local a = answer
	return a
end

--------------------------------------------------------------------------------

function lib.csv_to_table(csv_string, separator)
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

function lib.do_get_file_content (filename)
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

function lib.do_print_table(x)
    lib.types( x, 'table' )
	local inspect = require("inspect")
	local tbl = inspect(x)
	print(tbl)
end

--------------------------------------------------------------------------------

function lib.map(x, y)
    lib.types( x, 'table' )
    lib.types( y, 'function' )
    local tbl = {}
    for k, v in pairs(x) do
        tbl[k] = y(v)
    end
    return tbl
end

--------------------------------------------------------------------------------

function lib.filter(x, y)
    lib.types( x, 'table' )
    lib.types( y, 'boolean' )
    local tbl = {}
    for k, v in pairs(x) do
        if y(v) then
            tbl[k] = v
        end
    end
    return tbl
end

--------------------------------------------------------------------------------

function lib.reduce(x, y, var)
    lib.types( x, 'table' )
    lib.types( y, 'function' )
    local accumulator = var
    for k, v in pairs(x) do
        accumulator = y(accumulator, v)
    end
    return accumulator
end

--------------------------------------------------------------------------------

function lib.get_line(x)
	if type(x) == "number" then
    	a = string.rep("'", x)
    else
    	default = 80
    	a = string.rep("'", default)
    end
    return a
end

--------------------------------------------------------------------------------

function lib.combine_text(...)
    local args = {...}
    local result = {}
    local a = ""
    if #args == 0 then
        return a
    end
    for i, v in ipairs(args) do
        lib.types( v, 'string' )
        table.insert(result, v)
    end
    a = table.concat(result, "\n")
    return a
end

--------------------------------------------------------------------------------

function lib.do_sleep(x)
    lib.types( x, 'number' )
	sleep_time = 1
    local function get_time()
        return os.clock()
    end
    local start_time = get_time()
    while get_time() - start_time < sleep_time do
    end
end

--------------------------------------------------------------------------------

function lib.types(x, y)
    if type(x) ~= y then
        error("expected a " .. y .. ", got " .. type(x), 2)
    end
    return x
end

--------------------------------------------------------------------------------

function lib.map_data(x, y)
    lib.types( x, 'table' )
    lib.types( y, 'table' )
    local tbl = {}
    for i, a in pairs(y) do
        lib.types( a, 'string' )
        if x[a] then
            tbl[i] = x[a]
        end
    end
    return tbl
end

--------------------------------------------------------------------------------

function lib.break_long_text(x, y)
    lib.types( x, 'string' )
    lib.types( y, 'number' )
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

function lib.lua_to_json(x)
    lib.types(x, "table")
    local parser = require "dkjson"
    local str = parser.encode(x)
    return str
end

--------------------------------------------------------------------------------

function lib.json_to_lua(x)
    lib.types(x, "string")
    local parser = require "dkjson"
    local tbl = parser.decode(x, 1, nil, nil)
    return tbl
end

--------------------------------------------------------------------------------

function lib.db_request(filename)
    lib.types(filename, "string")
    local tbl = {}
    local func = lib.compose(lib.do_get_file_content, lib.json_to_lua)
    local tbl = func(filename)
    return tbl
end

--------------------------------------------------------------------------------

function lib.do_db_post(filename, x)
    lib.types(filename, "string")
    lib.types(x, "table")
    local json_string = lib.lua_to_json(x)
    lib.do_write_file(filename, json_string)
end

--------------------------------------------------------------------------------

function lib.xml_to_table(a)
    local xml2lua = require("xml2lua")
	local handler = require("xmlhandler.tree"):new()
    local parser = xml2lua.parser(handler)
    if type(a) ~= "string" or not a:find ("<.+>") then
    		tbl = { a .. " Input of xml_to_table(a) was not valid XML" }
    else
    		parser:parse(a)
    		tbl = handler.root
	end
    return tbl
end

--------------------------------------------------------------------------------
return lib