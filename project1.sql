SELECT name
FROM Pokemon
WHERE type='Grass'
ORDER BY name;

SELECT name
FROM Trainer
WHERE hometown='Brown City'
  OR hometown='Rainbow City'
ORDER BY name;

SELECT DISTINCT type
FROM Pokemon
ORDER BY type;

SELECT name
FROM City
WHERE name LIKE 'B%'
ORDER BY name;

SELECT hometown
FROM Trainer
WHERE NOT name LIKE 'M%'
ORDER BY hometown;

SELECT nickname
FROM CatchedPokemon
WHERE level=(
  SELECT MAX(level)
  FROM CatchedPokemon)
ORDER BY nickname;

SELECT name
FROM Pokemon
WHERE name LIKE 'A%'
  OR name LIKE 'E%'
  OR name LIKE 'I%'
  OR name LIKE 'O%'
  OR name LIKE 'U%'
ORDER BY name;

SELECT AVG(level)
FROM CatchedPokemon;

SELECT MAX(level)
FROM CatchedPokemon
WHERE owner_id=(
  SELECT id
  FROM Trainer
  WHERE name='Yellow');

SELECT DISTINCT hometown
FROM Trainer
ORDER BY hometown;

SELECT T.name,
  CP.nickname
FROM Trainer T,
  CatchedPokemon CP
WHERE T.id=CP.owner_id
  AND CP.nickname LIKE 'A%'
ORDER BY T.name;

SELECT name
FROM Trainer
WHERE id=(
  SELECT leader_id
  FROM Gym
  WHERE city=(
    SELECT name
    FROM City
    WHERE description='Amazon'));

SELECT owner_id,
  catched_fire_type
FROM (
  SELECT owner_id,
    COUNT(id) AS catched_fire_type
  FROM CatchedPokemon
  WHERE pid IN (
    SELECT id
    FROM Pokemon
    WHERE type='Fire')
  GROUP BY owner_id)
  AS NumFireType
WHERE catched_fire_type=(
  SELECT MAX(catched_fire_type) AS catched_fire_type
  FROM (
    SELECT owner_id,
      COUNT(id) AS catched_fire_type
    FROM CatchedPokemon
    WHERE pid IN (
      SELECT id
      FROM Pokemon
      WHERE type='Fire')
    GROUP BY owner_id)
    AS NumFireType);

SELECT DISTINCT type
FROM Pokemon
WHERE id < 10
ORDER BY id DESC;

SELECT COUNT(id) as num
FROM Pokemon
WHERE NOT type='Fire';

SELECT name
FROM Pokemon
WHERE id IN (
  SELECT before_id
  FROM Evolution
  WHERE before_id > after_id)
ORDER BY name;

SELECT AVG(level)
FROM CatchedPokemon
WHERE pid IN (
  SELECT id
  FROM Pokemon
  WHERE type='Water');

SELECT nickname
FROM CatchedPokemon
WHERE owner_id IN (
    SELECT leader_id
    FROM Gym) 
  AND level=(
    SELECT MAX(level)
    FROM CatchedPokemon
    WHERE owner_id IN (
      SELECT leader_id
      FROM Gym));

SELECT name
FROM Trainer
WHERE id IN (
  SELECT owner_id
  FROM (
    SELECT owner_id,
      AVG(level) AS avg_level
    FROM CatchedPokemon
    WHERE owner_id IN (
      SELECT id
      FROM Trainer
      WHERE hometown='Blue City')
    GROUP BY owner_id)
    AS BlueAvgLevel
  WHERE avg_level=(
    SELECT MAX(avg_level)
    FROM (
      SELECT owner_id,
        AVG(level) AS avg_level
      FROM CatchedPokemon
      WHERE owner_id IN (
        SELECT id
        FROM Trainer
        WHERE hometown='Blue City')
      GROUP BY owner_id)
      AS BlueAvgLevel))
ORDER BY name;

SELECT Pokemon.name
FROM (
  SELECT pid
  FROM (
    SELECT pid
    FROM CatchedPokemon
    WHERE owner_id IN (
      SELECT id
      FROM Trainer
      WHERE hometown IN (
        SELECT hometown
        FROM (
          SELECT hometown,
            COUNT(id) AS trainer_num
          FROM Trainer
          GROUP BY hometown)
          AS TrainerNum
        WHERE trainer_num=1)))
    AS LonelyTrainer
  WHERE pid IN (
    SELECT before_id
    FROM Evolution))
  AS Evolutionable
