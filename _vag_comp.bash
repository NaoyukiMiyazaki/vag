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
  done <$HOME/.vag/vag_config

  echo ${names[@]}
}

function _vag_comp() {
  local commands="init up ssh suspend reload halt set unset list status"
  local cur=${COMP_WORDS[COMP_CWORD]}
  case "$COMP_CWORD" in
  1) COMPREPLY=( $(compgen -W "$commands" -- $cur) ) ;;
  2)
    case ${COMP_WORDS[1]} in
        init|status|set|unset|list|status) ;;
        *) COMPREPLY=( $(compgen -W "$(get_names)" -- $cur) ) ;;
    esac
  esac
}

complete -F _vag_comp vag