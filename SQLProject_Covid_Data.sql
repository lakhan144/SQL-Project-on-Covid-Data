select *
From Project1..Covid_Deaths
Order by 3,4

--select *
--From Project1..Covid_Vaccinations
--Order by 3,4


select Location, date, total_cases, new_cases, total_deaths, population
From Project1..Covid_Deaths
order by 1,2


--total cases vs total deaths
--shows the likelihood of dying if one comes in contact of the virus
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From Project1..Covid_Deaths
where location like '%india%'
order by 1,2


--total cases vs population
select Location, date, total_cases, population, (total_cases/population)*100 as Case_Percentage
From Project1..Covid_Deaths
--where location like '%india%'
order by 1,2


--countries with highest infection rate
select Location, max(total_cases) as Highest_inf_count, population, max((total_cases/population))*100 as Case_Percentage
From Project1..Covid_Deaths
where continent is not null
--where location like '%india%'
Group by location, population
order by Case_Percentage desc


-- Highest Death count per population
select Location, Max(cast(total_deaths as int)) as Total_Deaths_count
From Project1..Covid_Deaths
where continent is not null
--where location like '%india%'
Group by location
order by Total_Deaths_count desc



-- Global Numbers

select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases) as DeathPercentage
from Project1..Covid_Deaths
where continent is not null
order by 1,2


-- Total Popualtion  vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over 
(partition by dea.location order by dea.location, dea.date) as Rolling_sum_of_NewVac

From Project1..Covid_Deaths dea
Join Project1..Covid_Vaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- Using CTE
-- finding Rolling Percentage
with PopvsVac(continent, location, date, population,
new_vaccination, rolling_Sum_of_new_vaccination)
as
(
Select dea.continent, dea.location, dea.date,
dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over 
(partition by dea.location order by dea.location, dea.date)
as Rolling_sum_of_NewVac

From Project1..Covid_Deaths dea
Join Project1..Covid_Vaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

)
Select*, (rolling_Sum_of_new_vaccination/population)*100 as rollingPercentage
From PopvsVac
