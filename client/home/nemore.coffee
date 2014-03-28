Template.home.rendered = ->
  $('#cn-slideshow').slideshow();
  $.fn.fullpage({
    anchors:['', 'heroView'],
    scrollingSpeed: 700,
    autoScrolling:true,
    #events
    onLeave: (index, direction) ->,
    afterLoad: (anchorLink, index) ->{},
    afterRender: () ->{},
    afterSlideLoad: (anchorLink, index, slideAnchor, slideIndex)->{},
    onSlideLeave: (anchorLink, index, slideIndex, direction)->{}
  });
Template.home.destroyed = ->
  $.fn.fullpage({
    autoScrolling: false
    })

Template.imageSlider.events
  'click i': (e) ->
    $.fn.fullpage.moveSectionDown();

Template.heroes.events
  'click .heroRowUl li': (e) ->
    $(".heroRowUl li").removeClass "active"
    $(e.currentTarget).addClass "active"
    $("body").addClass "show-x"

  'click span.close' :(e) ->
    $(".heroRowUl li.active").removeClass "active"
    $("body").removeClass "show-x"