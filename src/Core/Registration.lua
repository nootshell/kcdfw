kcdfw.registerCommand = function (command, expr, description, usage)
	if not kcdfw.runLocal then
		System.AddCCommand(
			command,
			expr,
			kcdfw.trimText(("Usage: %s %s\n\n%s"):format(command, usage, description))
		);
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
