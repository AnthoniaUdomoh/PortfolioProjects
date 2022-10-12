
Select *
From PortfolioProject. .CovidDeaths
where continent is not null
Order by 3,4


--Select *
--From PortfolioProject. .CovidVaccinations
--Order by 3,4

--Select Data for the Project
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject. .CovidDeaths
where continent is not null
Order by 1,2

-- Looking at Total Cases vs Total Deaths
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject. .CovidDeaths
Where Location like '%states%'  and continent is not null
Order by 1,2

-- Looking at Total Cases vs Population
-- Shows the population that has Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject. .CovidDeaths
Where Location like '%states%' and continent is not null
Order by 1,2

--Looking at Countries with the highest infection rate compared to population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject. .CovidDeaths
--Where Location like '%states%'
Group by Location, population
Order by PercentPopulationInfected desc

-- Show Countries with the Highest Death Count per Population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject. .CovidDeaths
where continent is not null
--Where Location like '%states%'
Group by Location 
Order by TotalDeathCount desc


Select Location, population, MAX(cast(total_deaths as int)) as TotalDeathCount, MAX((total_deaths/population))*100 as PercentPopulationDead
From PortfolioProject. .CovidDeaths
--Where Location like '%states%'
Group by Location, population
Order by PercentPopulationDead desc

-- Continent with the Highest Death Count
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject. .CovidDeaths
where continent is not null
--Where Location like '%states%'
Group by continent
Order by TotalDeathCount desc

-- Total across the world (Global Numbers)
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject. .CovidDeaths
--Where Location like '%states%'  
where continent is not null
-- Group by date
Order by 1,2

--Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject. .CovidDeaths dea
Join PortfolioProject. .CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- New Vaccination per day
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject. .CovidDeaths dea
Join PortfolioProject. .CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- CTE
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject. .CovidDeaths dea
Join PortfolioProject. .CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)* 100
From PopvsVac

--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject. .CovidDeaths dea
Join PortfolioProject. .CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
Select *, (RollingPeopleVaccinated/Population)* 100
From #PercentPopulationVaccinated


--Creating views for data visualisations 
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject. .CovidDeaths dea
Join PortfolioProject. .CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 

Select *
From PercentPopulationVaccinated



-- Expressions
Select SUM(dea.total_cases) as TC, SUM(cast(dea.new_deaths as int)) as TD, SUM(cast(vac.new_vaccinations as int))as NV
From PortfolioProject. .CovidDeaths dea
Join PortfolioProject. .CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 








