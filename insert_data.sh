#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

# ADD TEAMS and GAMES for winner
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then

    # insert TEAM names
    INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
    INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")

    #GET OPPONENT AND WINNER ID
    WINNER_ID=$($PSQL "SELECT TEAM_ID FROM TEAMS WHERE name='$WINNER'")  
    OPPONENT_ID=$($PSQL "SELECT TEAM_ID FROM TEAMS WHERE name='$OPPONENT'")  

    INSERT_GAMES_RESULT=$($PSQL "insert into GAMES(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  fi
done 

