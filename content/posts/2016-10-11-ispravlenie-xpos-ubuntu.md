---
published: true
layout: post
title: Исправление Frontol xPOS в Ubuntu 12.04
date: 2016-10-11 17:07:00 +0500
lastmod: 2023-04-06
tags: [atol,xpos,ubuntu]
description: Решение проблемы с правами xPos на Ubuntu 12.04 
---

В этой записи я расскажу о хаке, который можно использовать при проблеме с правами в [Frontol xPOS][1] на POS-системах, поставляемых "под ключ".

### Суть проблемы ###

В POS-терминалах на базе Ubuntu 12.04, поставляемых компанией ATOL "под ключ", присутствует проблема с ПО [xPOS][1]. Заключается она в том, что при попытке запуска прикладных компонентов с правами пользователя возникает ошибка прав доступа, несмотря на то, что БД создаётся в домашнем каталоге пользователя, и на этот каталог установлены корректные права чтения и записи.

### Решение проблемы ###

К сожалению, внятного ответа техническая поддержка ATOL по этому поводу не даёт. Привожу не самый лучший, но в то же время рабочий вариант решения данной проблемы. А именно: запуск прикладных компонентов от имени рута.

Изучаем содержимое каталога **/opt/ATOL**, в котором размещено ПО xPOS:
```bash
    ls -ah /opt/ATOL
    ./  ../  FrontolxPOS/  LicenseManager/
```
Смотрим содержимое каталогов *FrontolxPOS* и *LicenseManager*:
```bash
    ls -ah FrontolxPos
    ./             translations/       FxPOSExchange.sh*  libQtSql.so.4
    ../            Configure*          LayoutEditor*      libQtXml.so.4
    docs/          Configure.sh*       LayoutEditor.sh*   LicenseServer*
    drivers/       DBManager*          libCore.so         LicenseServer.sh*
    icons/         DBManager.sh*       libQtCore.so.4     POS*
    imageformats/  DiscountEditor*     libQtGui.so.4      POS.sh*
    license/       DiscountEditor.sh*  libQtNetwork.so.4  uninstall*
    sqldrivers/    FxPOSExchange*      libQtScript.so.4   uninstall.dat\

    ls -ah LicenseManager
    ./     icons/         libQtCore.so.4     libQtXml.so.4       uninstall*
    ../    imageformats/  libQtGui.so.4      LicenseManager*     uninstall.dat
    docs/  translations/  libQtNetwork.so.4  LicenseManager.sh*
```
Здесь нам интересны сценарии (с расширением *.sh*), которые запускают соответствующие бинарники. Они однотипные, для примера приведу здесь содержимое *Configure.sh*:
```bash
    #!/bin/sh
    appname=`basename "$0" | sed s,\.sh$,,`

    dirname=`dirname "$0"`
    tmp="${dirname#?}"

    if [ "${dirname%$tmp}" != "/" ]; then
	    dirname="$PWD/$dirname"
    fi
    LD_LIBRARY_PATH=$dirname:${LD_LIBRARY_PATH}
    LD_LIBRARY_PATH=$dirname/drivers:${LD_LIBRARY_PATH}
    export LD_LIBRARY_PATH

    cd "$dirname"
    "$dirname/$appname" "$@"
```
Для наших целей необходимо заменить последнюю строчку сценария на 
```bash
    sudo "$dirname/$appname" "$@"
```
Для того, чтобы не делать это вручную, можно использовать сценарий ([скачать][2]):
```bash
    #!/bin/bash
    for file in $(find . -name '*.sh')
    do
        TEMP=$(mktemp)
        cat $file | sed -e 's/\"\$dirname\/\$appname\" \"\$\@\"/#\"\$dirname\/\$appname\" \"\$\@\"/g'\
                        -e '$ a\sudo \"\$dirname\/\$appname\" \"\$\@\"' > ${TEMP}
	mv $TEMP $file	
	done
	exit 0
```
Скрипт поместить в **/opt/ATOL** и запустить от рута.

Далее, для того, чтобы предустановленный пользователь (*user*) смог запускать ПО от имени рута **без ввода пароля**, необходимо добавить с файл **/etc/sudoers** следующее:
```bash
    # Блок для xPOS
    user ALL = NOPASSWD: /opt/ATOL/FrontolxPOS/Configure
    user ALL = NOPASSWD: /opt/ATOL/FrontolxPOS/DiscountEditor
    user ALL = NOPASSWD: /opt/ATOL/FrontolxPOS/FxPOSExchange
    user ALL = NOPASSWD: /opt/ATOL/FrontolxPOS/LayoutEditor
    user ALL = NOPASSWD: /opt/ATOL/FrontolxPOS/LicenseServer
    user ALL = NOPASSWD: /opt/ATOL/FrontolxPOS/POS
    user ALL = NOPASSWD: /opt/ATOL/LicenseManager/LicenseManager
    # Конец блока для xPOS
```
### Итоги ###

К сожалению, решение не идеально, так как сильно зависит от структуры xPOS, а также не сохраняется при обновлении. 

[1]: http://www.atol.ru/software/front-office/frontol-xpos/ "Официальный сайт ПО xPOS"
[2]: /files/frontol-fix.sh "Быстрая правка скриптов запуска xPOS"


