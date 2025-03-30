-- LEVEL 3 SCRIPT
-- SPAGHETTI CODE BELOW !!
-- DONT ATTEMPT TO SKID, YOU WONT EVEN BE ABLE TO UNDERSTAND WHAT ANYTHING IS


print'pmo'

--ts is pmo
function customJSONDecode(json)
    local index = 1

    local parseObject, parseArray, parseString, parseBoolean, parseNull, parseNumber

    local function skipWhitespace()
        while json:sub(index, index) == " " or json:sub(index, index) == "\n" or json:sub(index, index) == "\t" do
            index = index + 1
        end
    end

    local function parseValue()
        skipWhitespace()

        local char = json:sub(index, index)

        if char == "{" then
            return parseObject()
        elseif char == "[" then
            return parseArray()
        elseif char == "\"" then
            return parseString()
        elseif char == "t" or char == "f" then
            return parseBoolean()
        elseif char == "n" then
            return parseNull()
        elseif tonumber(char) or char == "-" then 
            return parseNumber()
        else
            error("Unexpected character: " .. char)
        end
    end

    parseString = function()
        local startIndex = index + 1
        index = index + 1
        while json:sub(index, index) ~= "\"" do
            index = index + 1
            if index > #json then error("Unterminated string") end
        end
        local str = json:sub(startIndex, index - 1)
        index = index + 1
        return str
    end

    parseNumber = function()
        local startIndex = index
        while tonumber(json:sub(index, index)) or json:sub(index, index) == "." or json:sub(index, index) == "-" do
            index = index + 1
        end
        return tonumber(json:sub(startIndex, index - 1))
    end

    parseBoolean = function()
        if json:sub(index, index + 3) == "true" then
            index = index + 4
            return true
        elseif json:sub(index, index + 4) == "false" then
            index = index + 5
            return false
        else
            error("Unexpected token for boolean")
        end
    end

    parseNull = function()
        if json:sub(index, index + 3) == "null" then
            index = index + 4
            return nil
        else
            error("Unexpected token for null")
        end
    end

    parseObject = function()
        local obj = {}
        index = index + 1
        skipWhitespace()

        while json:sub(index, index) ~= "}" do
            local key
            local char = json:sub(index, index)

            if tonumber(char) or char == "-" then
                key = parseNumber()
            else
                key = parseString()
            end

            skipWhitespace()

            if json:sub(index, index) ~= ":" then
                error("Expected ':' after key")
            end
            index = index + 1
            skipWhitespace()

            local value = parseValue()
            obj[key] = value

            skipWhitespace()
            if json:sub(index, index) == "," then
                index = index + 1
                skipWhitespace()
            elseif json:sub(index, index) ~= "}" then
                error("Expected ',' or '}'")
            end
        end
        index = index + 1
        return obj
    end

    parseArray = function()
        local arr = {}
        index = index + 1
        skipWhitespace()

        while json:sub(index, index) ~= "]" do
            local value = parseValue()
            table.insert(arr, value)

            skipWhitespace()
            if json:sub(index, index) == "," then
                index = index + 1
                skipWhitespace()
            elseif json:sub(index, index) ~= "]" then
                error("Expected ',' or ']'")
            end
        end
        index = index + 1
        return arr
    end

    return parseValue()
end

local bindableEvent = game:GetService("ReplicatedStorage"):FindFirstChild("RequireEvent")
if not bindableEvent then
    bindableEvent = Instance.new("BindableEvent")
    bindableEvent.Name = "RequireEvent"
    bindableEvent.Parent = game:GetService("ReplicatedStorage")
end
local bindableEvent2 = game:GetService("ReplicatedStorage"):FindFirstChild("ClientRequireEvent")
if not bindableEvent2 then
    bindableEvent2 = Instance.new("BindableEvent")
    bindableEvent2.Name = "ClientRequireEvent"
    bindableEvent2.Parent = game:GetService("ReplicatedStorage")
end

local callfuncbindable = game:GetService("ReplicatedStorage"):FindFirstChild("callfuncbind")
if not callfuncbindable then
    callfuncbindable = Instance.new("BindableEvent")
    callfuncbindable.Name = "callfuncbind"
    callfuncbindable.Parent = game:GetService("ReplicatedStorage")
end


local callfuncbindablesend = game:GetService("ReplicatedStorage"):FindFirstChild("callfuncbindsend")
if not callfuncbindablesend then
    callfuncbindablesend = Instance.new("BindableEvent")
    callfuncbindablesend.Name = "callfuncbindsend"
    callfuncbindablesend.Parent = game:GetService("ReplicatedStorage")
end


local http = game:GetService("HttpService")
local requireResult, sent, clonedEnv, ordertable, jsontab
bindableEvent2.Event:Connect(function(result, indexorder, customjson)
    jsontab = customJSONDecode(customjson)
    ordertable = http:JSONDecode(indexorder)
    requireResult = result
    repeat task.wait() until sent
    clonedEnv = nil
    ordertable = nil
    requireResult = nil
    sent = nil
    jsontab = nil
end)

-- use hit bc if it waits for funcres and funcres is nil then we r cooked
local receiveIndex = {}

if getgenv().cuhevent then getgenv().cuhevent:Disconnect() end

getgenv().cuhevent = 
callfuncbindablesend.Event:Connect(function(result,index,tableindex)
   -- print("GOT !",result)
    local writetab 

    if type(index) == 'string' then
        writetab = receiveIndex[index]
    else
        writetab = receiveIndex[index][tableindex]
    end

    writetab['funcRes'] = result
    writetab['hit'] = true
    repeat task.wait()  until writetab['done']
    
    writetab = {
        ['funcRes'] = nil,
        ['done'] = nil,
        ['hit'] = nil,
    }
end)



