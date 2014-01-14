#Hero on click animations on landingpage
Template.heroes.events
  'click .hero': (e)->
    #animated jquery objects
    $clickedHero = $(e.currentTarget)
    $otherHeroes = $clickedHero.siblings()
    $firstOtherHero = $otherHeroes.eq(0)
    $secondOtherHero = $otherHeroes.eq(1)
    $thirdOtherHero = $otherHeroes.eq(2)

    #variables to set data-attributes
    heroDetailedOpen = 1
    heroDetailedClose = 0
    heroDetailedSwitchYes = 1
    heroDetailedSwitchNo = 0
    
    #variable to animate everything back to default
    left = 0

    #if clicked-hero is already opened, reset everything back to default
    if parseInt $clickedHero.attr("data-detailed"), 10 is 1
      $(".hero").each (index, element) =>
        #reset data attributes of each hero
        $(element).attr "data-detailed", heroDetailedClose
        $(element).attr "data-switch", heroDetailedSwitchNo

        #animating every hero back to default
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
    #if clicked-hero is not opened but its one of the other heroes (side-navigation-heroes)
    else if parseInt $clickedHero.attr("data-switch"), 10 is 1
      #hero which is currently in detailed view
      $heroToSwap = $(".hero[data-detailed=1]")

      #properties of clicked hero in side-navigation
      animateClickedHeroWidth = $clickedHero.css "width"
      animateClickedHeroHeight = $clickedHero.css "height"
      animateClickedHeroTop = $clickedHero.css "top"
      animateClickedHeroLeft = $clickedHero.css "left"

      #setting correct z-index
      $clickedHero.css 'z-index': '5'
      $otherHeroes.each (index, element) =>
        $(element).css 'z-index': '0'

      #animate clicked hero in detailed view
      $clickedHero.clearQueue().animate
        width: '80%'
        height: '100%'
        left: '0%'
        top: '0%'
      ,
        duration: 750
        easing: 'easeOutSine'
        queue: false

      #animate detailed-hero in side-navigation where the clicked hero was
      $heroToSwap.clearQueue().animate
        width: animateClickedHeroWidth
        height: animateClickedHeroHeight
        left: animateClickedHeroLeft
        top: animateClickedHeroTop
      ,
        duration: 750
        easing: 'easeOutSine'
        queue: false

      #set data-attributes corresponding to the current situation
      $otherHeroes.each (index, element) =>
        $(element).attr "data-detailed", heroDetailedClose
        $(element).attr "data-switch", heroDetailedSwitchYes
      $clickedHero.attr "data-detailed", heroDetailedOpen
  
    #if clicked hero is not opened
    else
      $clickedHero.css 'z-index':'5'
      $otherHeroes.each (index, element) =>
        $(element).css 'z-index':'0'

      #animate clicked-hero fullscreen; after finishing resize it to 80% width and start dropping other heroes
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

      #setting data-attributes corresponding to situation
      $otherHeroes.each (index, element) =>
        $(element).attr "data-detailed", heroDetailedClose      
        $(element).attr "data-switch", heroDetailedSwitchYes      
      $clickedHero.attr "data-detailed", heroDetailedOpen






