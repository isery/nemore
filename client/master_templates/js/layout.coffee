closeMenu = ($menu, $container)->
  $menu.toggleClass("bt-menu-open")
  $container?.delay(50).animate
    width: "+=80px",
    height: "+=40px",
    left:"0px",
    bottom: "0px"
  ,
    duration: 150

openMenu = ($menu, $container)->
  $menu.toggleClass("bt-menu-open")
  $container?.delay(50).animate
    width: "-=80px",
    height: "-=40px",
    left:"80px",
    bottom: "40px"
  ,
    duration: 150

#Function called when template rendered
init = ->
  console.log "here"
  menu = document.getElementById("bt-menu")
  trigger = menu.querySelector("a.bt-menu-trigger")
  $row = $(".heroRow")

  eventtype = (if mobilecheck() then "touchstart" else "click")
  resetMenu = ->
    $(menu).removeClass "bt-menu-open"
    $(menu).addClass "bt-menu-close"
    $row.delay(50).animate
      width: "+=80px",
      height: "+=40px",
      left:"0px",
      bottom: "0px"
    ,
      duration: 150

  closeClickFn = (ev) ->
    console.log "in close event"
    resetMenu()
    overlay.removeEventListener eventtype, closeClickFn

  overlay = document.createElement("div")
  overlay.className = "bt-overlay"
  menu.appendChild overlay
  trigger.addEventListener eventtype, (ev) ->
    console.log "in event"
    ev.stopPropagation()
    ev.preventDefault()
    if $(menu).hasClass "bt-menu-open"
      resetMenu()
    else
      $(menu).removeClass "bt-menu-close"
      $(menu).addClass "bt-menu-open"
      $row.delay(50).animate
        width: "-=80px",
        height: "-=40px",
        left:"80px",
        bottom: "40px"
      ,
        duration: 150
      overlay.addEventListener eventtype, closeClickFn
  console.log trigger

#this is needed so that the template only renders once (if it renders twice the menu won't work anymore)
templateCreated = false;
Template.container.created = ->
  templateCreated = true;

Template.container.rendered = ->
  if templateCreated
    templateCreated = false
    init()

Template.container.events
  'click #bt-menu > .bt-menu-trigger': (e) ->
    $overlay = $('.bt-overlay')
    $menu = $("#bt-menu")

    $container = $(".outerContainer")
    if $('#bt-menu').hasClass('bt-menu-open')
      closeMenu($menu, $container)
      $overlay.off()
    else
      openMenu($menu, $container)
      $overlay.click( -> closeMenu($menu, $container))

