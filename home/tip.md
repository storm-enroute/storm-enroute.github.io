---
layout: default
title: Tip of the Day
permalink: /tip/index.html
---


<br/>
<br/>
<br/>


Here is the selected tip of the day:

<br/>

<div id="afterbigquotebox">
<div class="bigquote">
  <div id="bigquotebox">
  </div>
</div>
</div>
<script>
var quotebox = document.getElementById("bigquotebox");
var afterquotebox = document.getElementById("afterbigquotebox");
var quote = fetchQuote();
var textnode = document.createElement("p");
textnode.appendChild(document.createTextNode(quote.text));
var authornode = document.createElement("p");
authornode.appendChild(document.createTextNode(quote.author));
authornode.setAttribute("style", "text-align: right;");
var descriptionnode = document.createElement("p");
descriptionnode.appendChild(document.createTextNode(quote.description));
quotebox.appendChild(textnode);
quotebox.appendChild(authornode);
afterquotebox.appendChild(descriptionnode);
</script>

<br/>
<br/>

