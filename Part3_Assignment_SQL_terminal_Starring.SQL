The rows with ##### are the rows where i explain what i did ######

pi@raspberrypi:~ $ sudo su postgres
spostgres@raspberrypi:/home/pi$ psql
psql (11.9 (Raspbian 11.9-0+deb10u1))
Type "help" for help.

###### CREATE DATABASE called starring (Starring) #####
postgres=# create database starring;
CREATE DATABASE
postgres=# \q
postgres@raspberrypi:/home/pi$ exit
exit
pi@raspberrypi:~ $ psql starring
psql (11.9 (Raspbian 11.9-0+deb10u1))
Type "help" for help.

###### CREATE TABLE of the dataset #####
starring=# CREATE TABLE movies (
starring(# url text,
starring(# title text,
starring(# ReleaseDate text,
starring(# Distributor text,
starring(# Starring text,
starring(# Summary text,
starring(# Director text,
starring(# Genre text,
starring(# Rating text,
starring(# Runtime text,
starring(# Userscore text,
starring(# Metascore text,
starring(# scoreCounts text);
CREATE TABLE

##### Copy the dataset "moviesFromMetacritic" into the created table ######
starring=# \copy movies FROM '/home/pi/moviesFromMetacritic.csv' with (format csv,header true, delimiter';');
COPY 5229

##### Make vector of Starring #####
starring=# ALTER TABLE movies ADD lexemesStarring tsvector;
ALTER TABLE
starring=# UPDATE movies SET lexemesStarring = to_tsvector(Starring);
UPDATE 5229

starring=# ALTER TABLE movies ADD lexemesStarring tsvector;
ALTER TABLE
starring=# UPDATE movies SET lexemesStarring = to_tsvector(Starring);
UPDATE 5229

##### Make a list of every movie in the dataset with an actor named "Jason"######
starring=# SELECT url FROM movies WHERE lexemesStarring @@ to_tsquery('Jason');
        url
-------------------
 a-cure-for-wellness
 the-alamo
 alvin-and-the-chipmunks-the-road-chip
 alvin-and-the-chipmunks
 alvin-and-the-chipmunks-the-squeakquel
 white-house-down
 american-pie
 american-pie-2
 american-wedding
 amityville-the-awakening
 the-angry-birds-movie
 anomalisa
 eight-below
 anything-else
 bankjob
 better-luck-tomorrow
 zero-dark-thirty
 blue-thunder
 bullet-to-the-head
 the-rage-carrie-2
 clerks-ii
 crank
 crank-high-voltage
 dawn-of-the-planet-of-the-apes
 dazed-and-confused
 death-race
 die-mommie-die!
 despicable-me
 diary-of-a-wimpy-kid-the-long-haul
 district-9
 dunston-checks-in
 dragon-wars-d-war
 dreamcatcher
 earth-to-echo
 the-end-of-the-tour
 existenz
 furious-7
 facing-the-giants
 the-five-year-engagement
 forgetting-sarah-marshall
 free-willy
 fury
 the-fate-of-the-furious
 good-time
 the-great-gatsby
 the-grudge
 (46 rows)
 
###### Create extra column ######
starring=# SELECT url FROM movies WHERE lexemesStarring @@ to_tsquery('Jason');
starring=# ALTER TABLE movies ADD ranks float4;
ALTER TABLE
starring=# UPDATE movies SET rank = ts_rank(lexemesStarring,plainto_tsquery( (
starring(# SELECT Starring FROM movies WHERE url='Jason')));
UPDATE 5229

##### CREATE TABLE with the top50 best recommendations to see for movies with an actor named "Jason" ######
starring=# CREATE TABLE recommendationsBasedOnStarringField3 AS SELECT url, rank FROM movies WHERE rank > 0.01 ORDER BY rank DESC LIMIT 50;
SELECT 46
starring=# \copy (SELECT * FROM recommendationsBasedOnStarringField3) to '/home/pi/RSL/top50recommendationsStarring.csv' WITH csv;
COPY 46

Now you have a csv file with the 46 movies based on rank with an actor named "Jason"

END OF PART 3