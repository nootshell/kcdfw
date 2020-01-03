KCDFW_LEVEL_DEBUG 		= 45;

KCDFW_LEVEL_VERBOSE		= 40;
KCDFW_LEVEL_INFO		= 35;
KCDFW_LEVEL_NOTICE		= 30;

KCDFW_LEVEL_WARNING		= 25;
KCDFW_LEVEL_ERROR		= 20;

KCDFW_LEVEL_BOOTSTRAP	= 10;




kcdfw = {
	distribution = true, -- [intermeta:true]

	package = {
		name = "&{MOD_NAME}",
		author = "&{MOD_AUTHOR}",
		date = "&{MOD_BUILD_DATE}",
		version = "&{MOD_VERSION}"
	},

	__funcs = {
		log = function (level, fmt, ...)
			if kcdfw.distribution and level == "debug" then
				return;
			end

			print(
				(("%s %s %s"):format("[%s]", "(%s)", fmt)):format("KCDFW", level, ...)
			);
		end
	},

	logLevel = KCDFW_LEVEL_INFO
};




function kcdfw:log(level, fmt, ...)
	if level > kcdfw.logLevel then
		return
	end

	kcdfw.__funcs.log(level, fmt, ...)
end

function kcdfw:logDebug(fmt, ...)
	kcdfw:log(KCDFW_LEVEL_DEBUG, fmt, ...)
end

function kcdfw:logVerbose(fmt, ...)
	kcdfw:log(KCDFW_LEVEL_VERBOSE, fmt, ...)
end

function kcdfw:logInfo(fmt, ...)
	kcdfw:log(KCDFW_LEVEL_INFO, fmt, ...)
end

function kcdfw:logNotice(fmt, ...)
	kcdfw:log(KCDFW_LEVEL_NOTICE, fmt, ...)
end

function kcdfw:logWarning(fmt, ...)
	kcdfw:log(KCDFW_LEVEL_WARNING, fmt, ...)
end

function kcdfw:logError(fmt, ...)
	kcdfw:log(KCDFW_LEVEL_ERROR, fmt, ...)
end

function kcdfw:logBootstrap(fmt, ...)
	kcdfw:log(KCDFW_LEVEL_BOOTSTRAP, fmt, ...)
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


KCDFW_MODULE_PATH = nil;
function kcdfw:bootstrap(base, ...)
	for i, module in ipairs({...}) do
		KCDFW_MODULE_PATH = ("%s/%s.lua"):format(base, module);

		kcdfw:logVerbose("Module load: %q", KCDFW_MODULE_PATH);
		if kcdfw.distribution then
			Script.ReloadScript(KCDFW_MODULE_PATH);
		else
			dofile(KCDFW_MODULE_PATH);
		end
		kcdfw:logBootstrap("Module init: %q", KCDFW_MODULE_PATH);
	end

	KCDFW_MODULE_PATH = nil;
end


kcdfw.paths = buildPaths();




kcdfw:logDebug("paths.root    = %q", kcdfw.paths.root);
kcdfw:logDebug("paths.core    = %q", kcdfw.paths.core);

kcdfw:bootstrap(kcdfw.paths.core, "Logging", "Override", "Diagnostics");
