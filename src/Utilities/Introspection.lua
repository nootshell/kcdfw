kcdfw.getParamValues = function(table, frameExtra)
	local res = (table or { });

	local fr = 2;
	if kcdfw.isInt(frameExtra) then
		fr = (fr + frameExtra);
	end

	local name, value;
	for i = 1, math.huge do
		name, value = debug.getlocal(fr, i)

		if not name then
			return res;
		end

		if name ~= "(*temporary)" then
			res[name] = value;
		end
	end

	return res;
end




kcdfw.getFunctionParams = function(fun)
	local res = { };

	pcall(function()
		local cr = coroutine.create(fun);
		debug.sethook(
			cr,
			function()
				local name;
				for i = 1, math.huge do
					name = debug.getlocal(cr, 2, i);

					if not name then
						error('');
					end

					if name ~= "(*temporary)" then
						table.insert(res, name);
					end
				end
				error('');
			end,
			"c"
		);
		coroutine.resume(cr);
	end);

	return res;
end




kcdfw.stringRepresentation = function(object)
	local t = type(object);

	if t == "nil" then
		return "nil";
	end

	if t == "number" then
		return ("%s: %s"):format(t, tostring(object));
	end

	if t == "string" then
		return ("%s: %q"):format(t, tostring(object));
	end

	return tostring(object);
end




kcdfw.dumpFunctions = function(object)
	for key, value in pairs(object) do
		if value and type(value) == "function" then
			kcdfw.logAlways(kcdfw, "%s(%s)", key, table.concat(kcdfw.getFunctionParams(value), ", "));
		else
			kcdfw.logAlways(kcdfw, "%s : %s", key, type(value));
		end
	end
end
