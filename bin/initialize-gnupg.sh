#!/bin/bash

set -e
set -o pipefail

GNUPG_HOME_DIR_ABS="$HOME/.gnupg"
GNUPG_CONFIG_FILE_ABS="$GNUPG_HOME_DIR_ABS/gpg.conf"
GNUPG="$(which gpg2 2>/dev/null || which gpg 2>/dev/null || which gpg1 2>/dev/null || true)"
PREFERENCES="SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed"
KEY_MAINTAINER_NAME="Florian"
KEY_MAINTAINER="Florian Leitner <me@fnl.es>"
KEY_MAINTAINER_FINGERPRINT="9BA6E862E4FF189A2466338233A712642EF78135"

log() {
    echo "$@"
}

error() {
    echo "Error:" "$@" >&2
    exit 1
}

log_section() {
    log "***" "$@" "..."
}

check_programs() {
    log_section "Checking if required programs exist"

    if [ -x "$GNUPG" ]
    then
        log "Using '$GNUPG' to start GnuPG"
    else
        error "Could not find a suitable GnuPG installation. Please check the OpenPGP TWiki on how to set it up."
    fi
    log
}

ask() {
    local QUESTION="$1"
    read -r -p "$QUESTION " ANSWER
}

ask_non_empty() {
    local QUESTION="$1"
    ask "$QUESTION"
    if [ -z "$ANSWER" ]
    then
        error "No answer given"
    fi
}

ask_yes_no() {
    local QUESTION="$1"
    ask "$QUESTION (y/n)"
    ANSWER="$(echo "${ANSWER}" | tr '[:upper:]' '[:lower:]')"
    if [ "$ANSWER" != "y" -a "$ANSWER" != "n" ]
    then
        error "Neither 'y' nor 'n' answered"
    fi
}

ask_name() {
    log_section "Getting basic settings"

    ask_non_empty "What's your first name?"
    FIRST_NAME="$ANSWER"

    ask_non_empty "What's your last name?"
    LAST_NAME="$ANSWER"
}

setup_variables() {
    log_section "Computing derived settings"

    local FIRST_NAME_LC="$(echo "$FIRST_NAME" | tr '[:upper:]' '[:lower:]')"
    local LAST_NAME_LC="$(echo "$LAST_NAME" | tr '[:upper:]' '[:lower:]')"
    EMAIL_ADDRESS="${FIRST_NAME_LC}.${LAST_NAME_LC}@selerityinc.com"
    EXPORTED_PUBLIC_KEY_FILE_RELC="${FIRST_NAME_LC}.${LAST_NAME_LC}.public-key.asc"
    EXPORTED_REVOCATION_CERTIFICATE_FILE_RELC="${FIRST_NAME_LC}.${LAST_NAME_LC}.revocation-certificate.asc"
}

confirm_email_address() {
    log_section "Confirming email address"

    ask_yes_no "So your email address is '$EMAIL_ADDRESS' ?"
    if [ "$ANSWER" != "y" ]
    then
        error "Aborting, due to email address mismatch"
    fi
}

add_gnupg_config() {
    local SETTING="$1"
    local VALUE="$2"
    if ! grep --quiet "^$SETTING" "$GNUPG_CONFIG_FILE_ABS" 2>/dev/null
    then
        echo "$SETTING $VALUE" >>"$GNUPG_CONFIG_FILE_ABS"
    fi
}

prepare_gnupg_home_dir() {
    log_section "Preparing GnuPG config directory"

    mkdir -p "$GNUPG_HOME_DIR_ABS"
    chmod 700 "$GNUPG_HOME_DIR_ABS"

    add_gnupg_config "default-preference-list" "$PREFERENCES"
    chmod 600 "$GNUPG_CONFIG_FILE_ABS"
}

run_gpg() {
    "$GNUPG" "$@"
}

create_key() {
    log_section "Creating key"

    if run_gpg --list-keys "$EMAIL_ADDRESS"&>/dev/null
    then
        error "A GnuPG key for $EMAIL_ADDRESS already exists"
    fi

    ask_yes_no "We're about to start key creation. You'll need a passphrase for that. Be sure to have one. Shall we start?"
    if [ "$ANSWER" != "y" ]
    then
        error "Aborting, due to not answering 'y'"
    fi

    run_gpg --batch --gen-key <<EOF
%ask-passphrase
Key-Type: RSA
Key-Length: 4096
# As GnuPG 2.1 currently can only handle a single subkey, we cannot
# decouple cert and sign keys. But it's the default to bundle them
# anyways, so it's not too bad.
Key-Usage: sign
Subkey-Type: RSA
Subkey-Length: 4096
Subkey-Usage: encrypt
Expire-Date: 3y
Name-Real: $FIRST_NAME $LAST_NAME
Name-Email: $EMAIL_ADDRESS
Preferences: $PREFERENCES
Revoker: 1:$KEY_MAINTAINER_FINGERPRINT
%echo Computing the new key may take some time.
%echo If it's not done after 5 minutes, abort and reach
%echo out to $KEY_MAINTAINER
%commit
%echo done
EOF
}

