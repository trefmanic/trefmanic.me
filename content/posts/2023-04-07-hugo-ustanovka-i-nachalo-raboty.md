---
title: "hugo: установка и начало работы"
date: "2023-04-05T17:38:22+05:00"
updated: false
tags: ["hugo", "web"]
keywords: ["hugo", "web"]
description: "Краткое руководство по началу работы с генератором статичных web-страниц hugo"
published: true
---

Этот блог создан при помощи генератора статичных веб-страниц на основе шаблонов [hugo][1]. В этой статье я расскажу о преимуществах такого метода создания сайтов, а также приведу примеры начала работы. В качестве ОС используется [Linux Mint 21][2].

### Статические страницы против динамической генерации ###

Предположим, вы написали в блокноте {{<abbr title="HyperText Markup Language">}}HTML{{</abbr>}}-документ для вашей домашней страницы, загрузили его на веб-сервер, и теперь любой желающий может прочитать, что вы любите сыр, а на досуге коллекционируете консервные банки. После этого вы решили добавить на ваш сайт контента, и написали ещё много страниц, всё вручную. А теперь представьте, что вы решили поменять название вашего сайта в шапке страницы, и вам придётся переписывать **каждую** страницу вручную.

Тут на сцене появляются динамические генераторы. Они представляют из себя сценарии, выполняющиеся на сервере, и формирующие каждую страницу вашего сайта на основе нескольких файлов. Оформление отдельно, содержимое отдельно. В тот момент, когда посетитель сайта запрашивает определённую страницу, она формируется сценарием <<на лету>>, и отдаётся веб-сервером. Одним из популярных языков для написания таких сценариев является, например, [PHP][3]. 

Если вам понадобится заменить элемент в шапке сайта, вам достаточно будет отредактировать один файл. Это удобно, но небезопасно, так как сценарий обрабатывает введённый посетителем адрес, который может быть специальным образом сфабрикован, чтобы использовать ошибки в коде, или уязвимости самого языка сценария. В результате злоумышленник может, выполнив произвольный код, взломать ваш сайт, и использовать его в своих целях.

### Выход есть ###

Решением обеих вышеуказанных проблем являются генераторы статических страниц. Они, так же, как и динамические сценарии, используют шаблоны, и формируют на их основе статический HTML, который вы и загружаете на веб-сервер. Так, как фактически код выполняется один раз, на вашем компьютере, созданные таким методом сайты не поддаются взлому. Менять дизайн, заголовки, и содержимое тоже очень просто. Одним из таких генераторов является [hugo][1], написанный на языке [Go][4].

### Установка, первая страница ###

В [Linux Mint][2] установка проста до неприличия:
```bash
sudo apt install hugo
```
Для создания первого сайта дайте команду:
```bash
hugo new site mycoolsite.com
```
После этого в текущем каталоге появится новый, под названием _mycoolsite.com_, в котором будут раположены начальные файлы шаблонов для генерации сайта. Рекомендую дополнительно создать репозитарий [GIT][5] в этом каталоге:
```bash
cd mycoolsite.com
git init
git add ./*
```
Теперь нужно установить **тему**. Именно тема определяет, как именно будет выглядеть ваш сайт, будет это блог, сайт-визитка, или что угодно ещё. Для начала вы можете скопировать тему этого блога, выполнив команды:
```bash
git clone https://github.com/trefmanic/hugo-theme-terminal-hacked.git themes/terminal-hacked
```
Отредактируйте файл _config.toml:_
```toml
baseURL = 'http://mycoolsite.com'
languageCode = 'en-us'
title = 'My COOL New Hugo Site'
theme = 'terminal-hacked'
```
Добавьте первую запись:
```bash
hugo new posts/myfirstpost.md
```
В каталоге _content_ появится дополнительный каталог _posts_, в котором, в свою очередь, ваша первая запись **myfirstpost.md**. Оформление контента выполяется на языке разметки [Markdown][6]. Если вы скопировали мою тему, то сейчас содержимое этого файла выглядит примерно так:
```markdown
---
title: "Myfirstpost"
date: "2023-04-12T14:46:51+05:00"
updated: false
tags: ["", ""]
keywords: ["", ""]
description: ""
showFullContent: false
published: false
---
```
Перейдите на строку ниже трёх знаков дефиса, и напишите
```
## Привет, мир!
Это моя первая запись в блоге, работающем на [hugo][1]

[1]: https://gohugo.io
```
Для того, чтобы посмотреть, как выглядит ваш сайт в браузере, запустите hugo в режиме сервера:
```bash
hugo server -D
```
И откройте в браузере адрес: [http://localhost:1313](http://localhost:1313) по умолчанию. Если всё сделано правильно, вы должны увидеть заглавную страницу. Кликните на заголовок **"Myfirstpost"**, и вы должны увидеть только что написанную вами статью. Попробуйте внести изменения в файл **myfirstpost.md**, не закрывая браузера. Вы увидите, как содержимое обновляется при каждом изменении файла, что очень удобно. Когда вы закончите редактировать страницы вашего сайта, нажмите в терминале **Ctrl-C** для остановки сервера hugo.

### Публикация сайта ###

Когда содержимое вашего сайта вас устраивает, время его опубликовать. Обратите внимание, что в заголовке _myfirstpost.md_ указан параметр **published: false**. Это означает, что пока ваша запись находится в состоянии черновика, и не будет сгенерирована и включена в готовый сайт. Поэтому мы и запускали hugo с параметром **-D** (development). Исправьте **false** на **true**, после чего запустите hugo без параметров:
```bash
hugo
```
После выполнения этой команды в каталоге вашего сайта появится каталог _public_, содержащий сгенерированные статические страницы для вашего сайта. Теперь вам осталось только выгрузить их на веб-сервер.

[1]: https://gohugo.io/ "Домашняя страница проекта"
[2]: https://linuxmint.com/ "Linux Mint"
[3]: https://www.php.net/ "Домашняя страница языка PHP"
[4]: https://go.dev/ "Язык Go"
[5]: https://git-scm.com/ "Распределённая система контроля версий GIT"
[6]: https://daringfireball.net/projects/markdown/syntax "Описание синтаксиса Markdown"