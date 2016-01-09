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

To make such continuations and coroutines equally powerful abstractions,
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

We can then continue invoking the coroutine instance operations on `c`,
as we did before.

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
This does not duplicate any other (global) objects that the coroutine
instance is pointing to.
Capturing a coroutine instance snapshot duplicates
the state of the <b>local variables</b> on the instance stack,
and its execution state (i.e. program counter).
It <b>does not</b> capture the state of the entire program runtime.
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
  "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/scala/examples/Snapshot.scala",
  null,
  "raw",
  "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/scala/examples/Snapshot.scala");
</script>


## Example use-case: backtracking testing suite

The previous example was simple, but it did not feel like a real use-case.
In this section,
we will study 

    class Cell {
      var value = false
    }

    class Mock {
      val get: ~~~>[Cell, Boolean] = coroutine { () =>
        val cell = new Cell
        yieldval(cell)
        cell.value
      }
    }

    def test[R](c: Cell <~> R): Try[R] = {
      def test[R](c: Cell <~> R): Unit = {
        if (c.resume) {
          val cell = c.value
          cell.value = true
          test(c.snapshot)
          cell.value = false
          test(c)
        }
      }
      test(c)
      c.tryResult
    }

    class MyTestSuite extends TestSuite {
      val myMockCondition = new Mock

      val myAlgorithm = coroutine { (x: Int) =>
        if (myMockCondition.get()) {
          assert(2 * x == x + x)
        } else {
          assert(x * x / x == x)
        }
      }

      assert(test(call(myAlgorithm(5))).isSuccess)
      assert(test(call(myAlgorithm(0))).isFailure)
    }

<div>
<pre id="examplebox-2">
</pre>
</div>
<script>
setContent(
  "examplebox-2",
  "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/scala/examples/MockSnapshot.scala",
  null,
  "raw",
  "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/scala/examples/MockSnapshot.scala");
</script>



### Summary

To summarize, we learned the following:

- Every coroutine instance can be duplicated by calling its `snapshot` method.
  The so-obtained coroutine snapshot is a new coroutine instance with a fresh
  copy of the local variables, suspended at the same point as the original instance.
- A coroutine snapshot does not include duplicating any other objects that the
  coroutine instance is referring to -- the state of the runtime is not duplicated.
- A coroutine may only be copied while it is suspended.
