---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Example -- Async-Await
permalink: /coroutines/docs/0.5/example-async-await/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
num: 8
outof: 20
coversion: 0.5
---


The nice thing about coroutines is that
they allow expressing logically connected statements as uninterrupted code,
even though control flow could be arbitrary.
As such, one of their use-cases
is implementing the Async/Await abstraction,
normally available as a Scala plugin.

The basic idea is the following -- there are two coroutine declarations.
One is called `async`, and the other one is called `await`.
The `await` coroutine uses a helper object of type `Cell[T]`,
which is used to obtain the value of the awaited future.
When `await` is [directly invoked](../composition),
it yields a tuple of a cell object and the future object.
After yielding, it returns the value `x` from the `Cell` object.

The `async` coroutine is slightly more complicated.
It creates a promise `p`, then returns its future.
Concurrently, in a future computation,
it executes the following loop:
it resumes the coroutine, and completes the promise `p` with the result
if the coroutine completed.
Otherwise, if the execution reached `await`,
it uses the future/cell pair to install a callback,
and repeats the loop after the future yielded by `await` gets completed.

Note that, for the sake of simplicity,
the example does not do any exception handling,
but that is a straightforward extension.
The code Ois shown below.

<div>
<pre id="examplebox-1">
</pre>
</div>
<script>
setContent(
  "examplebox-1",
  "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/org/examples/AsyncAwait.scala",
  null,
  "raw",
  "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/org/examples/AsyncAwait.scala");
</script>


