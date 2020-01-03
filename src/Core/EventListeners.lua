function kcdfw:actionListenerGateway(action, event, args)
	if action == "sys_loadingimagescreen" and event == "OnEnd" then
		for id, f in pairs(kcdfw.eventMap.postLoadingScreen) do
			if (type(f) == "function") then
				kcdfw.logDebug("Firing: %s (%s)", id, tostring(f));
				f();
				kcdfw.logDebug("Done: %s", id);
			end
		end
	end
end


if not kcdfw.runLocal then
	UIAction.RegisterActionListener(
		kcdfw,
		"",
		"",
		"actionListenerGateway"
	)
else
	kcdfw.logInfo("Skipped registering action listener");
end


if not kcdfw.distribution then
	kcdfw.registerPostLoadingScreen(
		'kcdfw_debug_hook',
		function ()
			kcdfw.logInfo("KCDFW loaded and available.");
		end
	);
end
