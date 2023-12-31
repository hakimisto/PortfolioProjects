-- View CovidDeaths
SELECT * FROM CovidDeaths
ORDER BY 3,4;

-- View CovidVaccination
SELECT * FROM CovidVaccination
ORDER BY 3,4;

-- Alter datatype
ALTER TABLE CovidDeaths
ALTER COLUMN total_deaths Float;

ALTER TABLE CovidDeaths
ALTER COLUMN total_cases Float;

ALTER TABLE CovidVaccination
ALTER COLUMN new_vaccinations Float;

-- View data that will be using
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 5;

-- Looking at Total_Cases vs Total Deaths for united states/high population area
SELECT Location, date, total_cases, new_cases, total_deaths, population, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

-- looking at Total_Cases vs Population
SELECT Location, date, total_cases, new_cases, total_deaths, population, (total_cases/population)*100 AS DeathPercentage
FROM CovidDeaths
--WHERE location = 'Malaysia'

-- looking at the highest country with highest infection rate
SELECT location,population,MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) AS HighestDeathPercentage
FROM CovidDeaths
GROUP BY location,population
ORDER BY HighestDeathPercentage DESC


-- Showing the country with highest death count per population
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Showing the death through continent
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, (nullif(SUM(new_deaths),0)/nullif(SUM(new_cases),0))*100 AS DeathPercentages
FROM CovidDeaths
WHERE new_cases is not null
GROUP BY date

SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, (nullif(SUM(new_deaths),0)/nullif(SUM(new_cases),0))*100 AS DeathPercentages
FROM CovidDeaths
WHERE new_cases is not null


-- USE CTE
WITH PopvsVac(Continent,Location,Date,Population, new_vaccinations,TotalAllTimes)
AS
(
-- looking for number of total population vs vaccinations
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location,dea.date) AS TotalAllTimes --,(TotalAllTimes/dea.population)*100
FROM CovidDeaths dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
)

SELECT *, (TotalAllTimes/population)*100
FROM PopvsVac

--TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
TotalAllTimes numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location,dea.date) AS TotalAllTimes --,(TotalAllTimes/dea.population)*100
FROM CovidDeaths dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null

SELECT *, (TotalAllTimes/population)*100
FROM #PercentPopulationVaccinated

-- Creating view for later visualization.
Create view PercentPopulationVaccinated AS
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location,dea.date) AS TotalAllTimes --,(TotalAllTimes/dea.population)*100
FROM CovidDeaths dea
JOIN CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null


--SELF NOTE
-- SUM(CAST(vac.new_vaccinations as INT)
-- SUM(convert(Int,vac.new_vaccinations))
