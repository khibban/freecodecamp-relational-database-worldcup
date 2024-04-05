#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE teams, games")"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
    then
        WINNER_STATEMENT=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
        OPPONENT_STATEMENT=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
        if [[ -z $OPPONENT_STATEMENT ]]
          then
            INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name)  VALUES ('$OPPONENT')")
          fi
        if [[ -z $WINNER_STATEMENT ]]
          then
            INSERT_WINNER=$($PSQL "INSERT INTO teams(name)  VALUES ('$WINNER')")
          fi
        WINNER_STATEMENT=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
        OPPONENT_STATEMENT=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    fi
done

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
    then
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id ) VALUES ($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")
    fi
done
