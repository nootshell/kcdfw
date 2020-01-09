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




kcdfw.getFunctionMeta = function(fun)
	local res = {
		info = nil,
		params = nil
	};

	pcall(function()
		local cr = coroutine.create(fun);
		debug.sethook(
			cr,
			function()
				res.info = debug.getinfo(cr, 2);
				res.params = { };

				local name;
				for i = 1, math.huge do
					name = debug.getlocal(cr, 2, i);

					if not name then
						error('');
					end

					if name ~= "(*temporary)" then
						table.insert(res.params, name);
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




kcdfw.dumpTable = function(object)
	if type(object) ~= "table" then
		return;
	end

	local noargs = { "?" };

	local t, info;
	for key, value in pairs(object) do
		t = type(value);
		if value and t == "function" then
			meta = kcdfw.getFunctionMeta(value);

			if meta.info then
				kcdfw.logAlways(
					kcdfw,
					"%s(%s) : %s (%s:%u)",
					key,
					table.concat(
						(meta.params or noargs),
						", "
					),
					t,
					meta.info.source:sub(2),
					meta.info.linedefined
				);
			else
				kcdfw.logAlways(
					kcdfw,
					"%s(%s) : %s",
					key,
					table.concat(
						(meta.params or noargs),
						", "
					),
					t
				);
			end
		else
			kcdfw.logAlways(kcdfw, "%s : %s", key, t);
		end
	end
end
