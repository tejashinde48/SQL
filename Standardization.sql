

select * from layoffs;
# 1. Remove Duplicates
# 2. Standardize the Data
# 3. Null Values or blank values
# 4. Remove Any Columns

Create table layoffs_staging
like layoffs;

select * from layoffs_staging;

insert layoffs_staging select * from layoffs;

select * ,
row_number() over(
partition by company,location,industry, total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_staging;

WITH duplicate_cte as
(
select * ,
row_number() over(
partition by company,location,
industry,total_laid_off,percentage_laid_off,'date',
stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
Delete from duplicate_cte
where row_num> 1;
 
select * from layoffs_staging
where company = "casper";


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging2
select * ,
row_number() over(
partition by company,location,
industry,total_laid_off,percentage_laid_off,'date',
stage,country,funds_raised_millions) as row_num
from layoffs_staging;

select * 
from layoffs_staging2
where row_num >1;

set sql_safe_updates = 0;
 
delete from layoffs_staging2
where row_num >1;


select distinct(Trim(company))
from layoffs_staging2;

update layoffs_staging2
set company= Trim(company);

select *
from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';


select distinct industry
from layoffs_staging2;


select *
from layoffs_staging2
where country like 'united states%'
order by 1;

select distinct	country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'Unites States%';

select distinct country from layoffs_staging2
order by 1;

update layoffs_staging2
set country = 'United States'
where country like 'Unites States.';


select `date`,
STR_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

select * 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
and funds_raised_millions is null;


select *
from layoffs_staging2
where industry is null
or industry = '';

select * 
from layoffs_staging2
where company like 'Bally%';

update layoffs_staging2
set industry = null
where industry = '';

select t1.industry,t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry='')
and t2.industry is not null;


update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null)
and t2.industry is not null;


select * from layoffs_staging2;

select * 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;


select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;

select * 
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;


select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

SELECT MIN(`date`), MAX(`date`) 
FROM layoffs_staging2;


SELECT 
  stage, SUM(total_laid_off) as Total_Laid_off
FROM
    layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

select company,round(avg(percentage_laid_off),2)
from layoffs_staging2
group by company
order by 2 desc;


select * from layoffs_staging2;

select substring(`date`,1,7) as Month, sum(total_laid_off) 
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc;


with Rolling_Total as
(select substring(`date`,1,7) as Month, sum(total_laid_off) AS Total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc
)
select `Month`,Total_off
,sum(Total_off) over(order by `Month`) as rolling_total
from Rolling_Total;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company,year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc;

with Company_Year (company,years,total_laid_off) as 
(
select company,year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
),company_year_rank as 
(select *, dense_rank () over(partition by years order by total_laid_off desc) as Ranking
from Company_Year
WHere years is not null
)
select * 
from company_year_rank
where ranking <= 5;
;










