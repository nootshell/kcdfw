kcdfw.log = function (level, fmt, ...)
	if level > kcdfw.logLevel then
		return;
	end

	local strFormatted = (("%s %s %s"):format("[%s]", "(%s)", fmt)):format("KCDFW", level, ...);
	if not kcdfw.runLocal then
		System.LogAlways(strFormatted);
	else
		print(strFormatted);
	end
end

kcdfw.logNotice("Logging function upgraded.");
kcdfw.logBootstrap("Permitted log levels set to %u to %u.", KCDFW_LEVEL_BOOTSTRAP, kcdfw.logLevel);
