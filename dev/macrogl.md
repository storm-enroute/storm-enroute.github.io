---
layout: devdefault
title: MacroGL
permalink: /dev/macrogl/index.html
---


<table><tr>

<td><img src="/resources/images/macrogl-96.png"/></td>

<td><table class="summary">
<tr>
  <td>Home Page</td>
  <td><a href="/macrogl/">MacroGL Home Page</a></td>
</tr>
<tr>
  <td>Source Code</td>
  <td><a href="https://github.com/storm-enroute/macrogl">https://github.com/storm-enroute/macrogl</a></td>
</tr>
<tr>
  <td>Build Status</td>
  <td><a href="https://ci.storm-enroute.com:8080/job/public-macrogl/"><img src="https://ci.storm-enroute.com:8080/buildStatus/icon?job=public-macrogl"/></a></td>
</tr>
<tr>
  <td>Last PR Status</td>
  <td><a href="https://travis-ci.org/storm-enroute/macrogl"><img src="https://travis-ci.org/storm-enroute/macrogl.svg?branch=master"></a></td>
</tr>
<tr>
  <td>Latest Stable Release</td>
  <td><code>"com.storm-enroute" % "macrogl_2.10" % "0.2"</code></td>
</tr>
<tr>
  <td>Snapshot Release</td>
  <td><code>"com.storm-enroute" % "macrogl_2.10" % "0.3-SNAPSHOT"</code></td>
</tr>
</table></td>

</tr></table>


MacroGL is a powerful OpenGL wrapper for Scala that allows building graphical applications using OpenGL
by providing structured programming constructs and higher abstractions for memory buffers, textures and shader programs.
It relies on Scala Macros to inline code heavily and avoid object allocation --
this is particularly important for GUI applications where GC-related glitches are harmful to user experience.
MacroGL uses [Lightweight Java Gaming Library](http://lwjgl.org/) as its default backend,
but is designed to have alternative backends for different platforms --
a ScalaJS backend is under development and an Android backend is planned.



