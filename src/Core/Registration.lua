kcdfw.registerCommand = function (command, expr, usage)
	if not kcdfw.runLocal then
		System.AddCCommand(command, expr, usage);
		kcdfw.logNotice("Command registered: %q", command);
		return;
	end

	kcdfw.logNotice("Skipped registering command: %q", command);
end
