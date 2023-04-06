---
published: true
layout: post
title: Начало работы с Jekyll в Ubuntu 18.04 LTS
date: 2016-10-04 11:53:18 +0500
lastMod: 2023-04-06
tags: [jekyll,ubuntu,web]
description: "В этой заметке я расскажу, как установить Jekyll в Ubuntu 18.04 LTS и быстро приступить
к созданию своего сайта."
---

> Статья устарела! Теперь мой блог работает на [hugo][5]. Прочитайте [про установку и начало работы hugo][6].

### Подготовка платформы ###

Для работы [Jekyll][2] нужен Ruby. Как показала практика, в репозитариях Ubuntu Ruby часто идет
не самой свежей версии. Поэтому, на мой взгляд, удобнее пользоваться сторонней системой,
например, RVM. Цитируя [официальный сайт][1]:

> RVM is a command-line tool which allows you to easily install, manage, and work with multiple ruby environments from interpreters to sets of gems. 

Для установки RVM в Ubuntu, нужны команды:
```bash
    gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
```
После чего необходимо запустить внутри эмулятора терминала дополнительную оболочку командой
```bash
    bash --login
```
Далее установим версию Ruby 2.6.3
```bash
    rvm install 2.6.3
    rvm use 2.6.3
```
Если у вас всё ешё не установлена система контроля версий git, рекомендую установить её, это потребуется для получения шаблона блога.
```bash
    sudo apt install git
```
### Установка Jekyll ###

Установим гемы, требующиеся для работы Jekyll:
```bash
    gem install jekyll jekyll-sitemap jekyll-feed
```    
Используйте git, чтобы клонировать репозитарий [Jekyll-now][3]
```bash 
    git clone https://github.com/barryclark/jekyll-now.git
```
Вы также можете скачать архив с пакетом по [ссылке на гитхабе][4].
Перейдите в каталог jekyll-now и используйте команду:
```bash
    cd jekyll-now
    jekyll serve
```
После чего, перейдя в браузере по ссылке <http://127.0.0.1:4000>, вы увидите работающий блог. Для настройки содержимого редактируйте файл **_config.yml**. Сгенерированные файлы для загрузки на хостинг размещаются в каталоге _site.

### Заключение ###

Дальнейшую разработку блога можно вести как на локальной машине, так и на выбранном вами хостинге. GitHub также предоставляет возможность бесплатно размещать сайты, разработанные с использованием Jekyll, но там в целях безопасности отключены все пользовательские плагины. 
Если вам понадобится дополнительная информация о Jekyll и связанных с ним технологиях, ищите её на официальных сайтах по ссылкам выше.

[1]: https://rvm.io/ "Официальный сайт RVM"
[2]: https://jekyllrb.com "Официальный сайт Jekyll"
[3]: https://github.com/barryclark/jekyll-now "Пакет Jekyll-now"
[4]: https://github.com/barryclark/jekyll-now/archive/master.zip "ZIP-архив Jekyll-now"
[5]: https://gohugo.io/ "Фреймворк для генерации статических веб-сайтов"
[6]: https://trefmanic.me/posts/hugo-ustanovka-i-nachalo-raboty/ "hugo: установка и начало работы"
