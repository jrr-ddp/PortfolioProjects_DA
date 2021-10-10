SELECT * 
FROM PortfolioProject_DA..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT * 
--FROM PortfolioProject_DA..CovidVaccinations
--ORDER BY 3,4


-- Select Data that we are going to be using
SELECT 
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM PortfolioProject_DA..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
--We used like operator for finding some specify country
SELECT 
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100 As 'Percentage of Death'
FROM PortfolioProject_DA..CovidDeaths
WHERE location like '%united%'
AND continent IS NOT NULL
ORDER BY 1,2



-- Looking at Total Cases Vs Population
-- Show the precentage of total cases
SELECT 
	location,
	date,
        population,
	total_cases,
	(total_cases/population)*100 As 'Percentage of Total Cases'
FROM PortfolioProject_DA..CovidDeaths
--WHERE location like '%in%'
WHERE continent IS NOT NULL
ORDER BY 1,2


-- Looking at countries is highest Infection rate compared to Population

SELECT 
	location,
        population,
	max(total_cases) AS 'Highest Affected Count',
	max((total_cases/population))*100 As 'Percentage Population Affected'
FROM PortfolioProject_DA..CovidDeaths
--WHERE location like '%in%'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 'Percentage Population Affected' desc

--Showing Countries having highest Death Rates as per their Populations

SELECT 
	location,
        --population,
	max(cast(total_deaths as int)) AS 'Total Death Count'
	--max((cast(total_deaths as int)/population))*100 As 'Percentage of Deaths'
FROM PortfolioProject_DA..CovidDeaths
--WHERE location like '%in%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 'Total Death Count' desc


-- Let's Break things down by continent

-- Showing contintents with the highest death count per population

SELECT 
	continent,
        --population,
	max(cast(total_deaths as int)) AS 'Total Death Count'
	--max((cast(total_deaths as int)/population))*100 As 'Percentage of Deaths'
FROM PortfolioProject_DA..CovidDeaths
--WHERE location like '%in%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 'Total Death Count' desc


-- Showing continents with the highest death count per population

SELECT 
	continent,
        --population,
	max(cast(total_deaths as int)) AS 'Total Death Count'
	--max((cast(total_deaths as int)/population))*100 As 'Percentage of Deaths'
FROM PortfolioProject_DA..CovidDeaths
--WHERE location like '%in%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 'Total Death Count' desc


-- GLOBAL NUMBERS

Select 
     SUM(new_cases) as total_cases, 
     SUM(cast(new_deaths as int)) as total_deaths, 
     SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject_DA..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject_DA..CovidDeaths dea
Join PortfolioProject_DA..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3




-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac 
	(Continent, 
	Location, 
	Date, 
	Population, 
	New_Vaccinations, 
	RollingPeopleVaccinated)
as
(
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject_DA..CovidDeaths dea
Join PortfolioProject_DA..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, 
	(RollingPeopleVaccinated/Population)*100 as Precentage
From PopvsVac




-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject_DA..CovidDeaths dea
Join PortfolioProject_DA..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Create view to Store data for visualizations

use PortfolioProject_DA

Create View PopulationVaccinated as
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject_DA..CovidDeaths dea
Join PortfolioProject_DA..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

SELECT *
FROM PopulationVaccinated
