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
        resetToDefault element, left, 
          duration:750
          easing: 'easeInSine'
        left+=25        
    
    #if clicked-hero is not opened but its one of the other heroes (side-navigation-heroes)
    else if parseInt $clickedHero.attr("data-switch"), 10 is 1
      #hero which is currently in detailed view
      $heroToSwap = $(".hero[data-detailed=1]")
      
      #setting correct z-index
      setZIndex $clickedHero, 5
      setZIndex $otherHeroes, 0

      #animate clicked hero in detailed view
      animateDetailedHero $clickedHero

      $deepCopyClickedHero = $clickedHero.clone()

      #animate detailed-hero in side-navigation where the clicked hero was
      animateSwappedHero $heroToSwap, $deepCopyClickedHero

      #set data-attributes corresponding to the current situation
      $otherHeroes.each (index, element) =>
        $(element).attr "data-detailed", heroDetailedClose
        $(element).attr "data-switch", heroDetailedSwitchYes
      $clickedHero.attr "data-detailed", heroDetailedOpen
      $clickedHero.attr "data-switch", heroDetailedSwitchNo
  
    #if no hero is open
    else
      setZIndex $clickedHero, 5
      setZIndex $otherHeroes, 0

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

            $clickedHero.delay(250).animate
              width: '80%'
            ,
              duration: 350
              complete: ->
                animateSideHeroes $firstOtherHero, $secondOtherHero, $thirdOtherHero

      #setting data-attributes corresponding to situation
      $otherHeroes.each (index, element) =>
        $(element).attr "data-switch", heroDetailedSwitchYes      
      $clickedHero.attr "data-detailed", heroDetailedOpen

animateSideHeroes = ($first, $second, $third)->
  opt =
    duration: 350
    easing: 'easeOutSine'

  

  $third.delay(250).clearQueue().animate
    top: '68%'
  ,
    duration: opt.duration
    easing: opt.easing
    complete: ->
      $second.clearQueue().animate
        top: '34%'
      ,
        duratino: opt.duration
        easing: opt.easing
        complete: ->
          $first.clearQueue().animate
            top: '0%'
          ,
            duration: opt.duration
            easing: opt.easing

animateDetailedHero = ($obj) ->
  $obj.clearQueue().animate
    width: '80%'
    height: '100%'
    left: '0%'
    top: '0%'
  ,
    duration: 750
    easing: 'easeOutSine'
    queue: false

animateSwappedHero = ($obj, $copy) ->
  $obj.clearQueue().animate
    width: $copy.css "width"
    height: $copy.css "height"
    left: $copy.css "left"
    top: $copy.css "top"
  ,
    duration: 750
    easing: 'easeOutSine'
    queue: false

resetToDefault = (obj, attr, opt) ->
  $(obj).css 'z-index':'0'
  $(obj).stop(true, false).animate 
    width:'25%'
    height:'100%'
    top:'0%'
    left:attr+'%'
  ,
    opt

setZIndex = ($obj, value) ->
  $obj.each (index, element) =>
    $(element).css 'z-index': value.toString()