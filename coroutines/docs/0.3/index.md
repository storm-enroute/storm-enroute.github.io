---
layout: projdefault
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Scala Coroutines Guide
permalink: /coroutines/docs/0.3/index.html
logostyle: "color: #5f5f5f;"
---


A *coroutine* is a programming construct that can suspend its execution
and resume execution later.
*Subroutines* (i.e. functions, procedures or methods) are well known
and available in most programming languages.
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
by copying it back to the appropriate location:

![ ](/resources/images/invoke1.png)


