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
	log_error 'Archive output path not specified.';
	exit 1;
fi




if [ -z "${P_ROOT}" ]; then
	P_ROOT="${P_INTERMEDIATE}/${BASENAME_FINAL}";
fi


make_archive 'final' "${P_ARCHIVE}" "${P_ROOT}";
