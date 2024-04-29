/* 
Condition:
	1) If custom_1 = custom_3 and custom_2 = custom_4: then keep only one pair
    2) If custom_1 != custom_3 or custom_2 != custom_4: then keep both pair
    3) For brands do not have pairs in the same year: keep those rows as well
    
Input Table
***********************************************************************************************************************
|brand_1|	|brand_2|	|year|	|custom_1|	|custom_2|	|custom_3|	|custom_4|
apple		samsung		2020		1		2			1			2
samsung		apple		2020		1		2			1			2
apple		samsung		2021		1		2			5			3
samsung		apple		2021		5		3			1			2
google				2020		5		9		
oneplus		nothing		2020		5		9			6			3
***********************************************************************************************************************

Output Table:
***********************************************************************************************************************
|brand_1|	|brand_2|	|year|	|custom_1|	|custom_2|	|custom_3|	|custom_4|
apple		samsung		2020		1		2			1			2
apple		samsung		2021		1		2			5			3
samsung		apple		2021		5		3			1			2
google				2020		5		9		
oneplus		nothing		2020		5		9			6			3
***********************************************************************************************************************
*/

-- CREATE TABLE brand_pairs (
-- 	brand_1 VARCHAR(50) NOT NULL,
-- 	brand_2 VARCHAR(50) NULL,
-- 	year INT NOT NULL,
-- 	custom_1 TINYINT NOT NULL,
-- 	custom_2 TINYINT NOT NULL,
-- 	custom_3 TINYINT NULL,
-- 	custom_4 TINYINT NULL
-- );

-- INSERT INTO brand_pairs(brand_1, brand_2, year, custom_1, custom_2, custom_3, custom_4)
-- 	VALUES 	("apple", "samsung", 2020, 1, 2, 1, 2),
-- 			("samsung", "apple", 2020, 1, 2, 1, 2),
-- 			("apple", "samsung", 2021, 1, 2, 5, 3),
-- 			("samsung", "apple", 2021, 5, 3, 1, 2),
-- 			("google", NULL, 2020, 5, 9, NULL, NULL),
-- 			("oneplus", "nothing", 2020, 5, 9, 6, 3);






WITH CTE AS (
			SELECT
				*,
				CASE
					WHEN brand_1 < brand_2 THEN CONCAT(brand_1, brand_2, year)
					ELSE CONCAT(brand_2, brand_1, year)
				END AS pair_id
			FROM brand_pairs
            ),
			CTE_2 AS (
					SELECT *,
					ROW_NUMBER() OVER(PARTITION BY pair_id) AS rn
					FROM CTE
                    )

SELECT *
FROM CTE_2
WHERE rn = 1 OR (custom_1 <> custom_3 and custom_2 <> custom_4);
