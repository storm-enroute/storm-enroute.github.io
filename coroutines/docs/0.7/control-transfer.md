---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Control Transfer
permalink: /coroutines/docs/0.7/control-transfer/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
num: 6
outof: 20
coversion: 0.7
---


In structured programming,
arbitrary, non-local control flow is generally forbidden.
In fact, negative aspects of statements such as `goto`
have been criticized to the degree where
they found themselves a place in the programming folklore.
This reputation is largely deserved --
it is difficult to make sense of or maintain a program
that has excessive and undisciplined uses of `goto`,
and it is far too easy to become undisciplined.

There are exceptions to this, of course (pun intended).
Most prominent is the widespread adoption of exception-handling
in many programing languages.
Exception-handling allows non-local jumps in control flow,
since an exception raised in one method
may cause the control flow to continue in an arbitrary other method.
Despite their perceived usefulness,
exceptions can be problematic both from program readability
and programming language implementation viewpoint.
For this reason,
some programming languages are now stepping away from exceptions --
newer languages such as Rust and Go do not have classic exception handling.

Coroutines themselves are a language primitive that supports
non-local control flow.
It makes sense to ask:
why would we use a primitive that enables non-local control flow?
There are two parts to that answer --
first of all, experience has shown that some programs *need* non-local control flow.
For example, we encode *callback chains* and implement *iterators*
without unrestricted control flow.
This results is a phenomenon called *inversion of control*,
where behavior is not directly apparent from the code that we write,
but is governed by a different part of the program.
Non-local control flow can increase program readability.
Second part of the answer is that
coroutines do not enable *unrestricted* control flow.
Since control flow jumps in a coroutine invocation (i.e. a coroutine instance)
are restricted to `yieldval` and `resume` pair,
it is much easier to understand the control flow compared to something like `goto`.

In this section,
we will see an alternative form of control flow jump
called the *control transfer*,
where a coroutine instance suspends itself and transfers control flow
to a different coroutine instance.


## Control transfer

Transferring control to a different coroutine instance
works with a special construct called `yieldto`.
This construct takes a target *coroutine instance* (not coroutine),
and continues executing 

Consider the following example.
Let's say that we have a coroutine `check` that can be periodically resumed
to check if there are any errors in the program.
The `check` coroutine yields a `Boolean` value,
and assigns an error description to a global `error` variable.

    var error: String = ""
    val check: ~~~>[Boolean, Unit] = coroutine { () =>
      yieldval(true)
      error = "Total failure."
      yieldval(false)
    }
    val checker: Boolean <~> Unit = call(check())

We then define another coroutine called `random`,
which yields random `Double` values,
but occasionally transfers control to `checker`.

    val random: ~~~>[Double, Unit] = coroutine { () =>
      yieldval(Random.nextDouble())
      yieldto(checker)
      yieldval(Random.nextDouble())
    }

Above, note that transferring control to an already completed coroutine instance
is not legal, and results in an exception being raised
in the coroutine that called `yieldto`.

Graphically, the control flow jump is as follows.
Note that after `check` yields or completes,
control is transferred back to the main program.

![ ](/resources/images/invoke6.png)

We can now test that this works as expected --
we start the `random` coroutine and name the instance `r0`,
and call `resume` and `hasValue`:

    val r0 = call(random())
    assert(r0.resume)
    assert(r0.hasValue)

As expected, `resume` returns `true` and
and `hasValue` returns `true`, as well, since `r0` yielded a value.
However, on the next resume, coroutine reaches a `yieldto`:

    assert(r0.resume)
    assert(!r0.hasValue)

This time, `resume` returns `true`, since `r0` is still live,
but `hasValue` returns `false`, because,
the coroutine instance `r0` did not yield a value.

After this, `resume` and `hasValue` calls behave as expected.

    assert(r0.resume)
    assert(r0.hasValue)
    assert(!r0.resume)
    assert(!r0.hasValue)

We now see that it is insufficient
to just call `resume` and `value` to extract values from a coroutine.
If `resume` results in transfering control
to another coroutine instance with a `yieldto`,
then the original coroutine instance will not yield a value.
So, the right way to extract all the value from a coroutine is as follows:

    val r1 = call(random())
    val values = mutable.Buffer[Double]()
    while (r1.resume) if (r1.hasValue) values += r1.value
    assert(values.length == 2)

The following rule is important to remember.

<table class="docs-tip">
<td><img src="/resources/images/warning.png"/></td>
<td>
Each <code>resume</code> may or may not actually <code>yield</code> a value.
Therefore, if you use <code>resume</code> to control the coroutine,
a <code>value</code> call <b>must be</b> preceded by a <code>hasValue</code> call.
</td>
</table>

The complete example is shown below.

<div>
<pre id="examplebox-1">
</pre>
</div>
<script>
setContent(
  "examplebox-1",
  "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/org/examples/ControlTransfer.scala",
  null,
  "raw",
  "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/org/examples/ControlTransfer.scala");
</script>

To reduce this boilerplate,
there is a convenience combinator called `pull`.
This combinator calls `resume` multiple times if it detects
that no value was yielded.
So, the following statement:

    while (r1.resume) if (r1.hasValue) values += r1.value

is equivalent to this one:

    while (r1.pull) values += r1.value

The `pull` combinator ensures that if it returned `true`,
then `value` can be called.
If `pull` returns `false`, then the coroutine is completed.

<table class="docs-tip">
<td><img src="/resources/images/warning.png"/></td>
<td>
If you use <code>pull</code> instead of <code>resume</code>,
then calls to <code>value</code> do not need to be preceded
with <code>hasValue</code>.
</td>
</table>

We can now rewrite our earlier example as follows:

<div>
<pre id="examplebox-2">
</pre>
</div>
<script>
setContent(
  "examplebox-2",
  "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/org/examples/ControlTransferWithPull.scala",
  null,
  "raw",
  "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/org/examples/ControlTransferWithPull.scala");
</script>

Note that this does not mean that the `resume` combinator is useless.
You will typically use `resume` when writing cooperative multitasking code,
where you care mostly about chunking the computation into small pieces
and dynamically passing control between coroutines,
but you do not have to retrieve values from the coroutine.


### Summary

We learned that:

- A coroutine instance can transfer control to another coroutine instance
  with a `yieldto` statement.
- When control is transferred to another coroutine instance,
  the original instance may not yield a value,
  so callers of `resume` must additionally call `hasValue`
  to check if a value was yielded.
- To avoid the `hasValue` boilerplate, you can use the `pull` combinator
  instead of `resume`. The `pull` combinator will call `resume` more than once
  under-the-hood if it detects that `hasValue` returned `false`.

In the [next part](../snapshots/),
we will see how to capture a snapshot of a coroutine instance,
and learn how to use this operation.
