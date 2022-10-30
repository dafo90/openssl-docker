#!/bin/bash

readonly KEYSTORE_TYPE_LIST="NONE PKCS12 JKS"

readonly ALGORITHM="${ALGORITHM:-rsa:2048}"
readonly DAYS="${DAYS:-365}"
readonly SUBJ="${SUBJ:-/C=CH/ST=/L=/O=/OU=/CN=}"
readonly KEYOUT="${KEYOUT:-cakey.pem}"
readonly OUT="${OUT:-cacert.pem}"
readonly KEYSTORE_TYPE="${KEYSTORE_TYPE:-none}" # NONE | PKCS12 | JKS
readonly KEYSTORE="${KEYSTORE:-identity}"
readonly PRIVATE_KEY_NAME="${PRIVATE_KEY_NAME:-identity}"

function existsInList {
    LIST=$1
    DELIMITER=$2
    VALUE=$3
    LIST_WHITESPACES=`echo $LIST | tr "$DELIMITER" " "`
    for x in $LIST_WHITESPACES
    do
        if [ "$x" = "$VALUE" ]
        then
            return 0
        fi
    done
    return 1
}

if ! existsInList "$KEYSTORE_TYPE_LIST" " " "$KEYSTORE_TYPE"
then
    echo "Invalid KEYSTORE_TYPE, allowed values: NONE, PKCS12, JKS"
    exit 1
fi

if [ -z "${PASSWORD}" ] && [ "$KEYSTORE_TYPE" != "NONE" ]
then
    echo "In order to generate a KeyStore you need to provide a PASSWORD"
    exit 1
fi

if [ -z "${PASSWORD}" ]
then
    openssl req -newkey $ALGORITHM -x509 -keyout "/certs/${KEYOUT}" -out "/certs/${OUT}" -days $DAYS -subj "$SUBJ"
else
    openssl req -newkey $ALGORITHM -x509 -keyout "/certs/${KEYOUT}" -out "/certs/${OUT}" -days $DAYS -subj "$SUBJ" -passin $PASSWORD -passout $PASSWORD
    if [ "$KEYSTORE_TYPE" != "NONE" ]
    then
        openssl pkcs12 -export -in "/certs/${OUT}" -inkey "/certs/${KEYOUT}" -out "/certs/${KEYSTORE}.p12" -name $PRIVATE_KEY_NAME -passin $PASSWORD -passout $PASSWORD
        if [ "$KEYSTORE_TYPE" = "JKS" ]
        then
            keytool -importkeystore -destkeystore "/certs/${KEYSTORE}.jks" -deststorepass "${PASSWORD#*:}" -srckeystore "/certs/${KEYSTORE}.p12" -srcstoretype PKCS12 -srcstorepass "${PASSWORD#*:}"
        fi
    fi
fi
