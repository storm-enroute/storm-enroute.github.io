---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Setup and Dependencies
permalink: /coroutines/docs/0.4/setup/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
num: 1
outof: 20
coversion: 0.4
---


Scala Coroutines are released since Scala 2.11.
To start using them,
you will need to add the official JAR to your project dependencies.
Here we assume that you are using SBT,
otherwise you can follow the guidelines on Maven.

[![Maven Artifact](https://img.shields.io/maven-central/v/com.storm-enroute/coroutines_2.11.svg)](http://mvnrepository.com/artifact/com.storm-enroute/coroutines_2.11)


### SBT

Stable versions are released on Sonatype and Maven.
You can add Scala Coroutines by adding the following to your project definition:

    libraryDependencies ++= Seq(
      "com.storm-enroute" %% "coroutines" % "0.4")

Snapshot versions are released regularly on Sonatype:

    resolvers ++= Seq(
      "Sonatype OSS Snapshots" at
        "https://oss.sonatype.org/content/repositories/snapshots",
      "Sonatype OSS Releases" at
        "https://oss.sonatype.org/content/repositories/releases"
    )
    libraryDependencies ++= Seq(
      "com.storm-enroute" %% "coroutines" % "0.5-SNAPSHOT")

To use coroutines in the code, import the `org.coroutines` package,
and you're all set:

    import org.coroutines._

In case you have the dependencies configured,
you can proceed immediately to the [next section](../101/).
