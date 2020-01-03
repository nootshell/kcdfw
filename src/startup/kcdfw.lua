kcdfw = {
	distribution = false,

	package = {
		date = "&{BUILD_DATE}",
		git = {
			origin = "&{GIT_ORIGIN_URL}",
			commit = "&{GIT_COMMIT_SHORT}",
			branch = "&{GIT_COMMIT_ABBREV}"
		}
	},

	__funcs = {
		log = function (level, fmt, ...)
			print(
				(('%s %s'):format('[%s]', fmt)):format(level, ...)
			)
		end
	}
};




KCDFW_LEVEL_DEBUG 		= 'dbg';

KCDFW_LEVEL_VERBOSE		= 'ver';
KCDFW_LEVEL_INFO		= 'inf';
KCDFW_LEVEL_NOTICE		= 'not';

KCDFW_LEVEL_WARNING		= 'wrn';
KCDFW_LEVEL_ERROR		= 'err';

KCDFW_LEVEL_BOOTSTRAP	= 'bsp';

function kcdfw:log(level, fmt, ...)
	kcdfw.__funcs.log(level, fmt, ...)
end




local function buildPathsFromRoot(rootPath)
	local pwdPath = debug.getinfo(1, 'S').source:sub(2);
	pwdPath = pwdPath:sub(
		1,
		pwdPath:find("/[^/]*$") - 1
	);
	pwdPath = pwdPath:sub(
		1,
		pwdPath:find("/[^/]*$") - 1
	);

	local __root, scriptsPath;
	if kcdfw.distribution then
		__root = rootPath;
		scriptsPath = ('%s/%s'):format(__root, 'Scripts');
	else
		__root = pwdPath;
		scriptsPath = __root;
	end

	return {
		root = __root,
		scripts = scriptsPath,
		pwd = pwdPath,
		core = ('%s/%s'):format(scriptsPath, "Core")
	};
end


KCDFW_MODULE_PATH = nil;
function kcdfw:bootstrap(base, ...)
	for i, module in ipairs({...}) do
		KCDFW_MODULE_PATH = ('%s/%s.lua'):format(base, module);

		if kcdfw.distribution then
			Script.ReloadScript(KCDFW_MODULE_PATH);
		else
			dofile(KCDFW_MODULE_PATH);
		end
	end

	KCDFW_MODULE_PATH = nil;
end


kcdfw.paths = buildPathsFromRoot("Mods/KCDFW");




kcdfw:log(KCDFW_LEVEL_BOOTSTRAP, kcdfw.paths.core)
kcdfw:bootstrap(kcdfw.paths.core, "Override", "Diagnostics");
