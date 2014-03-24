closeMenu = ($menu, $container)->
  $menu.toggleClass("bt-menu-open")

openMenu = ($menu, $container)->
  $menu.toggleClass("bt-menu-open")

Template.container.events
  'click #bt-menu > .bt-menu-trigger': (e) ->
    $overlay = $('.bt-overlay')
    $menu = $("#bt-menu")
    $menuContainer = $('.menuContainerLeft')
    $container = $(".outerContainer")

    if $('#bt-menu').hasClass('bt-menu-open')
      $overlay.off()
      closeMenu($menu, $container)
    else
      openMenu($menu, $container)
      $overlay.one 'click': (e) ->
        closeMenu($menu, $container)

  'click .heroRowUl li': (e) ->
    $(".heroRowUl li").removeClass "active"
    $(e.currentTarget).addClass "active"
    $("body").addClass "show-x"

  'click span.close' :(e) ->
    $(".heroRowUl li.active").removeClass "active"
    $("body").removeClass "show-x"