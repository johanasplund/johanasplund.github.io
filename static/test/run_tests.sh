#!/bin/bash
#Compiling into .js files and running tests
coffee -c brainfuck_test.coffee ../brainfuck.coffee
../../node_modules/.bin/test brainfuck_test.js --recursive
#Cleanup
rm ../brainfuck.js brainfuck_test.js
