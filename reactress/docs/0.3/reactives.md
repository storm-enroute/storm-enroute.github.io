---
layout: projdefault
projectname: Reactress
projectpath: reactress
logoname: reactress-mini-logo-flat.png
title: Reactive Values and Signals
permalink: /reactress/docs/0.3/reactives/index.html
reactressversion: 0.3
section: General
pagenum: 1
pagetot: 10
---



The basic data-type that drives most computations in Reactress is called `Reactive[T]`.
A value of type `Reactive[T]`, or simply -- a *reactive value*, represents an entity
that can occasionally produce values of type `T`.
These values are called *events*.

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
