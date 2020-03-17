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