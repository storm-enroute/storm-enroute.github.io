---
layout: projdefault
projectname: Reactress
projectpath: reactress
logoname: reactress-mini-logo-flat.png
title: Reactive Values
permalink: /reactress/docs/0.3/reactives/index.html
reactressversion: 0.3
section: General
pagenum: 1
pagetot: 10
---





The basic data-type that drives most computations in Reactress is called
a **reactive value**, represented by the type `Reactive[T]`.
A reactive value, or simply -- a **reactive**, represents an entity
that can occasionally produce values of type `T`.
These values are called *events*.

A reactive value is entirely a single-threaded entity.
There is no concurrency associated with a reactive value --
it can only propagate events on one thread at a time.
A programmer need not worry about an event concurrently being
emitted on the same reactive.
This simplifies the programming model, makes programs more maintainable
and ensures better performance.
As we will see, it also allows to encapsulate mutable objects
inside reactive values.

In what follows, we describe reactive values and their different variants.
We show how to compose reactive values in a declarative way
to yield concise and understandable reactive programs.


## Reactive values

The `Reactive[T]` type is represented with the following trait:

    trait Reactive[+T] {
      // lots of stuff
    }

To react to events produced by the reactive value,
we need to **subscribe** to it.
One way to do this is to use the `onReaction` method of the `Reactive[T]` trait:

    def onReaction(reactor: Reactor[T]): Reactive.Subscription

The `onReaction` method takes a reactor of type `Reactor[T]` and returns a `Subscription` object.
A `Reactor[T]` is a type that provides two methods called `react` and `unreact`:

    trait Reactor[-T] {
      def react(value: T): Unit
      def unreact(): Unit
    }

Whenever a reactive value produces an event, the reactors,
which were previously subscribed
to the reactive value with `onReaction`,
are notified -- their `react` method is invoked with the `value` of the event.

Every reactive value can at some point decide to stop emitting events.
We say that the reactive value **unreacts**.
At this point, the `unreact` value is called on all its reactors.

The `Subscription` object returned by `onReaction`
represents the subscription by the specific reactor.
It has a single method `unsubscribe`.
If the `unsubscribe` method is invoked,
events are no longer passed to the corresponding reactor
and its `unreact` method is never called.

Reactress offers several more Scala-idiomatic ways to subscribe to events.
The `onEvent` method is used to subscribe to events, but ignore unreactions.
The `onCase` method is similar, but takes a partial function --
only the events for which the partial function is defined are considered.
The `on` method executes a block of code when an event arrives --
it is most appropriate for reactives of type `Reactive[Unit]`.
Finally, the `onUnreact` method executes a block of code when the reactive unreacts.

    def onEvent(reactor: T => Unit): Reactive.Subscription
    def onCase(reactor: PartialFunction[T, Unit]): Reactive.Subscription
    def on(reactor: =>Unit): Reactive.Subscription
    def onUnreact(reactor: =>Unit): Reactive.Subscription

There are several basic concrete reactive values:

- `Reactive.Never` -- never emits any events
- `Reactive.Emitter` -- emits an event every time its `+=` method is called
- passive reactives -- emit a separate stream of events to each reactor that subscribes to them


## Reactive emitters

A **reactive emitter** is a concrete reactive value.
We create it as follows:

    val emitter = new Reactive.Emitter[Int]

The reactive emitter produces an events each time an event is added to it by the `+=` method.
The following example prints `"Hello world!"` to the standard output.

    val printSubscription = emitter onEvent println
    emitter += "Hello world!"

After calling `close` on the emitter, the emitter unreacts.
Subsequent invocations of `+=` are ignored.

    val unreactSubscription = emitter onUnreact {
      println("done for today.")
    }
    emitter.close()


## Subscriptions

A subscription is an object used to unsubscribe from a reaction.
In most cases this means that the corresponding entity will no longer receive events.
We unsubscribe by calling the `unsubscribe` method:

    val printSubscription = emitter onEvent println
    emitter += "Hi!"
    printSubscription.unsubscribe()
    emitter += "You can't hear me!"

