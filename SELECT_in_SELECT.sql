--#1 List each country name where the population is larger than that of 'Russia'.
SELECT name
FROM world
WHERE population >
     (SELECT population
FROM world
WHERE name='Russia');

--#2 Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name
FROM world
WHERE continent = 'Europe' AND gdp/population >
  (SELECT gdp/population
  FROM world
  WHERE name = 'United kingdom');

--#3 List the name and continent of countries in the continents containing
--# either Argentina or Australia. Order by name of the country.
SELECT name, continent
FROM world
WHERE continent = (SELECT continent
  FROM world
  WHERE name = 'Argentina')
  OR
  continent = (SELECT continent
  FROM world
  WHERE name = 'Australia')
ORDER BY name;

--#4 Which country has a population that is more than Canada but less than Poland?
--# Show the name and the population.
SELECT name, population
FROM world
WHERE population > (SELECT population
  FROM world
  WHERE name = 'Canada')
  AND
  population < (SELECT population
  FROM world
  WHERE name = 'Poland');

--#5 Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany
--# Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
SELECT name,
  CONCAT(ROUND(100*population/(SELECT population
  FROM world
  WHERE name = 'Germany'))
        , '%')
FROM world
WHERE continent = 'Europe';

--#6 Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
SELECT name
FROM world
WHERE gdp > ALL(SELECT MAX(gdp)
FROM world
WHERE continent = 'Europe');



--#7 Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, area
FROM world x
WHERE area >= ALL
    (SELECT area
FROM world y
WHERE y.continent=x.continent
  AND area>0);

--# this also work in place of the above...
SELECT w1.continent, name, w1.area
FROM world AS w1
  JOIN (SELECT continent, MAX(area) AS area
  FROM world
  GROUP BY continent) AS w2
  ON w1.continent = w2.continent
    AND w1.area = w2.area;




--#8 List each continent and the name of the country that comes first alphabetically.
SELECT continent, name
FROM world x
WHERE name = (SELECT name
FROM world y
WHERE  x.continent =  y.continent
ORDER BY name ASC
                  LIMIT 1);
-- you can also do the above likewise as :
SELECT continent
, MIN
(name) AS name
FROM world
GROUP BY continent
ORDER by continent;


--#9 Find the continents where all countries have a population <= 25000000.
--# Then find the names of the countries associated with these continents.
--# Show name, continent and population.
SELECT name, continent, population
FROM world x
WHERE NOT EXISTS (                  -- there are no countries
   SELECT *
FROM world y
WHERE y.continent = x.continent -- on the same continent
  AND y.population > 25000000     -- with more than 25M population
   );


--#10 Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
SELECT name, continent
FROM world x
WHERE population > ALL(SELECT population*3
FROM world y
WHERE y.continent=x.continent AND y.name != x.name);