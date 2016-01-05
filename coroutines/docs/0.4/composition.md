---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Coroutine Composition
permalink: /coroutines/docs/0.4/composition/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
num: 5
outof: 20
coversion: 0.4
---


As complexity of a system grows,
so does the need to separate it into independent software modules.
This way, non-trivial software systems are more easily understood,
tested and evolved.
In programming languages,
there are many different ways to achieve modularity.
In object-oriented programming,
a complex object usually contains multiple simpler objects,
where each part implements a certain functionality.
In functional programming,
a function calls simpler functions to compute a value,
or is composed from simpler functions using functional combinators.
Distributed systems are often separated into
independent, concurrent processes,
each of which assumes a particular role.
We refer to this as *composition*,
and say that programming abstractions *compose*
if it is possible to create more complex abstractions from simpler ones.

Scala coroutines compose
in a similar way functions (i.e. subroutines) do.
Code inside a coroutine can directly invoke another coroutine,
as if it were a normal function call.
This allows separating functionality across multiple simpler coroutines,
and composing them together.
In this section, we will see the details of how this works.


## Starting a coroutine instance vs. calling a coroutine

In [Coroutines 101](../101/),
we learned that normal program code cannot invoke a coroutine directly,
and must use the `call` statement instead,
to obtain a coroutine instance object.
Assume that we have a simple coroutine that yields
the integers in an `Option[Int]` object.
This coroutine will either yield a single integer, or none.

    val optionElems = coroutine { (x: Int) =>
      opt match {
        case Some(x) => yieldval(x)
        case None => // do nothing
      }
    }

Now, assume that we need to yield integers from a list of optional integers,
that is, a `List[Option[Int]]` value.
We need a coroutine `optionListElems`, that will yield these integers.
We could write an entirely new coroutine that traverses the `Option[Int]`
elements in the list in a `while` loop,
and then do the pattern match again on each element.
Sound software engineering principles such as DRY
tell us to reuse the existing `optionElems` coroutine instead
of duplicating the pattern match.

We implement a new coroutine `optionListElems` as follows.
Each time a `while` loop iteration stumbles upon a new optional value,
it invokes the existing `optionElems` method with that optional value.
This is shown in the following snippet:

    private val optionListElems = coroutine { (xs: List[Option[Int]]) =>
      var curr = xs
      while (curr != Nil) {
        optionElems(curr.head)
        curr = curr.tail
      }
    }

What happened here?
We are using the coroutine `optionElems` as if it were a regular function!
Instead of putting it into a `call` statement,
we're just invoking it directly!
Why is this allowed inside a coroutine,
but it was not allowed in the regular program code?

The reason is that the coroutine *instance* is executing in a special environment
where yielding is possible.
This environment includes a special stack, as we saw in [Coroutine 101](../101/),
which is used to store the local variables of the coroutine instance
when a `yieldval` occurs.
A coroutine instance can use this stack to seamlessly store
the variables belonging to another coroutine and continue execution.
If the code in the other coroutine also executes a `yieldval` statement,
the coroutine instance stack will contain the local variables of both coroutines.

Let's verify that this works -- we instantiate a list of optional integers,
and start the `optionListElems` coroutine.
We then verify that only non-`None` values are yielded:

    val xs = Some(1) :: None :: Some(3) :: Nil
    val c = call(optionListElems(xs))
    assert(c.resume)
    assert(c.value == 1)
    assert(c.resume)
    assert(c.value == 3)
    assert(!c.resume)

You can see the complete example below.

<div>
<pre id="examplebox-1">
</pre>
</div>
<script>
  setContent(
    "examplebox-1",
    "https://api.github.com/repos/storm-enroute/coroutines/contents/src/test/scala/scala/examples/Composition.scala",
    null,
    "raw",
    "https://github.com/storm-enroute/coroutines/blob/master/src/test/scala/scala/examples/Composition.scala");
</script>


## Summary

TODO
