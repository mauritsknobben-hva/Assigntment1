The rows with ##### are the rows where i explain what i did ######

pi@raspberrypi:~ $ sudo su postgres
postgres@raspberrypi:/home/pi$ psql
psql (11.9 (Raspbian 11.9-0+deb10u1))
Type "help" for help.

###### CREATE DATABASE called tsum (Summary) #####
postgres=# create database tsum;
CREATE DATABASE
postgres=# \q
postgres@raspberrypi:/home/pi$ exit
exit
pi@raspberrypi:~ $ psql tsum
psql (11.9 (Raspbian 11.9-0+deb10u1))
Type "help" for help.

###### CREATE TABLE of the dataset #####
tsum=# CREATE TABLE movies (
tsum(# url text,
tsum(# title text,
tsum(# ReleaseDate text,
tsum(# Distributor text,
tsum(# Starring text,
tsum(# Summary text,
tsum(# Director text,
tsum(# Genre text,
tsum(# Rating text,
tsum(# Runtime text,
tsum(# Userscore text,
tsum(# Metascore text,
tsum(# scoreCounts text);
CREATE TABLE

##### Copy the dataset "moviesFromMetacritic" into the created table ######
tsum=# \copy movies FROM '/home/pi/moviesFromMetacritic.csv' with (format csv,header true, delimiter';');
COPY 5229

##### Select the movie "pirates-of-the caribbean-the-curse-of-the-black-pearl" #####
tsum=# SELECT * FROM movies where url='pirates-of-the-caribbean-the-curse-of-the-black-pearl';
tsum=# ALTER TABLE movies ADD lexemesSummary tsvector;
ALTER TABLE
tsum=# UPDATE movies SET lexemesSummary = to_tsvector(Summary);
UPDATE 5229

##### Make a list of every movie in the dataset with the word "pirate" in the SUMMARY ######
tsum=# SELECT url FROM movies WHERE lexemesSummary @@ to_tsquery('pirate');
                          url
-------------------------------------------------------
 bukowski-born-into-this
 captain-phillips
 lucky-number-slevin
 pan
 the-pirates!-band-of-misfits
 pirates-of-the-caribbean-the-curse-of-the-black-pearl
 pirates-of-the-caribbean-at-worlds-end
 the-pirates-who-dont-do-anything-a-veggietales-movie
 pirates-of-the-caribbean-dead-men-tell-no-tales
 the-princess-bride
 stardust
(11 rows)

###### Create extra column ######
tsum=# ALTER TABLE movies ADD rank float4;
ALTER TABLE
tsum=# UPDATE movies SET rank = ts_rank(lexemesSummary,plainto_tsquery( (
tsum(#  SELECT Summary FROM movies WHERE url='pirates-of-the-caribbean-the-curse-of-the-black-pearl')));
UPDATE 5229

##### CREATE TABLE with the top50 best recommendations to see for the movie "pirates of the carribbean the curse of the black pearl" ######
tsum=# CREATE TABLE recommendationsBasedOnSummaryFieldvONE AS SELECT url, rank FROM movies WHERE rank > 0.01 ORDER BY rank DESC LIMIT 50;
SELECT 50

###### COPY the top50 list into a csv file #####
tsum=# \copy (SELECT * FROM recommendationsBasedOnSummaryFieldvOne) to '/home/pi/RSL/top50recommendationsvONE.csv WITH csv;
COPY 50
tsum=# \copy (SELECT * FROM recommendationsBasedOnSummaryFieldvOne) to '/home/pi/RSL/top50recommendationsvONE.csv' WITH csv;
COPY 50
END OF PART 1 OF THE ASSIGNMENT