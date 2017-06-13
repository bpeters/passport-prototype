#!/bin/bash

testrpc &
PID1=$!
truffle test
kill $PID1
