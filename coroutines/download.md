---
layout: projmainpage
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-128-xmas.png
title: Download
permalink: /coroutines/download/index.html
logostyle: "color: #5f5f5f;"
---


## SBT

We recommend that you use SBT for your projects.
Assuming you are using Scala 2.11,
you can include Scala Coroutines as a dependency as follows:

    libraryDependencies ++= Seq(
      "com.storm-enroute" % "coroutines_2.11" % "0.3")

The snapshot is released regularly on Sonatype:

    resolvers ++= Seq(
      "Sonatype OSS Snapshots" at
        "https://oss.sonatype.org/content/repositories/snapshots",
      "Sonatype OSS Releases" at
        "https://oss.sonatype.org/content/repositories/releases"
    )
    libraryDependencies ++= Seq(
      "com.storm-enroute" %% "coroutines" % "0.4-SNAPSHOT")
