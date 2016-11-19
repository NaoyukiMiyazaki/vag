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
  local commands="up ssh suspend reload halt set unset list status -v|--version"
  local cur=${COMP_WORDS[COMP_CWORD]}
  local names=($(get_names))
  case "$COMP_CWORD" in
  1) COMPREPLY=( $(compgen -W "$commands" -- $cur) ) ;;
  2)
    case ${COMP_WORDS[1]} in
        init|status|set|unset|list|status) ;;
        *) COMPREPLY=( $(compgen -W "$names" -- $cur) ) ;;
    esac
  esac
}

complete -F _vag_comp vag