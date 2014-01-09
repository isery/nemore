Template.home.events
  'click .heroRow > div': (e)->
    $clickedHero = $(this)
    $otherHeroes = $clickedHero.siblings()
    heroOpened = 1
    heroClosed = 0
    if $clickedHero.attr("data-detailed") is 1
      $(".heroRow > div").each ->
        $(this).css "width", "25%"
        $(this).css "height", "100%"
        $(this).attr "data-detailed", heroClosed

    else
      $(".heroRow").prepend $clickedHero
      $clickedHero.css "width", "80%"
      $clickedHero.css "height", "100%"
      $otherHeroes.each ->
        $(this).css "width", "20%"
        $(this).css "height", "33.333333%"
        $(this).attr "data-detailed", heroClosed

      $clickedHero.attr "data-detailed", heroOpened  

