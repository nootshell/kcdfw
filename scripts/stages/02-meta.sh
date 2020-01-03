#!/bin/bash

DIR="$(realpath -m "${0}/..")";

. "${DIR}/../lib/common.sh";




declare P_AUTHOR P_NAME P_DESCRIPTION P_VERSION

declare -a P_REQUIRES=();
p_requires_append() {
	P_REQUIRES+=("${@}");
}

PARAMS+=(
	['a:']=P_AUTHOR
	['n:']=P_NAME
	['D:']=P_DESCRIPTION
	['V:']=P_VERSION
	['R:']=p_requires_append
);

parse_params "${@}";




if [ -z "${P_VERSION}" ]; then
	P_VERSION="$(git rev-parse HEAD)";
fi




BUILD_DATE="$(date --utc +'%Y-%m-%d %H:%M:%S %Z')";




DEPENDENCIES='';
if [ ${#P_REQUIRES[@]} -gt 0 ]; then
	DEPENDENCIES="
		<dependencies>";

	for DEP in "${P_REQUIRES[@]}"; do
		DEPENDENCIES+="
			<req_mod>${DEP}</req_mod>";
	done

	DEPENDENCIES+="
		</dependencies>";
fi

cat <<EOF > "${P_INTERMEDIATE}/${BASENAME_FINAL}/mod.manifest"
<?xml version="1.0" encoding="utf-8" ?>
<kcd_mod>
	<info>
		<author>${P_AUTHOR}</author>
		<name>${P_NAME}</name>
		<description>${P_DESCRIPTION}</description>
		<version>${P_VERSION}</version>
		<created_on>${BUILD_DATE}</created_on>${DEPENDENCIES}
	</info>
</kcd_mod>
EOF




sed_escape ~ P_AUTHOR P_NAME P_DESCRIPTION P_VERSION;

PATTERN='s~^\(.*[[:space:]]*=[[:space:]]*\)\([^,]*\)\([,]\?[[:space:]]*--[[:space:]]*\[intermeta:\(.*\)\]\)$~\1\4\3~g;';
for VAR in {NAME,DESCRIPTION,AUTHOR,VERSION,BUILD_DATE}; do
	case "${VAR}" in
		BUILD_DATE)
			VAR_INT="${VAR}";
			;;
		*)
			VAR_INT="P_${VAR}";
			;;
	esac

	VAR_EXT="META_${VAR}";

	PATTERN+="s~&{${VAR_EXT}}~${!VAR_INT}~g;";
done;

find "${P_INTERMEDIATE}/${BASENAME_SAUCE}/Scripts" -type f -name '*.lua' -print0 | xargs -0 sed -i "${PATTERN}";
