---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Coroutine Snapshots
permalink: /coroutines/docs/0.4/snapshots/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
num: 7
outof: 20
coversion: 0.4
---


Although definitions of the two vary,
coroutines and continuations are closely related.
Typically, first-class continuations are functions that execute
from the given position in the program.
As such, it is possible to invoke the same continuation many times --
each time, the execution continues from the point
that the continuation function represents.

Defined this way,
first-class continuations are more expressive than standard coroutines.
It is possible to implement coroutines using continuations,
but it is not possible to express continuations using coroutines.
The reason is that a continuation object can be resumed many times,
whereas resuming a coroutine instance irreparably changes its state.

To make continuations and coroutines equally powerful abstractions,
we need to add a straightforward extension to coroutines --
namely, the *snapshot* operation on the coroutine instance.
This part of the guide explains how to use capture coroutine snapshots.


## Capturing a snapshot

Assume we have the following simple coroutine called `values`:

    val values = coroutine { () =>
      yieldval(1)
      yieldval(2)
      yieldval(3)
    }

As we learned in the previous sections,
we can start a coroutine instance of `values`,
and then resume it to yield a value:

    val c = call(values())
    assert(c.resume)
    assert(c.value == 1)

Now, the coroutine instance `c` is suspended
at the first yieldpoint.
To obtain a snapshot of this state,
i.e. *duplicate* the coroutine instance,
we call the `snapshot` method:

    val c2 = c.snapshot

Note that the `snapshot` method can only be called while the coroutine is suspended --
but it is illegal to call `snapshot` on a coroutine that is currently executing.
After this,
we can continue invoking the coroutine instance operations on `c`,
just like we did before.

    assert(c.resume)
    assert(c.value == 2)
    assert(c.resume)
    assert(c.value == 3)

However, after the coroutine instance `c` completes,
we can continue calling the coroutine `c2`,
which is still suspended on the first yieldpoint:

    assert(c2.resume)
    assert(c2.value == 2)
    assert(c2.resume)
    assert(c2.value == 3)

We can see that the coroutine instance `c2` behaves in exactly the same way
as the instance `c` did.

<table class="docs-tip">
<td><img src="/resources/images/warning.png"/></td>
<td>
A coroutine instance snapshot operation duplicates a coroutine instance.
Capturing a coroutine instance snapshot duplicates
the state of the <b>local variables</b> on the instance stack,
and its execution state (i.e. program counter).
This does not duplicate any other (global) objects that the
local variables are pointing to,
and <b>does not</b> capture the state of the entire program runtime.
</td>
</table>

The complete snippet for this example is shown below.

<div>
<pre id="examplebox-1">
</pre>
</div>
<script>
setContent(
  "examplebox-1",
  "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/org/examples/Snapshot.scala",
  null,
  "raw",
  "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/org/examples/Snapshot.scala");
</script>


## Example use-case: backtracking testing suite

The previous example was simple, but it did not feel like a real use-case.
In this section,
we study how to implement a *backtracking* test suite,
which enables tests that simultaneously
execute different control paths in the test snippet.
We will introduce special *mock* values,
which, when used in an expression,
execute the snippet from that point on with different values.

Concretely, we will be able to write tests like this:

    if (mock()) {
      assert(2 * x == x + x)
    } else {
      assert(x * x / x == x)
    }

Above, when the coroutine reaches `myMockCondition.get()`,
it will execute the remainder of the snippet twice --
once with the value `true`, and once with the value `false`.

Before we start,
we introduce several helper classes.
The `Cell` is just a placeholder for a `Boolean` value:

    class Cell {
      var value = false
    }

The `mock` coroutine creates a new `Cell` object,
yields it to the caller,
and resumes by returning the `value` from the caller:

    val mock: ~~~>[Cell, Boolean] = coroutine { () =>
      val cell = new Cell
      yieldval(cell)
      cell.value
    }

The `mock` coroutine allows suspending the computation
and taking a parameter from the caller, as we will soon see.
The `test` method is where the magic happens.
It takes a coroutine instance that yields `Cell` objects,
and checks if it can be resumed.
If `resume` returns `false`,
the test is checked to see if it ended in an exceptional state.
If `resume` returns `true`,
the last yielded `Cell` is obtained,
and its value is set to `true`.
The `test` method is then run recursively with `snapshot` of the current coroutine.
After it returns, the same procedure repeats with the value `false` in the `Cell`.

    def test[R](c: Cell <~> R): Boolean = {
      if (c.resume) {
        val cell = c.value
        cell.value = true
        val res0 = test(c.snapshot)
        cell.value = false
        val res1 = test(c)
        res0 && res1
      } else c.hasResult
    }

If we take a look at the `mock` coroutine again,
we will see that it will first return `true` and then `false`.
We can use `mock` in a test coroutine to enable the testing
of different control paths:

    val myAlgorithm = coroutine { (x: Int) =>
      if (mock()) {
        assert(2 * x == x + x)
      } else {
        assert(x * x / x == x)
      }
    }

The `myAlgorithm` coroutine can now be invoked with different values:

    assert(test(call(myAlgorithm(5))))
    assert(!test(call(myAlgorithm(0))))

For each of the invocations,
both branches of `myAlgorithm` will be executed.
The second invocation will return `false`,
because the second branch will throw an exception for `x == 0`.
The complete example is shown below.

<div>
<pre id="examplebox-2">
</pre>
</div>
<script>
setContent(
  "examplebox-2",
  "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/org/examples/MockSnapshot.scala",
  null,
  "raw",
  "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/org/examples/MockSnapshot.scala");
</script>


### Summary

To summarize, we learned the following:

- Every coroutine instance can be duplicated by calling its `snapshot` method.
  The so-obtained coroutine snapshot is a new coroutine instance with a fresh
  copy of the local variables, suspended at the same point as the original instance.
- A coroutine snapshot does not include duplicating any other objects that the
  coroutine instance is referring to -- the state of the runtime is not duplicated.
- A coroutine may only be copied while it is suspended.
