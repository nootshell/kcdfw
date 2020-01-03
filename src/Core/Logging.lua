kcdfw.log = function (level, fmt, ...)
	if level > kcdfw.logLevel then
		return;
	end

	local strFormatted = (("%s %s %s"):format("[%s]", "(%s)", fmt)):format("KCDFW", level, ...);
	if kcdfw.distribution then
		System.LogAlways(strFormatted);
	else
		print(strFormatted);
	end
end

kcdfw.logNotice("Logging function upgraded.");
kcdfw.logBootstrap("Log level set to %u-%u.", KCDFW_LEVEL_BOOTSTRAP, kcdfw.logLevel);
