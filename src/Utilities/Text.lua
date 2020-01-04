kcdfw.getTextS = function (n)
	return ((n == 1) and "") or "s";
end


kcdfw.trimText = function (str)
	local n = str:find("%S");
	return (n and str:match(".*%S", n) or "");
end
