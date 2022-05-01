SELECT *
FROM PortfolioProject1..COVID_DEATHS
ORDER BY 3,4

ALTER TABLE PortfolioProject1..COVID_DEATHS
ALTER COLUMN population float;

ALTER TABLE PortfolioProject1..COVID_DEATHS
ALTER COLUMN Date Date;



UPDATE PortfolioProject1..COVID_VACCINATIONS
SET new_vaccinations = NULL 
WHERE  new_vaccinations = ''

--SELECT *
--FROM PortfolioProject1..COVID_VACCINATIONS
--ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject1..COVID_DEATHS
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM PortfolioProject1..COVID_DEATHS
WHERE Location like '%state%'
ORDER BY 2;


--Looking at Total cases vs population
--Show what percentage of population got COVID
SELECT Location, date, total_cases, population, (total_cases/population) * 100 as PercentofPopulaitonInfected
FROM PortfolioProject1..COVID_DEATHS
WHERE Location like '%state%'
ORDER BY PercentofPopulaitonInfected DESC

--Contries with Highest Infection Rates Compared to Population 

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population)) * 100 as PercentPopulationInfected
FROM PortfolioProject1..COVID_DEATHS
--WHERE Location like '%state%'
GROUP BY Location, population
ORDER BY PercentPopulationInfected DESC

--Showing Countries with Highest Death Count per Population

SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject1..COVID_DEATHS
WHERE continent is not NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC



--Showing the Continents with highest death count per population

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject1..COVID_DEATHS
WHERE continent is not NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

SELECT date, SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, sum(cast(new_deaths as float))/sum(cast(new_cases as float)) * 100 as DeathPrecentage
FROM PortfolioProject1..COVID_DEATHS
--WHERE Location like '%state%'
where continent	is not null
GROUP BY date
ORDER BY 1,2; 


-- Total Poplulation vs Vaccinations

SELECT *
FROM PortfolioProject1..COVID_VACCINATIONS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast( vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeaopleVaccinated,
FROM PortfolioProject1..COVID_DEATHS dea
JOIN PortfolioProject1..COVID_VACCINATIONS vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 2, new_vaccinations;


--use CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast( vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeaopleVaccinated
FROM PortfolioProject1..COVID_DEATHS dea
JOIN PortfolioProject1..COVID_VACCINATIONS vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER BY 2, new_vaccinations
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac

--TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
	(continent nvarchar(255),
	Location nvarchar(255),
	Date datetime, Populaiton numeric,
	New_vaccination numeric, RollingPeopleVaccinated numeric)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast( vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeaopleVaccinated
FROM PortfolioProject1..COVID_DEATHS dea
JOIN PortfolioProject1..COVID_VACCINATIONS vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER BY 2, new_vaccinations
SELECT *, (RollingPeopleVaccinated/Populaiton)*100
FROM #PercentPopulationVaccinated 

--Creating View to Store Data for Later Visulizations

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast( vac.new_vaccinations as float)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeaopleVaccinated
FROM PortfolioProject1..COVID_DEATHS dea
JOIN PortfolioProject1..COVID_VACCINATIONS vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
--ORDER BY 2, new_vaccinations
