if not kcdfw.runLocal then
	function print(...)
		System.LogAlways(
			table.concat(
				{...},
				"\t"
			)
		);
	end
end
