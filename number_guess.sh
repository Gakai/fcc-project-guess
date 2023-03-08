#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

GOAL=$(( RANDOM % 1000 + 1 ))

echo "Enter your username:"
read NAME
if [[ -z $NAME ]]; then exit; fi
USER_ID=$($PSQL "select user_id from users where name='$NAME'")
