#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

GOAL=$(( RANDOM % 1000 + 1 ))

echo "Enter your username:"
read NAME
if [[ -z $NAME ]]; then exit; fi
USER_ID=$($PSQL "select user_id from users where name=trim('$NAME')")
# if not found
if [[ -z $USER_ID ]]; then
  # save new user
  INSERT_USER_RESULT="$($PSQL "insert into users(name) values(trim('$NAME'))")"
  # greet new user
  echo "Welcome, $NAME! It looks like this is your first time here."
fi