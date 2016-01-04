---
layout: projmainpage
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Scala Coroutines
permalink: /coroutines/index.html
logostyle: "color: #5f5f5f;"
---


<img alt="Scala Coroutines" src="/resources/images/coroutines-512-xmas.png"
  height="256px"/>

Scala Coroutines is a library-level extension for the Scala programming language
that introduces first-class coroutines.

*Coroutines* are a language abstraction that generalizes subroutines
(i.e. procedures, methods or functions).
Unlike a subroutine, which is invoked once and executes until it completed,
a coroutine can pause execution
and yield control back to the caller, or another coroutine.
The caller can then resume the coroutine when appropriate.
Coroutines have a number of use cases, including but not limited to:

- data structure iterators
- event-driven code without the inversion of control
- cooperative multitasking
- concurrency frameworks such as actors, async-await and dataflow networks
- expressing asynchrony, and better composition of asynchronous systems
- capturing continuations
- expressing backtracking algorithms
- AI agents such as behavior trees

To learn how to use coroutines, please see the Scala Coroutines Guide
in the [documentation section](/coroutines/learn).


CI service         | Status | Description
-------------------|--------|------------
Travis             | [![Build Status](https://travis-ci.org/storm-enroute/coroutines.png?branch=master)](https://travis-ci.org/storm-enroute/coroutines) | Testing only
Drone              | [![Build Status](http://ci.storm-enroute.com:443/api/badges/storm-enroute/coroutines/status.svg)](http://ci.storm-enroute.com:443/storm-enroute/coroutines) | Testing, docs, and snapshot publishing
Maven              | [![Maven Artifact](https://img.shields.io/maven-central/v/com.storm-enroute/coroutines_2.11.svg)](http://mvnrepository.com/artifact/com.storm-enroute/coroutines_2.11) | Coroutines artifact on Maven
