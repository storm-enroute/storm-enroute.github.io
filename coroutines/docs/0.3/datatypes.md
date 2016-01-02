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


## Coroutine types

Consider the following coroutine declaration:

    val rube = coroutine { () =>
      yieldval("execution suspended!")
      Some("execution completed!")
    }

The `rube` coroutine suspends once and yields the string `"execution suspended!"`.
It the returns an optional value `Some("execution completed!")` to the caller.
A careful inspection reveals that these two values do not have the same type --
the `rube` coroutine *yields* a value of type `String`,
but it returns a coroutine of type `Some[String]`.

This is true for most coroutines -- unlike a lambda,
the coroutine may yield values that have a type different than the return type.
Any `coroutine` declaration creates an object of type `Coroutine[Y, R]`,
where `Y` is the type of values that the coroutine yields,
and `R` is the return type, which corresponds to the return type of a normal lambda.

<table class="docs-tip">
<td><img src="/resources/images/warning.png"/></td>
<td>
A coroutine makes a distinction between the type of values it <b>yields</b>
and the type of values it <b>returns</b>.
Every coroutine therefore has the type <code>Coroutine[Y, R]</code>.
</td>
</table>

The `rube` coroutine has the type `Coroutine[String, Some[String]]`.
More specifically, `rube` has the type `Coroutine._0[String, Some[String]]`.
The `_0` suffix denotes the *arity* of the coroutine --
the number of value parameters.
Since `rube` does not take any parameters (`() =>`), the arity is zero.
This notation is similar to the one used by Scala lambdas
(`Function0`, `Function1`, etc.).

The following coroutine takes an integer, and yields the string `"na"` that many times
before yielding `"batman!"`. Try to determine its type:

    val song = coroutine { (n: Int) =>
      var i = 0
      while (i < n) {
        yieldval("na")
        i += 1
      }
      yieldval("batman!")
    }

Hint: It has the suffix `_1` because its arity is 1.
Its only argument has the type `Int`.
It yields strings at every yield point, so the yield type is `String`.
It does not return any value to the main program, so its return type is `Unit`.
Therefore, the answer is `Coroutine._1[Int, String, Unit]`.

<table class="docs-tip">
<td><img src="/resources/images/warning.png"/></td>
<td>
The <b>yield type</b> of the coroutine is determined by taking the least upper bound
of the types of the expressions at all the yield points.
</td>
</table>

The identity coroutine seen earlier does not yield any values.
The yield type the least upper bound of no types.
Can you guess which type this is?

    val id = coroutine { (x: Int) => x }

The least upper bound of an empty list of types is the *bottom type*.
In Scala, the bottom type is called `Nothing`.
So, the type of the identity coroutine is `Coroutine._1[Int, Nothing, Int]`.


## Types for syntactic sugar

Names such as `Coroutine._0` and `Coroutine._1` are inconvenient and clumsy.
Scala functions have a much nicer syntax `FunctionN` boilerplate -- for example,
`Function1[List[Int], Int]` can be written as `List[Int] => Int`.

In this section,
we will see similar syntactic sugar used to refer to Scala coroutine definitions.
Remember, unlike a function type, a coroutine type must encode
both the types of the input parameters,
the yield type and the return type.
Nevertheless, we would like to retain the familiar arrow-like syntax.

TODO finish

Consider the following program.

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
