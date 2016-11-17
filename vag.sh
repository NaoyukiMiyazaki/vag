#!/bin/sh

. ./.vag_config

function _up() {
  eval ID=\"\$$1\"
  if [ "$ID" = "" ]; then
    name_error $1
  fi
  return
  echo "start vag ${FUNCNAME[0]} $1 (ID: $ID)"
  vagrant up $ID
  echo "finish vag ${FUNCNAME[0]} $1"
}

function _ssh() {
  eval ID=\"\$$1\"
  echo "start vag ${FUNCNAME[0]} $1 (ID: $ID)"
  vagrant ssh $ID
  echo "finish vag ${FUNCNAME[0]} $1"
}

function _suspend() {
  eval ID=\"\$$1\"
  echo "start vag ${FUNCNAME[0]} $1 (ID: $ID)"
  vagrant suspend $ID
  echo "finish vag ${FUNCNAME[0]} $1"
}

function _reload() {
  eval ID=\"\$$1\"
  echo "start vag ${FUNCNAME[0]} $1 (ID: $ID)"
  vagrant reload $ID
  echo "finish vag ${FUNCNAME[0]} $1"
}

function _halt() {
  eval ID=\"\$$1\"
  echo "start vag ${FUNCNAME[0]} $1 (ID: $ID)"
  vagrant halt $ID
  echo "finish vag ${FUNCNAME[0]} $1"
}

function _set() {
  echo "start vag ${FUNCNAME[0]} $1 $2"
  echo "${1}=${2};" >>./.vag_config
  echo "finish vag ${FUNCNAME[0]} $1 $2"
}

function _unset() {
  echo "start vag ${FUNCNAME[0]} $1"
  echo "finish vag ${FUNCNAME[0]} $1"
}

function display_name_list() {
  echo "displaylist"
}

function command_error() {
cat <<_EOS_
commad not fount
--command list--
$0 up [name]
$0 ssh [name]
$0 suspend [name]
$0 reload [name]
$0 halt [name]
$0 set [name] [id]
$0 unset [name]
$0 list
_EOS_
return 1
}

function name_error() {
  echo "$1 name does not exist"
  echo ------name list-------
  local config_array=$(read_config)
  for config in ${config_array[@]}; do
    local name=`echo $config | cut -d "=" -f1`
    local id_semi=`echo $config | cut -d "=" -f2`
    local id=`echo $id_semi | cut -d ";" -f1`
    echo "$name (id:$id)"
  done
  return 1
}

function read_config() {
  local name=""
  local line=""
  local name_array=()

  if [ ! -r ./.vag_config ]; then
    echo '.vag_configが見つからないか、または読み込み権限がありませんでした。処理を中断します。'
    exit 101
  fi

  while read line
  do
    if [ ${#line} -eq 0 ]; then
      :
    else
      name="${name} $line"
    fi
  done <./.vag_config
  local name_array=($name)
  echo ${name_array[@]}
  return 0
}

case $1 in
  up ) _up $2 ;;
  ssh ) _ssh $2 ;;
  suspend ) _suspend $2 ;;
  reload ) _reload $2 ;;
  halt ) _halt $2 ;;
  set ) _set $2 $3 ;;
  unset ) _unset $2 ;;
  list ) displaylist ;;
  test ) name_error ;;
  * ) command_error ;;
esac