---
layout: projdefaultnotitle
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Scala Coroutines Guide
permalink: /coroutines/docs/0.3/index.html
logostyle: "color: #5f5f5f;"
---


## Coroutines 101

A *coroutine* is a programming construct that can suspend its execution
and resume execution later.
*Subroutines* (i.e. functions, procedures or methods) are well known
and available in most programming languages.
For the purposes of this guide, we will jointly refer to functions, procedures, methods
and lambdas as subroutines, despite their subtle differences.
When a subroutine is called,
its execution begins at the start of the subroutine definition,
and finishes when the end of the subroutine is reached.
A coroutine is more powerful -- it can pause execution at any point between the start
and the end of the coroutine definition.
In this sense, coroutines generalize subroutines.

To better understand how coroutines work,
we contrast them to lambdas from functional programming.
Consider the following definition of an identity lambda:

    val id = (x: Int) => x

We call (i.e. invoke) the identity lambda `id` as follows:

    id(7)

When `id` is invoked, the following sequence of events occurs.
First, the runtime allocates a location on the program stack to hold the parameter `x`.
Then, the value of `x` is copied to this location.

![ ](/resources/images/invoke.png)

The `id` body then simply returns the value `x` back to the caller
by copying it back to the appropriate location.
After that, the invocation of `id` (i.e. an *instance* of the subroutine `id`)
completes.

![ ](/resources/images/invoke1.png)

Above, the caller of the `id` lambda (e.g. the main program) must suspend execution
until `id` completes.
After `id` returns control to the caller, the instance of the subroutine
`id` no longer exists, so it does not make sense to refer to it.
An invocation (i.e. *an instance of a subroutine*) is not a first-class object.

By contrast, a coroutine invocation can suspend its execution before it completes,
and later be resumed.
For this reason, it makes sense to represent the coroutine invocation
(i.e. a *coroutine instance*) as a first-class object
that can be passed to and returned from functions,
whose execution state can be retrieved,
and which can be resumed when required.

Let's see the simplest possible coroutine definition -- an *identity coroutine*,
which just returns the argument that is passed to it.
Its definition is similar to that of an identity lambda,
the only difference being the enclosing `coroutine` block:

    val id = coroutine { (x: Int) => x }

Although this particular coroutine `id` is semantically equivalent
to the prior definition of the identity lambda `id`,
its execution is slightly different.

