--#1 List the films where the yr is 1962 [Show id, title]
SELECT id, title
FROM movie
WHERE yr=1962;

--#2 Give year of 'Citizen Kane'
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

--#3 List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE 'Star Trek%'
ORDER BY yr;

--#4 What id number does the actor 'Glenn Close' have?
SELECT actor.id
FROM actor
WHERE actor.name = 'Glenn Close';

--#5 What is the id of the film 'Casablanca'.
SELECT movie.id
FROM movie
WHERE movie.title = 'Casablanca';

--#6 Obtain the cast list for 'Casablanca'.
-- what is a cast list? --
-- Use movieid=11768, (or whatever value you got from the previous question)

SELECT actor.name
FROM actor
  JOIN casting
  ON actor.id = casting.actorid
WHERE casting.movieid = 11768;

--#7 Obtain the cast list for the film 'Alien'
SELECT actor.name
FROM actor
  JOIN casting
  ON actor.id = casting.actorid
  JOIN movie
  ON casting.movieid = movie.id
WHERE movie.title = 'Alien'

--#8 List the films in which 'Harrison Ford' has appeared
SELECT movie.title
FROM movie
  JOIN casting
  ON movie.id = casting.movieid
  JOIN actor
  ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford';

--#9 List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT movie.title
FROM movie
  JOIN casting
  ON movie.id = casting.movieid
  JOIN actor
  ON casting.actorid = actor.id
WHERE actor.name = 'Harrison Ford' AND casting.ord <> 1;

--#10 List the films together with the leading star for all 1962 films.
SELECT movie.title, actor.name
FROM movie
  JOIN casting
  ON movie.id = casting.movieid
  JOIN actor
  ON casting.actorid = actor.id
WHERE movie.yr = 1962 AND casting.ord = 1;

--#11 Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr, COUNT(title)
FROM movie
  JOIN casting ON movie.id=casting.movieid
  JOIN actor ON casting.actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

--#12 List the film title and the leading actor for all of the films 'Julie Andrews' played in.
-- Did you get "Little Miss Marker twice"? --
-- Julie Andrews starred in the 1980 remake of Little Miss Marker and not the original(1934).
-- Title is not a unique field, create a table of IDs in your subquery
SELECT DISTINCT m.title, a.name
FROM (SELECT movie.*
  FROM movie
    JOIN casting
    ON casting.movieid = movie.id
    JOIN actor
    ON actor.id = casting.actorid
  WHERE actor.name = 'Julie Andrews') AS m
  JOIN (SELECT actor.*, casting.movieid AS movieid
  FROM actor
    JOIN casting
    ON casting.actorid = actor.id
  WHERE casting.ord = 1) as a
  ON m.id = a.movieid
ORDER BY m.title;

--#13 Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT actor.name
FROM actor
  JOIN casting
  ON casting.actorid = actor.id
WHERE casting.ord = 1
GROUP BY actor.name
HAVING COUNT(*) >= 15;

--#14 List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT movie.title, COUNT(casting.actorid)
FROM movie
  JOIN casting
  ON movie.id = casting.movieid
WHERE movie.yr = 1978
GROUP BY movie.title
ORDER BY COUNT(casting.actorid) DESC, movie.title;

--#15 List all the people who have worked with 'Art Garfunkel'.
SELECT a.name
FROM (SELECT movie.*
  FROM movie
    JOIN casting
    ON casting.movieid = movie.id
    JOIN actor
    ON actor.id = casting.actorid
  WHERE actor.name = 'Art Garfunkel') AS m
  JOIN (SELECT actor.*, casting.movieid
  FROM actor
    JOIN casting
    ON casting.actorid = actor.id
  WHERE actor.name != 'Art Garfunkel') as a
  ON m.id = a.movieid;