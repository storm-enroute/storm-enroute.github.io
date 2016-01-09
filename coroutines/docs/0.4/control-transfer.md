---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Control Transfer
permalink: /coroutines/docs/0.4/control-transfer/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
num: 6
outof: 20
coversion: 0.4
---


In structured programming,
arbitrary, non-local control flow is generally forbidden.
In fact, the negative aspects of statements such as `goto`
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
since an exception raised in one method,
may cause the control flow to continue in an arbitrary other method.
Despite their perceived usage,
exceptions can be problematic both from program readability
and programming language implementation viewpoint.
For this reason,
some programming languages are now stepping away from exceptions.
Newer languages such as Rust and Go do not have exception handling.

Coroutines themselves are a language primitive that supports
non-local control flow.
It makes sense to ask:
why would we use a primitive that enables non-local control flow?
There are two parts to that answer --
first of all, experience has shown that some programs *need* non-local control flow.
As a response,
we normally encode *callback chains* and implement *iterators*
in the model that does not support unrestricted control flow.
The consequence is a phenomenon called *inversion of control*,
where control flow is no longer apparent from the code that we write,
but is governed by a different part of the program.
Therefore, we *need* non-local control flow to increase the readability of our programs.
Second part of the answer is that
coroutines do not enable unrestricted control flow.
Since control flow jumps in a coroutine invocation (i.e. a coroutine instance)
are restricted to `yieldval` and `resume` pair,
it is much easier to understand the control flow compared to something like `goto`.

In this section,
we will see an alternative form of control flow jump
called the *control transfer*,
where a coroutine instance suspends itself and transfers control flow
to a different coroutine instance.


## Control transfer

    var error: String = ""
    val check: ~~~>[Boolean, Unit] = coroutine { () =>
      yieldval(true)
      error = "Total failure."
      yieldval(false)
    }
    val checker = call(check())



    val random: ~~~>[Double, Unit] = coroutine { () =>
      yieldval(Random.nextDouble())
      yieldto(checker)
      yieldval(Random.nextDouble())
    }


    val r0 = call(random())
    assert(r0.resume)
    assert(r0.hasValue)



    assert(r0.resume)
    assert(!r0.hasValue)



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
Therefore, a <code>value</code> call **must be**
preceded by a <code>hasValue</code> call.
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
  "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/scala/examples/ControlTransfer.scala",
  null,
  "raw",
  "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/scala/examples/ControlTransfer.scala");
</script>


### Summary

We have learned that:

- a coroutine instance can transfer control to another coroutine instance
  with a `yieldto` statement
- when control is transferred to another coroutine instance,
  the original instance may not yield a value,
  so callers of `resume` must additionally call `hasValue`
  to check if a value was yielded
