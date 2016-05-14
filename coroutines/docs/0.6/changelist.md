---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Changelist
permalink: /coroutines/docs/0.6/changelist/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
coversion: 0.6
---


# Version {{ page.coversion }} changes

- Added the `pull` combinator that guarantees that `value` is always defined. Usage:
  `while (c.pull) println(c.value)` (no `c.hasValue` check required)
- Fixed bug with returning invoking concrete-return-type coroutines from within a
  generic coroutine.
- Fixed a bug where method invocations without qualifiers were getting dropped.
- Fixed a lot of hygiene problems in macros.
- Performance work and performance evaluations.
