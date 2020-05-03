-- #1 Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
SELECT goal.matchid, goal.player
FROM goal
WHERE goal.teamid = 'GER';

--#2 Show id, stadium, team1, team2 for just game 1012
SELECT game.id, game.stadium, game.team1, game.team2
FROM game
WHERE game.id = 1012;

--#3 Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT player, teamid, stadium, mdate
FROM game
  JOIN goal
  ON id = matchid
WHERE teamid = 'GER';

--#4 Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1, team2, player
FROM game
  JOIN goal
  ON id = matchid
WHERE player LIKE 'Mario%';

--#5 Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
FROM goal
  JOIN eteam
  ON teamid = id
WHERE gtime <= 10;

--#6 List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname
FROM game
  JOIN eteam
  ON game.team1 = eteam.id
WHERE eteam.teamname = 'Greece';

--#7 List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT goal.player
FROM game
  JOIN goal
  ON game.id = goal.matchid
WHERE game.stadium LIKE 'National Stadium%';

--#8 The example query shows all goals scored in the Germany-Greece quarterfinal.

--Instead show the name of all players who scored a goal against Germany.
--HINT
--Select goals scored only by non-German players in matches where GER was the id of either team1 or team2.
--You can use teamid!='GER' to prevent listing German players.
--You can use DISTINCT to stop players being listed twice.
SELECT DISTINCT goal.player
FROM game
  JOIN goal
  ON goal.matchid = game.id
WHERE goal.teamid != 'GER' AND (game.team1 = 'GER' OR game.team2 = 'GER');

--#9 Show teamname and the total number of goals scored.
--COUNT and GROUP BY
--You should COUNT(*) in the SELECT line and GROUP BY teamname
SELECT teamname, COUNT(goal.teamid)
FROM eteam
  JOIN goal
  ON eteam.id = goal.teamid
GROUP BY teamname;

--#10 Show the stadium and the number of goals scored in each stadium.
SELECT stadium, COUNT(game.id)
FROM game
  JOIN goal
  ON game.id = goal.matchid
GROUP BY stadium;

--#11 For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid, mdate, COUNT(teamid)
FROM game
  JOIN goal
  ON goal.matchid = game.id
WHERE (game.team1 = 'POL' OR game.team2 = 'POL')
GROUP BY goal.matchid, game.mdate;

--#12 For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT goal.matchid, game.mdate, COUNT(teamid)
FROM game
  JOIN goal
  ON game.id = goal.matchid
WHERE goal.teamid = 'GER' AND (game.team1 = 'GER' OR game.team2 = 'GER')
GROUP BY goal.matchid;

--#13 List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
-- Sort your result by mdate, matchid, team1 and team2.
SELECT mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1,
  team2,
  SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
FROM game
  LEFT JOIN goal
  ON matchid = id
GROUP BY mdate, matchid, team1, team2;