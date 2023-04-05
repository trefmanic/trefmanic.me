---
published: false
layout: post
title: Проброс портов к серверу 1С через SSH
date: 2017-11-02 15:31:32 +0500
categories: [справочная] 
tags: [1c,ssh,linux]
description: Как быстро подключиться к серверу 1С через SSH-туннель
---

Настройка SSH для быстрого доступа к серверу 1С

### Задача ###

Предположим, у клиента есть сервер 1С с БД PostgreSQL. При наличии во внутренней сети этого клиента машины с Linux можно работать в базах данных 1С через SSH-туннель. Для этого создадим в домашнем каталоге [файл конфигурации SSH][1]:
```bash    
    mkdir ~/.ssh
    touch ~/.ssh/config
```
Внесём в него следующее:
```bash
    Host ssh-to-1c
        # Адрес сервера SSH
        HostName 172.17.2.129
        # Порт SSH, по умолчанию 22
        Port 22
        # Пользователь SSH-сервера
        User trefmanic
        
        # Проброс портов к серверу 1С
        # 192.168.1.251 - адрес сервера 1С
        # Если сервер 1С размещён на том же хосте,
        # к которому производится подключение по SSH,
        # то этот адрес нужно заменить на 127.0.0.1
        #----------------------------
        
        # Если сервер PostgreSQL размещён на том же хосте, что и 1С
        LocalForward 5432 192.168.1.251:5432
        # Если PostgreSQL на другой машине:
        # LocalForward 5432 <адрес Postgresql>:5432
 
        # Блок портов сервера 1С
        # Для агента сервера (не обязательно, если в кластере 1 сервер)
        LocalForward 1540 127.0.0.1:1540
        # Для менеджера кластера
        LocalForward 1541 127.0.0.1:1541
        # Для рабочих процессов (диапазон 1560-1591)
        # на практике, редко требуется проброс бОльшего количества
        LocalForward 1560 127.0.0.1:1560
        LocalForward 1561 127.0.0.1:1561
        LocalForward 1562 127.0.0.1:1562
```       

Данные о портах по умолчанию ([с сайта 1С-ИТС][2]):

> По умолчанию при установке кластера серверов используются следующие номера сетевых портов:
>
> ● Агент сервера – порт 1540;
>
> ● Менеджер кластера – порт 1541.
>
> ● Для рабочего процесса номер порта выделяется динамически из указанного диапазона, по умолчанию используется диапазон сетевых портов 1560:1591.

[1]:https://linux.die.net/man/5/ssh_config "Руководство по конфигурационному файлу SSH"
[2]:https://its.1c.ru/db/v836doc#bookmark:cs:TI000000023 "Документ на сайте 1С-ИТС (для доступа нужна подписка)"