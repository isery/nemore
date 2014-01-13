#Hero on click animations on landingpage
Template.heroes.events
  'click .hero': (e)->
    $clickedHero = $(e.currentTarget)
    $otherHeroes = $clickedHero.siblings()
    $firstOtherHero = $otherHeroes.eq(0)
    $secondOtherHero = $otherHeroes.eq(1)
    $thirdOtherHero = $otherHeroes.eq(2)


    heroOpened = 1
    heroClosed = 0
    top = 0
    left = 0

    if parseInt $clickedHero.attr("data-detailed"), 10 is 1
      $(".hero").each (index, element) =>
        $(element).css 'z-index':'0'
        $(element).stop(true, false).animate 
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
      $clickedHero.css 'z-index':'5'
      $otherHeroes.each (index, element) =>
        $(element).css 'z-index':'0'

      $clickedHero.animate 
        width:'100%'
        height:'100%'
        left:'0%'
        top:'0%'
      ,
        duration:750
        easing: 'easeOutSine'
        queue:false
        complete: ->
          $otherHeroes.each (index, element) =>
            $(element).css
              width:'20%'
              height:'34%'
              left:'80%'
              top:'-34%'
              'z-index':'6'

            $clickedHero.delay(250).animate
              width: '80%'
            ,
              duration: 350


            $firstOtherHero.delay(750).animate
              top: '0%'
            ,
              duration: 350
              easing: 'easeOutSine'
              complete: ->
                $secondOtherHero.animate
                  top: '34%'
                ,
                  duration: 350,
                  easing: 'easeOutSine'
                  complete: ->
                    $thirdOtherHero.animate
                      top: '68%'
                    ,
                      duration: 350
                      easing: 'easeOutSine'

      
      $clickedHero.attr "data-detailed", heroOpened






