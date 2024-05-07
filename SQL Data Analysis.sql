# Data Analysis
SELECT * FROM cleaned_data;

-- check to see max total_laid_off and max percentage_laid_off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM cleaned_data;

-- check to see which companies ran out of business
SELECT *
FROM cleaned_data
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- check to see companies ran out of business with plenty of funding
SELECT *
FROM cleaned_data
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM cleaned_data
GROUP BY company
ORDER BY 2 DESC;

-- check to see which industry has most total_laid_off 
SELECT industry, MAX(total_laid_off)
FROM cleaned_data
WHERE total_laid_off IS NOT NULL
GROUP BY industry
ORDER BY MAX(total_laid_off) DESC;

-- check to see data collected date range
SELECT MIN(`date`), MAX(`date`)
FROM cleaned_data;

SELECT country, SUM(total_laid_off)
FROM cleaned_data
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM cleaned_data
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`) DESC;		

SELECT stage, SUM(total_laid_off)
FROM cleaned_data
GROUP BY stage
ORDER BY 2 DESC;	

SELECT company, SUM(percentage_laid_off)
FROM cleaned_data
GROUP BY company
ORDER BY 2 DESC;

SELECT country, SUM(percentage_laid_off)
FROM cleaned_data
GROUP BY country
ORDER BY 2 DESC;

-- rolling sum of lay-offs
SELECT SUBSTRING(`date`, 6, 2) AS month, SUM(total_laid_off)
FROM cleaned_data
GROUP BY month
ORDER BY SUM(total_laid_off) DESC;

SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off)
FROM cleaned_data
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1;

WITH Rolling_Toal AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off) AS total_off
FROM cleaned_data
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1
)
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_laid_off
FROM Rolling_Toal;

-- Company rolling laid off by year
SELECT company, SUM(total_laid_off)
FROM cleaned_data
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM cleaned_data
GROUP BY company, YEAR(`date`)
ORDER BY company;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM cleaned_data
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM cleaned_data
GROUP BY company, YEAR(`date`)
)
SELECT *
FROM Company_Year
WHERE total_laid_off IS NOT NULL;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM cleaned_data
GROUP BY company, YEAR(`date`)
)
SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS laid_off_dense_rank,
RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS laid_off_rank
FROM Company_Year
WHERE years IS NOT NULL;