check_exported_public_key_does_not_exist() {
    log_section "Making sure exported public key does not yet exist"
    if [ -e "$EXPORTED_PUBLIC_KEY_FILE_RELC" ]
    then
        error "The file '$EXPORTED_PUBLIC_KEY_FILE_RELC' already exists."
    fi
}

export_public_key() {
    log_section "Exporting public key"

    check_exported_public_key_does_not_exist
    run_gpg --armor --export "$EMAIL_ADDRESS" >"$EXPORTED_PUBLIC_KEY_FILE_RELC"

    if [ ! -e "$EXPORTED_PUBLIC_KEY_FILE_RELC" ]
    then
        error "Failed to export public key."
    fi
}

check_revocation_certificate_does_not_exist() {
    log_section "Making sure revocation certificate does not yet exist"

    if [ -e "$EXPORTED_REVOCATION_CERTIFICATE_FILE_RELC" ]
    then
        error "The file '$EXPORTED_REVOCATION_CERTIFICATE_FILE_RELC' already exists."
    fi
}

export_revocation_certificate() {
    log_section "Exporting revocation certificate"

    check_revocation_certificate_does_not_exist
    local CHATTER_FILE="$(mktemp -t init-gnupg.sh.XXXXXX)"

    local CURRENT_TS="$(date +%s)"
    local TIMEOUT_TS="$((CURRENT_TS+30))"

    local RESPONDED_okay=
    local RESPONDED_ask_revocation_reason_code=
    local RESPONDED_ask_revocation_reason_text=
    local RESPONDED_ask_revocation_reason_okay=

    while [ "$CURRENT_TS" -lt "$TIMEOUT_TS" \
        -a -z "$RESPONDED_ask_revocation_reason_okay" ]
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
            'GET_BOOL gen_revoke.okay' )
                if [ -z "$RESPONDED_okay" ]
                then
                    echo y
                    RESPONDED_okay=yes
                fi
                ;;
            'GET_LINE ask_revocation_reason.code' )
                if [ -z "$RESPONDED_ask_revocation_reason_code" ]
                then
                    echo 0
                    RESPONDED_ask_revocation_reason_code=yes
                fi
                ;;
            'GET_LINE ask_revocation_reason.text' )
                if [ -z "$RESPONDED_ask_revocation_reason_text" ]
                then
                    echo ""
                    RESPONDED_ask_revocation_reason_text=yes
                fi
                ;;
            'GET_BOOL ask_revocation_reason.okay' )
                if [ -z "$RESPONDED_ask_revocation_reason_okay" ]
                then
                    echo "y"
                    RESPONDED_ask_revocation_reason_okay=yes
                fi
                ;;
            * )
                error "Unknown prompt '$PROMPT'"
        esac
        CURRENT_TS="$(date +%s)"
    done | run_gpg --command-fd 0 --status-fd 1 --output "$EXPORTED_REVOCATION_CERTIFICATE_FILE_RELC" --gen-revoke "$EMAIL_ADDRESS" >"$CHATTER_FILE" || true
    rm -f "$CHATTER_FILE"

    if [ ! -e "$EXPORTED_REVOCATION_CERTIFICATE_FILE_RELC" ]
    then
        error "Failed to generate revocation certificate."
    fi
}

check_programs
ask_name
setup_variables
check_exported_public_key_does_not_exist
check_revocation_certificate_does_not_exist
confirm_email_address
prepare_gnupg_home_dir
create_key

export_public_key
export_revocation_certificate


log_section "Getting new fingerprint"
OUR_FPR=$(run_gpg --with-colons --fingerprint --list-keys "$EMAIL_ADDRESS" | grep fpr | cut -f 10 -d : | head -n 1)

log_section "Printing summary and next steps"
cat <<EOF


----------------------------------------

GnuPG key generation done.

Please send the public key file

  $EXPORTED_PUBLIC_KEY_FILE_RELC

to $KEY_MAINTAINER.
(Afterwards you no longer need that file.)

Then please add your key fingerprint

  $OUR_FPR

to the table on the TWiki page at

  http://twiki.seleritycorp.com/cgi-bin/twiki/view/Main/OpenPGP#Known_keys

(Adding your key fingerprint is good enough. $KEY_MAINTAINER_NAME can fill in the rest)

Then, copy the revocation certificate file

  $EXPORTED_REVOCATION_CERTIFICATE_FILE_RELC

to a medium which you can hide away (the file allows to revoke your
key, if you loose access to this GnuPG setup (e.g.: theft, hard disk
crash, ...)). Also please print a copy of that file and store it away.
(You do not have to keep the file around on this host, but keep the
offline and the printed copy.)

Have fun with your GnuPG setup! \o/

The OpenPGP TWiki page has details on how to encrypt/decrypt files.
And it also has an update-keys.sh script that allows to update and
import keys from your colleagues.
EOF
