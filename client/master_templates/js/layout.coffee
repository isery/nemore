closeMenu = ($menu)->
  $menu.toggleClass("bt-menu-open")

openMenu = ($menu)->
  $menu.toggleClass("bt-menu-open")

Template.container.events
  'click #bt-menu > .bt-menu-trigger': (e) ->
    $overlay = $('.bt-overlay')
    $menu = $("#bt-menu")

    if $('#bt-menu').hasClass('bt-menu-open')
      $overlay.off()
      closeMenu($menu)
    else
      openMenu($menu)
      $overlay.one 'click': (e) ->
        closeMenu($menu)


Template._loginButtonsLoggedOutDropdown.rendered = ->
  $(".dropdown-toggle").text('').addClass("fa fa-sign-in")

Template._loginButtonsLoggedInDropdown.rendered = ->
  $(".dropdown-toggle").text('').addClass("fa fa-gears")


