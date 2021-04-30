
select  * from users limit 10;

update users set updated_at = now(), created_at = now();

desc users;

ALTER TABLE users MODIFY COLUMN created_at DATETIME;

ALTER TABLE users MODIFY COLUMN updated_at DATETIME;

select  * from storehouses_products;

SELECT * from storehouses_products ORDER BY IF(value > 0, 0, 1), value;

select AVG(floor((to_days(now()) - to_days(birthday_at)) / 365.25)) as age from users;

SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day, COUNT(*) AS total from users 
    GROUP by day ORDER by total DESC;


