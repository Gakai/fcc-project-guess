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
  INSERT_USER_RESULT="$($PSQL "insert into users(name) values(trim('$NAME')) returning user_id")"
  # inserting failed?
  if [[ -z $INSERT_USER_RESULT ]]; then exit; fi
  # save new user id for later
  USER_ID="$(echo "$INSERT_USER_RESULT" | head -1 )"
  # greet new user
  echo "Welcome, $NAME! It looks like this is your first time here."
else
  GAMES_RESULT="$($PSQL "select count(*), min(guesses) from games where user_id=$USER_ID group by user_id")"
  readarray -t GAME_STATS <<< "$(echo "$GAMES_RESULT" | sed 's/|/\n/g')"
  echo "Welcome back, $NAME! You have played ${GAME_STATS[0]} games, and your best game took ${GAME_STATS[1]} guesses."
fi

echo "Guess the secret number between 1 and 1000:"
GUESSES=1
read GUESS
until (( GUESS == GOAL )); do
  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  elif (( GUESS > GOAL )); then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
  (( GUESSES++ ))
  read GUESS
done
echo "You guessed it in $GUESSES tries. The secret number was $GOAL. Nice job!"
ADD_GAME_RESULT="$($PSQL "insert into games(user_id, guesses) values($USER_ID, $GUESSES)")"
