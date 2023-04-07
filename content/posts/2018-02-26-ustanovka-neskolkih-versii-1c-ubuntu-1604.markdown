---
published: true
layout: post
title: Установка нескольких версий 1С в Ubuntu
date: 2018-02-26 09:23:27 +0500
updated: true
lastmod: 2023-04-07
tags: [1c,linux]
keywords: [1c,linux]
description: "Сценарий для распаковки и установки параллельно нескольких версий платформы 1С:Предприятие."
---
> Статья устарела. Начиная с версии платформы 8.3.18 поддерживается нативный механизм параллельной установки нескольких версий.

> **tl;dr**: [скачать архив со сценарием][4].

### Проблема ###

Начиная с версии 8.2 платформы 1С:Предприятия есть возможность пользоваться нативным клиентом для ОС Linux. Существуют .deb-пакеты и для Ubuntu. Однако, разработчики 1С так и не реализовали нативную поддержку установки нескольких версий в систему. Это приводит к неудобствам при разработке и поддержке баз, размещённых на серверах разных версий.

К счастью, есть решение - устанавливать нужные версии платформы вручную. Ниже приведён сценарий, который позволяет автоматизировать этот процесс. Он основан на сценарии, приведённом на [вики AltLinux][1] и переработан для Ubuntu. Сценарий должен работать в любой современной версии Ubuntu.

### Установка ###

Прежде, чем использовать сценарий, убедитесь в следующем:
 
 * В системе есть релиз платформы любой версии, установленный обычным способом (из .deb-пакетов при помощи **dpkg**).
 * Вы загрузили [с сайта релизов 1С][2] архивы с пакетами клиента **и** сервера. В списке загрузок они называются *"Клиент 1С:Предприятия (64-bit) для DEB-based Linux-систем"* и *"Cервер 1С:Предприятия (64-bit) для DEB-based Linux-систем"*. 
 * Вы разместили архивы **client.deb64.tar.gz** и **deb64.tar.gz** в одном каталоге со сценарием.
 
 После этого запускайте сценарий командой:

```bash
./1cmulti.sh
```

### Удаление ###

Для удаления установленных вручную версий, используйте команды:
```bash
# Версия для удаления:
# VERSION="8.3.13-1690"
sudo rm -Rf "/opt/1C/v$VERSION"
sudo rm "/usr/share/applications/1cestart.$VERSION.desktop"
sudo update-desktop-database
```
Чтобы удалить установленную из deb-пакета версию 1С, используйте **sudo apt remove**. После этого необходимо установить из deb-пакета более свежую версию, иначе установленные вручную работать не будут.

### Сценарий ###

Полный текст сценария приведён ниже. Вы также можете [скачать архив со сценарием][4], а для самой свежей версии посетить [мой репозиторий на GitHub][3].

