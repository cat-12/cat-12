CREATE TRIGGER CostTrigger AFTER UPDATE
ON gameRental
FOR EACH ROW
WHEN NEW.date_back IS NOT NULL
AND NEW.rental_cost IS NULL
BEGIN
UPDATE gameRental
SET rental_cost = (3+
(SELECT price
FROM gameRental
JOIN GameLicense ON GameLicense.license_id = gameRental.license_id
JOIN GameTitle ON GameTitle.title = GameLicense.title
WHERE rental_cost IS NULL AND GameLicense.platform == GameTitle.platform AND date_back IS NOT NULL)
*0.05*
(SELECT julianday(date_back) - julianday(date_out) AS days_rented
FROM gameRental 
WHERE date_back IS NOT NULL AND rental_cost IS NULL))
WHERE date_back IS NOT NULL AND rental_cost IS NULL;
END


/*
rental_cost row must be updated
when date_back is entered, calculating rental_costwith a flat rate of $3 + 5% of retail price of game multiplied by the number of days rented  */

/*number of days rented is difference
of date_back - date_out */

/* trigger starts as date_back is updated */

/* julianday(date_back) - julianday(date_out) =
days_rented */

/* 3+GameTitle.price * 0.05 * days_rented */

/* GameTitle.price linked where
gameRental.license_id ==  GameLicense.license_id 
and GameLicense.title == GameTitle.title */
/*
WHERE gameRental.license_id == GameLicense.license_id
AND GameLicense.title == GameTitle.title)*/
