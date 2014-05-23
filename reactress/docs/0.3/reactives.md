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
a *reactive value*, represented by the type `Reactive[T]`.
A reactive value, or simply -- a *reactive*, represents an entity
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
we need to *subscribe* to it.
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
We say that the reactive value *unreacts*.
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

A *reactive emitter* is a concrete reactive value.
We create it as follows:

    val emitter = new Reactive.Emitter[Int]

The reactive emitter produces an events each time an event is added to it by the `+=` method.
The following example prints `"Hello world!"` to the standard output.

    def printer(r: Reactive[String]) = r onEvent println

    printer(emitter)
    emitter += "Hello world!"

After calling `close` on the emitter, the emitter unreacts.
Subsequent invocations of `+=` are ignored.

    emitter onUnreact {
      println("done for today.")
    }
    emitter.close()




## Functional Composition on Reactives

Reactives represent event sources and reactors are very similar to *observers*.
However, using only the `onX` family of methods on reactives soon
results in a *callback hell* -- in a program composed of a large number
of unstructured `onX` method calls understandibility becomes a problem.

To overcome this problem, we use *functional composition* on reactive values --
a programming pattern in which more complex values are created by declaratively
composing simpler ones.
