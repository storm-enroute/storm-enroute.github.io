---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Coroutine snapshots
permalink: /coroutines/docs/0.4/snapshots/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
num: 7
outof: 20
coversion: 0.4
---


TODO write intro


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
A coroutine snapshot operation duplicates a coroutine instance.
This does not duplicate any other (global) objects that the coroutine
is pointing to.
Capturing a coroutine snapshot duplicates
the state of the **local variables** on the coroutine stack,
and its execution state (i.e. program counter).
It **does not** capture the state of the entire program runtime.
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


## Example use-case

TODO write section


### Summary

To summarize, we learned the following:

- Every coroutine instance can be duplicated by calling its `snapshot` method.
  The so-obtained coroutine snapshot is a new coroutine instance with a fresh
  copy of the local variables, suspended at the same point as the original instance.
- A coroutine snapshot does not include duplicating any other objects that the
  coroutine instance is referring to -- the state of the runtime is not duplicated.
- A coroutine may only be copied while it is suspended.
