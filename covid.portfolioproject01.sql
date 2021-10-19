

--avg number of total cases in USA (in percentage)

select location, date, population, AVG(total_cases)/population *100 as averagenumberofcases
from portfolioproject..coviddeaths
where continent is not null
and population is not null
group by location, date, population
having location like '%states'
order by population;



--avg number of total cases in the world (in percentage)

select location, date, population, AVG(total_cases)/population *100 as averagenumberofcases
from portfolioproject..coviddeaths
where continent is not null
and population is not null
group by location, date, population
order by population;




-- looking at the percentage of total cases vs total deaths in NIGERIA
-- shows likelihood of dying if you contact covid in nigeria
 
select location, date, population, total_cases, new_cases, total_deaths, 
(total_deaths/total_cases) * 100 as PerectageofDeathRate 
from portfolioproject..coviddeaths
WHERE location like '%nigeria'
and continent is not null
ORDER BY location, date;


select * from 
portfolioproject..coviddeaths
where continent is not null
and population is not null;



--avg number of total cases in USA (in percentage)

select location, date, population, AVG(total_cases)/population *100 as averagenumberofcases
from portfolioproject..coviddeaths
where continent is not null
and population is not null
group by location, date, population
having location like '%states'
order by population







-- looking at the percentage of total cases vs total deaths in USA
-- shows likelihood of dying if you contact covid in USA

select location, date, population, total_cases, new_cases, total_deaths, 
(total_deaths/total_cases) * 100 as PerectageofDeathRate 
from portfolioproject..coviddeaths
WHERE location like '%states'
and continent is not null
ORDER by location, date;

-- looking at the percentage of total cases vs total deaths in NIGERIA
-- shows likelihood of dying if you contact covid in nigeria
 
select location, date, population, total_cases, new_cases, total_deaths, 
(total_deaths/total_cases) * 100 as PerectageofDeathRate 
from portfolioproject..coviddeaths
WHERE location like '%nigeria'
and continent is not null
ORDER BY location, date;


--looking at the percentage of total cases vs population
--shows percentage of people infected with covid

select location, date, population, total_cases,
(total_cases/population) * 100 as PerectageInfected
from portfolioproject..coviddeaths
WHERE continent is not null
ORDER by location, date, population;

-- Countries with Highest Infection Rate compared to Population
Select Location, 
MAX(total_cases) as HighestInfectionCount,
population,
Max((total_cases/population))*100 as 'PercentPerPopulationInfected'
from portfolioproject..coviddeaths
WHERE continent is NOT null
GROUP BY Location, population
order by PercentPerPopulationInfected desc;

-- Countries with Highest Death Count per Population
select location, MAX(cast(total_deaths as int)) as Totaldeathcount
from portfolioproject..coviddeaths
where continent is not null
group by location
order by Totaldeathcount desc;


--Global numbers
select date, SUM(new_cases) as total_cases, 
SUM(CAST(new_deaths as int)) as total_deaths, 
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage 
from portfolioproject..coviddeaths
where continent is not null
group by date
order by 1,2;

--LOOKING AT TOTAL VACCINATED PEOPLE VS POPULATION

--Use CTE
with popvsvac (continent, location, date, population, new_vaccinations, Rollingpeoplevaccinated)
as
(
select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, 
dea.date) as Rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
)
select *, (Rollingpeoplevaccinated/population)*100 as percentagevaccinated
from popvsvac;



--creating view for visualation
--creating view for Global Numbers

 create view Globalnumbers as
select date, SUM(new_cases) as total_cases, 
SUM(CAST(new_deaths as int)) as total_deaths, 
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage 
from portfolioproject..coviddeaths
where continent is not null
group by date

select *
from Globalnumbers;
