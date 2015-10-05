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

[Detailed guide](/macrogl/docs/0.4/getting-started/index.html)
on using MacroGL.
This is the ideal starting point if this is your first encounter with MacroGL,
or OpenGL in general.


### Misc Examples

Here is a list of various short self-contained MacroGL programs,
focusing on different MacroGL features:

- [Basic triangle example](/macrogl/docs/0.4/triangle) -- shows how to render a simple
  triangle using MacroGL and OpenGL 3.3 functionality.


### Build Outputs

MacroGL build pipeline produces example programs, used to validate code changes.
The list of all builds can be found in the builds directory
[on GitHub](https://github.com/storm-enroute/builds/tree/gh-pages/macrogl).

#### Build links

<ul id="build-list">
</ul>
<script>
function getKeys(obj) {
    var r = []
    for (var k in obj) {
        if (!obj.hasOwnProperty(k)) 
            continue
        r.push(k)
    }
    return r
}
$.get(
  "https://api.github.com/repos/storm-enroute/builds/contents/macrogl?ref=gh-pages",
  function(data) {
    var buildList = $("#build-list");
    var buildDirs = data;
    for (var i = 0; i < buildDirs.length; i++) {
      var dir = buildDirs[i]["name"];
      buildList.append("<li><a href='http://storm-enroute.com/builds/macrogl/" +
        dir + "/index-fastopt.html'></a></li>");
    }
  }
)
</script>
