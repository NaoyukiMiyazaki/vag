#!/bin/sh

VAG_DIR_PATH=$HOME/.vag
VAG_CONFIG_PATH=$VAG_DIR_PATH/vag_config

function _init() {
  if [ -e $VAG_CONFIG_PATH ]; then
    echo "すでにvag_configが存在します"
    return 1
  fi

  if [ -e $VAG_DIR_PATH ]; then
    touch $VAG_CONFIG_PATH
    return 0
  else
    mkdir $VAG_DIR_PATH
    touch $VAG_CONFIG_PATH
    return 0
  fi
}

function check_init() {
  if [ ! -e $VAG_CONFIG_PATH ]; then
    echo "usage:"
    echo "1: $0 init"
    echo "2: $0 set [name] [id]"
    echo "3: $0 up [name]"
    exit 101
  fi
}

function _up() {
  check_init

  . $VAG_CONFIG_PATH
  eval ID=\"\$$1\"
  if [ -z $ID ]; then
    name_error $1
    return 1
  fi

  vagrant up $ID
}

function _ssh() {
  check_init

  . $VAG_CONFIG_PATH
  eval ID=\"\$$1\"
  if [ -z $ID ]; then
    name_error $1
    return 1
  fi

  vagrant ssh $ID
}

function _suspend() {
  check_init

  . $VAG_CONFIG_PATH
  eval ID=\"\$$1\"
  if [ -z $ID ]; then
    name_error $1
    return 1
  fi

  vagrant suspend $ID
}

function _reload() {
  check_init

  . $VAG_CONFIG_PATH
  eval ID=\"\$$1\"
  if [ -z $ID ]; then
    name_error $1
    return 1
  fi

  vagrant reload $ID
}

function _halt() {
  check_init

  . $VAG_CONFIG_PATH
  eval ID=\"\$$1\"
  if [ -z $ID ]; then
    name_error $1
    return 1
  fi

  vagrant halt $ID
}

function _set() {
  check_init

  if [ ! $# -eq 2 ]; then
    echo "command error"
    echo "usage: $0 set [name] [id]"
    return 1
  fi

  echo "${1}=${2}" >>$VAG_CONFIG_PATH
  echo "--setting--"
  display_name_list
}

function _unset() {
  check_init

  local config_array=$(read_config)
  local ID=""
  local NAME=""

  echo "searching ID = $1 or NAME = $1..."
  for config in ${config_array[@]}; do
    local name=`echo $config | cut -d "=" -f1`
    local id=`echo $config | cut -d "=" -f2`

    if [ $1 = $name ]; then
      NAME=$1
      echo "$name (id:$id)"
    fi
    if [ $1 = $id ]; then
      ID=$1
      echo "$name (id:$id)"
    fi

  done

  if [ "$ID" = "" -a "$NAME" = "" ]; then
    echo "Not Found"
    return 0
  fi

  echo "unset OK? y or n : \c"
  read ans
  if [ $ans = "y" ]; then
    if [ -n "$ID" ]; then
      sed -i".tmp" -e "/${ID}/d" $VAG_CONFIG_PATH
    fi

    if [ -n "$NAME" ]; then
      sed -i".tmp" -e "/${NAME}/d" $VAG_CONFIG_PATH
    fi
  else
    return 0
  fi

  echo "--setting--"
  display_name_list
}

function display_global_status() {
  vagrant global-status
}

function display_name_list() {
  check_init

  local config_array=$(read_config)
  for config in ${config_array[@]}; do
    local name=`echo $config | cut -d "=" -f1`
    local id=`echo $config | cut -d "=" -f2`
    echo "$name (id:$id)"
  done
  return 0
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
$0 unset [name or id]
$0 status
$0 list
_EOS_
return 1
}

function name_error() {
  echo "$1 name does not exist"
  echo ------name list-------
  display_name_list
  return 1
}

function read_config() {
  local name=""
  local line=""
  local name_array=()

  if [ ! -r $VAG_CONFIG_PATH ]; then
    echo 'vag_configが見つからないか、または読み込み権限がありませんでした。処理を中断します。'
    exit 101
  fi

  while read line
  do
    if [ ${#line} -eq 0 ]; then
      :
    else
      name="${name} $line"
    fi
  done <$VAG_CONFIG_PATH
  local name_array=($name)
  echo ${name_array[@]}
  return 0
}

case $1 in
  init ) _init ;;
  up ) _up $2 ;;
  ssh ) _ssh $2 ;;
  suspend ) _suspend $2 ;;
  reload ) _reload $2 ;;
  halt ) _halt $2 ;;
  set ) _set $2 $3 ;;
  unset ) _unset $2 ;;
  list ) display_name_list ;;
  status ) display_global_status ;;
  * ) command_error ;;
esac