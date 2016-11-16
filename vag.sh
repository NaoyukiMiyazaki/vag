#!/bin/sh

. ./.vag_config

function up() {
  eval ID=\"\$$1\"
  echo "start vag ${FUNCNAME[0]} $1 (ID: $ID)"
  vagrant up $ID
  echo "finish vag ${FUNCNAME[0]} $1"
}

function ssh() {
  eval ID=\"\$$1\"
  echo "start vag ${FUNCNAME[0]} $1 (ID: $ID)"
  vagrant ssh $ID
  echo "finish vag ${FUNCNAME[0]} $1"
}

function suspends() {
  eval ID=\"\$$1\"
  echo "start vag ${FUNCNAME[0]} $1 (ID: $ID)"
  vagrant suspend $ID
  echo "finish vag ${FUNCNAME[0]} $1"
}

function reload() {
  eval ID=\"\$$1\"
  echo "start vag ${FUNCNAME[0]} $1 (ID: $ID)"
  vagrant reload $ID
  echo "finish vag ${FUNCNAME[0]} $1"
}

function halt() {
  eval ID=\"\$$1\"
  echo "start vag ${FUNCNAME[0]} $1 (ID: $ID)"
  vagrant halt $ID
  echo "finish vag ${FUNCNAME[0]} $1"
}

function sets() {
  echo "start vag ${FUNCNAME[0]} $1 $2"
  echo "finish vag ${FUNCNAME[0]} $1 $2"
}

function displaylist() {
  echo "displaylist"
}

function error() {
cat <<_EOS_
commad not fount
--command list--
$0 up [name]
$0 ssh [name]
$0 suspend [name]
$0 reload [name]
$0 halt [name]
$0 set [name] [id]
_EOS_
}

case $1 in
  up ) up $2 ;;
  ssh ) ssh $2 ;;
  suspend ) suspends $2 ;;
  reload ) reload $2 ;;
  halt ) halt $2 ;;
  set ) sets $2 $3 ;;
  * ) error ;;
esac