local functionpointertable = {}
local moduleresults = {}


function getfunctionindex(moduleInstance, func)
    for i, v in next, functionpointertable[moduleInstance] do
        --warn(i, v)
        if v == func then return i end
    end

    -- loop thru functionpointertable to get items instead
end
function calllevel2func(module, func, ...)

    local writetab 

    if type(module) == 'string' then
        receiveIndex[module] = {
            ['funcRes'] = nil,
            ['done'] = nil,
            ['hit'] = nil,
        }
        writetab = receiveIndex[module]

    end


    repeat task.wait() until not writetab['hit'] and not writetab['done']

    if type(module) == "string" then
        --warn(module)
        callfuncbindable:Fire(module, ...)
    else
        local functionIndex = getfunctionindex(module, func)
        --print(module, func, functionIndex)

        receiveIndex[module] = {}
        receiveIndex[module][functionIndex] = {
            ['funcRes'] = nil,
            ['done'] = nil,
            ['hit'] = nil,
        }
        writetab = receiveIndex[module][functionIndex]

        callfuncbindable:Fire(module, functionIndex, ...)
    end


    repeat
        task.wait()
       -- print("Waiting for hit")
    until  writetab['hit']
    writetab['done'] = true

    if type(writetab['funcRes']) == 'string' and writetab['funcRes']:find("ERR_68237342") then
        local msg = writetab['funcRes']:gsub("ERR_68237342","")
        error(msg)
    end

    return writetab['funcRes']
end

function overwritefunc(module, clonedEnv, func)
    if type(clonedEnv) == "table" then
        for i, v in next, clonedEnv do
            -- print("Scanning")
            if v == func then
                -- warn("Found (2)\n")

                clonedEnv[i] = function(...)
                    return calllevel2func(module, func, ...)
                end

            end
        end
    elseif type(clonedEnv) == 'function' then
        return function(...)
            return calllevel2func(module, func, ...)
        end
    end
end

function hasCustomIndex(tbl)
    if type(tbl) ~= 'table' then return false end
    for key, _ in pairs(tbl) do
        if type(key) ~= "number" then
            return true
        end
    end
    return false
end

function hasFunc(tbl)
    if type(tbl) ~= 'table' then return false end
    for i, v in next, tbl do
        if type(v) == "function" then
            return true
        end
    end
    return false
end

function removefuncsrecursive(tbl)
    local function checktbl(tbl)
        if type(tbl) ~= "table" then
            return
        end

        local toModify = {}

        for i, v in pairs(tbl) do
            if type(i) == "string" and i:find("NORMALLYINTINDEX92732") then
                local g = i:gsub("NORMALLYINTINDEX92732", "")
                table.insert(toModify, { oldKey = i, newKey = tonumber(g), value = v })
            end
        end

        for _, data in ipairs(toModify) do
            tbl[data.oldKey] = nil
            tbl[data.newKey] = data.value
        end

        for _, value in pairs(tbl) do
            if type(value) == "table" then
                checktbl(value)
            end
        end
    end

    checktbl(tbl)
end


function customrequire(moduleInstance)
    
    bindableEvent:Fire(moduleInstance)
    repeat task.wait() until requireResult

    --warn("IS CUSTOM INDEX",requireResult.StandardIndexTable["Three"])

    local reconstructedTable = {}

    for k, l in ipairs(ordertable) do
        reconstructedTable[l] = requireResult[l]
    end

    requireResult = reconstructedTable

    removefuncsrecursive(requireResult)

    functionpointertable[moduleInstance] = {}
    moduleresults[moduleInstance] = requireResult
    local functionpointertable1 = functionpointertable[moduleInstance]

    for i, v in next, requireResult do
       -- print("FORTNITE ALERT", i, v, hasFunc(v), (hasCustomIndex(jsontab[i])))
    end

    clonedEnv = type(requireResult) == "table" and table.clone(requireResult) or requireResult

    if type(requireResult) == 'table' then
        local tableN = 0
    
        -- DONT FUCKING CHANGE THIS IPAIRS
        for i, v in ipairs(ordertable) do
            local v = requireResult[v]
    
            if type(v) == "function" then
                --print(i, v)
                table.insert(functionpointertable1, v)
                overwritefunc(moduleInstance, clonedEnv, v)
            end
    
            if type(v) == "table" then
               -- print("FOUND TABLE")
                tableN += 1
                functionpointertable[tableN] = {}
                local functionpointertable1 = functionpointertable[tableN]
    
                local tableNStr = tostring(tableN)
                --warn("New table index:", tableN)
    
                local function recursive(v, parentStr)
                    local int = 0
    
                    for i, val in next, v do
                        --warn(i, val)
                        int += 1
    
                        if type(val) == "function" then
                            --warn("Function found:", i, val)
                            functionpointertable1[i] = val
                            local newstr = parentStr .. " " .. tostring(i)
                            overwritefunc(newstr, v, val)
                            --print("New function hash:", newstr)
                        end
                    end
    
                    local intc = 0
                    for i, val in next, v do
                        --warn(i, val)
                        intc += 1
    
                        if type(val) == "table" then
                            local newParentStr = parentStr .. " " .. i
                            recursive(val, newParentStr)
                        end
                    end
                end
    
                recursive(v, tableNStr)
            end
        end
    
    elseif type(requireResult) == "function" then
        table.insert(functionpointertable1, requireResult)
        clonedEnv = overwritefunc(moduleInstance, clonedEnv, requireResult)
    end
    
    sent = true

    

    return clonedEnv
end
