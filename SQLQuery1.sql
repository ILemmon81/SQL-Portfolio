--SELECT location, date, total_cases, population, (total_cases / population) AS 'Percentage of Reported Infections'
--FROM [Covid Deaths]
--WHERE location LIKE '%states%' 
--ORDER BY 1,2

--SELECT Location, population, SUM((cast(total_cases AS int))) AS 'Largest Infection Count'
--FROM [Covid Deaths]
--WHERE total_cases IS NOT NULL AND continent IS NOT NULL
--GROUP BY date
--ORDER BY 'Largest Infection Count' desc

--SELECT location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
--FROM [Covid Deaths]
--WHERE continent IS  NULL
--GROUP BY location
--ORDER BY TotalDeathCount desc

--SELECT date, SUM(new_cases) AS 'Total Cases', SUM(cast(new_deaths as INT)) AS 'Total Deaths', SUM(cast(new_deaths as INT))/SUM(new_cases)*100 AS 'DeathPercentage'
--FROM [Covid Deaths]
--WHERE continent IS NOT NULL
--GROUP BY date
--ORDER BY 1,2

--SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, 
--SUM(cast(vax.new_vaccinations as int)) OVER (partition by dea.location ORDER BY dea.location, dea.date) AS 'Total Vaccinations'
--FROM [Covid Deaths] as DEA 
--JOIN [Covid Vaccinations] AS VAX 
--	on DEA.location = VAX.location
--	AND dea.date = vax.date
--WHERE dea.continent IS NOT NULL AND dea.population IS NOT NULL;
--ORDER BY 2,3


--- USE CTE


With PopvsVax (continent, location, date, population, new_vaccinations, TotalVaccinations)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, 
SUM(cast(vax.new_vaccinations as int)) OVER (partition by dea.location ORDER BY dea.location, dea.date) AS TotalVaccinations
FROM [Covid Deaths] as DEA 
JOIN [Covid Vaccinations] AS VAX 
	on DEA.location = VAX.location
	AND dea.date = vax.date
WHERE dea.continent IS NOT NULL AND dea.population IS NOT NULL AND dea.location like '%states%'
)

Select *, (TotalVaccinations/population)*100 AS '% of Pop Marinated'
from PopvsVax