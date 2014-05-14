Template.home.rendered = ->
  $('#cn-slideshow').slideshow();

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
