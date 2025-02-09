---
title: "Сброс пароля в базе данных 1С, работающей на PostgreSQL"
date: "2025-01-22T15:25:41+05:00"
updated: false
tags: ["postgresql", "1C", "linux"]
keywords: ["1C", ""]
description: "В статье рассказывается, как получить доступ к базе данных 1С, работающей на PostgreSQL, если утеряны пароли."
showFullContent: false
published: true
---

Иногда нужно получить доступ к базе данных 1С в тех случаях, когда утерян пароль. Если база данных
размещена на сервере PostgreSQL, к которому у вас есть доступ, или же есть дамп БД, сделать это просто. Можно даже восстановить предыдущих пользователей после завершения работы с базой данных.

> Перед внесением изменений в базу данных, убедитесь, что есть резервная копия.

Подключаемся к базе данных **testbase**, работающей на сервере **warp** от имени пользователя **postgres** через psql:

```bash
psql -h warp -U postgres testbase
```

Выполняем команды:

```sql
-- Переименуем таблицу с пользователями
ALTER TABLE v8users RENAME TO v8users_old;
-- Обновляем ссылки на файл с учётными записями
UPDATE Params SET FileName = 'users.usr_old' WHERE FileName = 'users.usr';
```

Теперь можно подключаться к базе данных как из клиента, так и из конфигуратора. Пользователь и пароль
запрашиваться не будут. 1С создаст новую пустую таблицу **v8users**. После завершения работы можно восстановить предыдущих пользователей. Для этого выполняем команды:


```sql
-- Удаляем созданную 1С таблицу
DROP TABLE v8users;
-- Восстанавливаем таблицу из бекапа
ALTER TABLE v8users_old RENAME TO v8users;
-- Восстанавливаем ссылки на файл
UPDATE Params SET FileName = 'users.usr' WHERE FileName = 'users.usr_old';
```

### Примечание ###

Внесение изменений в базы данных 1С, за исключением тех случаев, когда используются инструменты платформы, является нарушением [лицензионного соглашения 1С][2]. Данная статья носит исключительно информационный характер, и не является руководством к действию.


*На основе материала сайта [itbpr.ru][1]*.

[1]: https://itbpr.ru/kak-sbrosit-parol-1s-8-esli-baza-na-postgresql "Статья на сайте itbpr.ru"
[2]: https://1c.ru/texts/kp_license.htm "Лицензионное соглашение 1С"