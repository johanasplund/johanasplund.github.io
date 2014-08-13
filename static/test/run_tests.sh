#!/bin/bash
# Compiling into .js files and running tests
coffee -c brainfuck_test.coffee ../brainfuck.coffee
coffee -c gameoflife_test.coffee ../gameoflife.coffee
# Running test suite
../../node_modules/.bin/test . --recursive
# Cleanup
rm ../brainfuck.js brainfuck_test.js
rm ../gameoflife.js gameoflife_test.js
