---
layout: projmainpage
projectname: MacroGL
projectpath: macrogl
logoname: macrogl-mini-logo.png
title: Download
permalink: /macrogl/download/index.html
logostyle: "color: #5f5f5f;"
---


Snapshot released regularly on Sonatype:

    resolvers ++= Seq(
      "Sonatype OSS Snapshots" at
        "https://oss.sonatype.org/content/repositories/snapshots",
      "Sonatype OSS Releases" at
        "https://oss.sonatype.org/content/repositories/releases"
    )
    libraryDependencies ++= Seq(
      "com.storm-enroute" %% "macrogl" % "0.4-SNAPSHOT")
