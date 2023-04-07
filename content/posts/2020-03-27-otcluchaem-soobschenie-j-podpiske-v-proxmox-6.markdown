---
published: true
layout: post
title: Отключаем надоедливое сообщение о подписке в  Proxmox VE 6.2 и выше
date: 2020-03-27 09:41:23 +0500
updated: true
keywords: [linux,proxmox]
tags: [linux, proxmox]
keywords: [linux, proxmox]
description: Удаление назойливого сообщения о подписке в ProxmoxVE 6.2 и выше одной командой.
---

```bash
sed -i.backup -z "s/res === null || res === undefined || \!res || res\n\t\t\t.data.status.toLowerCase() \!== 'active'/false/g" \
/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js \
&& systemctl restart pveproxy.service
```

Источник: [John's Computer Services][1]

[1]: https://johnscs.com/remove-proxmox51-subscription-notice/ "Ссылка на статью"
