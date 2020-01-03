kcdfw.registerCommand = function (command, expr, usage)
	if not kcdfw.runLocal then
		System.AddCCommand(command, expr, usage);
		kcdfw.logNotice("Command registered: %q", command);
		return;
	end

	kcdfw.logNotice("Skipped registering command: %q", command);
end


kcdfw.eventMap.postLoadingScreen = { };
kcdfw.registerPostLoadingScreen = function (id, callback)
	if type(id) ~= "string" or type(callback) ~= "function" then
		kcdfw.logError("Type error.");
		return false
	end

	kcdfw.eventMap.postLoadingScreen[id] = callback;
end
