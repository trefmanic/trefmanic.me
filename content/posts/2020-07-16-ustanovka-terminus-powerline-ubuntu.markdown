---
published: true
layout: post
title: Установка Terminus Powerline в Ubuntu
date: 2020-07-16 20:30:41 +0500
lastMod: 2023-04-06
categories: [справочная] 
tags: [ubuntu, terminus, powerline]
description: В статье описан процесс установки комплекта шрифтов Powerline и активации их в Ubuntu Linux и производных ОС.
---

> Информация устарела. На сегодняшний момент библиотека **pango**, отвечающая за отображение текста в приложениях GTK [не поддерживает растровые шрифты][5]. Несмотря на то, что энтузиасты собрали [OTB][6]-версию Terminus с фиксированными размерами глифов, поддержки powerline нет.

### О чём речь? ###

[Powerline Fonts][1] это специальным образом пропатченный комплект моноширинных шрифтов для использования с темами приглашения командной строки [Powerlevel10k][2] и не только. В эти шрифты добавлены специальные символы, для того, чтобы приглашение отображалось корректно. Мой любимый шрифт для эмулятора терминала — [Terminus][4], пропатченная версия которого тоже есть в этом пакете.

### Установка ###

Клонируйте репозитарий Github [powerline/fonts][1]:
```bash
git clone https://github.com/powerline/fonts.git
```
Установите, запустив **install.sh**:
```bash
chmod +x fonts/install.sh
fonts/install.sh # для установки в профиль пользователя
# Вы также можете установить шрифты общесистемно
# Всегда проверяйте код, когда запускаете его от
# имени суперпользователя!!
# sudo fonts/install.sh # для общесистемной установки
```
### Это всё? ###

Не совсем. В Ubuntu и её производных (например, [Linux Mint][3]) по умолчанию отключены растровые шрифты. Для того, чтобы это исправить, выполните:
```bash
cd /etc/fonts/conf.d/
sudo rm /etc/fonts/conf.d/10*  
sudo rm -rf 70-no-bitmaps.conf 
sudo ln -s ../conf.avail/70-yes-bitmaps.conf .
sudo dpkg-reconfigure fontconfig
```
На этом всё! Теперь можно настроить шрифт в вашем эмуляторе терминала. Пропатченная версия Terminus называется **Terminess Powerline**.

[1]: https://github.com/powerline/fonts "Репозитарий на Github"
[2]: https://github.com/romkatv/powerlevel10k "Тема"
[3]: https://www.linuxmint.com/ "Домашняя страница проекта Linux Mint"
[4]: http://terminus-font.sourceforge.net/ "Домашнаяя страница Terminus Font"
[5]: https://blogs.gnome.org/mclasen/2019/05/25/pango-future-directions/ "Отключение поддержки растровых шрифтов"
[6]: https://ru.wikipedia.org/wiki/OpenType#Данные,_включаемые_в_файл_шрифта  "OpenType Bitmap"
