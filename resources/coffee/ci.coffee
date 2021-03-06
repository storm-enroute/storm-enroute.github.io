---
---

class Service
  constructor: (@url, @image_url) ->

  appendContent: (td) ->
    a = document.createElement("a")
    div = document.createElement("div")
    img = document.createElement("img")
    img.setAttribute("src", this.image_url)
    div.appendChild img
    a.href = this.url
    a.appendChild div
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
  constructor: (@name, @image, @scm, @travis, @drone, @appveyor, @maven) ->


projects =
  bundleboy: new Project(
    "Bundleboy",
    "/resources/images/bundleboy-mini-logo.png",
    "https://github.com/storm-enroute/bundleboy",
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

  chronodb: new Project(
    "ChronoDB",
    "/resources/images/code-repo-dark.png",
    "https://github.com/storm-enroute/chrono-db",
    new LiveService(
      "https://travis-ci.org/storm-enroute/chrono-db",
      "https://travis-ci.org/storm-enroute/chrono-db.svg?branch=master"),
    new LiveService(
      "http://ci.storm-enroute.com:443/storm-enroute/chrono-db",
      "http://ci.storm-enroute.com:443/api/badges/storm-enroute/chrono-db/status.svg"),
    null,
    new Service(
      "http://mvnrepository.com/artifact/com.storm-enroute/chrono-db_2.11",
      "https://img.shields.io/maven-central/v/com.storm-enroute/chrono-db_2.11.svg"))

  coroutines: new Project(
    "Coroutines",
    "/resources/images/coroutines-128-xmas-pale.png",
    "https://github.com/storm-enroute/coroutines",
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
    "https://github.com/storm-enroute/macrogl",
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
    "https://github.com/storm-enroute/mecha",
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
    "https://github.com/reactors-io/reactors",
    new LiveService(
      "https://travis-ci.org/reactors-io/reactors",
      "https://travis-ci.org/reactors-io/reactors.svg?branch=master"),
    null,
    null,
    new Service(
      "http://mvnrepository.com/artifact/com.storm-enroute/reactors_2.11",
      "https://img.shields.io/maven-central/v/com.storm-enroute/reactors_2.11.svg"))

  scalameter: new Project(
    "ScalaMeter",
    "/resources/images/scalameter-logo-yellow.png",
    "https://github.com/scalameter/scalameter",
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

  scalameter_examples: new Project(
    "ScalaMeter Examples",
    "/resources/images/code-repo-dark.png",
    "https://github.com/scalameter/scalameter-examples",
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
      a = document.createElement("a")
      a.href = project.scm
      div = document.createElement("div")
      img = document.createElement("img")
      img.setAttribute("src", project.image)
      img.setAttribute("height", "48")
      div.appendChild(img)
      a.appendChild(div)
      imgtd.appendChild(a)
      tr.appendChild(imgtd)

      nametd = document.createElement("td")
      a = document.createElement("a")
      a.href = project.scm
      div = document.createElement("div")
      nametd.setAttribute("class", "projects-name")
      div.appendChild(document.createTextNode(project.name))
      a.appendChild(div)
      nametd.appendChild(a)
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
  setInterval(reloadServices, 180 * 1000)


setupCi()
