---
---

class Service
  constructor: (@url, @image_url) ->

  appendContent: (td) ->
    a = document.createElement('a')
    img = document.createElement('img')
    img.setAttribute("src", this.image_url)
    a.href = this.url
    a.appendChild img
    td.appendChild a
    td.setAttribute("class", "projects-content")
    td.serviceData = this

  reloadContent: (td) ->


class LiveService extends Service
  reloadContent: (td) ->
    console.log "Reloading service at " + this.url
    while (td.lastChild)
      td.removeChild td.lastChild
    this.appendContent(td)

class Project
  constructor: (@name, @image, @travis, @drone, @appveyor, @maven) ->


projects =
  bundleboy: new Project(
    "Bundleboy",
    "/resources/images/bundleboy-mini-logo.png",
    new LiveService(
      "https://travis-ci.org/storm-enroute/bundleboy",
      "https://travis-ci.org/storm-enroute/bundleboy.svg?branch=master"),
    new LiveService(
      "http://ci.storm-enroute.com:443/storm-enroute/bundleboy",
      "http://ci.storm-enroute.com:443/api/badges/storm-enroute/bundleboy/status.svg"),
    null,
    new Service(
      "http://mvnrepository.com/artifact/com.storm-enroute/bundleboy_2.11",
      "https://img.shields.io/maven-central/v/com.storm-enroute/bundleboy_2.11.svg"))

  coroutines: new Project(
    "Coroutines",
    "/resources/images/coroutines-128.png",
    new LiveService(
      "https://travis-ci.org/storm-enroute/coroutines",
      "https://travis-ci.org/storm-enroute/coroutines.svg?branch=master"),
    new LiveService(
      "http://ci.storm-enroute.com:443/storm-enroute/coroutines",
      "http://ci.storm-enroute.com:443/api/badges/storm-enroute/coroutines/status.svg"),
    null,
    new Service(
      "http://mvnrepository.com/artifact/com.storm-enroute/coroutines_2.11",
      "https://img.shields.io/maven-central/v/com.storm-enroute/coroutines_2.11.svg"))

  macrogl: new Project(
    "MacroGL",
    "/resources/images/macrogl-96.png",
    new LiveService(
      "https://travis-ci.org/storm-enroute/macrogl",
      "https://travis-ci.org/storm-enroute/macrogl.svg?branch=master"),
    new LiveService(
      "http://ci.storm-enroute.com:443/storm-enroute/macrogl",
      "http://ci.storm-enroute.com:443/api/badges/storm-enroute/macrogl/status.svg"),
    null,
    new Service(
      "http://mvnrepository.com/artifact/com.storm-enroute/macrogl_2.10",
      "https://img.shields.io/maven-central/v/com.storm-enroute/macrogl_2.10.svg"))

  mecha: new Project(
    "Mecha",
    "/resources/images/mecha-logo-64.png",
    new LiveService(
      "https://travis-ci.org/storm-enroute/mecha",
      "https://travis-ci.org/storm-enroute/mecha.svg?branch=master"),
    new LiveService(
      "http://ci.storm-enroute.com:443/storm-enroute/mecha",
      "http://ci.storm-enroute.com:443/api/badges/storm-enroute/mecha/status.svg"),
    null,
    new Service(
      "http://mvnrepository.com/artifact/com.storm-enroute/mecha",
      "https://img.shields.io/maven-central/v/com.storm-enroute/mecha.svg"))

  reactors: new Project(
    "Reactors.IO",
    "/resources/images/reactress-gradient.png",
    new LiveService(
      "https://travis-ci.org/reactors-io/reactors",
      "https://travis-ci.org/reactors-io/reactors.svg?branch=master"),
    new LiveService(
      "http://ci.storm-enroute.com:443/reactors-io/reactors",
      "http://ci.storm-enroute.com:443/api/badges/reactors-io/reactors/status.svg"),
    null,
    new Service(
      "http://mvnrepository.com/artifact/com.storm-enroute/reactors_2.11",
      "https://img.shields.io/maven-central/v/com.storm-enroute/reactors_2.11.svg"))

  scalameter: new Project(
    "ScalaMeter",
    "/resources/images/scalameter-logo-yellow.png",
    new LiveService(
      "https://travis-ci.org/scalameter/scalameter",
      "https://travis-ci.org/scalameter/scalameter.svg?branch=master"),
    new LiveService(
      "http://ci.storm-enroute.com:443/scalameter/scalameter",
      "http://ci.storm-enroute.com:443/api/badges/scalameter/scalameter/status.svg"),
    new LiveService(
      "https://ci.appveyor.com/project/storm-enroute-bot/scalameter/branch/master",
      "https://ci.appveyor.com/api/projects/status/08hfljfae46wj9hc/branch/master?svg=true"),
    new Service(
      "http://mvnrepository.com/artifact/com.storm-enroute/scalameter_2.11",
      "https://img.shields.io/maven-central/v/com.storm-enroute/scalameter_2.11.svg"))

  code_examples: new Project(
    "Code Examples",
    "/resources/images/code-repo.png",
    null,
    new LiveService(
      "http://ci.storm-enroute.com:443/storm-enroute/examples",
      "http://ci.storm-enroute.com:443/api/badges/storm-enroute/examples/status.svg"),
    null,
    null)

  scalameter_examples: new Project(
    "ScalaMeter Examples",
    "/resources/images/code-repo.png",
    new LiveService(
      "https://travis-ci.org/scalameter/scalameter-examples",
      "https://travis-ci.org/scalameter/scalameter-examples.svg?branch=master"),
    null,
    null,
    null)


setupCi = () ->
  table = document.getElementById("projects-table")

  reloadService = (tr, service) ->
    td = document.createElement("td")
    tr.appendChild td
    if service != null
      service.appendContent(td)
    else
      td.appendChild(document.createTextNode("N/A"))

  addServices = () ->
    for name, project of projects
      console.log "Loading project: " + name
      tr = document.createElement("tr")

      imgtd = document.createElement("td")
      img = document.createElement("img")
      img.setAttribute("src", project.image)
      img.setAttribute("height", "48")
      imgtd.appendChild(img)
      tr.appendChild(imgtd)

      nametd = document.createElement("td")
      nametd.setAttribute("class", "projects-name")
      nametd.appendChild(document.createTextNode(project.name))
      tr.appendChild(nametd)

      reloadService(tr, project.travis)
      reloadService(tr, project.drone)
      reloadService(tr, project.appveyor)
      reloadService(tr, project.maven)

      table.appendChild(tr)

  reloadServices = () ->
    tds = document.getElementsByClassName("projects-content")
    for td in tds
      if td.serviceData
        td.serviceData.reloadContent(td)

  addServices()
  setInterval(reloadServices, 30 * 1000)


setupCi()
