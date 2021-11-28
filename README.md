# dailylog

## Usage

[mark-usage-start]::
```shell

usage: dailylog <text> [<argument>]

    --label     | -b label    The label of the log message.
    --level     | -l level    The level of the log message.

    --l-info    | -li         Sets the level to INFO.
    --l-warning | -lw         Sets the level to WARN.
    --l-error   | -le         Sets the level to ERRO.

    --remove    | -r          Removes the dailylog file.
    --week                    Shows the weekly log.
    --quite     | -q          Do not print message on console.
    --dry       | -d          Do not write message to files.
    --help      | -h          Prints this help and exists.

```
[mark-usage-end]::


## Install

#### Install `dailylog` with ([`install-dailylog.sh`](https://raw.githubusercontent.com/lukasdanckwerth/dailylog/main/install-dailylog.sh)) script

```shell
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/dailylog/main/install-dailylog.sh)"
```

#### Manual install
```shell
# clone project
$ git clone https://github.com/lukasdanckwerth/dailylog.git

# change into directory
$ cd dailylog && git status

# install
$ sudo make install
```
