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