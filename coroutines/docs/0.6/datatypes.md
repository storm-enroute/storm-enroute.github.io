---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Coroutine Data Types
permalink: /coroutines/docs/0.6/datatypes/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
num: 3
outof: 20
coversion: 0.6
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
Its single parameter has the type `Int`.
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
Its yield type is the least upper bound of no types.
Can you guess which type this is?

    val id = coroutine { (x: Int) => x }

The least upper bound of an empty list of types is the *bottom type*.
In Scala, the bottom type is called `Nothing`.
So, the type of the identity coroutine is `Coroutine._1[Int, Nothing, Int]`.


## Syntactic sugar types

Names such as `Coroutine._0` and `Coroutine._1` are inconvenient and clumsy.
Scala functions have a much nicer syntax that overcomes the `FunctionN` boilerplate --
for example, `Function1[List[Int], Int]` can be written as `List[Int] => Int`.

In this section,
we will see similar syntactic sugar used to refer to Scala coroutine definitions.
Remember, unlike a function type, a coroutine type must encode
both the types of the input parameters,
the yield type and the return type.
Nevertheless, we would like to retain the familiar arrow-like syntax.

The syntactic sugar translation rules are summarized in the following table.
Type `Y` is the yield type,
type `R` is the return type,
and types `T1`, `T2`, and so on are input parameter types.
Note that the arity-0 coroutine is a kind of a special case,
and requires a triple-squiggly arrow syntax with square brackets.
The arity-1 coroutine is also a bit special, and requires double-squiggly arrows.
The arity-2 and above coroutines use a single-squiggly arrow,
and specify input parameters in the parameter list on the left,
with yield and return types specified on the right.

Full type                            | Syntactic sugar type
-------------------------------------|--------------------------
`Coroutine._0[Y, R]`                 | `~~~>[Y, R]`
`Coroutine._1[T1, Y, R]`             | `T1 ~~> (Y, R)`
`Coroutine._2[T1, T2, Y, R]`         | `(T1, T2) ~> (Y, R)`
`Coroutine._3[T1, T2, T3, Y, R]`     | `(T1, T2, T3) ~> (Y, R)`

Consider the following coroutine:

    val rube = coroutine { (x: Int) =>
      yieldval(x.toString)
      List(x)
    }

It has the type `Coroutine._1[Int, String, List[Int]]`,
or with a bit of syntactic sugar, just:

    Int ~~> (String, List[Int])

To see an example of how the syntactic sugar types are used,
consider the following program.
We want to implement a coroutine that yields a range of numbers,
but implement it in two ways -- once using a while loop,
and once using a do-while loop.
The two coroutines `whileRange` and `doWhileRange`
take an integer parameter, and yield the values of the range.
The main program calls the generic testing method `assertEqualsRange`,
which takes a generic implementation of a coroutine
and checks that it is equal to the corresponding range.
Since the two coroutines only yield values, and do not return values to the caller,
their type is `Int ~~> (Int, Unit)`.

<div>
<pre id="examplebox-1">
</pre>
</div>
<script>
  setContent(
    "examplebox-1",
    "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/org/examples/Datatypes.scala",
    null,
    "raw",
    "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/org/examples/Datatypes.scala");
</script>


## Coroutine instance types

The type of a coroutine instance has a very simple set of types --
since parameters were already passed to a coroutine instance,
the instance does not need to encode their types.
A coroutine instance object only needs to encode
the yield type `Y` and the return type `R`.
It is represented with the type `Coroutine.Frame[Y, R]`.
Consider the following coroutine `twice`:

    val twice = coroutine { (x: Int) => 2 * x }

The coroutine instance type is `Coroutine.Frame[Nothing, Int]`:

    val c: Coroutine.Frame[Nothing, Int] = call(twice(7))

This is lengthy, so coroutine instance (i.e. *frame*) types
also have a syntactic sugar form:

    val c: Nothing <~> Int = call(twice(7))

Here, the `<` character in `<~>` symbolizes the fact that values of the yield type
are sent back to the caller
(who originally passed some arguments that were on the left of the arrow),
while the ordinary return type is written on the right hand side.


### Summary

We have learned about basic data types revolving around coroutines,
and about syntactic sugar for expressing them more nicely.
The syntactic sugar looks fancy, but it is somewhat of a hack.
In a vast majority of cases,
the performance of a coroutine captured in its sugared form
is equal to the non-sugared form.
Coroutines use a combination of Scala specialization
and some extra logic to ensure that the yield type
is always specialized, and thus avoid boxing.
The only exception are some pathological cases when using
coroutine arguments that are primitive values
and new coroutine frames are created extremely frequently,
or when you're using coroutines with a high arity
(if you want to know the details, see the
[API](http://storm-enroute.com/apidocs/coroutines/0.6/api/)
to figure out which coroutine arities are specialized and how).
If you are super-sensitive about performance
and your coroutines are invoked with primitive values,
use the syntactic sugar form only if you really need to
abstract over different coroutine implementations,
and rely on the type inferencer whenever you can.
In most cases, however, you don't need to worry.

The most important takeaways are:

- Where possible, declare a coroutine without the type annotation.
- Otherwise, if you need to abstract over a coroutine implementation,
  use one of the squiggly arrow types from the above table.
- Use the left-right squiggly arrow syntax (`<~>`) to refer to
  already started coroutine instances.

In the next section, we will study the [lifecycle of a coroutine](../lifecycle/)
more closely.
