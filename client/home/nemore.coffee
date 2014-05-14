Template.home.rendered = ->
  $('#cn-slideshow').slideshow();
  #adjustLoginBox()

Template.home.destroyed = ->

Template.imageSlider.events
  'click i': (e) ->
    $("html").animate({ scrollTop: $('.heroRowUl').offset().top });

Template.heroes.events
  'click .heroRowUl li': (e) ->
    $(".heroRowUl li").removeClass "active"
    $(e.currentTarget).addClass "active"
    $("body").addClass "show-x"

  'click span.close' :(e) ->
    $(".heroRowUl li.active").removeClass "active"
    $("body").removeClass "show-x"

adjustLoginBox = ->
  $loginBox = $("#login-dropdown-list")
  $link = $loginBox.find(".dropdown-toggle")
  $link.empty().addClass('fa fa-gears')
  return null