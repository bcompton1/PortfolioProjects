SELECT *
From PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4 

--select data that we are going to be using 

SELECT location, date, total_cases, new_cases, total_deaths population
From PortfolioProject..CovidDeaths$
order by 1,2

--Looking at the total casese vs total deaths
--Shows the likelihood of dying if you contract covid in your country


SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentagee
From PortfolioProject..CovidDeaths$
Where location like '%states%'
order by 1,2

--Looking at te total cases vs the population
--Shows what percent of the population got covid

SELECT location, date, total_cases, population, (total_cases/population)*100 as DeathPercentagee
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
order by 1,2

--Looking at countries with highest infection rate compared to population

SELECT location,  MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Group by location, population
order by PercentPopulationInfected desc

--showing countries with highest death count per populaiton

SELECT location,  MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group by location
order by TotalDeathCount desc

--Breaking down by continent
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


--SELECT *
--From PortfolioProject..CovidDeaths$
--where continent is not null
--order by 3,4 

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Showing continents with the highest death count

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Where continent is null
Group by continent
order by TotalDeathCount desc



---GLobal Numbers
SELECT SUM(new_cases), SUM(cast(new_deaths as int)) --SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
where continent is not null
--group by date
order by 1,2 2 



SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases) as DeathPercentage
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
where continent is not null
--group by date
order by 1,2 


--Looking at TotalPopulation vs Vaccination
SElect dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and vac.date = vac.date
Where dea.continent is not null
Order by 2,3

SElect dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PArtition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
, (
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

-- USE CTE

With PopVsVac (continent, location, date, population, new_vaccinations, rollingPeopleVaccinated)
as 
(
SElect dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PArtition by dea.location order by dea.location, 
dea.date) as rollingPeopleVaccinated
-- (rollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
SElect *, (rollingPeopleVaccinated/population)*100
From PopVsVac





-- TEMP TABLE



Drop table if exists #percentpopulationvaccinated
Create TAble #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
NEW_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into #PercentPopulationVaccinated 
SElect dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PArtition by dea.location order by dea.location, 
dea.date) as rollingPeopleVaccinated
-- (rollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3

SElect *, (rollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



--Creating view to store data for later visuals

Create View PercentPeopleVaccinated as
SElect dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PArtition by dea.location order by dea.location, 
dea.date) as rollingPeopleVaccinated
-- (rollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

SELECT* 
FROM PercentPeopleVaccinated




