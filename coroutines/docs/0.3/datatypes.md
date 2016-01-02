---
layout: projdefaultnotitle
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Coroutine Data Types
permalink: /coroutines/docs/0.3/datatypes/index.html
logostyle: "color: #5f5f5f;"
---


Scala Coroutines are *first-class*.
That means that a coroutine definition is a value that can be passed to other
functions and coroutines as arguments, much like ordinary function objects can.
This property allows abstracting over implementations of a coroutine,
as the user of the coroutine does not need to know anything
about its concrete implementation.

In a statically typed language,
we need to give the values in our program
some types before we can start using them.
In this part of the guide,
we will learn about data types
that make first-class coroutines possible.


## Basic coroutine types

A `coroutine` declaration creates an object of type `Coroutine[T]`,
where `T` is the type of values that the coroutine yields.


## Syntactic sugar

TODO

We will consider a program that defines ...

<div>
<pre id="examplebox-1">
</pre>
</div>
<script>
  setContent(
    "examplebox-1",
    "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/scala/examples/Datatypes.scala",
    null,
    "raw",
    "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/scala/examples/Datatypes.scala");
</script>
