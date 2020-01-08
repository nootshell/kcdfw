kcdfw.isInt = function(n)
	local _n = tonumber(n);
	if not _n then
		return false;
	end

	return (math.floor(_n) == n);
end
