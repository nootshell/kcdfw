kcdfw.countTableEntries = function (table)
	local n = 0;

	for _ in pairs(table) do
		n = (n + 1);
	end

	return n;
end


kcdfw.getTableKeys = function(t)
	local res = { };

	for key, v in pairs(t) do
		table.insert(res, key);
	end

	return res;
end
