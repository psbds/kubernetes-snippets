#/usr/bin/env bash
_foo()
{
    local cur L2 L3

    cur=${COMP_WORDS[COMP_CWORD]}
    L2=${COMP_WORDS[COMP_CWORD-1]}
    L3=${COMP_WORDS[COMP_CWORD-2]}

  # echo "CWORD=$COMP_CWORD      L1=($cur) L2=($L2) L3=($L3)"

    case ${COMP_CWORD} in
        1)
            COMPREPLY=($(compgen -W "cluster devops backup" -- ${cur}))
            ;;
        2)
            case ${L2} in
                cluster)
                    COMPREPLY=($(compgen -W "create create-aad-credentials " -- ${cur}))
                    ;;
                devops)
                    COMPREPLY=($(compgen -W "create-service-connection " -- ${cur}))
                    ;;
                backup)
                    COMPREPLY=($(compgen -W "create-velero-vault install-velero uninstall-velero " -- ${cur}))
                    ;;
            esac
            ;;
        3)
            case ${L2} in
                create-service-connection)
                    COMPREPLY=("-o <ORG> -p <PROJECT> -u <USER> -pat <PA TOKEN> ")
                    ;;
                devops)
                    COMPREPLY=($(compgen -W "xd" -- ${cur}))
                    ;;
            esac
        ;;
        *)
            COMPREPLY=()
            ;;
    esac
}

complete -F _foo akssnippets
