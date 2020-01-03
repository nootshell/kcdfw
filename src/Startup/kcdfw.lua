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

	log = function (level, fmt, ...)
		print(
			(("%s %s %s"):format("[%s]", "(%s)", fmt)):format("KCDFW", (level & 0x0FFF), ...)
		);
	end,
	logLevel = KCDFW_LEVEL_INFO
};




kcdfw.logDebug = function (fmt, ...)
	kcdfw.log(
		(KCDFW_LEVEL_DEBUG | KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logVerbose = function (fmt, ...)
	kcdfw.log(
		(KCDFW_LEVEL_VERBOSE | KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logInfo = function (fmt, ...)
	kcdfw.log(
		(KCDFW_LEVEL_INFO | KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logNotice = function (fmt, ...)
	kcdfw.log(
		(KCDFW_LEVEL_NOTICE | KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logWarning = function (fmt, ...)
	kcdfw.log(
		(KCDFW_LEVEL_WARNING | KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logError = function (fmt, ...)
	kcdfw.log(
		(KCDFW_LEVEL_ERROR | KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logBootstrap = function (fmt, ...)
	kcdfw.log(
		(KCDFW_LEVEL_BOOTSTRAP | KCDFW_FLAG_EXTRA_FRAME),
		fmt,
		...
	);
end

kcdfw.logAlways = function (fmt, ...)
	kcdfw.log(
		(KCDFW_LEVEL_ALWAYS | KCDFW_FLAG_EXTRA_FRAME),
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

kcdfw.bootstrap(kcdfw.paths.core, "Console", "Registration");
kcdfw.bootstrap(kcdfw.paths.util, "Tables");

kcdfw.registerCommand('kcdfw_test', "kcdfw.logWarning(%line)", 'testing');
