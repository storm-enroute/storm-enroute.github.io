---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Changelist
permalink: /coroutines/docs/0.7/changelist/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
coversion: 0.7
---


# Version {{ page.coversion }} changes

- `Coroutine.Frame` renamed to `Coroutine.Instance`, because it's technically not an
  invocation frame. The short name `<~>` stayed the same.
