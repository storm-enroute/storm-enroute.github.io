---
layout: projdefaultcoroutines
projectname: Scala Coroutines
projectpath: coroutines
logoname: coroutines-64-xmas-pale.png
title: Coroutine Composition
permalink: /coroutines/docs/0.3/composition/index.html
logostyle: "color: #5f5f5f;"
partof: getting-started
num: 5
outof: 20
coversion: 0.3
---


As complexity of a system grows,
so does the need to separate it into independent software modules.
This way, non-trivial software systems are more easily understood,
tested and evolved.
In programming languages,
there are many different ways of achieving modularity.
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

Scala coroutines support composition
in a similar way functions (i.e. subroutines) do.
Code inside a coroutine can directly invoke another coroutine,
as if it were a normal function call.
This allows separating functionality across multiple simpler coroutines,
and compose them together.
In this section, we will see the details of how this works.


