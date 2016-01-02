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
Below, we create a new `katamari` instance called `c`, and then immediately resume it
in order to get our first `"na"`:

    val c = call(katamari(9))
    c.resume

The method `resume` executes the coroutine until either reaching a `yieldval` statement,
or the end of the coroutine.
It returns a `Boolean` value denoting which of the two events happened --
if `resume` returns `true`, then a `yieldval` statement suspended execution.
We can additionally verify that a `yieldval` statement produced a value
by calling the `hasValue` method.
Unlike `resume`, calling the `hasValue` method does not change execution state.
If `hasValue` returns `true`, we know that we can inspect the last yielded value
by calling the `value` method.
All this is shown in the following:

    assert(c.resume) // moves the coroutine to the next yieldval
    assert(c.hasValue) // asserts that the coroutine has a value
    assert(c.value == "naaaa") // retrieves the preceding yielded value

Additionally, we can call the `getValue` method that returns
This method returns an object of type `Option[Y]`, where `Y` is the yield type.

    for (i <- 1 until 9) {
      assert(c.resume)
      assert(c.getValue == Some("na"))
    }

Another way to retrieve a value after calling `resume` is with the `tryValue` method.
This method returns a `Success` if the value is available,
and a `Failure` if the execution ended or resulted in an exception (more on that soon).

    assert(c.resume)
    assert(c.tryValue == Success("Katamari Damacy!"))

The last `resume` call will return `false`,
because execution reaches the end of the coroutine.
At this point, calling `getValue` returns `None`,
and calling `value` throws an exception.
This makes sense -- the coroutine did not yield any values this time.
We can instead call the `result` method to get the return value.

    assert(!c.resume)
    assert(c.getValue == None)
    assert(c.result == 11)

At this point we can double check that the coroutine ended
with the `isCompleted` and `isLive` methods:

    assert(c.isCompleted)
    assert(!c.isLive)

From all these different ways to interact with a coroutine,
you might be overwhelmed, but don't worry!
The textbook method of extracting values from a coroutine is
simple and super-convenient!
To show this,
we define the method `drain`,
which takes a coroutine that emits strings,
and, as long as `resume` returns `true`,
adds strings to a buffer, and then concatenates those strings together.
We can use the `drain` method to more concisely test the correctness of
the `katamari` coroutine.

  def drain(f: String <~> Int): String = {
    val buffer = mutable.Buffer[String]()
    while (f.resume) buffer += f.value
    buffer.mkString(" ")
  }

  val theme = "naaaa na na na na na na na na Katamari Damacy!"
  assert(drain(call(katamari(9))) == theme)

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



