---
layout: projdefault
projectname: MacroGL
projectpath: macrogl
logoname: macrogl-mini-logo.png
title: Documentation
permalink: /macrogl/docs/0.4/index.html
logostyle: "color: #5f5f5f;"
---



### Getting Started Guide

First, we need to create attributes of our rendering context. It can be done with following code:

```
val contextAttributes = new ContextAttribs(3, 2)
      .withForwardCompatible(true).withProfileCore(true)
```


### Misc Examples

- [Basic triangle example](/macrogl/docs/0.4/triangle) -- shows how to render a simple
  triangle using MacroGL and OpenGL 3.3 functionality.


### Build Outputs

MacroGL build pipeline produces example programs, used to validate code changes.
The list of all builds can be found here
[here](https://github.com/storm-enroute/builds/tree/gh-pages/macrogl).