JOIN Pokemon
  ON Evolutionable.pid=Pokemon.id
WHERE Pokemon.type='Electric';

SELECT T.name,
  LeaderLevelSum.level_sum
FROM Trainer T
JOIN (
  SELECT owner_id,
    SUM(level) AS level_sum
  FROM CatchedPokemon
  WHERE owner_id IN (
    SELECT leader_id
    FROM Gym)
  GROUP BY owner_id)
  AS LeaderLevelSum
  ON T.id=LeaderLevelSum.owner_id
ORDER BY LeaderLevelSum.level_sum DESC;

SELECT hometown
FROM (
  SELECT hometown,
    COUNT(id) AS trainer_num
  FROM Trainer
  GROUP BY hometown)
  AS Hometown
WHERE trainer_num=(
  SELECT MAX(trainer_num)
  FROM (
    SELECT hometown,
      COUNT(id) AS trainer_num
    FROM Trainer
    GROUP BY hometown)
    AS Hometown);

SELECT name
FROM Pokemon
WHERE id IN (
  SELECT DISTINCT pid
  FROM CatchedPokemon
  WHERE owner_id IN (
    SELECT id
    FROM Trainer
    WHERE hometown='Brown City')
  )
  AND id IN (
    SELECT DISTINCT pid
    FROM CatchedPokemon
    WHERE owner_id IN (
      SELECT id
      FROM Trainer
      WHERE hometown='Sangnok City'))
    ORDER BY name;

SELECT name
FROM Trainer
WHERE id IN (
  SELECT owner_id
  FROM CatchedPokemon
  WHERE pid IN (
    SELECT id
    FROM Pokemon
    WHERE name LIKE 'P%')
  )
  AND hometown='Sangnok City'
ORDER BY name;

SELECT T.name,
  P.name
FROM CatchedPokemon CP
JOIN Trainer T
  ON CP.owner_id=T.id
JOIN Pokemon P
  ON P.id=CP.pid
ORDER BY T.name,
  P.name;

SELECT name
FROM Pokemon
WHERE id IN (
  SELECT before_id
  FROM Evolution
  WHERE before_id NOT IN (
    SELECT after_id
    FROM Evolution
  )
  AND after_id NOT IN (
    SELECT before_id
    FROM Evolution))
ORDER BY name;

SELECT nickname
FROM CatchedPokemon
WHERE owner_id=(
  SELECT leader_id
  FROM Gym
  WHERE city='Sangnok City'
  )
  AND pid IN (
    SELECT id
    FROM Pokemon
    WHERE type='Water')
ORDER BY nickname;

SELECT name
FROM Trainer
WHERE id IN (
  SELECT owner_id
  FROM CatchedPokemon
  WHERE pid IN (
    SELECT after_id
    FROM Evolution)
  GROUP BY owner_id
  HAVING COUNT(id) >= 3)
ORDER BY name;

SELECT name
FROM Pokemon
WHERE id NOT IN (
  SELECT DISTINCT pid
  FROM CatchedPokemon) 
ORDER BY name;

SELECT MAX(CP.level) AS max_level
FROM CatchedPokemon CP
JOIN Trainer T
  ON CP.owner_id=T.id
GROUP BY T.hometown
ORDER BY max_level DESC;

SELECT Id.first_id,
  P1.name AS first_name,
  P2.name AS second_name,
  P3.name AS third_name
FROM (
  SELECT E1.before_id AS first_id,
    E1.after_id AS second_id,
    E2.after_id AS third_id
  FROM (
    SELECT *
    FROM Evolution
    WHERE after_id IN (
      SELECT before_id
      FROM Evolution)
    )
    AS E1
  JOIN Evolution E2
    ON E2.before_id=E1.after_id
  )
  AS Id
JOIN Pokemon P1
  ON Id.first_id=P1.id
JOIN Pokemon P2
  ON Id.second_id=P2.id
JOIN Pokemon P3
  ON Id.third_id=P3.id
ORDER BY Id.first_id;
