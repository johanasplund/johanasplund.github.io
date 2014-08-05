test = require 'unit.js'
bf = require "../brainfuck"

describe("findMatchingBracket(code, pos)", ->
  it("plain bracket with random text", ->
    inputPlain = "Random text [ABCDEFGH]"
    getIndex = bf.findMatchingBracket(inputPlain, inputPlain.indexOf("]"))
    test.assert.deepEqual(inputPlain[getIndex], "A")
  )
  it("nested brackets", ->
    inputNested = "[A[B[C[D]]]]"
    aIndex = bf.findMatchingBracket(inputNested, inputNested.length-1)
    bIndex = bf.findMatchingBracket(inputNested, inputNested.length-2)
    cIndex = bf.findMatchingBracket(inputNested, inputNested.length-3)
    dIndex = bf.findMatchingBracket(inputNested, inputNested.length-4)
    test.assert.deepEqual(inputNested[aIndex], "A")
    test.assert.deepEqual(inputNested[bIndex], "B")
    test.assert.deepEqual(inputNested[cIndex], "C")
    test.assert.deepEqual(inputNested[dIndex], "D")
  )
  it("multiple nonnested brackets", ->
    inputHalfNested = "[ABC]>[DEF]"
    firstIndex = bf.findMatchingBracket(inputHalfNested, inputHalfNested.indexOf("]"))
    lastIndex = bf.findMatchingBracket(inputHalfNested, inputHalfNested.lastIndexOf("]"))
    test.assert.deepEqual(inputHalfNested[firstIndex], "A")
    test.assert.deepEqual(inputHalfNested[lastIndex], "D")
  )
  it("throwing syntax error correctly", ->
    inputSyntaxError = ">>>>>>>]+"
    shouldThrow = ->
      bf.findMatchingBracket(inputSyntaxError, inputSyntaxError.lastIndexOf("]"))
    test.assert.throws(shouldThrow, SyntaxError)
  )       
)

tape = new bf.Tape({0: 0}, [])
pointer = new bf.Pointer(0)
setup_test_doInstruction = (code, inputs...) ->
  tape.tape = {0: 0}
  tape.output = []
  pointer.x = 0
  inputCode = code
  currChar = 0
  inputcounter = -1
  while currChar < inputCode.length
    if inputCode[currChar] == ","
      inputcounter += 1
    bf.doInstruction(inputCode[currChar], tape, pointer, inputcounter, inputs...)
    if inputCode[currChar]  == "]" and tape.tape[pointer.x] != 0
      currChar = bf.findMatchingBracket(inputCode, currChar)
    else
      currChar += 1

describe("doInstruction(code, pos, tape, pointer, manualInputIndex, manualInputs...)", ->
  it("move, add >+", ->
    setup_test_doInstruction(">+")
    test.assert.deepEqual(tape.tape, {"0": 0, "1": 1})
  )
  it("move, add, subtract >+-", ->
    setup_test_doInstruction(">+-")
    test.assert.deepEqual(tape.tape, {"0": 0, "1": 0})
  )
  it("move, subtract >-", ->
    setup_test_doInstruction(">-")
    test.assert.deepEqual(tape.tape, {"0": 0, "1": 0})
  )
  it("random arithmetic and movement +>++<->>+++", ->
    setup_test_doInstruction("+>++<->>+++")
    test.assert.deepEqual(tape.tape, {"0": 0, "1": 2, "2": 3})
  )
  it("multiplication 2*2 >++[<++>-]", ->
    setup_test_doInstruction(">++[<++>-]")
    test.assert.deepEqual(tape.tape, {"0": 4, "1": 0})
  )
  it("multiplication and output ! >+++++++++++[<+++>-]<.", ->
    setup_test_doInstruction(">+++++++++++[<+++>-]<.")
    test.assert.deepEqual(tape.output.join(""), "!")
  )
  it("simple cat program ,.", ->
    setup_test_doInstruction(",.", "a")
    test.assert.deepEqual(tape.output.join(""), "a")
  )
  it(", should overwrite current ,,.", ->
    setup_test_doInstruction(",,.", "a", "b")
    test.assert.deepEqual(tape.output.join(""), "b")
  )
  it("multiple inputs ,.>,.>,.>,." , ->
    setup_test_doInstruction(",.>,.>,.>,.", "a", "b", "c", "d")
    test.assert.deepEqual(tape.output.join(""), "abcd")
  )
)


