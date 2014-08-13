test = require 'unit.js'
gol = require "../gameoflife"

f = new gol.Field(
  [[".", ".", ".", ".", "."],
   [".", ".", "#", ".", "."],
   [".", ".", ".", "#", "#"],
   [".", "#", "#", "#", "."],
   [".", ".", ".", ".", "."]
  ]
)
f2 = new gol.Field(
  [[".", ".", ".", ".", "."],
   [".", ".", ".", ".", "."],
   [".", ".", "#", ".", "."],
   [".", ".", ".", "#", "."],
   [".", "#", "#", "#", "."]
  ]
)
describe("Field.isAlive()", ->
  it("normal false", -> test.assert.deepEqual(f.isAlive(0, 0), false))
  it("normal true", -> test.assert.deepEqual(f.isAlive(2, 1), true))
  it("modulo X", -> test.assert.deepEqual(f.isAlive(7, 1), true))
  it("modulo Y", -> test.assert.deepEqual(f.isAlive(1, 8), true))
  it("modulo X and Y", -> test.assert.deepEqual(f.isAlive(7, 8), true))
  it("negative index X", -> test.assert.deepEqual(f.isAlive(-1, 2), true))
  it("negative index Y", -> test.assert.deepEqual(f.isAlive(1, -2), true))
)
describe("Field.willLive()", ->
  it("live cell dies of underp.", -> test.assert.deepEqual(f.willLive(2, 1), false))
  it("live cell will live", -> test.assert.deepEqual(f.willLive(2, 3), true))
  it("live cell dies of overp.", -> test.assert.deepEqual(f.willLive(3, 2), false))
  it("dead cell lives (reproduces)", -> test.assert.deepEqual(f.willLive(2, 4), true))
  it("dead cell remain dead", -> test.assert.deepEqual(f.willLive(1, 4), false))
  #it("glider gen 2 live mod Y", -> test.assert.deepEqual(f.willLive(2, 0), true))
)
describe("Field.nextGen()", ->
  it("first generation", ->
    f.nextGen()
    expectedField = [
      [".", ".", ".", ".", "."],
      [".", ".", ".", "#", "."],
      [".", "#", ".", ".", "#"],
      [".", ".", "#", "#", "#"],
      [".", ".", "#", ".", "."]
    ]
    test.assert.deepEqual(f.field, expectedField)
  )
  it("second generation", ->
    f.nextGen()
    expectedField = [
      [".", ".", ".", ".", "."],
      [".", ".", ".", ".", "."],
      ["#", ".", ".", ".", "#"],
      ["#", "#", "#", ".", "#"],
      [".", ".", "#", ".", "."]
    ]
    test.assert.deepEqual(f.field, expectedField)
  )
  it("third generation", ->
    f.nextGen()
    expectedField = [
      [".", ".", ".", ".", "."],
      [".", ".", ".", ".", "."],
      [".", ".", ".", "#", "#"],
      [".", ".", "#", ".", "#"],
      ["#", ".", "#", "#", "."]
    ]
    test.assert.deepEqual(f.field, expectedField)
  )
)
describe("Field.nextGen() glider", ->
  it("first gen", ->
    f2.nextGen()
    expectedField = [
      [".", ".", "#", ".", "."],
      [".", ".", ".", ".", "."],
      [".", ".", ".", ".", "."],
      [".", "#", ".", "#", "."],
      [".", ".", "#", "#", "."]
    ]
    test.assert.deepEqual(f2.field, expectedField)
  )
  it("second gen", ->
    f2.nextGen()
    expectedField = [
      [".", ".", "#", "#", "."],
      [".", ".", ".", ".", "."],
      [".", ".", ".", ".", "."],
      [".", ".", ".", "#", "."],
      [".", "#", ".", "#", "."]
    ]
    test.assert.deepEqual(f2.field, expectedField)
  )
  it("third gen", ->
    f2.nextGen()
    expectedField = [
      [".", ".", "#", "#", "."],
      [".", ".", ".", ".", "."],
      [".", ".", ".", ".", "."],
      [".", ".", "#", ".", "."],
      [".", ".", ".", "#", "#"]
    ]
    test.assert.deepEqual(f2.field, expectedField)
  )
)