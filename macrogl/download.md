---
layout: projmainpage
projectname: MacroGL
projectpath: macrogl
logoname: macrogl-mini-logo.png
title: Download
permalink: /macrogl/download/index.html
logostyle: "color: #5f5f5f;"
---


## SBT

We recommend that you use SBT for your projects.
In this case, you can include MacroGL as a dependency as follows:

    libraryDependencies ++= Seq(
      "com.storm-enroute" % "macrogl_2.10" % "0.3")

The snapshot is released regularly on Sonatype:

    resolvers ++= Seq(
      "Sonatype OSS Snapshots" at
        "https://oss.sonatype.org/content/repositories/snapshots",
      "Sonatype OSS Releases" at
        "https://oss.sonatype.org/content/repositories/releases"
    )
    libraryDependencies ++= Seq(
      "com.storm-enroute" %% "macrogl" % "0.4-SNAPSHOT")
