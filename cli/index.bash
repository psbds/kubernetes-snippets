#/bin/bash

load(){
    ARG=$1
    shift
    DIR="${BASH_SOURCE%/*}" && if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi && source "$DIR/$ARG" $@
}

load 'helpers.bash'  

case $1 in
devops) shift && load "devops/index.bash" $@ ;;
#"-h") echo "dois" ;;
#*) echo "Wrong Args" ;;
esac


