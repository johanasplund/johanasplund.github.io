$(document).ready(->
  $(".bigbtn").mouseenter(->
    $(this).fadeTo(190, 0.6)
  )
  $(".bigbtn").mouseleave(->
    $(this).fadeTo(190, 1)
  )
  $("body").mousemove((e) ->
    w = $(this).css("width")[..-3]
    h = $(this).css("height")[..-3]
    b = $(".bigbtn")
    x = e.pageX-w/2
    y = e.pageY-h/2
    topFactor = 150
    b.css({"top": (y+w/2)/topFactor, "left": (x+h/2)/topFactor})
  )
)