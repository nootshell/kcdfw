#!/bin/bash

DIR="$(realpath -m "${0}/..")";

. "${DIR}/../lib/common.sh";




declare P_PATH_DOCS P_PATH_SCRIPTS;

PARAMS+=(
	['d:']=P_PATH_DOCS
	['s:']=P_PATH_SCRIPTS
);

parse_params "${@}";




if [ -z "${P_INTERMEDIATE}" ]; then
	log_error 'Intermediate directory not given.';
	exit 1;
fi

rm -rf "${P_INTERMEDIATE}";
mkdir -p \
	"${P_INTERMEDIATE}" \
	"${P_INTERMEDIATE}/${BASENAME_SAUCE}" \
	"${P_INTERMEDIATE}/${BASENAME_PAK}" \
	"${P_INTERMEDIATE}/${BASENAME_FINAL}" \
	"${P_INTERMEDIATE}/${BASENAME_FINAL_DATA}";




declare -A MAPPING=(
	['Docs']="${P_PATH_DOCS}"
	['Scripts']="${P_PATH_SCRIPTS}"
);

for TARGET in "${!MAPPING[@]}"; do
	SOURCE="${MAPPING[${TARGET}]}";

	if [ -z "${SOURCE}" ]; then
		continue;
	fi

	if [ ! -d "${SOURCE}" ]; then
		log_error "${TARGET}" 'directory not found:' "${SOURCE}";
		continue;
	fi

	cp -a "${SOURCE}" "${P_INTERMEDIATE}/${BASENAME_SAUCE}/${TARGET}";
done
