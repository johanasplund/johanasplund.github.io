class Field
  constructor: (@field) ->
    @X = @field[0].length
    @Y = @field.length
  getChar: (x, y) =>
    return @field[y % @Y][x % @X]
  isAlive: (x, y) =>
    if x < 0
      x = @X+x
    if y < 0
      y = @Y+y
    if @getChar(x, y) == "#"
      return true
    else
      return false
  printField: =>
    for row in @field
      console.log row.join("")
  willLive: (x, y) =>
    numOfAlive = 0
    for j in [-1..1]
      for i in [-1..1]
        if i == 0 and j == 0
          continue
        # console.log x, y, @isAlive(x + i, y + j), x+i, y+j
        if @isAlive(x + i, y + j)
          numOfAlive += 1
    if @isAlive(x, y)
      if numOfAlive < 2 or numOfAlive > 3
        return false 
      else
        return true
    else if numOfAlive == 3 
      return true
    else 
      return false
  nextGen: =>
    next = new Array(@Y)
    for y in [0..@Y-1]
      next[y]  = new Array(@X)
      for x in [0..@X-1]
        if @willLive(x, y)
          next[y][x] = "#"
        else
          next[y][x] = "."
    @field = next

getRandomField = (arr) -> 
  for row, i in arr
    for char, j in row
      if Math.random() <= 0.2
        arr[i][j] = "#"
      else
        arr[i][j] = "."
  return new Field(arr)

# Comment everything below this when testing
RUN = false
rects = []
fArr = new Array(49)
for j in [0..49]
  fArr[j] = new Array(69)
f = new Field(fArr)

paper.install(window)
$(document).ready(->
  createSelection = (X,Y) ->
    rects.push(new Path.Rectangle({
      topLeft: [X,Y]
      bottomRight: [X+10, Y+10]
      strokeColor: "black"
      fillColor: "white"
    }))
  removeSelection = (X,Y) ->
    for rect in rects
      if rect.position.x-5 == X and rect.position.y-5 == Y
        rect.remove()
  drawGrid = (field) ->
    for y in [0..49]
      for x in [0..69]
        if f.getChar(x, y) == "#"
          createSelection(x*10, y*10)
  clearGrid = ->
    for rect in rects
      rect.remove()
  canv = document.getElementById("game")
  paper.setup(canv)
  for j in [1..49]
    new Path.Line({
      from: [0, 10*j]
      to: [view.size.width, 10*j]
      strokeColor: "black"
    })
  for i in [1..69]
    new Path.Line({
      from: [10*i,0]
      to: [10*i,view.size.height]
      strokeColor: "black"
    })
  view.draw()
  tool = new Tool()
  tool.onMouseDrag = (event) ->
    X = Math.floor(event.point.x/10)*10
    Y = Math.floor(event.point.y/10)*10
    createSelection(X, Y)
    f.field[Y/10][X/10] = "#"
  tool.onMouseDown = (event) ->
    X = Math.floor(event.point.x/10)*10
    Y = Math.floor(event.point.y/10)*10
    if f.getChar(X/10, Y/10) == "#"
      removeSelection(X, Y)
      f.field[Y/10][X/10] = "."
    else
      createSelection(X, Y)
      f.field[Y/10][X/10] = "#"
  view.onFrame = (event) ->
    if RUN
      clearGrid()
      f.nextGen()
      drawGrid(f.field)
  $("#random-field").click(->
    clearGrid()
    f = getRandomField(fArr)
    drawGrid(f.field)
  )
  $("#clear-field").click(->
    clean = new Array(49)
    for j in [0..49]
      clean[j] = new Array(69)
    f.field = clean
    clearGrid()
    if $(this).hasClass("fa fa-play")
      $(this).removeClass("fa fa-play")
      $(this).addClass("fa fa-pause")
      RUN = false
  )

  $("#glider-gun").click(->
    gun = new Array(49)
    for j in [0..49]
      gun[j] = new Array(69)
    coords = [
      [1, 25], [2, 23], [2, 25], [3, 13], [3, 14], [3, 21], [3, 22], [3, 35], [3, 36],
      [4, 12], [4, 16], [4, 21], [4, 22], [4, 35], [4, 36], [5, 1], [5, 2], [5, 11],
      [5, 17], [5, 21], [5, 22], [6, 1], [6, 2], [6, 11], [6, 15], [6, 17], [6, 18],
      [6, 23], [6, 25], [7, 11], [7, 17], [7, 25], [8, 12], [8, 16], [9, 13], [9, 14]
    ]
    for c in coords
      gun[c[0]][c[1]] = "#"
    f.field = gun
    clearGrid() 
    drawGrid(f.field)
    if $(this).hasClass("fa fa-play")
      $(this).removeClass("fa fa-play")
      $(this).addClass("fa fa-pause")
      RUN = false
  )

  $("#pause-toggle").click(->
    if $(this).hasClass("fa fa-pause")
      $(this).removeClass("fa fa-pause")
      $(this).addClass("fa fa-play")
      RUN = false
    else
      RUN = true
      $(this).removeClass("fa fa-play")
      $(this).addClass("fa fa-pause")
  )
)

# Uncomment when testing
# exports.Field = Field