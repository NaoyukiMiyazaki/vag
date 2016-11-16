typeset -A vagrant_name
vagrant_name=( \
  hoge 44bf64d \
  foo d4ecd46 \
  bar 69a5989
)

function error_command() {
  echo "command not found"
  echo --command list--
  for key in ${(k)vagrant_name}; do
    echo "$1 $key"
  done
}

function vup() {
  if (( $+vagrant_name[$1] )); then
    vagrant up ${vagrant_name[$1]}
  else
    error_command $0
  fi
}

function vh() {
  if (( $+vagrant_name[$1] )); then
    vagrant halt ${vagrant_name[$1]}
  else
    error_command $0
  fi
}

function vsu() {
  if (( $+vagrant_name[$1] )); then
    vagrant suspend ${vagrant_name[$1]}
  else
    error_command $0
  fi
}

function vssh() {
  if (( $+vagrant_name[$1] )); then
    vagrant ssh ${vagrant_name[$1]} 2>/dev/null
    if [ $? -ne 0 ]; then
      vagrant up ${vagrant_name[$1]}
      vagrant ssh ${vagrant_name[$1]}
    fi
  else
    error_command $0
  fi
}

function _compnames() {
  local -a names
  names=()
  for key in ${(k)vagrant_name}; do
    names=($names $key)
  done

  _values \
    'names' \
    $names

  return 1
}

compdef _compnames vup
compdef _compnames vh
compdef _compnames vsu
compdef _compnames vssh