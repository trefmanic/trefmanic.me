---
published: true
layout: post
title: Расшифровка сохраненных паролей в rclone
date: 2021-06-02 11:47:00 +0500
updated: false
tags: [rclone,crypt]
keywords: [rclone,crypt]
description: При сохранении паролей в модуле crypt для rclone они обфусцируются. В данной заметке я расскажу, как из сохранённого пароля (или соли) получить простой текст.
---

### Необходимые данные ###

Конфигурация удалённых точек rclone хранится в **~/.config/rclone/rclone.conf**.
Нам нужны следующие параметры:
```bash
    password = qjWNcYpaERP4j9PfEY73qLeb7paRFj3EmRRKxYCWKoEX7yUzigChaCiMdVjdWdwg
    password2 = 9pdJd9RJpb7FvnhxYEkedqRodF9FVcJ3mEoLMpVLiVMLvvmu
```
Первый параметр это ваш пароль, второй — соль (если вы её указывали).

### Деобфускация ###

Для перевода данных в простой текст используйте следующий код на GO:

```go
package main

import (
    "crypto/aes"
    "crypto/cipher"
    "crypto/rand"
    "encoding/base64"
    "errors"
    "fmt"
    "log"
)

// crypt internals
var (
    cryptKey = []byte{
        0x9c, 0x93, 0x5b, 0x48, 0x73, 0x0a, 0x55, 0x4d,
        0x6b, 0xfd, 0x7c, 0x63, 0xc8, 0x86, 0xa9, 0x2b,
        0xd3, 0x90, 0x19, 0x8e, 0xb8, 0x12, 0x8a, 0xfb,
        0xf4, 0xde, 0x16, 0x2b, 0x8b, 0x95, 0xf6, 0x38,
    }
    cryptBlock cipher.Block
    cryptRand  = rand.Reader
)

// crypt transforms in to out using iv under AES-CTR.
//
// in and out may be the same buffer.
//
// Note encryption and decryption are the same operation
func crypt(out, in, iv []byte) error {
    if cryptBlock == nil {
        var err error
        cryptBlock, err = aes.NewCipher(cryptKey)
        if err != nil {
            return err
        }
    }
    stream := cipher.NewCTR(cryptBlock, iv)
    stream.XORKeyStream(out, in)
    return nil
}

// Reveal an obscured value
func Reveal(x string) (string, error) {
    ciphertext, err := base64.RawURLEncoding.DecodeString(x)
    if err != nil {
        return "", fmt.Errorf("base64 decode failed when revealing password - is it obscured? %w", err)
    }
    if len(ciphertext) < aes.BlockSize {
        return "", errors.New("input too short when revealing password - is it obscured?")
    }
    buf := ciphertext[aes.BlockSize:]
    iv := ciphertext[:aes.BlockSize]
    if err := crypt(buf, buf, iv); err != nil {
        return "", fmt.Errorf("decrypt failed when revealing password - is it obscured? %w", err)
    }
    return string(buf), nil
}

// MustReveal reveals an obscured value, exiting with a fatal error if it failed
func MustReveal(x string) string {
    out, err := Reveal(x)
    if err != nil {
        log.Fatalf("Reveal failed: %v", err)
    }
    return out
}

func main() {
    fmt.Println(MustReveal("MY-SUPER-SECRET-PASSWORD-HERE"))
}
```

Замените строку **MY-SUPER-SECRET-PASSWORD-HERE** на ваш обфусцированный пароль из файла конфигурации, результатом выполнения будет пароль в открытом виде.

Запустить сценарий на GO можно онлайн, на сайте [play.golang.org][2].

Источник: [запись][3] пользователя [fiatjaf][4] на форуме rclone. 

[1]: https://rclone.org/ "Приложение для работы с облачными хранилищами rclone"
[2]: https://play.golang.org "Онлайн-интрепретатор GO"
[3]: https://forum.rclone.org/t/how-to-retrieve-a-crypt-password-from-a-config-file/20051 "Запись пользователя fiatjaf на форуме rclone"
[4]: https://forum.rclone.org/u/fiatjaf "Профиль пользователя fiatjaf на форуме rclone"
