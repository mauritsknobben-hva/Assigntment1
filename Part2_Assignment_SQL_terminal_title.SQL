The rows with ##### are the rows where i explain what i did ######

pi@raspberrypi:~ $ sudo su postgres
postgres@raspberrypi:/home/pi$ psql
psql (11.9 (Raspbian 11.9-0+deb10u1))
Type "help" for help.

###### CREATE DATABASE called title (title) #####
postgres=# create database title;
CREATE DATABASE
postgres=# \q
postgres@raspberrypi:/home/pi$ exit
exit
pi@raspberrypi:~ $ psql title
psql (11.9 (Raspbian 11.9-0+deb10u1))
Type "help" for help.

###### CREATE TABLE of the dataset #####
title=# CREATE TABLE movies (
title(# url text,
title(# title text,
title(# ReleaseDate text,
title(# Distributor text,
title(# Starring text,
title(# Summary text,
title(# Director text,
title(# Genre text,
title(# Rating text,
title(# Runtime text,
title(# Userscore text,
title(# Metascore text,
title(# scoreCounts text);
CREATE TABLE

##### Copy the dataset "moviesFromMetacritic" into the created table ######
title=# \copy movies FROM '/home/pi/moviesFromMetacritic.csv' with (format csv,header true, delimiter';');
COPY 5229

##### Select the movies "the-wolf-of-wall-street" #####
title=# SELECT * FROM movies where url='the-wolf-of-wall-street';
test=#  ALTER TABLE movies ADD lexemestitle tsvector;
ALTER TABLE
test=# UPDATE movies SET lexemestitle = to_tsvector(title);
UPDATE 5229

##### Make a list of every movie in the dataset with the word "wolf" in the TITLE ######
test=# SELECT url FROM movies WHERE lexemestitle @@ to_tsquery('wolf');
                          url
-------------------------------------------------------
 brotherhood-of-the-wolf
 cry-wolf
 jin-roh-the-wolf-brigade
 teen-wolf-too
 the-wolf-of-wall-street
 teen-wolf
 wolf-creek
 wolf-totem
(8 rows)

###### Create extra column ######
test=# ALTER TABLE movies ADD rank float4;
ALTER TABLE
test=# UPDATE movies SET rank = ts_rank(lexemestitle,plainto_tsquery( (
test(# SELECT title FROM movies WHERE url='the-wolf-of-wall-street')));
UPDATE 5229

##### CREATE TABLE with the top50 best recommendations to see for the movie "the wolf of wall street" ######
test=# CREATE TABLE recommendationsBasedOntitleField AS SELECT url, rank FROM movies WHERE rank >0.01 ORDER BY rank DESC LIMIT 50;
SELECT 8
test=# \copy (SELECT * FROM recommendationsBasedOntitleField) to '/home/pi/RSL/top50recommendationstitle.csv' WITH csv;
COPY 8

Now you have a csv file with the 8 movies based on rank with the word "wolf" in the title

END OF PART 2