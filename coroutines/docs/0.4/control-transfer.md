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



    val r1 = call(random())
    val values = mutable.Buffer[Double]()
    while (r1.resume) if (r1.hasValue) values += r1.value
    assert(values.length == 2)


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



