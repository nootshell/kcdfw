-- For some reason Lua 5.1 is a total static nightmare.
local function workaroundStupidShit(fmt, tbl)
	local newTable = { };

	local defaultMap = {
		u = 0,
		s = '',
		f = 0.0,
		q = ''
	};
	local default;
	for f in fmt:gmatch("%%[A-Za-z]") do
		default = defaultMap[f:sub(2)];

		if default then
			table.insert(newTable, default);
		end
	end

	if type(tbl) == "table" then
		for i, value in ipairs(tbl) do
			newTable[i] = tostring(value)
		end
	end

	return newTable
end

if _VERSION == 'Lua 5.1' then
	table.unpack = unpack
end


kcdfw.log = function (level, context, fmt, ...)
	local trueLevel = kcdfw.bitwiseAnd(level, 0x0FFF);
	if trueLevel > kcdfw.logLevel then
		return;
	end

	-- awaiting 5.2+ -- local frame = debug.getinfo(2 + (kcdfw.bitwiseAnd(level, KCDFW_FLAG_EXTRA_FRAME) >> 12));
	local frame = debug.getinfo(2 + (((kcdfw.bitwiseAnd(level, KCDFW_FLAG_EXTRA_FRAME) == KCDFW_FLAG_EXTRA_FRAME) and 1) or 0));
	local sauce = frame.source;
	local line = frame.currentline;
	local idx = sauce:find(kcdfw.paths.root);
	if idx then
		-- will never hit on !runLocal, may eventually fix (probably not, dunno)
		if kcdfw.distribution then
			sauce = "KCDFW";
		else
			sauce = ("%s" .. ((line > 0 and ":%u") or "")):format(sauce:sub(#kcdfw.paths.root + idx + 1), line);
		end
	else
		sauce = context.package.name;
	end

	local strFormatted;
	if (kcdfw.bitwiseAnd(level, KCDFW_FLAG_NO_PREFIX) == KCDFW_FLAG_NO_PREFIX) then
		strFormatted = fmt:format(table.unpack(workaroundStupidShit(fmt, {...})));
	else
		if trueLevel > 0 then
			strFormatted = (("%s %s %s"):format("[%s]", "(%s)", fmt)):format(sauce, trueLevel, table.unpack(workaroundStupidShit(fmt, {...})));
		else
			strFormatted = (("%s %s"):format("[%s]", fmt)):format(sauce, table.unpack(workaroundStupidShit(fmt, {...})));
		end
	end

	if not kcdfw.runLocal then
		System.LogAlways(strFormatted);
	else
		print(strFormatted);
	end
end

kcdfw.logNotice(kcdfw, "Logging function upgraded.");
kcdfw.logBootstrap(kcdfw, "Permitting log levels %u-%u.", KCDFW_LEVEL_BOOTSTRAP, kcdfw.logLevel);




kcdfw.strToLogLevel = function(str)
	if str == "debug" then return KCDFW_LEVEL_DEBUG; end
	if str == "verbose" then return KCDFW_LEVEL_VERBOSE; end
	if str == "info" then return KCDFW_LEVEL_INFO; end
	if str == "notice" then return KCDFW_LEVEL_NOTICE; end
	if str == "warning" then return KCDFW_LEVEL_WARNING; end
	if str == "error" then return KCDFW_LEVEL_ERROR; end

	return nil;
end

kcdfw.setLogLevel = function(level)
	local lvl = level;

	if not kcdfw.isInt(lvl) then
		lvl = kcdfw.strToLogLevel(lvl);
	end

	if not kcdfw.isInt(lvl) then
		kcdfw.logError(kcdfw, "Invalid level indicator given: %s", tostring(level));
		return;
	end

	local old = kcdfw.logLevel;
	if lvl == old then
		kcdfw.log(lvl, kcdfw, "Log level remained unchanged.");
	else
		kcdfw.logLevel = lvl;
		kcdfw.log(lvl, kcdfw, "Log level changed from %u to %u.", old, lvl);
	end
end




kcdfw.normalizeCmdlineKey = function(key)
	return key:gsub("^-*", ""):gsub("=.*$", "");
end

kcdfw.parseCmdline = function(cmdline, nonoptions)
	local found = {};
	local nopts = (nonoptions or {});

	local key = nil;
	local optend = false;
	for arg in cmdline:gmatch("%S+") do
		if not optend then
			if arg:sub(1, 1) == '-' then
				if key then
					found[key] = true
				end

				if arg == '--' then
					key = nil;
					optend = true;
				else
					key = kcdfw.normalizeCmdlineKey(arg);
				end
			else
				if key then
					found[key] = arg;
					key = nil;
				else
					table.insert(nopts, arg);
				end
			end
		else
			table.insert(nopts, arg);
		end
	end

	if key then
		found[key] = true
		key = nil;
	end

	-- For any key=value pairs, override.
	for key, value in cmdline:gsub(" -- .*", ""):gmatch("-?(%S+)=(%S+)") do
		found[kcdfw.normalizeCmdlineKey(key)] = value;
	end

	return found;
end

-- Abbreviated parseCmdline wrapper.
function cmdtab(cmdline)
	local nopts = {};
	local res = kcdfw.parseCmdline(cmdline, nopts);
	res.__nopts = nopts;
	res.__values = nopts; -- TODO: distinguish between non-options and values, e.g. values only come after all params/--
	return res;
end
