kcdfw.registerCommand = function (command, expr, usage)
	if not kcdfw.runLocal then
		System.AddCCommand(command, expr, usage);
		kcdfw.logNotice(kcdfw.package.name, "Command registered: %q", command);
		return;
	end

	kcdfw.logNotice(kcdfw.package.name, "Skipped registering command: %q", command);
end


kcdfw.eventMap.postLoadingScreen = { };
kcdfw.registerPostLoadingScreen = function (id, callback)
	if type(id) ~= "string" or type(callback) ~= "function" then
		kcdfw.logError(kcdfw.package.name, "Type error.");
		return false
	end

	kcdfw.eventMap.postLoadingScreen[id] = callback;
end
