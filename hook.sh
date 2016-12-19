#!/bin/sh
. $CONFIG

deploy_challenge() {
	local DOMAIN="${1}" TOKEN="${3}"
	${HOST_RB} ${DOMAIN} ${TOKEN}
}

clean_challenge() {
	local DOMAIN="${1}" TOKEN="${3}"
	${HOST_RB} ${DOMAIN} ${TOKEN} cleanup
}

unchanged_cert() {
	local DOMAIN="${1}"
	# nowt
}

deploy_cert() {
	local DOMAIN="${1}"
	# nowt
}

invalid_challenge() {
	local DOMAIN="${1}" RESULT="${2}"
	echo " - ${DOMAIN} failed with ${RESULT}"
}

HANDLER=$1; shift; $HANDLER $@
