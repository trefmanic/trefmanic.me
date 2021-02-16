---
published: true
layout: post
title: Отключаем надоедливое сообщение о подписке в  Proxmox VE 6
date: 2020-03-27 09:41:23 +0500
categories: [справочная] 
tags: [linux, proxmox]
description: Удаление назойливого сообщения о подписке в ProxmoxVE 6/5.1 одной командой.
---

```bash
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{\/\/\1/g" \
/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js \
&& systemctl restart pveproxy.service
```

Источник: [John's Computer Services][1]

[1]: https://johnscs.com/remove-proxmox51-subscription-notice/ "Ссылка на статью"
