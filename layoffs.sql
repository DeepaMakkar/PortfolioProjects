DROP TABLE IF EXISTS Layoffs.layoffs_staging;
CREATE TABLE Layoffs.layoffs_staging 
LIKE Layoffs.employee_layoffs;

INSERT Layoffs.layoffs_staging 
SELECT * FROM Layoffs.employee_layoffs;

SELECT *
FROM Layoffs.layoffs_staging 
;

SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		Layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;

SELECT *
FROM Layoffs.layoffs_staging2
where company = "Cazoo";
;

DROP TABLE IF EXISTS Layoffs.layoffs_staging2;
CREATE TABLE `Layoffs`.`layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
row_num INT
);

INSERT INTO `Layoffs`.`layoffs_staging2`
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		Layoffs.layoffs_staging;

SET SQL_SAFE_UPDATES = 0;
delete FROM Layoffs.layoffs_staging2
WHERE row_num >= 2;

SELECT DISTINCT industry
FROM Layoffs.layoffs_staging2
ORDER BY industry;

SELECT *
FROM Layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

SELECT *
FROM Layoffs.layoffs_staging2
where company = "Appsmith";
;

UPDATE Layoffs.layoffs_staging2 t1
JOIN Layoffs.layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM Layoffs.layoffs_staging2
WHERE industry IN ('Crypto', 'CryptoCurrency');

SELECT DISTINCT country
FROM Layoffs.layoffs_staging2
ORDER BY country;

UPDATE Layoffs.layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

UPDATE Layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');



ALTER TABLE  Layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM Layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM Layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE Layoffs.layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM Layoffs.layoffs_staging2;