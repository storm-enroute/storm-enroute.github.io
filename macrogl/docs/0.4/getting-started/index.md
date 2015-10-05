---
layout: projdefault
projectname: MacroGL
projectpath: macrogl
logoname: macrogl-mini-logo.png
title: Documentation
permalink: /macrogl/docs/0.4/getting-started/index.html
logostyle: "color: #5f5f5f;"
---


Welcome to the MacroGL Getting Started guide!


## Installation

The idea behind MacroGL is to provide a seamless OpenGL frontend,
so that graphics code that runs on the JVM can be reused directly
when compiling ScalaJS programs.
This means you write your graphics code only once,
but are then able to reuse it on multiple platforms, which is great!
In this guide,
we will mostly focus on the LWJGL MacroGL backend,
used by Scala running on the JVM.

To depend on MacroGL,
please add the following dependency to SBT:

    resolvers ++= Seq(
      "Sonatype OSS Snapshots" at
        "https://oss.sonatype.org/content/repositories/snapshots",
      "Sonatype OSS Releases" at
        "https://oss.sonatype.org/content/repositories/releases"
    )
    libraryDependencies ++= Seq(
      "com.storm-enroute" %% "macrogl" % "0.4-SNAPSHOT")

Later parts of the guide will show how to use the WebGL backend for ScalaJS --
when we get there, we will show how to use the alternative backend.


## Minimal example

In this paragraph,
we take a look at a minimal example code needed to run a MacroGL program.
First of all, we need to add the following imports,
which ensure that we have basic LWJGL and MacroGL functionality available:

    import org.lwjgl.opengl._
    import org.macrogl._

We start the program by creating a rendering context and set its attributes.
This is done with following snippet of code:

    val contextAttributes = new ContextAttribs(major, minor)

where `major` and `minor` are respective OpenGL versions.
These values drive which functionality is available to the MacroGL program.
For example, if we want to use OpenGL 3.2 with core profile and forward compatibility,
we can use attributes like these:

    val contextAttributes = new ContextAttribs(3, 2)
      .withForwardCompatible(true).withProfileCore(true)

Next, we should create a window with the specified properties:

    Display.setDisplayMode(new DisplayMode(800, 600))
    Display.create(new PixelFormat, contextAttributes)

The code above will create a window 800px wide and 600px high.
Now we can use OpenGL until we invoke the `Display.destroy` method.
Typical MacroGL program repetitively runs the body of the main program loop,
and calls the `Display.update` method:

    // Iterate until user presses 'X' in the window corner.
    while (!Display.isCloseRequested()) {
      // Do your OpenGL stuff here.
      // E.g. swap buffers and poll events.
      Display.update()
    }

Once the main program loop ends,
make sure you call `Display.destroy`:

    Display.destroy()

At that point, the display context gets destroyed,
and the MacroGL program can end.
The complete program is shown here:

<pre class="prettyprint linenums" id="examplebox-1"></pre>
<script>
  setContent(
    "examplebox-1",
    "https://api.github.com/repos/storm-enroute/macrogl/contents/src/test/scala/org/macrogl/examples/EmptyExample.scala",
    null,
    "raw");
</script>

You can find this example in the MacroGL source code repository
[here](https://github.com/storm-enroute/macrogl/blob/master/src/backend-examples/common/scala/org/macrogl/examples/backend/common/EmptyExample.scala).
The example can be run with the following command.

This example was minimal, but it was not very interesting.
In the next part, we examine a more exciting MacroGL program.
