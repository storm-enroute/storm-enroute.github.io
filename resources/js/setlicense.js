
function setContent(contentboxname, url, logoname, contenttype) {
  var contentbox = document.getElementById(contentboxname);
  $.get(url, function(data) {
    if (logoname != null) {
      var icon = document.createElement('IMG');
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
      contentbox.innerHTML = ltxt
    }
    // restore highlighting
    $(function() {
      contentbox.removeClass('prettyprinted');
      $('pre').addClass('prettyprint linenums');
    })
    prettyPrint();
  });
}

function setLicense(url, logoname) {
  setContent("licensebox", url, logoname, "txt");
}
