kcdfw.registerCommand = function (command, expr, usage)
	System.AddCCommand(command, expr, usage);
	kcdfw.logNotice("Command registered: %q", command);
end
