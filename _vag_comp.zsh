function get_names() {
  local -a names
  while read line
  do
    if [ ${#line} -eq 0 ]; then
      :
    else
      local name=`echo $line | cut -d "=" -f1`
      names=($names $name)
    fi
  done <$CONFIG_PATH

  echo ${names[@]}
}

function _vag_comp() {
  local state
  local -a cmds=('up' 'ssh' 'suspend' 'reload' 'halt' 'set' 'unset' 'list' 'status' '-v|--version')
  local -a names=($(get_names))

  _arguments '1: :->commands' '2: :->modes'

  case $state in
    commands)  _describe -t commands "subcommand" cmds ;;
    modes)
      case $words[2] in
        init|status|set|unset|list|status) ;;
        *)
          case $names in
            "") ;;
            *) _values 'names' $names ;;
          esac
      esac
  esac

  return 1
}

autoload -U compinit
compdef _vag_comp vag
