class Tape
  constructor: (@tape, @output, @promptedChars) ->
  addAt: (pos, val) =>
    if val == undefined
      toAdd = 1
    else
      toAdd = val
    if pos of @tape and toAdd == 1
      @tape[pos] += toAdd
    else if @tape[pos] == undefined or toAdd > 1
      @tape[pos] = toAdd
  subAt: (pos) =>
    if pos of @tape and @tape[pos] > 0
      @tape[pos] -= 1
    else
      @tape[pos] = 0
  printAtIndex: (pos) =>
    @output.push(String.fromCharCode(@tape[pos]))

class Pointer
  constructor: (@x) ->
  moveUp: =>
    @x += 1
  moveDown: =>
    @x -= 1

doInstruction = (char, t, p, manualInputIndex, manualInputs...) ->
  switch char
    when ">"
      p.moveUp()
      return ">"
    when "<"
      p.moveDown()
      return "<"
    when "+"
      t.addAt(p.x)
      return "+"
    when "-"
      t.subAt(p.x)
      return "-"
    when "."
      t.printAtIndex(p.x)
      return "."
    when ","
      if manualInputIndex == undefined
        t.addAt(p.x, prompt("Input character").charCodeAt(0))
      else
        t.addAt(p.x, manualInputs[manualInputIndex].charCodeAt(0))
      return ","

findMatchingBracket = (code, pos) ->
  counter = 1
  for i in [0..pos]
    currentChar = code[pos-i-1]
    if currentChar == "]"
      counter += 1
    else if currentChar == "["
      counter -= 1
    if counter == 0
      return pos-i
  throw new SyntaxError("Missing starting bracket")

# Comment everything below this when testing
input = document.getElementById("input")
tape = new Tape({0: 0}, [])
pointer = new Pointer(0)
currChar = 0
intervalId = 0
stepOnly = false
speed = 500
$(document).ready(->
  moveTape = (dir) ->
    olower = $("#outputLower")
    oupper = $("#outputUpper")
    for i in [0..9]
      childLower = $("#outputLower li:nth-child("+i.toString()+")")
      if dir == ">"
        childText = (parseInt(childLower.text())+1).toString()
      else if dir == "<"
        childText = (parseInt(childLower.text())-1).toString()
      childLower.text(childText)
      childUpper = $("#outputUpper li:nth-child("+i.toString()+")")
      if tape.tape[childLower.text()] == undefined
        childUpper.text("0")
      else
        childUpper.text(tape.tape[childLower.text()].toString())
  adjustValue = (dir) ->
    valueChild = $("#outputUpper li:nth-child(5)")
    if dir == "+"
      valueChild.text((parseInt(valueChild.text())+1).toString())
    else if dir == "-"
      valueChild.text((parseInt(valueChild.text())-1).toString())
  logToPrinted = ->
    if $("#printed").text() == "Output"
      $("#printed").text("")
    textarea = $("#printed")
    textarea.text("").append(tape.output)
    textarea.css({"font-style": "normal"})

  eventLoop = ->
      inputCode = input.value
      instruction = doInstruction(inputCode[currChar], tape, pointer)
      if instruction == ">" or instruction == "<"
        moveTape(instruction)
      else if instruction == "+" or instruction == "-"
        adjustValue(instruction)
      else if instruction == "."
        logToPrinted()
      else if instruction == ","
        $("#outputUpper li:nth-child(5)").text(tape.tape[pointer.x])
      if inputCode[currChar]  == "]" and tape.tape[pointer.x] != 0  and tape.tape[pointer.x] != undefined
        currChar = findMatchingBracket(inputCode, currChar)
      else
        currChar += 1
      # Move selection
      input.selectionStart = currChar
      input.selectionEnd = currChar+1
      input.focus()
      if currChar >= inputCode.length
        $("#status div").attr("class", "fa fa-pause")
        clearInterval(intervalId)
        input.blur()
      if stepOnly
        clearInterval(intervalId)

  $("#reset").click(->
    $("#status div").attr("class", "fa fa-fast-backward")
    clearInterval(intervalId)
    currChar = 0
    input.blur()
    for i in [0..9]
      childUpper = $("#outputUpper li:nth-child("+i.toString()+")")
      childLower = $("#outputLower li:nth-child("+i.toString()+")")
      childUpper.text("0")
      childLower.text((i-5).toString())
    $("#printed").css({"font-style": "normal"})
    $("#printed").text("Output")
    tape = new Tape({0: 0}, [])
    pointer = new Pointer(0)
  ) 
  $("#backward").click(->
    clearInterval(intervalId)
    speed = 500
    intervalId = setInterval(eventLoop, speed)
    $("#status div").attr("class", "fa fa-backward")
  )
  $("#play").click(->
    $("#status div").attr("class", "fa fa-play")
    input.selectionStart = currChar
    input.selectionEnd = currChar+1
    input.focus()
    stepOnly = false
    if intervalId
      clearInterval(intervalId)
    intervalId = setInterval(eventLoop, speed)
  )
  $("#pause").click(->
    input.focus()
    $("#status div").attr("class", "fa fa-pause")
    clearInterval(intervalId)
  )
  $("#step-forward").click(->
    $("#status div").attr("class", "fa fa-step-forward")
    stepOnly = true
    if intervalId
      clearInterval(intervalId)
    intervalId = setInterval(eventLoop, speed)
  )
  $("#forward").click(->
    clearInterval(intervalId)
    speed = 100
    intervalId = setInterval(eventLoop, speed)
    $("#status div").attr("class", "fa fa-forward")
  )
  $("#end").click(->
    inputCode = input.value
    while currChar < inputCode.length
      eventLoop()
  )

)

# Uncomment when testing
#exports.findMatchingBracket = findMatchingBracket
#exports.doInstruction = doInstruction
#exports.Tape = Tape
#exports.Pointer = Pointer