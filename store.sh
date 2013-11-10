#!/bin/bash
#
# A very simple password store using gnupg
#

usage() {
    cat <<_
Usage: store.sh -f filename -i <gpg userid> <Parameters>
    where <Parameters> can be any of
    -n        Generate a new password store file
    -s <user>   Store a password for <user> (overwrites an existing password)
    -r <user>   Retrieve the password for <user>
_
}


if [ $# -eq 0 ]
then
    usage
    exit 0
fi

ACTIONS=0

while getopts i:f:ns:r: opt; do
    case $opt in
        f) PWFILE=$OPTARG;;
        i) ID=$OPTARG;;
        n) NEW=1; ACTIONS=$(expr $ACTIONS + 1);;
        r) RETRIEVE=$OPTARG; ACTIONS=$(expr $ACTIONS + 1);;
        s) STORE=$OPTARG; ACTIONS=$(expr $ACTIONS + 1);;
        h) usage; exit 0;;
        ?) usage; exit -1;;
    esac
done

if [ x$ID == x ] || [ x$PWFILE == x ] || [ $ACTIONS -lt 1 ]; then
    echo "Missing parameter (-i,-f and one of the other ones)"
    usage
    exit -2
fi

if [ $ACTIONS -gt 1 ]; then
    echo "Only one of -n, -s or -r allowed."
    usage
    exit -3
fi

PREAMBLE="#PASSWORDFILE" 
SEP=":::::"

#
# Create a new password file
#
if [ x$NEW == x1 ]; then
    # GPG will ask if we want to overwrite an existing file. This would also allow
    # the user to change the filename.
    $(
        echo $PREAMBLE| gpg --recipient $ID -se --output $PWFILE
    )
fi

#
# Store a password
#
if [ x$STORE != x ]; then
    echo "enter the password"
    read -s -r password
    entry="${STORE}${SEP}$password"
    # sed: delete previous user entries (if any), add new entry
    RESULT=$(gpg -d $PWFILE 2>/dev/null |\
                sed "/^${STORE}${SEP}.*$/d;1a $entry")
    # GPG fucks up my shell; run the command in a subshell
    $(gpg -o $PWFILE --recipient $ID -se <<_
$RESULT
_
    )
    echo done
fi

#
# Retrieve a password
#
if [ x$RETRIEVE != x ]; then
    gpg -d $PWFILE 2>/dev/null |\
        grep $RETRIEVE |\
        awk -F"$SEP" '{print $2;}'
fi
