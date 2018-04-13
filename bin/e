#!/bin/bash

if [ "$1" == "clean" ]; then
    echo "" > /home/changmin/.emacs.bakcup/last_em.txt
    exit
elif [ "$1" == "list" ]; then
    cat /home/changmin/.emacs.backup/last_em.txt
    exit
elif [ "$1" == "edit" ]; then
    XMODIFIERS= emacs /home/changmin/.emacs.backup/last_em.txt &
    exit
elif [ "$#" -ge "1" ]; then
    EM_ARGS=${*%%:*}
    echo $EM_ARGS >> /home/changmin/.emacs.backup/last_em.txt
else
    EM_ARGS=$(tail -n1 /home/changmin/.emacs.backup/last_em.txt 2> /dev/null)
    [ "$EM_ARGS" ] && echo em $EM_ARGS
fi

which_args() {
    local WHICH_ARGS=""
    for FILE in $*; do
	WHICH_FILE=$(which $FILE)
	if [ -f "$WHICH_FILE" ]; then
	    echo em $WHICH_FILE
	    WHICH_ARGS=$WHICH_ARGS" "$WHICH_FILE
	else
	    echo em $FILE
	    WHICH_ARGS=$WHICH_ARGS" "$FILE
	fi
    done
    EM_ARGS=$WHICH_ARGS
}

[ -f ${EM_ARGS} ] || which_args $EM_ARGS

if [ $0 == "${0%%e}e" ] || [ $0 == "${0%%ec}ec" ] || [ $0 == "${0%es}es" ]; then
    XMODIFIERS= emacsclient -n $EM_ARGS 2> /dev/null || XMODIFIERS= emacsserver $EM_ARGS &
fi

if [ $0 == "${0%em}em" ]; then
    EMACSPID=$(pidof emacs)
    if [ "a$EMACSPID" == "a" ]; then
	XMODIFIERS= emacsserver $EM_ARGS 2> /dev/null &
    else
	XMODIFIERS= emacs $EM_ARGS 2> /dev/null &
    fi
fi
