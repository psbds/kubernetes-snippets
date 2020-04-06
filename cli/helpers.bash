#/bin/bash

printDanger(){
    if [ -z "$2" ] || [ $2 != 0 ]
    then
        echo -ne "\e[1;31m$1\e[0m"
    fi
}

printWarning(){
    if [ -z "$2" ] || [ $2 != 0 ]
    then
        echo -ne "\e[1;33m$1\e[0m"
    fi
}

printInfo(){
    if [ -z "$2" ] || [ $2 != 0 ]
    then 
         echo -ne "\e[1;36m$1\e[0m"   
    fi
}


validate_empty(){
    # $1 = Condition
    # $2 = Message
    if [ -z $1 ]
    then
        printDanger "$2"
        VALID=0
    fi
}

validate_options(){
    VALID=0
    MESSAGE=$1
    SELECTED=$2
    shift && shift
    # $1 = Message
    # $2 = Selected
    # $@ = Options
    for OPTION in "$@"
    do
        if [ $SELECTED == $OPTION ]
        then
            VALID=1
            return
        fi
    done

    if [ VALID=0 ]
    then
        printDanger "$MESSAGE"
        VALID=0
    fi
}

read_args(){
    local -n args=$1
    shift

    cmd='case $1 in '
    for parameter in "${args[@]}" ; do
        KEYS="${parameter%%:*}"
        KEY="${KEYS%%|*}"
        KEY2="${KEYS##*|}"

        VALUE="${parameter##*:}"
        if [ $KEY == "-h" -o $KEY2 == "--help" ]; then
            cmd="$cmd -h | --help ) usage \"$VALUE\" && exit ;;"
        elif [ $KEY == "-v" -o $KEY == "--verbose" ]; then
            cmd="$cmd -v | --verbose ) VERBOSE=1 ;;"
        else
            cmd="$cmd  $(echo "$KEY | $KEY2 ) shift && $VALUE=\$1 ;;")"
        fi
    done
    cmd="$cmd esac ; shift"
    
    while [ "$1" != "" ]; do
        eval "$cmd"
    done
}