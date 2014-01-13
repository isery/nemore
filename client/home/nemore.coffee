#Hero on click animations on landingpage
Template.heroes.events
  'click .hero': (e)->
    $clickedHero = $(e.currentTarget)
    $otherHeroes = $clickedHero.siblings()
    heroOpened = 1
    heroClosed = 0
    top = 0
    left = 0

    if parseInt $clickedHero.attr("data-detailed"), 10 is 1
      $(".hero").each (index, element) =>
        $(element).animate 
          width:'25%'
          height:'100%'
          top:'0%'
          left:left+'%'
        ,
          duration:750,
          easing: 'easeInSine'
        
        left+=25        
        $(element).attr "data-detailed", heroClosed
    else
      $clickedHero.animate 
        width:'80%'
        height:'100%'
        left:'0%'
        top:'0%'
      ,
        duration:750
        easing: 'easeOutSine'
        queue:false
      
      $otherHeroes.each (index, element) =>
        $(element).animate 
          width:'20%'
          height:'34%'
          left:'80%'
          top:top+'%' 
        ,
          duration:750
          easing:'easeInSine'
          queue:false
        
        top+=33
        $(element).attr "data-detailed", heroClosed
      
      $clickedHero.attr "data-detailed", heroOpened






