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
	kcdfw.logWarning(kcdfw.package.name, "Beginning eval of expression: %q", expr);

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
			kcdfw.package.name,
			"Eval done: load=%fs, exec=%fs, return=%s%s%s",
			(tPreExec - tBegin),
			(tPostExec - tPreExec),
			resultPad, tostring(result), resultPad
		);
	else
		kcdfw.logError(kcdfw.package.name, "Eval failed, dumping error below.");
		kcdfw.log(
			kcdfw.package.name,
			kcdfw.bitwiseOr(KCDFW_LEVEL_ERROR, KCDFW_FLAG_NO_PREFIX),
			error
		);
	end
end

kcdfw.registerCommand(
	"kcdfw_eval",
	"kcdfw.evalString(%line)",
	"Evaluates the entire cmdline as a Lua expression.\nTo enable the use of the '=' sign, use command as \"kcdfw_eval= [expr]\"."
);
