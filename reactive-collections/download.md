---
layout: projdefault
projectname: Reactive Collections
projectpath: reactive-collections
logoname: reactress-mini-logo-flat.png
title: Download
permalink: /reactive-collections/download/index.html
---




Reactive Collections are hosted on Sonatype OSSRH.
You can download the JAR directly,
or add Reactive Collections to your SBT file as a managed dependency.


## Direct

### Scala 2.10

- latest stable version: [{{ site.reactive_collections_version }}](http://search.maven.org/remotecontent?filepath=com/storm-enroute/reactive-collections_2.10/{{ site.reactive_collections_version }}/reactive-collections_2.10-{{ site.reactive_collections_version }}.jar)
- snapshot version: [{{ site.reactive_collections_snapshot_version }}](https://oss.sonatype.org/service/local/artifact/maven/redirect?r=snapshots&g=com.storm-enroute&a=reactive-collections_2.10&v={{ site.reactive_collections_snapshot_version }}&e=jar)


## SBT

To add Reactive Collections to you project,
add the following lines to your SBT build definition file (e.g. `build.sbt`):

    resolvers ++= Seq(
      "Sonatype OSS Snapshots" at
        "https://oss.sonatype.org/content/repositories/snapshots",
      "Sonatype OSS Releases" at
        "https://oss.sonatype.org/content/repositories/releases"
    )

    libraryDependencies ++= Seq(
      "com.storm-enroute" %% "reactive-collections" % "{{ site.reactive_collections_version }}")

If you want to live on the cutting edge,
you can use the nightly snapshot by adding the following line instead:

    libraryDependencies ++= Seq(
      "com.storm-enroute" %% "reactive-collections" % "{{ site.reactive_collections_snapshot_version }}")

