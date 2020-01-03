kcdfw.countTableEntries = function (table)
	local n = 0;

	for _ in pairs(table) do
		n = (n + 1);
	end

	return n;
end
