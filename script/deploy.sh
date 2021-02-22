#!/bin/bash
set -euC

##
##
# gcloud app deploy --appyaml $HOME/go/src/github.com/tweeeety/go-gae-sample/svc1/default.yaml
##


#
# GLOBAL VARS
#
SCRIPT_DIR=$(cd $(dirname $0); pwd)
APP_ROOT_DIR=`cd $SCRIPT_DIR/..; pwd`
readonly DEBUG=false
SERVICE_NAME=
SERVICE_DIR=
APP_YAML_PATH=

#
# Usage
#
function usage() {
  cat <<EOS >&2
Usage: $0 [-s SERVICE_NAME]
  SERVICE_NAME サービス名
EOS
  exit 1
}

# Parse Arguments
function parse_args() {
  while getopts "s:h" OPT; do
    case $OPT in
      s) SERVICE_NAME=$OPTARG ;;
      h) usage
        ;;
      ?) usage
        ;;
    esac
  done

  shift $((OPTIND - 1))

  if [[ "$SERVICE_NAME" == "" ]]; then
    usage
  fi
}

#
# Function
#
function set_service_info(){
  SERVICE_DIR="$APP_ROOT_DIR/$SERVICE_NAME"
  APP_YAML_PATH="$SERVICE_DIR/app.yaml"
}

function is_service_correct() {
  if [ ! -e ${SERVICE_DIR} ]; then
    echo "[ERROR] Service is not exists: ${SERVICE_DIR}"
    exit 1
  fi
  if [ ! -e ${APP_YAML_PATH} ]; then
    echo "[ERROR] app.yaml is not exists: ${APP_YAML_PATH}"
    exit 1
  fi
}

function is_installed_command(){
  if !(type "gcloud" > /dev/null 2>&1); then
    echo "[ERROR] gcloud command does not installed"
    exit 1
  fi
}

function confirm_deploy_info(){
  gcloud config list
  echo -e "----"
  echo -n "Is the Deploy information correct? [y/N]: "
  read ANS

  case $ANS in
    [Yy]* )
      echo -e "\ntyped \"Yes\"\n"
      ;;
    * )
      echo -e "\ntyped \"No\"\n"
      echo "Please set up with the gcloud command."
      exit 1
      ;;
  esac
}

function deploy() {
  exec_command="gcloud app deploy --appyaml $APP_YAML_PATH"
  echo "exec command:"

  echo $exec_command

  cd $SERVICE_DIR
  `$exec_command`
}

#
# Main
#
function main() {
  # settings
  set_service_info

  # check
  is_installed_command
  is_service_correct

  # confirm deploy
  confirm_deploy_info

  # deploy
  deploy
}

# エントリー処理
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  parse_args "$@"
  main
fi
