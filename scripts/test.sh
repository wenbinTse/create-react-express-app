#!/bin/bash

cd server
npm run build-ts
res=$?
if [[ $res -ne 0 ]]; then
  echo 'server build errored'
  exit $res
fi

REACT_APP_ENV=test node dist/frontend_test/pretest.js
res=$?
if [[ $res -ne 0 ]]; then
  echo 'pretest script errored'
  exit $res
fi

# Catch server-side errors in the file "server.stderr". See server/scripts/test.sh for details.
REACT_APP_ENV=test node dist/server.js 2> frontend_test.stderr &
# Store nodejs server process pid so that we can later kill it.
echo $! > frontendTest.pid

cd ..
CI=true node scripts/test.js --env=jsdom
resTest=$?

cd server
REACT_APP_ENV=test node dist/frontend_test/posttest.js
res=$?
if [[ $res -ne 0 ]]; then
  echo 'posttest script errored'
  exit $res
fi

# Look for "Error" keyword in the server stderr. See server/scripts/test.sh for details.
serverStderr=`grep "Error" frontend_test.stderr`
cat frontend_test.stderr
rm frontend_test.stderr

# Stop the nodejs server. In case the server errored, kill reports "No such process".
kill `cat frontendTest.pid`
rm frontendTest.pid

if [[ ! -z $serverStderr ]]; then
  # Server is not working for frontend tests.
  echo 'something was wrong with the frontend test server'
  exit 1
fi

if [[ $resTest -ne 0 ]]; then
  # Frontend tests failed.
  exit $resTest
fi
