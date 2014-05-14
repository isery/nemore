closeMenu = ($menu)->
  $menu.toggleClass("bt-menu-open")

openMenu = ($menu)->
  $menu.toggleClass("bt-menu-open")

Template.container.rendered = ->
  adjustLoginBox()


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

adjustLoginBox = ->
  $loginBox = $("#login-dropdown-list")
  $link = $loginBox.find(".dropdown-toggle")
  $link.empty().addClass('fa fa-gears')