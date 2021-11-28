.DEFAULT_GOAL := install
.SILENT: install remove
.ONESHELL: install remove

ML_ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
ML_LOCAL_VER := $(shell grep -hs ^ /var/log/dailylog/.version)
ML_REMOTE_VER := $(shell git rev-parse HEAD)
ML_USER := $(shell whoami)

install:
ifneq ($(ML_USER),root)
	@echo "[install]  run as root"
	exit
endif
ifeq ($(ML_LOCAL_VER),$(ML_REMOTE_VER))
	@echo "[install]  version ($(ML_LOCAL_VER)) already up-to-date"
	exit
endif

	echo "[install]  copy dailylog to /usr/local/bin/dailylog"
	sudo rm -rf /usr/local/bin/dailylog
	sudo cp -nf "${ML_ROOT_DIR}/dailylog" /usr/local/bin/dailylog

	echo "[install]  configure /var/log/dailylog"
	sudo chmod 777 /var/log/dailylog

	sudo git rev-parse HEAD >/var/log/dailylog/.version
	echo "[install]  installed version:" $(ML_REMOTE_VER)

remove:
ifneq ($(ML_USER),root)
	@echo "[remove]  run as root"
	exit
endif

	echo "[remove]  removing /usr/local/bin/dailylog"
	[ -f /usr/local/bin/dailylog ] && sudo rm -rf /usr/local/bin/dailylog

	echo "[remove]  removing /var/log/dailylog"
	[ -d /var/log/dailylog ] && sudo rm -rf /var/log/dailylog
