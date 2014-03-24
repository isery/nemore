Template.heroes.rendered = ->
  $('#cn-slideshow').slideshow();
  $.fn.fullpage({
    anchors:['', 'heroView'],
    scrollingSpeed: 700,
    #events
    onLeave: (index, direction) ->,
    afterLoad: (anchorLink, index) ->{},
    afterRender: () ->{},
    afterSlideLoad: (anchorLink, index, slideAnchor, slideIndex)->{},
    onSlideLeave: (anchorLink, index, slideIndex, direction)->{}
  });

Template.imageSlider.events
  'click i': (e) ->
    $.fn.fullpage.moveSectionDown();