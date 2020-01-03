declare -i P_VERBOSE=0 P_QUIET=0;

log() {
	echo "${@}";
}

log_error() {
	log "${@}" >&2;
}

log_info() {
	log "${@}";
}

declare -ri FD_QUIET=3 FD_VERBOSE=4;
eval "exec $((FD_QUIET))>&1 $((FD_VERBOSE))>&1";




declare -r \
	BASENAME_SAUCE='sauce' \
	BASENAME_PAK='pak' \
	BASENAME_FINAL='final';

declare -r \
	BASENAME_FINAL_DATA="${BASENAME_FINAL}/Data";




declare P_INTERMEDIATE;

declare -A PARAMS=(
	['v']=P_VERBOSE
	['q']=P_QUIET
	['i:']=P_INTERMEDIATE
);

parse_params() {
	local K;

	local OPTSTR='';
	for K in "${!PARAMS[@]}"; do
		OPTSTR="${OPTSTR}${K}";
	done

	local KEY;
	while getopts ":${OPTSTR}" OPT; do
		KEY=;
		for K in "${!PARAMS[@]}"; do
			if [ "${K:0:1}" = "${OPT}" ]; then
				KEY="${K}";
				break;
			fi;
		done

		if [ -z "${KEY}" ]; then
			if [ "${OPT}" != '?' ]; then
				log_error 'Failed to resolve key for param:' "${OPT}";
			fi
			continue;
		fi

		if [ -z "${OPTARG}" ]; then
			if [ "${KEY:1:1}" != ':' ]; then
				OPTARG=1;
			fi
		fi

		export -n "${PARAMS[${KEY}]}"="${OPTARG}";
	done
}




sed_escape() {
	local CHAR="${1}"; shift;

	for VAR in "${@}"; do
		export -n "${VAR}"="${!VAR/\~/}";
	done
}


make_archive() {
	local TYPE="${1}"; shift;
	local ARCHIVE="${1}"; shift;
	local ROOT="${1}"; shift;
	local ROOT_NAME="${1}"; shift;

	if [ -z "${ARCHIVE}" ]; then
		log_error 'Archive output path not specified.';
		return 1;
	fi

	if [ -z "${ROOT}" ]; then
		log_error 'Archive root path not specified.';
		return 1;
	fi

	ARCHIVE="$(realpath -m "${ARCHIVE}")";
	rm -f "${ARCHIVE}";

	if [ -n "${ROOT_NAME}" ]; then
		local NEW_ROOT="${ROOT}/${ROOT_NAME}";
		mkdir -p "${NEW_ROOT}";
		mv "${ROOT}"/* "${NEW_ROOT}" >/dev/null 2>&1; # Would use -u, but -u lies and actually matches against equally old files as well (> != >=, GNU). Bummer.
		ROOT="${NEW_ROOT}";
	fi

	case "${TYPE}" in
		pak)
			(
				cd "${ROOT}";
				find -type f > /tmp/pak.list;
				7za a -r -mx=0 -tzip "${ARCHIVE}" * >/dev/null;
			);
			;;
		final)
			(
				cd "${ROOT}";
				find -type f > /tmp/final.list;
				7za a -tzip "${ARCHIVE}" * >/dev/null;
			);
			;;
		*)
			log_error 'Invalid archive type specified:' "${TYPE}";
			return 1;
			;;
	esac
}
