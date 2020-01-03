#!/bin/bash

DIR="$(realpath -m "${0}/..")";

. "${DIR}/../lib/common.sh";




declare P_ARCHIVE P_ROOT;

PARAMS+=(
	['o:']=P_ARCHIVE
	['r:']=P_ROOT
);

parse_params "${@}";




if [ -z "${P_ARCHIVE}" ]; then
	P_ARCHIVE="${P_INTERMEDIATE}/${BASENAME_FINAL_DATA}/data.pak";
fi

if [ -z "${P_ROOT}" ]; then
	P_ROOT="${P_INTERMEDIATE}/${BASENAME_PAK}";
fi


cp -a "${P_INTERMEDIATE}/${BASENAME_SAUCE}/"* "${P_INTERMEDIATE}/${BASENAME_PAK}/";


make_archive 'pak' "${P_ARCHIVE}" "${P_ROOT}";
