
function setContent(contentboxname, url, logoname) {
  var contentbox = document.getElementById(contentboxname);
  $.get(url, function(data) {
    var icon = document.createElement('IMG');
    icon.setAttribute("src", "/resources/images/" + logoname);
    icon.setAttribute("height", 48);
    var ltxt = window.atob(data.content);
    ltxt = ltxt.replace(/\t/g, '    ').replace(/  /g, '&nbsp; ').replace(/  /g, ' &nbsp;').replace(/\r\n|\n|\r/g, '<br />');
    contentbox.appendChild(icon);
    contentbox.innerHTML = contentbox.innerHTML + '<br/>' + ltxt;
  });
}

function setLicense(url, logoname) {
  setContent(url, logoname, "licensebox")
}
