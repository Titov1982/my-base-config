#!/bin/bash

RED="echo -e -n \033[1;31m"
GREEN="echo -e -n \033[1;32m"
YELLOW="echo -e -n \033[1;33m"
NORMAL="echo -e -n \033[0;39m"

$GREEN
echo "Скрипт подготовки вашего окружения к работе..."
$NORMAL
echo

# -------------------------------------------------------------
# Поиск уже установленных пакетов и определение тех, которые
# необходимо установить
# -------------------------------------------------------------

installed_pkg_list=$(dpkg-query -f '${binary:Package}\n' -W)
installing_pkg_list=""

# Список желаемых пакетов
new_pkg_list="\
tldr \
bat \
mc \
vim \
curl \
nodejs \
npm \
clangd \
zsh \
asd1 \
asd2 \
git \
traceroute \
"

$YELLOW
for util in $new_pkg_list
    do
        if [[ $installed_pkg_list == *"$util"* ]]; then
            echo "Утилита \"$util\" уже установлена"
        else
            installing_pkg_list=$installing_pkg_list"$util "
        fi
done
$NORMAL

$GREEN
echo
echo "Необхожимо устрановить следующие пакеты:"
$NORMAL
echo
echo $installing_pkg_list
echo

# -------------------------------------------------------------
# Обновление базы данных репозиториев
# Установка пакетов
# -------------------------------------------------------------

sudo apt update
sudo apt install $installing_pkg_list

# Установка языкового сервера для поддержки автодополнений bash
sudo npm i -g bash-language-server

# Установка дополнений внутри Vim
# :PlugInstall
#:CocInstall coc-clangd
#:CocInstall coc-sh
vim -s ./vim.cfg

# -------------------------------------------------------------
# Копирование конфигурационных файлов 
# -------------------------------------------------------------

$GREEN
read -p "Скопировать конфигурационный файл .vimrc [y/N]:" flag
$NORMAL
if [ $flag == "y" ]; then
    cp configs/.vimrc $HOME/test
    echo "Конфигурационный файл .vimrc скопирован"
fi

# -------------------------------------------------------------
# Добавление конфигурационных параметров
# -------------------------------------------------------------

#echo "alias ll=\"ls -la --color=auto\"" >> $HOME/.bashrc 
#echo "alias ll=\"ls -la --color=auto\"" >> $HOME/.zshrc 
