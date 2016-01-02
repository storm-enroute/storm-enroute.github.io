---
layout: projdefaultnotitle
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Lifecycle of a Coroutine
permalink: /coroutines/docs/0.3/lifecycle/index.html
logostyle: "color: #5f5f5f;"
---


In functional programming,
pure functions are functions whose return values are determined
only by its input values.
It is sometimes said that such function invocation cannot have any state.
However, this is not entirely true.
Even a pure function invocation needs to have at least some *execution state* --
the current state of evaluating the expression that defines that function.
Due to the fact that this state is *hidden* from the caller and cannot be observed,
a pure function invocation can be considered *stateless* in functional languages.

Similar to a subroutine invocation,
a coroutine invocation (i.e. a frame) also has its respective execution state.
Again, this execution state exists
even if the computation inside the coroutine is *pure*
(does not have side-effects).
However, unlike the state of a subroutine invocation,
coroutine execution state can be observed.
This observable mutable state is inherent to all coroutines,
and is the consequence of having the `yieldval` statement.
In this section, we will see different ways of interacting with this state.


## Coroutine instance state

After a coroutine instance is created with the `call` keyword,
it does not immediately start executing.
Instead, a newly created instance is in a suspended state,
and must be resumed by calling the `resume` method on it.
Consider the `katamari` coroutine,
which yields the words of the theme song from the popular video game:

    val katamari: Int ~~> (String, Int) = coroutine { (n: Int) =>
      var i = 1
      yieldval("naaaaaa")
      while (i < n) {
        yieldval("na")
        i += 1
      }
      yieldval("Katamari Damacy!")
      i + 2
    }

With our newly acquired knowledge of
[coroutine data types from the previous section](../datatypes/),
we know that this coroutine's type must be `Int ~~> (String, Int)`,
since it has a parameter `n` of type `Int` -- the number of `"na"` words to yield,
yields `String` values and
returns an integer denoting how many words were yielded in total.

Real Katamari connaisseurs will know which argument to pass when calling this coroutine!
Below, we create a new `katamari` instance called `c`:

    val c = call(katamari(9))

The complete example is shown below.

<div>
<pre id="examplebox-1">
</pre>
</div>
<script>
  setContent(
    "examplebox-1",
    "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/scala/examples/Lifecycle.scala",
    null,
    "raw",
    "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/scala/examples/Lifecycle.scala");
</script>


## Exception handling



