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
else
  GAMES_RESULT="$($PSQL "select count(*), min(guesses) from games where user_id=$USER_ID group by user_id")"
  readarray -t GAME_STATS <<< "$(echo "$GAMES_RESULT" | sed 's/|/\n/g')"
  echo "Welcome back, $NAME! You have played ${GAME_STATS[0]} games, and your best game took ${GAME_STATS[1]} guesses."
fi
