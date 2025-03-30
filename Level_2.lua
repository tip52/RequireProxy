-- LEVEL 2 SCRIPT

-- should probably make this unparented but meh who gaf not me
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


local functionpointertable = {}
local stringpointertable = {}

function isinstringptr(string)

	for i,v in next, stringpointertable do
		--print(i,v)
		if v == string then
			return i
		end
	end
end

callfuncbindable.Event:Connect(function(module, ...)
	local args = {...}
	local index = args[1]
	--print(module, ...)

	local functiontocall = (type(module) == "string" and isinstringptr(module) or functionpointertable[module] and functionpointertable[module][index])

	local suc, result = pcall(function()
		return functiontocall(unpack(args))
	end)

	--warn("Firing!")
	
	if not suc then
		result ..= "ERR_68237342"
	end

	callfuncbindablesend:Fire(result, type(module) == "string" and module or (functionpointertable[module] and module), (functionpointertable[module] and index))
end)

local http = game:GetService("HttpService")

-- chatgpt json encode (DONT WORRY TS NOT EVEN USED 💔💔💔)
function customJSONEncode(value)
	local function encodeTable(tbl)
		local result = "{"
		for key, val in pairs(tbl) do
			local formattedKey
			if type(key) == "number" then
				formattedKey = tostring(key)
			else
				formattedKey = '"' .. tostring(key) .. '"' 
			end
			local formattedValue = customJSONEncode(val)
			result = result .. formattedKey .. ":" .. formattedValue .. ","
		end
	
		if #result > 1 then
			result = result:sub(1, #result - 1)
		end
		result = result .. "}"
		return result
	end

	if type(value) == "table" then
		return encodeTable(value)
	elseif type(value) == "string" then
		return '"' .. value .. '"'
	elseif type(value) == "number" or type(value) == "boolean" then
		return tostring(value)
	elseif value == nil then
		return "null"
	else
		return '"' .. tostring(value) .. '"'
	end
end

function hasNormalIndex(tbl)
	for key, _ in pairs(tbl) do
		if type(key) == "number" then
			return true
		end
	end
	return false
end

function addfuncsrecursive(tbl)

	function checktbl(tbl)
		if type(tbl) ~= "table" then
			return
		end

		for i,v in next, tbl do
			--warn(i,v)
			if type(i) == 'number' then
				--print("Hello giys today i am replacing a index")
				tbl[i] = nil
				tbl[tostring(i) .. "NORMALLYINTINDEX92732"] = v
			end
		end


		for key, value in pairs(tbl) do
			if type(value) == "table" then
				checktbl(value) 
			end
		end
	end

	checktbl(tbl)

end

bindableEvent.Event:Connect(function(moduleInstance)
	local module = require(moduleInstance)
	addfuncsrecursive(module)
	functionpointertable[moduleInstance] = {}
	--print(moduleInstance)
	local functionpointertable1 = functionpointertable[moduleInstance]

	for i,v in next, module do
		--warn("FORTNITE ALERT",i,v)
	end 


	if type(module) == 'table' then
		local tableN = 0

		for k, v in next, module do
			if type(v) == "function" then
				table.insert(functionpointertable1, v)
			end

			if type(v) == "table" then
				tableN += 1
				functionpointertable[tableN] = {}
				local functionpointertable1 = functionpointertable[tableN]

				local tableNStr = tostring(tableN)

				-- Recursive function with proper tracking
				local function recursive(v, parentStr)
					--print("Recursive called with parent:", parentStr)

					local int = 0
					for i, val in next, v do
						--warn(i, val)
						int += 1

						if type(val) == "function" then
							--warn("Function found:", i, val)
							functionpointertable1[i] = val
							local newstr = parentStr .. " " .. tostring(i)
							stringpointertable[val] = newstr
							--print("New hash:", newstr)
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

				for i, v in next, v do
					if type(v) == "function" then
						functionpointertable1[i] = v
					end
				end
			end
		end
	elseif type(module) == "function" then
		table.insert(functionpointertable1,module)
	end

	local orderTable = {}

	for i,v in next, module do
		table.insert(orderTable,i)
	end

	local json = http:JSONEncode(orderTable)
	local json2 = customJSONEncode(module)
	--warn(json)

	--warn(json2)
	bindableEvent2:Fire(module,json,json2)
end)

