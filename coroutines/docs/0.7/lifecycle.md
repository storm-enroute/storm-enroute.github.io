---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Lifecycle of a Coroutine
permalink: /coroutines/docs/0.7/lifecycle/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
num: 4
outof: 20
coversion: 0.7
---


In functional programming,
pure functions are functions whose return values are determined
only by its input values.
It is sometimes said that such a function invocation does not have any state.
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
Most of the time, you just need to remember that if `resume` returns `true`,
you can retrieve the yielded value with `value`,
and otherwise can retrive the resulting value with `result`.

<table class="docs-tip">
<td><img src="/resources/images/warning.png"/></td>
<td>
If the coroutine yields control to the caller,
the last yielded value can be retrieved by calling <code>value</code>.
Otherwise, if the coroutine completes its execution,
the resulting value is retrieved by calling <code>result</code>.
</td>
</table>

The textbook method of extracting values from a coroutine is, in fact,
simple and super-convenient.
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
    "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/org/examples/Lifecycle.scala",
    null,
    "raw",
    "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/org/examples/Lifecycle.scala");
</script>


## Exception handling

Coroutines can also raise exceptions.
When an exception is raised inside the coroutine,
it gets propagated as far as possible along the call stack,
just like an ordinary exception would.
If the exception propagation reaches the bounds of the coroutine instance,
the exception is stored as part of the coroutine instance state,
and the instance completes without a resulting value.

To illustrate this, we consider the following definition
of the `kaboom` coroutine.

    case class TestException() extends Throwable

    val kaboom = coroutine { (x: Int) =>
      yieldval(x)
      try {
        sys.error("will be caught")
      } catch {
        case e: RuntimeException => yieldval("oops")
      }
      throw TestException()
    }

This coroutine starts by yielding its argument `x` back to the caller.
Then, the coroutine raises an exception in a `try` block,
which is successfully caught in the `catch` block.
The coroutine then yields the value `"oops"`.
Another exception of type `TestException` is then thrown,
which is this time uncaught and terminates the coroutine.
To verify that the `kaboom` coroutine executes as we expect,
we run the following snippet:

    val c = call(kaboom(5))
    assert(c.resume)
    assert(c.value == 5)
    assert(c.resume)
    assert(c.value == "oops")
    assert(!c.resume)
    assert(c.tryResult == Failure(TestException()))

Above, the final `tryResult` call does not return a `Success` value,
because the coroutine did not terminate normally.
Instead, `tryResult` returns a `Failure` value
that contains the uncaught exception.

<table class="docs-tip">
<td><img src="/resources/images/warning.png"/></td>
<td>
Every coroutine instance terminates by either producing a result,
or by raising an exception.
If the coroutine instance terminates with an exception,
the exception is not rethrown by the <code>resume</code> method,
but is raised when calling the <code>result</code> method.
The <code>tryResult</code> method can also be used to retrieve the exception.
</td>
</table>

The complete example with exceptions is shown below.

<div>
<pre id="examplebox-2">
</pre>
</div>
<script>
  setContent(
    "examplebox-2",
    "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/org/examples/Exceptions.scala",
    null,
    "raw",
    "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/org/examples/Exceptions.scala");
</script>


### Summary

Things to remember about the coroutine lifecycle
and the respective lifecycle-related operations
are the following:

- A coroutine instance is started in suspended state.
- A coroutine instance is resumed with its `resume` method.
- If `resume` returns `true`, then a value was yielded.
  You can check the last yielded value with `value`, `getValue` and `tryValue`.
- If `resume` returns `false`, then the coroutine instance reached its end.
  You can check the result value with `result`, `getResult` and `tryResult`.
- A coroutine instance can complete normally, or with an exception,
  which is rethrown when calling `result` on an abnormally completed instance.

In the next section,
we will learn how to [make coroutine code more modular](../composition/).
