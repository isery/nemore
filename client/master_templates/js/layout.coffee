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