#!/bin/bash


MOD_SOURCE="${1}"; shift;
MOD_MANIFEST="${1}"; shift;


# Vars must not contain ~
MOD_NAME="${1}"; shift;
MOD_AUTHOR="${1}"; shift;
MOD_DESCRIPTION="${1}"; shift;
MOD_VERSION="$(git rev-parse HEAD)";
MOD_BUILD_DATE="$(date --utc +'%Y-%m-%d %H:%M:%S %Z')";




echo -n 'Generating manifest...';

cat <<EOF > "${MOD_MANIFEST}"
<?xml version="1.0" encoding="utf-8" ?>
<kcd_mod>
	<info>
		<name>${MOD_NAME}</name>
		<description>${MOD_DESCRIPTION}</description>
		<author>${MOD_AUTHOR}</author>
		<version>${MOD_VERSION}</version>
		<created_on>${MOD_BUILD_DATE}</created_on>
	</info>
</kcd_mod>
EOF

echo ' done.';




echo -n 'Updating metadata in scripts...';

PATTERN='';
for VAR in MOD_{NAME,DESCRIPTION,AUTHOR,VERSION,BUILD_DATE}; do
	PATTERN+="s~&{${VAR}}~${!VAR}~g;";
done;

find "${MOD_SOURCE}" -type f -name '*.lua' -print0 | xargs -0 sed -i "${PATTERN}";

echo ' done.';
