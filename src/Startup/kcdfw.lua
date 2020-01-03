KCDFW_LEVEL_DEBUG 		= 45;

KCDFW_LEVEL_VERBOSE		= 40;
KCDFW_LEVEL_INFO		= 35;
KCDFW_LEVEL_NOTICE		= 30;

KCDFW_LEVEL_WARNING		= 25;
KCDFW_LEVEL_ERROR		= 20;

KCDFW_LEVEL_BOOTSTRAP	= 10;
KCDFW_LEVEL_ALWAYS		= 0;

--                        0x0FFF = range for true log level (more than ever ever ever needed but who cares)
KCDFW_FLAG_EXTRA_FRAME	= 0x1000;
KCDFW_FLAG_NO_PREFIX	= 0x2000;




kcdfw = {
	distribution = false, -- [intermeta-TODO:ask]
	runLocal = true, -- [intermeta:false]

	package = {
		name = "&{MOD_NAME}",
		author = "&{MOD_AUTHOR}",
		date = "&{MOD_BUILD_DATE}",
		version = "&{MOD_VERSION}"
	},


	-- Lua 5.1 (used in KCD) does not support native bitwise operations, until KCD makes use of 5.2+ these
	-- functions will have to drop in for that deficiency.

	bitwiseAnd = function (x, y)
		-- Taken from https://stackoverflow.com/questions/32387117/

		local result = 0
		local bitval = 1

		while x > 0 and y > 0 do
		if x % 2 == 1 and y % 2 == 1 then -- test the rightmost bits
			result = result + bitval      -- set the current bit
		end

		bitval = bitval * 2 -- shift left
		x = math.floor(x / 2) -- shift right
		y = math.floor(y / 2)
		end

		return result
	end,

	bitwiseOr = function (x, y)
		-- Absolutely not ideal, but this works so long as no bits overlap (should be the case in this codebase).
		return (x + y);
	end,


	log = function (level, fmt, ...)
		print(
			(("%s %s %s"):format("[%s]", "(%s)", fmt)):format("KCDFW", kcdfw.bitwiseAnd(level, 0x0FFF), ...)
		);
	end,
	logLevel = KCDFW_LEVEL_INFO
};




kcdfw.logDebug = function (fmt, ...)
	kcdfw.log(
		kcdfw.bitwiseOr(KCDFW_LEVEL_DEBUG, KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logVerbose = function (fmt, ...)
	kcdfw.log(
		kcdfw.bitwiseOr(KCDFW_LEVEL_VERBOSE, KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logInfo = function (fmt, ...)
	kcdfw.log(
		kcdfw.bitwiseOr(KCDFW_LEVEL_INFO, KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logNotice = function (fmt, ...)
	kcdfw.log(
		kcdfw.bitwiseOr(KCDFW_LEVEL_NOTICE, KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logWarning = function (fmt, ...)
	kcdfw.log(
		kcdfw.bitwiseOr(KCDFW_LEVEL_WARNING, KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logError = function (fmt, ...)
	kcdfw.log(
		kcdfw.bitwiseOr(KCDFW_LEVEL_ERROR, KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logBootstrap = function (fmt, ...)
	kcdfw.log(
		kcdfw.bitwiseOr(KCDFW_LEVEL_BOOTSTRAP, KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logAlways = function (fmt, ...)
	kcdfw.log(
		kcdfw.bitwiseOr(KCDFW_LEVEL_ALWAYS, KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end




local function buildPaths()
	local pwdPath = debug.getinfo(1, "S").source:sub(2);
	pwdPath = pwdPath:sub(
		1,
		pwdPath:find("/[^/]*$") - 1
	);
	pwdPath = pwdPath:sub(
		1,
		pwdPath:find("/[^/]*$") - 1
	);

	local rootPath;
	if not kcdfw.runLocal then
		rootPath = "Scripts";
	else
		rootPath = pwdPath;
	end

	return {
		root = rootPath,
		cmds = ("%s/%s"):format(rootPath, "Commands"),
		core = ("%s/%s"):format(rootPath, "Core"),
		util = ("%s/%s"):format(rootPath, "Utilities")
	};
end

kcdfw.paths = buildPaths();




KCDFW_MODULE_PATH = nil;

kcdfw.bootstrap = function (base, ...)
	for i, module in ipairs({...}) do
		KCDFW_MODULE_PATH = ("%s/%s.lua"):format(base, module);

		kcdfw.logVerbose("Module load: %q", KCDFW_MODULE_PATH);
		if not kcdfw.runLocal then
			Script.ReloadScript(KCDFW_MODULE_PATH);
		else
			dofile(KCDFW_MODULE_PATH);
		end
		kcdfw.logBootstrap("Module init: %q", KCDFW_MODULE_PATH);
	end

	KCDFW_MODULE_PATH = nil;
end

kcdfw.logBootstrap("Bootstrapping started.");
kcdfw.bootstrap(kcdfw.paths.core, "Console", "Registration");
kcdfw.bootstrap(kcdfw.paths.util, "Tables");
kcdfw.bootstrap(kcdfw.paths.cmds, "Diagnostics");
kcdfw.logBootstrap("Bootstrapping finished.");




kcdfw.dumpToConsole = function(cmdline)
	kcdfw.logAlways("Commandline given to function: %q", cmdline);

	if cmdline then
		local nopts = {};
		local args = kcdfw.parseCmdline(cmdline, nopts);
		local argc = kcdfw.countTableEntries(args);

		if argc > 0 then
			kcdfw.logAlways("Arguments passed to this function:");
			for key, value in pairs(args) do
				kcdfw.logAlways("\t%q = %q", key, value);
			end
		end

		if #nopts > 0 then
			kcdfw.logAlways("Nonoptions found while parsing arguments:");
			for i, value in ipairs(nopts) do
				kcdfw.logAlways("\t%q", value);
			end
		end
	end

	local dumpVars;

	kcdfw.logAlways("Version:");
	dumpVars = {
		"date", "version"
	};
	for i, var in ipairs(dumpVars) do
		kcdfw.logAlways("\t%s = %q", var, kcdfw.package[var]);
	end

	kcdfw.logAlways("State:");
	dumpVars = {
		"distribution", "runLocal"
	};
	for i, var in ipairs(dumpVars) do
		kcdfw.logAlways("\t%s = %q", var, kcdfw[var])
	end
end

kcdfw.registerCommand(
	"kcdfw_dump",
	"kcdfw:dumpToConsole(%line)",
	"Dumps KCDFW state to the console."
);




kcdfw.log(
	((kcdfw.runLocal and KCDFW_LEVEL_BOOTSTRAP) or KCDFW_LEVEL_INFO),
	"KCDFW initialized, run %q to dump state.",
	((kcdfw.runLocal and "kcdfw.dumpToConsole([cmdline])") or "kcdfw_dump")
);
