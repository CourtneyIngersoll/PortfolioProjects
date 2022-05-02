/*Tableau Queries
Simplified and Cleaned from COVID Portfolio for Vizulization Use*/

-- 1.Global Numbers

Select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(New_Cases as float))*100 as DeathPercentage
From PortfolioProject1..COVID_DEATHS
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--2. Continents with the highest death per populaiton

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject1..COVID_DEATHS
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'Upper middle income','High income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc

--3.Contries with Highest Infection Rates Compared to Population 

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..COVID_DEATHS
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--4.Contries with Highest Infection Rates Compared to Population by Date

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..COVID_DEATHS
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc
