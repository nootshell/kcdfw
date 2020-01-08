kcdfw.registerCommand = function(command, expr, description, usage)
	local strUsage = usage;
	local strUsageEx = "";
	local strDescription = description;

	if type(usage) == "table" then
		strUsage = "[-";
		strUsageEx = "\n\nOptions:";
		for opt, desc in pairs(usage) do
			strUsage = strUsage .. opt;
			strUsageEx = strUsageEx .. "\n  -" .. opt .. "  " .. desc;
		end
		strUsage = strUsage .. "]";
	end

	if not strUsage then
		strUsage = "";
	end
	if not strDescription then
		strDescription = "";
	end

	if not kcdfw.runLocal then
		System.AddCCommand(
			command,
			expr,
			kcdfw.trimText(
				("%s\n\nUsage: %s %s%s"):format(
					strDescription,
					command,
					strUsage,
					strUsageEx
				)
			)
		);
		kcdfw.logNotice(kcdfw, "Command registered: %q", command);
	else
		kcdfw.logNotice(kcdfw, "Skipped registering command: %q", command);
		kcdfw.logDebug(kcdfw, strDescription);
		kcdfw.logDebug(kcdfw, ("Usage: %s %s%s"):format(command, strUsage, strUsageEx));
	end
end


kcdfw.eventMap.postLoadingScreen = { };
kcdfw.registerPostLoadingScreen = function (id, callback)
	if type(id) ~= "string" or type(callback) ~= "function" then
		kcdfw.logError(kcdfw, "Type error.");
		return false
	end

	kcdfw.eventMap.postLoadingScreen[id] = callback;
end
