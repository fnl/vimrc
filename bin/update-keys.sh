#!/bin/bash

set -e
set -o pipefail

GNUPG="$(which gpg2 2>/dev/null || which gpg 2>/dev/null || which gpg1 2>/dev/null || true)"
DOWNLOAD_TOOL="$(which xwget 2>/dev/null || which curl 2>/dev/null || true)"
PUBLIC_KEY_RING_URL="SECRET"
KEY_MAINTAINER_FINGERPRINT="9BA6E862E4FF189A2466338233A712642EF78135"

log() {
    echo "$@"
}

error() {
    echo "Error:" "$@" >&2
    exit 1
}

check_programs() {
    if [ -x "$DOWNLOAD_TOOL" ]
    then
        log "Using '$DOWNLOAD_TOOL' to download URLs"
    else
        error "Could not find a suitable tool to download a web page. Please install wget or curl."
    fi
    if [ -x "$GNUPG" ]
    then
        log "Using '$GNUPG' to start GnuPG"
    else
        error "Could not find a suitable GnuPG installation. Please check the OpenPGP TWiki on how to set it up."
    fi
    log
}

run_gpg() {
    "$GNUPG" "$@"
}

import_keys() {
    local EXTRA_OPTIONS=()
    case "$(basename "$DOWNLOAD_TOOL" )" in
        "wget")
            EXTRA_OPTIONS+=("--quiet" "-O" "-")
            ;;
        "curl")
            EXTRA_OPTIONS+=("--silent" "--show-error")
            ;;
    esac
    "$DOWNLOAD_TOOL" "${EXTRA_OPTIONS[@]}" "$PUBLIC_KEY_RING_URL" | run_gpg --import
}

lsign_key() {
    local UNSIGNED_KEY_ID="$1"
    local CHATTER_FILE="$(mktemp -t init-gnupg.sh.XXXXXX)"

    local CURRENT_TS="$(date +%s)"
    local TIMEOUT_TS="$((CURRENT_TS+30))"

    local RESPONDED_keyedit_sign_all_okay=
    local RESPONDED_sign_uid_okay=

    while [ "$CURRENT_TS" -lt "$TIMEOUT_TS" \
        -a -z "$RESPONDED_sign_uid_okay" ]
    do
        local PROMPT=
        if [ -e "$CHATTER_FILE" ]
        then
            local TAIL="$(tail -n 1 "$CHATTER_FILE")"
            if [ "${TAIL:0:9}" = "[GNUPG:] " ]
            then
                PROMPT="${TAIL:9}"
            fi
        fi

        case "$PROMPT" in
            '' | 'NEED_PASSPHRASE'* )
                ;;
            'GET_BOOL keyedit.sign_all.okay' )
                if [ -z "$RESPONDED_keyedit_sign_all_okay" ]
                then
                    echo y
                    RESPONDED_keyedit_sign_all_okay=yes
                fi
                ;;
            'GET_BOOL sign_uid.okay' )
                if [ -z "$RESPONDED_sign_uid_okay" ]
                then
                    echo y
                    RESPONDED_sign_uid_okay=yes
                fi
                ;;
            * )
                error "Unknown prompt '$PROMPT'"
        esac
        CURRENT_TS="$(date +%s)"
    done | run_gpg --command-fd 0 --status-fd 1 --lsign-key "0x$UNSIGNED_KEY_ID" >"$CHATTER_FILE" || true
    rm -f "$CHATTER_FILE"
}

trust_key() {
    local UNTRUSTED_KEY_ID="$1"
    local CHATTER_FILE="$(mktemp -t update-keys.sh.XXXXXX)"

    local CURRENT_TS="$(date +%s)"
    local TIMEOUT_TS="$((CURRENT_TS+30))"

    local HAD_PROMPT=no

    local RESPONDED_keyedit_sign_all_okay=
    local RESPONDED_edit_ownertrust_value=

    while [ "$CURRENT_TS" -lt "$TIMEOUT_TS" \
        -a -z "$RESPONDED_edit_ownertrust_value" ]
    do
        local PROMPT=
        if [ -e "$CHATTER_FILE" ]
        then
            local TAIL="$(tail -n 1 "$CHATTER_FILE")"
            if [ "${TAIL:0:9}" = "[GNUPG:] " ]
            then
                PROMPT="${TAIL:9}"
            fi
        fi

        case "$PROMPT" in
            '' | 'NEED_PASSPHRASE'* )
                ;;
            'GET_LINE keyedit.prompt' )
                if [ -z "$RESPONDED_keyedit_prompt" ]
                then
                    echo trust
                    RESPONDED_keyedit_prompt=once
                fi
                ;;
            'GET_LINE edit_ownertrust.value' )
                if [ -z "$RESPONDED_edit_ownertrust_value" ]
                then
                    echo 4
                    RESPONDED_edit_ownertrust_value=yes
                fi
                ;;
            * )
                error "Unknown prompt '$PROMPT'"
        esac
        CURRENT_TS="$(date +%s)"
    done | run_gpg --command-fd 0 --status-fd 1 --edit-key "0x$UNTRUSTED_KEY_ID" >"$CHATTER_FILE" || true
    rm -f "$CHATTER_FILE"
}

dump_unsigned_signworthy_key_ids() {
    gpg --list-keys --with-colons "$KEY_MAINTAINER_FINGERPRINT" \
        | grep ^pub:-: \
        | cut -f 5 -d :
}

lsign_keys() {
    dump_unsigned_signworthy_key_ids | while read UNSIGNED_KEY_ID
    do
        lsign_key "$UNSIGNED_KEY_ID"
    done
    if [ -n "$(dump_unsigned_signworthy_key_ids)" ]
    then
        error "Unsigned keys still exist"
    fi
}

dump_untrusted_trustworthy_key_ids() {
    if [ -n "$(gpg --list-keys --with-colons "$KEY_MAINTAINER_FINGERPRINT" \
        | grep ^pub: \
        | cut -f 9 -d : \
        | (grep -v '^f$' || true))" ]
    then
        echo "$KEY_MAINTAINER_FINGERPRINT"
    fi
}

trust_keys() {
    dump_untrusted_trustworthy_key_ids | while read UNTRUSTED_KEY_ID
    do
        trust_key "$UNTRUSTED_KEY_ID"
    done
    if [ -n "$(dump_untrusted_trustworthy_key_ids)" ]
    then
        error "Untrusted trustworthy_key_ids still exist"
    fi
}

check_programs
import_keys
lsign_keys
trust_keys

cat <<EOF


----------------------------------------

GnuPG key update done.

Enjoy the fresh keys!
EOF
