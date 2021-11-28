.DEFAULT_GOAL := install
.SILENT: install remove
.ONESHELL: install remove

DL_ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DL_LOCAL_VER := $(shell grep -hs ^ /var/log/dailylog/.version)
DL_REMOTE_VER := $(shell git rev-parse HEAD)
DL_USER := $(shell whoami)

install:
ifneq ($(DL_USER),root)
	@echo "[make install]  run as root"
	exit
endif
ifeq ($(DL_LOCAL_VER),$(DL_REMOTE_VER))
	@echo "[make install]  version ($(DL_LOCAL_VER)) already up-to-date"
	exit
endif

	echo "[make install]  copy dailylog to /usr/local/bin/dailylog"
	sudo rm -rf /usr/local/bin/dailylog
	sudo cp -nf "${DL_ROOT_DIR}/dailylog" /usr/local/bin/dailylog

	echo "[make install]  configure /var/log/dailylog"
	sudo mkdir -p /var/log/dailylog
	sudo chmod 777 /var/log/dailylog

	sudo git rev-parse HEAD >/var/log/dailylog/.version
	echo "[make install]  installed version:" $(DL_REMOTE_VER)

remove:
ifneq ($(DL_USER),root)
	@echo "[make remove]  run as root"
	exit
endif

	echo "[make remove]  removing /usr/local/bin/dailylog"
	[ -f /usr/local/bin/dailylog ] && sudo rm -rf /usr/local/bin/dailylog

	echo "[make remove]  removing /var/log/dailylog"
	[ -d /var/log/dailylog ] && sudo rm -rf /var/log/dailylog
