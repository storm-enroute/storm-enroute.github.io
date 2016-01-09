---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Frequently Asked Questions
permalink: /coroutines/docs/faq/index.html
logostyle: "color: #5f5f5f;"
---


## Frequently Asked Questions

This sections covers some of the frequently asked questions about Scala Coroutines.
Some of these questions were frequently raised on social media and mailing lists,
for others, we felt that they are important to address here.


### What are these coroutines all about?

A coroutine is a language construct that expresses a suspendable computation.
The best way to think about them is as lambdas that can emit some additional values
before returning the resulting value.
Instead of just calling it once and blocking until it completes,
a coroutine suspends multiple times and can be resumed by the caller.
In this sense, a coroutine behaves very similarly to an *iterator*.

Coroutines can be used to implement many things,
for example producer-consumer concurrency, collection iterators,
complex UI logic, asynchronous concurrent computations frameworks,
or even continuations.

Note that the Getting Started Guide in the [docs section](/coroutines/learn/)
is the best place to learn all about Scala Coroutines.


### I don't want to read this silly guide of yours. Can you just show me how this works?

Sure.
Here's a declaration of a coroutine that outputs the range
of numbers from `0` to `n`:

    val range = coroutine { (n: Int) =>
      var i = 0
      while (i < n) {
        yieldval(i)
        i += 1
      }
    }

And here's how to extract all the elements that this coroutine yields:

    def extract(c: Int <~> Unit): Seq[Int] = {
      var xs: List[Int] = Nil
      while (c.resume) if (c.hasValue) xs ::= c.value
      xs.reverse
    }

    val instance = call(range(10))
    val elems = extract(instance)
    assert(elems == 0 until 10)

Complete example is available
[here](https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/scala/examples/FaqSimpleExample.scala).
But, you should really consider reading [The Guide](/coroutines/learn) at some point.


### What is the concurrency model behind Scala Coroutines?

Short answer: there is no concurrency model whatsoever.

Long answer:
Starting a coroutine does not start a new thread,
or schedule a computation on some thread pool.
Instead, starting a coroutine is similar to calling a function --
it starts the computation on the same thread.
Similarly, when a coroutine instance is resumed,
it happens on the caller thread as a normal method call,
with a few housekeeping operations.

There are two main reasons for this.
First, any kind of concurrency involves synchronization between separate
threads of control. Synchronization requires memory writes and barriers,
which makes things slower than most people imagine.

Second,
thread-driven concurrency decreases the amount of control a client has.
If a coroutine were to run on a separate thread,
the caller would have no idea if the coroutine completed or was suspended,
unless some sort of synchronization were employed.

Scala coroutines are primarily used to express *asynchrony*
between several computations.
Asynchrony is present in many systems, not just concurrent systems.
For example, callbacks for user input events in a UI are asynchronous computations,
but in most UIs, they execute on a single thread.
Note that **concurrency implies asynchrony,
but asynchrony does not imply concurrency**
(if in doubt about this statement, just remember JavaScript and its execution model).


### Can Scala Coroutines be used to implement concurrent programming models?

Yes, absolutely.

Coroutines can (and are meant to, among other things) be used to
implement concurrency primitives and concurrent programming frameworks.
For example, Erlang-style actors without top-level-only receives,
or Oz-style single-assignment variables whose reads suspend until an assignment,
are example use cases for which coroutines are ideal candidates.


### How do Scala Coroutines relate to goroutines in Go?

Despite a similar name,
Go goroutines and Scala coroutines are different beasts altogether,
both in implementation, and, to a large extent, in the intended use case.

Goroutines are lightweight threads of execution in the Go runtime.
A goroutine is started in a similar way as a Java thread.
Its main advantage is that it is cheaper to start or switch context with
compared to a Java thread.

On the other hand,
a coroutine is just a chunk of executable computation that can occasionally suspend,
much like a function is a chunk of executable computation that, once run, must execute
until it completes.
A coroutine can be started and resumed on any thread,
but starting and resuming the coroutine is **explicit** --
a thread does this with special coroutine operations.

When looking for direct analogs of Scala coroutines in other languages,
you should instead think of generators in Python, or enumerators in C#.
Python allows defining subroutines that contain `yield` statements.
Such subroutines are called *generators* -- after they are started,
they can suspend, yield a value to the caller and later be resumed.
This process does not involve any concurrency.
In C#, `yield return` and `yield break` statements
define `IEnumerator` objects in almost exactly the same way.

Goroutines are independent units of concurrency.
As their client, you have no control over how and when a goroutine will execute.
That does not mean that goroutines are somehow flawed or otherwise bad,
just that they have **a different use case**.
So, don't let yourself be fooled by the name -- after all:

> What's in a name? That which we call a rose,
> \\
> By any other name would smell as sweet;


### How do Scala Coroutines relate to Scala Async?

Scala Async is a Scala extension that simplifies asynchronous programming
with Scala Futures.
It helps avoid for-comprehensions, callbacks and,
generally, [inversion-of-control](https://en.wikipedia.org/wiki/Inversion_of_control)
when using Scala Futures.
Scala Async automatically translates a snippet of that seems to suspend on Future values
to an equivalent sequence of `flatMap` and `map` calls, roughly speaking.
Note that Scala Async **only works with concurrent Future computations**,
and concurrency is its integral part.

Scala coroutines also translate a snippet of code with suspensions (yields)
to an alternative form, but does not assume any concurrency.
A coroutine is explicitly started and resumed on the caller thread
(although it internally uses its own separate stack to save its state).

Scala coroutines are more general means to express asynchrony
(i.e. separate, independent computations) --
this asynchrony may or may not involve concurrency
(i.e. simultaneously executing, separate threads).
In fact, Scala Async could be implemented relatively easily using Scala Coroutines.


### How do Scala Coroutines relate to Scala Delimited Continuations?

Of the APIs and frameworks listed so far,
Scala Delimited Continuations are by their nature the closest to Scala Coroutines.
They are a general language abstraction used to modify the usual flow of the program.
They can suspend a computation and express the rest of the computation as a function.

However, Scala Delimited Continuations have several drawbacks:

- They are no longer actively maintained.
- The `cps` annotation and involved syntax makes continuations more cumbersome to use
  than coroutines. Good evidence for this is the prior widespread acceptance of
  Scala Async and its more simplistic model.
- Delimited Continuations are a compiler plugin, which many people feel averse to.
  Both Scala Async and Scala Coroutines are available as third-party library modules.
- Due to their functional nature, they allocate many function objects that capture
  computation continuations. This may be adequate for non-performance-critical
  applications, but can be problematic when GC pressure or raw performance is an issue.

For these reasons, we felt it was important to provide an alternative,
simpler, but equally expressive flow control primitive -- coroutines.
