---
layout: projdefault
projectname: Reactress
projectpath: reactress
logoname: reactress-mini-logo-flat.png
title: Download
permalink: /reactress/download/index.html
---




Reactress is hosted on Sonatype OSSRH.
You can download the JAR directly,
or add Reactress to your SBT file as a managed dependency.


## Direct

### Scala 2.10

- latest stable version: [{{ site.reactress_version }}](http://search.maven.org/remotecontent?filepath=com/storm-enroute/reactress_2.10/{{ site.reactress_version }}/reactress_2.10-{{ site.reactress_version }}.jar)
- snapshot version: [{{ site.reactress_snapshot_version }}](https://oss.sonatype.org/service/local/artifact/maven/redirect?r=snapshots&g=com.storm-enroute&a=reactress_2.10&v={{ site.reactress_snapshot_version }}&e=jar)


## SBT

To add Reactress to you project,
add the following lines to your SBT build definition file (e.g. `build.sbt`):

    resolvers ++= Seq(
      "Sonatype OSS Snapshots" at
        "https://oss.sonatype.org/content/repositories/snapshots",
      "Sonatype OSS Releases" at
        "https://oss.sonatype.org/content/repositories/releases"
    )

    libraryDependencies ++= Seq(
      "com.storm-enroute" %% "reactress" % "{{ site.reactress_version }}")

If you want to live on the cutting edge,
you can use the nightly snapshot by adding the following line instead:

    libraryDependencies ++= Seq(
      "com.storm-enroute" %% "reactress" % "{{ site.reactress_snapshot_version }}")

