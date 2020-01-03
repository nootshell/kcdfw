KCDFW_LEVEL_DEBUG 		= 45;

KCDFW_LEVEL_VERBOSE		= 40;
KCDFW_LEVEL_INFO		= 35;
KCDFW_LEVEL_NOTICE		= 30;

KCDFW_LEVEL_WARNING		= 25;
KCDFW_LEVEL_ERROR		= 20;

KCDFW_LEVEL_BOOTSTRAP	= 10;




kcdfw = {
	distribution = false, -- [intermeta:true]

	package = {
		name = "&{MOD_NAME}",
		author = "&{MOD_AUTHOR}",
		date = "&{MOD_BUILD_DATE}",
		version = "&{MOD_VERSION}"
	},

	log = function (level, fmt, ...)
		print(
			(("%s %s %s"):format("[%s]", "(%s)", fmt)):format("KCDFW", level, ...)
		);
	end,
	logLevel = KCDFW_LEVEL_INFO
};




kcdfw.logDebug = function (fmt, ...)
	kcdfw.log(KCDFW_LEVEL_DEBUG, fmt, ...)
end

kcdfw.logVerbose = function (fmt, ...)
	kcdfw.log(KCDFW_LEVEL_VERBOSE, fmt, ...)
end

kcdfw.logInfo = function (fmt, ...)
	kcdfw.log(KCDFW_LEVEL_INFO, fmt, ...)
end

kcdfw.logNotice = function (fmt, ...)
	kcdfw.log(KCDFW_LEVEL_NOTICE, fmt, ...)
end

kcdfw.logWarning = function (fmt, ...)
	kcdfw.log(KCDFW_LEVEL_WARNING, fmt, ...)
end

kcdfw.logError = function (fmt, ...)
	kcdfw.log(KCDFW_LEVEL_ERROR, fmt, ...)
end

kcdfw.logBootstrap = function (fmt, ...)
	kcdfw.log(KCDFW_LEVEL_BOOTSTRAP, fmt, ...)
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
	if kcdfw.distribution then
		rootPath = "Scripts";
	else
		rootPath = pwdPath;
	end

	return {
		root = rootPath,
		core = ("%s/%s"):format(rootPath, "Core")
	};
end

kcdfw.paths = buildPaths();

kcdfw.logDebug("paths.root    = %q", kcdfw.paths.root);
kcdfw.logDebug("paths.core    = %q", kcdfw.paths.core);




KCDFW_MODULE_PATH = nil;

kcdfw.bootstrap = function (base, ...)
	for i, module in ipairs({...}) do
		KCDFW_MODULE_PATH = ("%s/%s.lua"):format(base, module);

		kcdfw.logVerbose("Module load: %q", KCDFW_MODULE_PATH);
		if kcdfw.distribution then
			Script.ReloadScript(KCDFW_MODULE_PATH);
		else
			dofile(KCDFW_MODULE_PATH);
		end
		kcdfw.logBootstrap("Module init: %q", KCDFW_MODULE_PATH);
	end

	KCDFW_MODULE_PATH = nil;
end

kcdfw.bootstrap(kcdfw.paths.core, "Logging", "Registration");

kcdfw.registerCommand('kcdfw_test', "kcdfw.log(%line)", 'testing');
