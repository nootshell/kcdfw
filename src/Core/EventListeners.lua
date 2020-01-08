function kcdfw:actionListenerGateway(action, event, args)
	if action == "sys_loadingimagescreen" and event == "OnEnd" then
		for id, f in pairs(kcdfw.eventMap.postLoadingScreen) do
			if (type(f) == "function") then
				kcdfw.logDebug(kcdfw, "Firing: %s (%s)", id, tostring(f));
				f();
				kcdfw.logDebug(kcdfw, "Done: %s", id);
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
	kcdfw.logInfo(kcdfw, "Skipped registering action listener");
end


if not kcdfw.distribution then
	kcdfw.registerPostLoadingScreen(
		'kcdfw_main_hook',
		function ()
			kcdfw.logInfo(kcdfw, "KCDFW loaded and available.");
		end
	);
end
