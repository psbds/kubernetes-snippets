#/bin/bash
load(){
    ARG=$1
    shift
    DIR="${BASH_SOURCE%/*}" && if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi && source "$DIR/$ARG" $@
}

load 'helpers.bash'  
load '_help.bash'

case $1 in
        devops) shift && load "devops/index.bash" $@ ;;
        cluster) shift && load "cluster/index.bash" $@ ;;
        backup) shift && load "backup/index.bash" $@ ;;
        -h | --help ) usage && exit ;;
        *) usage && exit
esac