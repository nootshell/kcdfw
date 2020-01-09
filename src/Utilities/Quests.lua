if kcdfw.runLocal then
	script = (script or { });
	script.cutscenes = (script.cutscenes or {
		q_waldensians = "rip"
	});
end

kcdfw.findQuest = function(pattern)
	local res = { };

	local p;
	if pattern ~= nil then
		p = pattern:lower();
	end

	for quest, _ in pairs(script.cutscenes) do
		if pattern == nil or quest:find(p, 0, true) ~= nil then
			table.insert(res, quest);
		end
	end

	return res;
end
