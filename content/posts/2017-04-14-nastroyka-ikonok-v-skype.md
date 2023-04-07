---
published: true
layout: post
title: Иконки Skype в трее Ubuntu 16.04
date: 2017-04-14 09:48:59 +0500
updated: false
tags: [skype, ubuntu, numix]
keywords: [skype, ubuntu, numix]
description: "В статье описано, как заменить иконки индикатора Skype в системном трее Unity на монохромные."
---

### Проблема ###

После установки Skype в Ubuntu 16.04, внимательный пользователь может заметить, что иконки в трее выбиваются из общесистемной темы. 
Функциональность от этого не страдает, но если у вас все иконки монохромны, то единственная цветная смотрится как бельмо на глазу. К счастью, это исправимо.

### Решение ###

В соответствии со [статьёй на webguruz.ru][1], модифицируем пакет **sni-qt**. Добавляем архитектуру i386:
```bash
    sudo dpkg --add-architecture i386
```
Устанавливаем модифицированный пакет при помощи **dpkg**.
Если вам лень править пакет вручную, я [разместил][2] его в этом блоге:
```bash
    wget http://trefmanic.me/files/sni-qt_0.2.6-0ubuntu1_i386-modified.deb
    sudo dpkg -i sni-qt_0.2.6-0ubuntu1_i386-modified.deb
```
Теперь нам нужны сами иконки. Если у вас стандартная тема иконок, ищите их в ответе на Ask Ubuntu (ссылка ниже). Я же использую тему Numix-Circle от [Numix Project][4]. Поэтому архив с иконками тоже можно [скачать][6] из этого блога. Изначально этот архив [разместил][5] пользователь Launchpad [Mariusz Kubański][7].
```bash
    wget http://trefmanic.me/files/skype_numix_fix.zip
    unzip skype_numix_fix.zip
```
Создаём каталоги для иконок (взято из [ответа пользователя Gabriel Araújo на Ask Ubuntu][3]) и копируем туда содержимое распакованного архива:
```bash
    sudo mkdir /usr/share/pixmaps/skype
    cd ./skype
    sudo cp -Rvf * /usr/share/pixmaps/skype/
    sudo chmod +r /usr/share/pixmaps/skype/*
```
Для того, чтобы наш изменённый пакет не перезаписался новой версией при обновлении, необходимо пометить его как зафиксированный:
```bash
    sudo apt-mark hold sni-qt:i386
```
После этого можно перезапустить Skype и наслаждаться единообразием иконок.



[1]: http://webguruz.ru/ubuntu/%D0%B7%D0%B0%D0%BC%D0%B5%D0%BD%D0%B0-%D0%B8%D0%BA%D0%BE%D0%BD%D0%BA%D0%B8-skype-%D0%B2-ubuntu/ "Пересборка sni-qt"
[2]: http://trefmanic.me/files/sni-qt_0.2.6-0ubuntu1_i386-modified.deb "Изменённый пакет для Ubuntu 16.04"
[3]: https://askubuntu.com/a/549964 "Ответ Gabriel Araújo"
[4]: https://github.com/numixproject "Numix Project на Github"
[5]: https://bugs.launchpad.net/numix-icon-theme-circle/+bug/1414405 "Тема об иконках Skype на Launchpad"
[6]: http://trefmanic.me/files/skype_numix_fix.zip "Архив иконок Skype для Numix-Light"
[7]: https://launchpad.net/~mkubanski "Ссылка на профиль"