#!/bin/bash

DIR="$(realpath -m "${0}/..")";

. "${DIR}/lib/common.sh";




declare \
	P_PATH_DOCS P_PATH_SCRIPTS \
	P_AUTHOR P_NAME P_DESCRIPTION P_VERSION \
	P_ARCHIVE;

PARAMS+=(
	['d:']=P_PATH_DOCS
	['s:']=P_PATH_SCRIPTS

	['a:']=P_AUTHOR
	['n:']=P_NAME
	['D:']=P_DESCRIPTION
	['V:']=P_VERSION

	['o:']=P_ARCHIVE
);

parse_params "${@}";




STAGES="${DIR}/stages";

env -i "${STAGES}"/01-prepare.sh \
	-i "${P_INTERMEDIATE}" \
	-d "${P_PATH_DOCS}" \
	-s "${P_PATH_SCRIPTS}";

env -i "${STAGES}"/02-meta.sh \
	-i "${P_INTERMEDIATE}" \
	-a "${P_AUTHOR}" \
	-n "${P_NAME}" \
	-D "${P_DESCRIPTION}" \
	-V "${P_VERSION}";

env -i "${STAGES}"/03-pak.sh \
	-i "${P_INTERMEDIATE}";

env -i "${STAGES}"/04-release.sh \
	-i "${P_INTERMEDIATE}" \
	-o "${P_ARCHIVE}";
