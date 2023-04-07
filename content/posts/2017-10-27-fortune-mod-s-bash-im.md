---
published: true
layout: post
title: Цитаты дня fortune-mod с bash.im
date: 2017-10-27 16:57:28 +0500
updated: true
lastmod: 2023-07-04 
tags: [fortune-mod, linux]
keywords: [fortune-mod, linux]
description: "Не всё системному администратору заниматься работой, иногда можно и развлечься. Будем развлекаться при помощи «цитат дня», предоставляемых программой **fortune-mod**. В качестве источника цитат будем использовать Башорг."
---

> [bash.im][1] умер, статья оставлена на память

> **tl;dr**: [скачайте архив с кодом][4].

### Метод ###

Я встречался с решениями, которые парсят и загружают цитаты онлайн. Минусы такого подхода в том, что каждый раз при запуске fortune-mod хост обращается к сайту, да и пул цитат ограничен RSS-лентой. 

Метод из данной статьи загружает сразу большое количество цитат (потенциально **все**), записывает их в текстовый файл в формате, понимаемом fortune-mod, после чего формирует специальный файл-указатель и сохраняет это всё в системе. При вызове
```bash
    fortune bash-ru
```
цитаты читаются из локального файла, что гораздо быстрее, не зависит от наличия доступа в Интернет, да и готовые файлы можно распространить между своими системами (или подарить другу :).

### Парсер ###

Я взял за основу [готовый код парсера][3], за авторством [aruseni][2]. После небольшой обработки получилось следующее:
```python
    #!/usr/bin/env python
    # bash.im fortune parser
    # original author: aruseni (https://github.com/aruseni)
    
    import sys
    import errno
    import urllib2
    import datetime

    from bs4 import BeautifulSoup

    class Parser:
        user_agent = (
            "Mozilla/5.0 "
            "(X11; Ubuntu; Linux x86_64; rv:30.0) "
            "Gecko/20100101 Firefox/30.0"
        )
    
        def __init__(self, start_page, end_page):
            self.start_page = start_page
            self.end_page = end_page
    
        def get_url(self, page_number):
            return "http://bash.im/index/%s" % page_number
    
        def fetch_page(self, page_number):
            req = urllib2.Request(
                url=self.get_url(page_number),
                headers={"User-Agent": self.user_agent}
            )
            f = urllib2.urlopen(req)
            return f.read()
    
        def parse_all_pages(self):
            for page_number in xrange(self.start_page, self.end_page + 1):
            self.parse_quotes(page_number)
    
        def parse_quotes(self, page_number):
            html = self.fetch_page(page_number)
            soup = BeautifulSoup(html, "lxml")
            quote_divs = soup.find_all("div", class_="quote")
            for quote_div in quote_divs:
                quote = {}
    
                text_div = quote_div.find("div", class_="text")

                # Skipping advertisement
                if not text_div:
                    continue
    
                # The quote text divs contain strings of text and
                # <br> elements. Here all contents of a text div
                # are joined with any elements replaced by \n.
                quote["text"] = "".join(
                    map(
                        lambda x: x if isinstance(x, unicode) else "\n",
                        text_div.contents
                    )
                )
    
                quote["text"] = quote["text"].strip()
    
                self.write_quote(quote)
    
        def write_quote(self, quote):
            line = quote.get("text")
            quotes_file = open ("bash-ru","a")
            quotes_file.write(line.encode('utf8') + "\n" + "%" + "\n")
            quotes_file.close()
    
    if __name__ == "__main__":
        arguments = sys.argv
        if (
            len(arguments) == 3
            and arguments[1].isdigit()
            and arguments[2].isdigit()
        ):
            start_page = int(arguments[1])
            end_page = int(arguments[2])
    
            if start_page > 0 and end_page >= start_page:
                p = Parser(start_page, end_page)
                p.parse_all_pages()
            else:
                sys.stderr.write("Please check the page numbers\n")
                sys.exit(errno.EINVAL)
        else:
            sys.stderr.write("Invalid arguments\n")
            sys.exit(errno.EINVAL)
```
Этот скрипт принимает в качестве аргументов номер первой страницы и номер последней страницы для обработки:
```bash
    ./parse.py 1 10
```
и формирует текстовый файл *bash-ru* в формате, поддерживаемом фортункой.

### Makefile ###

Для автоматизации дальнейшей обработки я написал Makefile:
```makefile
    # Fortunes processing
    
    POSSIBLE += $(shell ls -1 | egrep -v '\.dat|Makefile|README|parse|requirements' | sed -e 's/$$/.dat/g')
    
    all: ${POSSIBLE}
    
    %.dat : %
    
        @strfile $< $@
    
    install: all
        mv bash-ru bash-ru.dat /usr/share/games/fortunes
    
    clean:
        rm *.dat bash-ru
```
После отработки парсера, запускайте
```bash    
    make all
```
для формирования файла-указателя **bash-ru.dat** и
```bash
    # make install
```
для установки файла фортунок в систему. Необходимы права суперпользователя!

После установки можно вызывать **fortune bash-ru**, прописывать эту команду в алиасы, смеяться (по желанию).


[1]: http://bash.im/ "Старый добрый башорг"
[2]: https://github.com/aruseni "Профиль автора парсера на Github"
[3]: https://github.com/aruseni/bash.im-parser "Код исходного парсера"
[4]: /files/fortune-bash-ru.tar.gz "Парсер фортунок с bash.im"
