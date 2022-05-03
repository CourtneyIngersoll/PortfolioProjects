/* Queries for Vaccination Vizualization in Tableau*/

--Data Cleaning

SELECT *
FROM PortfolioProject1..COVID_VACCINATIONS
order by location

UPDATE PortfolioProject1..COVID_VACCINATIONS
SET population = NULL 
WHERE  population = ''

--People Vaccinated 

SELECT location, population
FROM PortfolioProject1..COVID_VACCINATIONS
--where location = 'United States'
order by location

SELECT location, year(date), max(people_fully_vaccinated)
FROM PortfolioProject1..COVID_VACCINATIONS
where location = 'United States'
GROUP BY location, year(date)
order by location

--Percent of Population Vaccinated

WITH PercentofPopVac (location, populaiton, TotalPeopleVaccinated)
as
(
SELECT location, population, SUM(cast(new_people_vaccinated_smoothed as float)) as TotalPeopleVaccinated
FROM PortfolioProject1..COVID_VACCINATIONS v
GROUP BY location,  population
--ORDER BY location, population
)
SELECT * , (TotalPeopleVaccinated/ populaiton) * 100 as PercentofPopulationVac
FROM PercentofPopVac
ORDER BY PercentofPopulationVac DESC

--New Vaccinations by Month

SELECT location, SUM(cast(new_vaccinations as float)) as TotalPeopleVaccinated, year(date) as YearVaccinated, month(date) as MonthVaccinated
FROM PortfolioProject1..COVID_VACCINATIONS
--WHERE location = 'United States'
GROUP BY location, year(date), MONTH(date)
ORDER BY location




