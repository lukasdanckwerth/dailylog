#!/bin/bash
set -u
set -e

DL_GIT_REPO="https://github.com/lukasdanckwerth/dailylog.git"
DL_DIR="/var/log/dailylog"
DL_VERSION="${DL_DIR}/.version"

log() {
  echo "[install-dailylog.sh]  ${*}"
}

emph() {
  echo -e "\033[1m${*}\033[0m"
}

random_string() {
  echo $RANDOM | md5sum | head -c 32
}

die() {
  log "${*}" && exit 0
}

remote_version() {
  git ls-remote "${DL_GIT_REPO}" HEAD | awk '{ print $1}'
}

local_version() {
  if [[ -f "${DL_VERSION}" ]]; then echo "$(cat "${DL_VERSION}")"; else echo ""; fi
}

DL_REMOTE_VER="$(remote_version)"
DL_LOCAL_VER="$(local_version)"

[[ "$(whoami)" == "root" ]] || die "must be run as root"
[[ "$(which git)" == "" ]] && die "$(emph "git") not found"
[[ "${DL_REMOTE_VER}" == "${DL_LOCAL_VER}" && ! "$*" == *--force* ]] && die "already up to date"

if [[ ! "${DL_LOCAL_VER}" == "" ]]; then
  log "" && log "$(emph "UPDATE AVAILABLE")" && log ""
  log "CURRENT:   $(emph "${DL_LOCAL_VER}")"
  log "NEW:       $(emph "${DL_REMOTE_VER}")" && log ""
  log "Do you want to install the update (y/n)?"
else
  log "Are you sure you want to insall dailylog (y/n)?"
fi

read -r -p "" IM_INSTALL_CONTROL
[[ "${IM_INSTALL_CONTROL}" == "y" ]] || exit 0

DL_TMP_REPO="/tmp/dailylog-$(random_string)"

log "Repo URL:      ${DL_GIT_REPO} ..."
log "Cloning into:  ${DL_TMP_REPO}"
git clone --quiet "${DL_GIT_REPO}" "${DL_TMP_REPO}"

pushd "${DL_TMP_REPO}" >/dev/null

log "Install ..."
sudo make install

popd >/dev/null

log "Remove ${DL_TMP_REPO}"
rm -rf "${DL_TMP_REPO}"
