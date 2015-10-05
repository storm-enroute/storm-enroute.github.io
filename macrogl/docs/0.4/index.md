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
val contextAttributes = new ContextAttribs(major, minor)
```

In example if we want to use OpenGL 3.2 with core profile and forward compatibility, we can use attributes like these:

```
val contextAttributes = new ContextAttribs(3, 2).withForwardCompatible(true).withProfileCore(true)
```

After that, we can create window with specified properties:

```
Display.setDisplayMode(new DisplayMode(800, 600))
Display.create(new PixelFormat, contextAttributes)
```

With code provided above, a window of size 800px wide and 600px high should show up. Now we can use OpenGL till invocation of Display.destroy method. Typical application would probably look like that:

```
while(!Display.isCloseRequested()){ //iterate until user presses 'X' in the window corner
    // do your gl stuff here
    Display.update() //swap buffers and poll events
} 
```

And that's all! Just remember to call Display.destroy after exitting loop. 


### Misc Examples

- [Basic triangle example](/macrogl/docs/0.4/triangle) -- shows how to render a simple
  triangle using MacroGL and OpenGL 3.3 functionality.


### Build Outputs

MacroGL build pipeline produces example programs, used to validate code changes.
The list of all builds can be found here
[here](https://github.com/storm-enroute/builds/tree/gh-pages/macrogl).
