SELECT *
FROM PortafolioProject..covidDeaths
where continent is not null
ORDER by 3,4

--SELECT *
--FROM PortafolioProject..covidVacinations
--ORDER by 3,4


-- Looking at total cases vs total deaths

SELECT location,date,total_cases,  total_deaths, (total_deaths/ total_cases)*100 as DeathPercentage
FROM PortafolioProject..covidDeaths
where location like'%col%'
order by 1, 2

--Consultar y cambiar el tipo de dato

--SELECT COLUMN_NAME, DATA_TYPE
--FROM INFORMATION_SCHEMA.COLUMNS
--WHERE TABLE_NAME = 'covidDeaths' 

-- Otra manera SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount


--ALTER TABLE covidDeaths
--	ALTER COLUMN population FLOAT;

--Looking at Total Cases vs Population
--Shows what percentage of population got covid

SELECT location,date, population,total_cases,   (total_cases/ population)*100 as PercentPopulationInfected
FROM PortafolioProject..covidDeaths
where location like'%col%'
order by 1, 2

-- Shows at the countries  with highest Infection  rate compared to Population

SELECT location, population,MAX(total_cases) AS HighestInfectionCounts,   max((total_cases/ population))*100 as PercentPopulationInfected
FROM PortafolioProject..covidDeaths
GROUP BY location, population
order by PercentPopulationInfected desc

--Showing countries with Highest death per Population
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM PortafolioProject..covidDeaths
where continent is not null
GROUP BY location
order by TotalDeathCount desc




--LET'S BREAK THINGS DOWN BY CONTINENT



--Showing continent with Highest death 
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM PortafolioProject..covidDeaths
where continent is not null
GROUP BY continent
order by TotalDeathCount desc


--Global Numbers

SELECT date,  sum(cast(new_cases as float)) as totalCases, sum(cast(new_deaths as float)) as totalDeaths, (sum(cast(new_deaths as float))/sum(cast(new_cases as float)))*100 as DeathPercentage
FROM PortafolioProject..covidDeaths
--where location like'%col%'
where continent is not null 
group by date
order by 1, 2


-- Total at Total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(float, vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population)*100
FROM PortafolioProject..covidDeaths dea
 join PortafolioProject..covidVacinations vac
	on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null 
order by 2,3

--USE CTE

with PopvsVac(Continent,Location,Date,Population,new_Vaccinations,RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(float, vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population)*100
FROM PortafolioProject..covidDeaths dea
 join PortafolioProject..covidVacinations vac
	on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null 
--order by 2,3
)
select*, (RollingPeopleVaccinated/Population)*100
from PopvsVac


--TEMP TABLE

drop table if exists #PercentPopulationvaccinated
CREATE TABLE #PercentPopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


INSERT INTO #PercentPopulationvaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(float, vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population)*100
FROM PortafolioProject..covidDeaths dea
 join PortafolioProject..covidVacinations vac
	on dea.location = vac.location and dea.date=vac.date
--where dea.continent is not null 
--order by 2,3

select*, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationvaccinated

--Creating View to store data for later visualizations

Create View PercentPopulationvaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(float, vac.new_vaccinations)) OVER(Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population)*100
FROM PortafolioProject..covidDeaths dea
 join PortafolioProject..covidVacinations vac
	on dea.location = vac.location and dea.date=vac.date
where dea.continent is not null 
--order by 2,3

--SELECT * 
--FROM INFORMATION_SCHEMA.VIEWS 
--WHERE TABLE_NAME = 'PercentPopulationvaccinated';

select *
from PercentPopulationvaccinated