```bash
#!/bin/bash
# 1cmulti
####################################
# Сценарий устанавливает в систему
# дополнительные версии платформы 1С: Предприятие
# Для корректной работы нужно предварительно установить
# платформу любой версии обычным способом.
####################################

####################################
# Переменные
####################################

# Архитектура системы
ARCH=amd64
PKG_ARCH=`echo $ARCH | sed -e 's/amd/deb/g'`

# Имя пакета
NAME="1c-enterprise83"

# Защита от дурака, запускающего сценарий из корня ФС:

if [[ $(pwd) = "/" ]]
    then
        echo "При запуске из / возможна потеря данных."
        echo "Не запускайте этот сценарий так."
        exit 1
fi

# Проверка на наличие исходных файлов
# для парсера версии

if ! [ -f $PKG_ARCH.tar.gz ]
    then
        echo "Отсутствует архив с пакетами сервера $PKG_ARCH.tar.gz"
        exit 1
fi

if ! [ -f client.$PKG_ARCH.tar.gz ]
    then
        echo "Отсутствует архив с пакетами клиента client.$PKG_ARCH.tar.gz"
        exit 1
fi

# Если архивы найдены, пробуем их распаковать.
echo "Распаковываем архивы..."

tar xfz "$PKG_ARCH.tar.gz"
if [[ $? != 0 ]]
    then
        # Если код возврата не равен нулю, tar завершился с ошибкой
        # Прерываем выполнение сценария
        echo "Ошибка tar при распаковке $PKG_ARCH.tar.gz"
        exit 1
fi

tar xfz "client.$PKG_ARCH.tar.gz"
if [[ $? != 0 ]]
    then
        # Если код возврата не равен нулю, tar завершился с ошибкой
        # Прерываем выполнение сценария
        echo "Ошибка tar при распаковке client.$PKG_ARCH.tar.gz"
        exit 1
fi

# Проверяем, есть ли распакованные пакеты.
find ./ -name "$NAME-client*.deb" | egrep '.*'
if [[ $? != 0 ]]
    then
        echo "Пакет $NAME не найден"
        exit 1
    else
        echo "Пакет $NAME найден..."
        echo "Парсим версию..."

        # Извлечение версии пакета из имени
        VERSION=`ls $NAME-client* | head -1 | sed -e 's/'_"$ARCH"'//g' -e 's/^.*client_//g' -e 's/\.[^.]*$//'`

fi

echo "Версия:"$VERSION

# DEBUG
# exit 0


# Проверяем наличие всех требуемых пакетов

if ! [ -f "$NAME-client_"$VERSION"_"$ARCH".deb" ]
    then
        echo "$NAME-client_"$VERSION"_"$ARCH".deb не найден"
        echo "Проверьте наличие всех пакетов"
        #exit 1
    else
        echo "$NAME-client_"$VERSION"_"$ARCH".deb НАЙДЕН!"
fi

if ! [ -f "$NAME-client-nls_"$VERSION"_"$ARCH".deb" ]
    then
        echo "$NAME-client-nls_"$VERSION"_"$ARCH".deb не найден"
        echo "Проверьте наличие всех пакетов"
        #exit 1
    else
        echo "$NAME-client-nls_"$VERSION"_"$ARCH".deb НАЙДЕН"
fi

if ! [ -f "$NAME-server_"$VERSION"_"$ARCH".deb" ]
    then
        echo "$NAME-server_"$VERSION"_"$ARCH".deb не найден"
        echo "Проверьте наличие всех пакетов"
        #exit 1
    else
        echo "$NAME-server_"$VERSION"_"$ARCH".deb НАЙДЕН!"
fi

if ! [ -f "$NAME-server-nls_"$VERSION"_"$ARCH".deb" ]
    then
        echo "$NAME-server-nls_"$VERSION"_"$ARCH".deb не найден"
        echo "Проверьте наличие всех пакетов"
        #exit 1
    else
        echo "$NAME-server-nls_"$VERSION"_"$ARCH".deb НАЙДЕН!"
fi

echo "Все пакеты найдены!"
echo " "
echo "Установить пакет в систему? Потребуются права суперпользователя (Y/n)"

# Спрашиваем пользователя, нужна ли установка в систему
read item
case "$item" in
    y|Y) SETUP=1
        ;;
    n|N) SETUP=0
        ;;
    *) SETUP=1
        ;;
esac

# Распаковка пакетов
echo "Подождите, распаковка пакетов..."
dpkg -x $NAME"-client_"$VERSION"_"$ARCH".deb" . 
dpkg -x $NAME"-client-nls_"$VERSION"_"$ARCH".deb" . 
dpkg -x $NAME"-server_"$VERSION"_"$ARCH".deb" . 
dpkg -x $NAME"-common_"$VERSION"_"$ARCH".deb" . 

# Генерация файла .desktop
DESKTOPFILE="1cestart.$VERSION.desktop"
touch "$DESKTOPFILE"

#DEBUG

echo "[Desktop Entry]" >> "$DESKTOPFILE"
echo "Version=1.0" >> "$DESKTOPFILE"
echo "Type=Application" >> "$DESKTOPFILE"
echo "Terminal=false" >> "$DESKTOPFILE"
echo "Exec=/opt/1C/v"$VERSION"/x86_64/1cestart" >> "$DESKTOPFILE"
echo "Categories=Office;Finance;" >> "$DESKTOPFILE"
echo "Name[ru_RU]=1C:Предприятие "$VERSION >> "$DESKTOPFILE"
echo "Name=1C:Enterprise "$VERSION >> "$DESKTOPFILE"
echo "Icon=1cestart" >> "$DESKTOPFILE"

# Если пользователь согласился на установку:
if [[ $SETUP != 0 ]]
    then
        sudo mv "opt/1C/v8.3" "/opt/1C/"v$VERSION
        sudo desktop-file-install "1cestart.$VERSION.desktop"
    else
        tar -cpzf 1C_$VERSION.tgz opt
fi    

echo "Очистить установочные файлы (*.deb, *.desktop)? (Y/n)"

# Спрашиваем пользователя, нужно ли очищать временные файлы
read item
case "$item" in
    y|Y) rm -rf opt/ etc/ usr/; rm ./*.deb ./*.desktop
        ;;
    n|N) : #Ничего не делаем
        ;;
    *) rm -rf opt/ etc/ usr/; rm ./*.deb ./*.desktop
        ;;
esac

echo "Завершено успешно!"
exit 0


```

[1]: https://www.altlinux.org/1C/MultiClient "Статья на вики AltLinux"
[2]: https://releases.1c.ru "Релизы 1С:Предприятие"
[3]: https://github.com/trefmanic/1cmulti-ubuntu "1cmulti-ubuntu на GitHub"
[4]: /files/1cmulti.sh.tar.gz
