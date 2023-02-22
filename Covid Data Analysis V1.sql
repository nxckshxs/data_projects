-- Likelihood of death by country
SELECT location, total_cases, ROUND((total_deaths/total_cases)*100, 2) AS Death_Percent
FROM COVID_DEATHS
ORDER BY 1, 2
FETCH FIRST 100 ROWS ONLY;

--Total Cases vs Population
SELECT location, dates, total_cases, population, ROUND((total_cases/population)*100,2) AS Infection_rate
FROM COVID_deaths
ORDER BY 1,2;

-- Countries with High Infection rate vs Population
SELECT location, population, MAX(total_cases) AS Highest_inf_count, ROUND(MAX((total_cases/population)*100),2) AS Infection_rate
FROM COVID_deaths
GROUP BY location, population
ORDER BY 4 DESC;

-- Countries with the highest death count per population
SELECT location, MAX(total_deaths) AS Total_Death_Count
FROM COVID_DEATHS
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX(total_deaths) IS NOT NULL
ORDER BY 2 DESC;

--Highest Death Count By Continent
SELECT location, MAX(TO_CHAR(total_deaths,'99G999G999G999')) AS Total_Deaths
FROM covid_deaths
WHERE continent IS NULL AND location NOT LIKE '%income%' AND location != 'International' AND location != 'European Union'
GROUP BY location
ORDER BY 2 DESC;

-- Global Numbers
SELECT dates, SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, ROUND(SUM(new_deaths)/SUM(new_cases)*100,2) AS Percentage
FROM COVID_DEATHS
WHERE continent IS NOT NULL
GROUP BY dates
ORDER BY 1, 2;

--GLOBAL Totals
SELECT SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, ROUND(SUM(new_deaths)/SUM(new_cases)*100,2) AS Percentage
FROM COVID_DEATHS
WHERE continent IS NOT NULL
ORDER BY 1, 2;


-- COVID VACCS -- 
WITH PopVsVac (Continent, location, dates, Population, new_vaccinations, Cum_Vaccs) AS (
    SELECT covid_deaths.continent, 
        covid_deaths.location, 
        covid_deaths.dates, 
        covid_deaths.population, 
        covid_vaccs.new_vaccinations, 
        SUM(covid_vaccs.new_vaccinations) OVER (PARTITION BY covid_vaccs.location ORDER BY covid_vaccs.location, covid_vaccs.dates) AS Cum_Vaccs
    FROM covid_vaccs  
    INNER JOIN covid_deaths
     ON covid_vaccs.location = covid_deaths.location AND covid_vaccs.dates = covid_deaths.dates
    WHERE covid_deaths.continent IS NOT NULL AND covid_vaccs.location = 'United Kingdom'
    --ORDER BY 2,3
    )
SELECT *
FROM PopVsVac;

--Creating View to store data for later Visualisations

CREATE VIEW Highest_Death_By_Country AS
SELECT location, MAX(total_deaths) AS Total_Death_Count
FROM COVID_DEATHS
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX(total_deaths) IS NOT NULL
ORDER BY 2 DESC;

--Querying The View
SELECT *
FROM Highest_Death_By_Country;
