if _VERSION == 'Lua 5.1' then
	load = loadstring
end

local function clock()
	if kcdfw.runLocal then
		return os.clock();
	end

	return 0;
end

kcdfw.evalString = function (expr)
	kcdfw.logWarning(kcdfw, "Beginning eval of expression: %q", expr);

	local tBegin = clock();
	local f, error = load(expr);
	if not error then
		local tPreExec = clock();
		local result = f();
		local tPostExec = clock();

		local resultPad = "";
		if (type(result) == "string") then
			resultPad = "\"";
		end

		kcdfw.logWarning(
			kcdfw,
			"Eval done: load=%fs, exec=%fs, return=%s%s%s",
			(tPreExec - tBegin),
			(tPostExec - tPreExec),
			resultPad, tostring(result), resultPad
		);
	else
		kcdfw.logError(kcdfw, "Eval failed, dumping error below.");
		kcdfw.log(
			kcdfw.bitwiseOr(KCDFW_LEVEL_ERROR, KCDFW_FLAG_NO_PREFIX),
			kcdfw,
			tostring(error)
		);
	end
end

kcdfw.registerCommand(
	"kcdfw_eval",
	"kcdfw.evalString(%line)",
	"Evaluates the entire cmdline as a Lua expression.\nTo enable the use of the '=' sign, use command as \"kcdfw_eval= [expr]\".",
	"<expr>"
);




kcdfw.dumpToConsole = function(cmdline)
	if type(cmdline) == "string" then
		kcdfw.logAlways(kcdfw, "Commandline given to function: %q", cmdline);

		local nopts = {};
		local args = kcdfw.parseCmdline(cmdline, nopts);
		local argc = kcdfw.countTableEntries(args);

		if argc > 0 then
			kcdfw.logAlways(kcdfw, "Arguments passed to this function:");
			for key, value in pairs(args) do
				kcdfw.logAlways(kcdfw, "\t%q = %q", key, value);
			end
		end

		if #nopts > 0 then
			kcdfw.logAlways(kcdfw, "Nonoptions found while parsing arguments:");
			for i, value in ipairs(nopts) do
				kcdfw.logAlways(kcdfw, "\t%q", value);
			end
		end
	end

	local dumpVars;

	kcdfw.logAlways(kcdfw, "State:");
	dumpVars = {
		"distribution", "runLocal"
	};
	for i, var in ipairs(dumpVars) do
		kcdfw.logAlways(kcdfw, "\t.%s = %q", var, kcdfw[var])
	end

	kcdfw.logAlways(kcdfw, "\tpackage:");
	dumpVars = {
		"date", "version"
	};
	for i, var in ipairs(dumpVars) do
		kcdfw.logAlways(kcdfw, "\t\t.%s = %q", var, kcdfw.package[var]);
	end

	kcdfw.logAlways(kcdfw, "\tusersMap:");
	for name, context in pairs(kcdfw.usersMap) do
		kcdfw.logAlways(kcdfw, "\t\t%q = %s", name, tostring(context));
	end

	kcdfw.logAlways(kcdfw, "\teventMap:");
	local n;
	for type, map in pairs(kcdfw.eventMap) do
		n = kcdfw.countTableEntries(map);
		kcdfw.logAlways(kcdfw, "\t\t.%s (%u callback%s)", type, n, kcdfw.getTextS(n));

		for id, f in pairs(map) do
			kcdfw.logAlways(kcdfw, "\t\t\t.%s = %s", id, tostring(f));
		end
	end
end

kcdfw.registerCommand(
	"kcdfw_dump",
	"kcdfw.dumpToConsole(%line)",
	"Dumps KCDFW state to the console."
);




kcdfw.cmdInspect = function(args)
	local dump = (args.dump or args.d);
	local lookGlobal = (args.global or args.g);
	local objectName = (args.object or args.o);


	if not objectName then
		kcdfw.logError(kcdfw, "Missing/invalid object name.");
		return;
	end


	local object = nil;

	if lookGlobal then
		object = _G[objectName];
	end


	kcdfw.logAlways(kcdfw, "%s = %s", objectName, kcdfw.stringRepresentation(object));


	if dump then
		kcdfw.dumpTable(object);
	end
end

kcdfw.registerCommand(
	"kcdfw_inspect",
	"kcdfw.cmdInspect(cmdtab(%line))",
	"Uses introspection to display properties of the specified object.",
	{
		d = "Dump object.",
		g = "Use the global table to look up the object.",
		o = { value = "object_name", description = "Specify the object to inspect." }
	}
)




kcdfw.cmdLogLevel = function(args)
	kcdfw.setLogLevel(args.level or args.l);
end

kcdfw.registerCommand(
	"kcdfw_loglevel",
	"kcdfw.cmdLogLevel(cmdtab(%line))",
	"Sets the log level for the loggers shipped with KCDFW.",
	{
		l = { value = "level", description = "The level to use. Can be numeric or named." }
	}
);