Note that we always store the `Subscription` object returned by the `onX` methods.
Without keeping a reference to the `Subscription` there is no way to unsubscribe from the callback,
so the callback could react forever, leading to effects called **memory leaks** and **time leaks**.
For this reason, when Reactress detects that the program no longer has a reference to the `Subscription`,
it automatically unsubscribes.
This automatic unsubscription usually happens during the first subsequent GC cycle.

    emitter onEvent println
    System.gc()
    emitter += "Chances are you won't hear me anymore."

This behaviour is by design.
Consider the following method `sumOfSquares` that uses an
emitter `squares` to compute a sum of squares of first `n` integers.
It subscribes to `squares` to update its `sum` and
uses an auxiliary method `emitSquare` to emit `n` squares:

    val squares = new Reactive.Emitter[Int]

    def emitSquare(x: Int) = squares += x * x

    def sumOfSquares(n: Int): Int = {
      var sum = 0
      
      squares.onEvent(sum += _)
      for (i <- 1 until n) emitSquare(i)

      sum
    }

The scope in which the callback that updates `sum` is useful
is only the method `sumOfSquares`.
Once the method completes, this callback is not only useful,
but also dangerous.
It occupies a region of memory that cannot be freed and
captures the lifted version of the `sum` variable --
it leads to memory leaks.
Furthermore, whenever some other part of the program
emits an event on `squares`, the callback that updates
the `sum` must be executed and wastes computational resources --
in FRP, this is known as a time leak.

For these reasons, Reactress subscribes to the
"If you didn't save it, you don't need it." philosophy.

<table class="docs-tip">
<td><img src="/resources/images/reactress-warning.png"/></td>
<td>
Always store a reference to the subscription of the callback
that is important in the program.
Otherwise, the callback is eventually automatically unsubscribed.
</td>
</table>


## Functional Composition on Reactives

Reactives represent event sources and reactors are very similar to *observers*.
However, using only the `onX` family of methods on reactives soon
results in a *callback hell* -- in a program composed of a large number
of unstructured `onX` method calls understandibility becomes a problem.

To overcome this problem, we use *functional composition* on reactive values --
a programming pattern in which more complex values are created by declaratively
composing simpler ones.

Let's rewrite the method `sumOfSquares` from before.
This time we do not use a callback and a mutable variable.
Instead, we use the `map` and `scanPast` combinators.
The `map` combinator transforms events in one reactive into events for a derived reactive --
we use it to map each number into its square.
The `scanPast` combinator combines the last and the current event to produce a new event for the derived reactive --
we use it to add the previous value of the sum to the current one.

    def sumOfSquares(n: Int): Int = {
      val emitter = new Reactive.Emitter[Int]
      val sum = emitter.map(x => x * x).scanPast(0)(_ + _)
      for (i <- 0 until n) emitter += n
      sum()
    }

The `Reactive[T]` trait comes with a large number of predefined combinators.
Same as with callbacks, you must always store the return value of the combinator.
Not doing so eventually results in an automatic unsubscription.

A bunch of reactive values composed using functional combinators
forms a **dataflow graph**.
Emitters are source nodes in this graph, reactives obtained by various combinators are inner nodes
and callback methods like `onEvent` form sink nodes.
Some combinators like `union` take several input reactives.
Such reactives correspond to nodes with multiple input edges in the dataflow graph.

    val numbers = new Reactive.Emitter[Int]
    val even = numbers.filter(_ % 2 == 0)
    val odd = numbers.filter(_ % 2 == 1)
    val numbersAgain = even union odd


## Higher-order Reactive Values

In some cases reactive values produce events that are themselves reactive values --
we call them **higher-order reactive values**.
A higher-order reactive can have a type like:

    Reactive[Reactive[T]]


