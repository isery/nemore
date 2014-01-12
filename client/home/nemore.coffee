Template.home.events
  'click .heroRow > div': (e)->
    $clickedHero = $(e.currentTarget)
    $otherHeroes = $clickedHero.siblings()
    heroOpened = 1
    heroClosed = 0
    if parseInt $clickedHero.attr("data-detailed"), 10 is 1
      $(".heroRow > div").each (index, element) =>
        $(element).css "width": "25%", "height": "100%"
        $(element).attr "data-detailed", heroClosed
    else
      $(".heroRow").prepend $clickedHero
      $clickedHero.css "width": "80%", "height": "100%"
      $otherHeroes.each (index, element) =>
        $(element).css "width": "20%", "height": "33.333333%"
        $(element).attr "data-detailed", heroClosed
      $clickedHero.attr "data-detailed", heroOpened