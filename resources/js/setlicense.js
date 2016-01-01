
function setContent(contentboxname, url, logoname, contenttype, contentlink) {
  var contentbox = document.getElementById(contentboxname);
  // add link
  if (contentlink != null) {
    var icon = document.createElement("img")
    icon.setAttribute("src", "/resources/images/link.png")
    icon.setAttribute("style", "border: 1px dotted #aaa; background-color: #ccc;")
    var a = document.createElement("a");
    a.appendChild(icon)
    a.setAttribute("href", contentlink);
    a.setAttribute("style", "position: absolute; top: 10px; left: 620px;")
    contentbox.parentNode.setAttribute("style", "position: relative;")
    contentbox.parentNode.appendChild(a);
  }
  $.get(url, function(data) {
    if (logoname != null) {
      var icon = document.createElement("img");
      icon.setAttribute("src", "/resources/images/" + logoname);
      icon.setAttribute("height", 48);
      contentbox.appendChild(icon);
    }
    var ltxt = window.atob(data.content);
    if (contenttype == "txt") {
      ltxt = ltxt.replace(/\t/g, '    ').replace(/  /g, '&nbsp; ').replace(/  /g, ' &nbsp;').replace(/\r\n|\n|\r/g, '<br />');
      contentbox.innerHTML = contentbox.innerHTML + '<br/>' + ltxt;
    } else if (contenttype == "md") {
      contentbox.innerHTML = markdown.toHTML(ltxt);
    } else if (contenttype == "raw") {
      contentbox.innerHTML = ltxt;
    }
    // restore highlighting
    $(function() {
      $('#' + contentboxname).removeClass('prettyprinted');
      $('pre').addClass('prettyprint linenums');
    })
    prettyPrint();
  });
}

function setLicense(url, logoname) {
  setContent("licensebox", url, logoname, "txt", null);
}

function setMacroGLBuilds(boxid) {
  $.get(
    "https://api.github.com/repos/storm-enroute/builds/contents/macrogl?ref=gh-pages",
    function(data) {
      var buildList = $(boxid);
      var buildDirs = data;
      for (var i = 0; i < buildDirs.length; i++) {
        var dir = buildDirs[i]["name"];
        buildList.append("<li><a href='http://storm-enroute.com/builds/macrogl/" +
          dir + "/backend-examples-webgl/index-fastopt.html'>" + dir + "</a></li>");
      }
    }
  )
}
