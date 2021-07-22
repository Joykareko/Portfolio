SELECT *
FROM Covid19Data
ORDER by 3,4

--select everything in the table--
SELECT date,location,total_cases,total_deaths,new_cases,new_deaths,population
FROM Covid19Data
ORDER by 1,2

--looking at the total cases vs deaths
SELECT date,location,total_cases, total_deaths ,(cast(total_deaths as int)/total_cases)*100 as DeathPercentage
FROM Covid19Data
WHERE location like '%Africa%'
ORDER by 1,2

--looking at the total cases and population
SELECT location,date,population,total_cases,round((total_cases/population)*100,4) as PopulationPercentage
FROM Covid19Data
WHERE location like '%state%'
ORDER by 1,2

---looking at countries with highest cases
SELECT location,date,population,max(total_cases) as HighestInfecCount,max(total_cases/population)*100 as HighestInfecCountPercentage
FROM Covid19Data
--WHERE location like '%Africa%'
GROUP by location,population
ORDER by HighestInfecCount DESC

---looking at countries with highest cases
SELECT location,date,population,max(total_cases) as HighestInfecCount,max(total_cases/population)*100 as HighestInfecCountPercentage
FROM Covid19Data
--WHERE location like '%Africa%'
GROUP by location,population
ORDER by HighestInfecCountPercentage DESC

---seeing highest deaths b continent
SELECT continent, max(cast(total_deaths as INT)) as TotalDeathCount
FROM Covid19Data
where continent is NOT NULL
group by continent
order by TotalDeathCount DESC

--seeing continent with highest death counts
SELECT continent, max(cast(total_deaths as INT)) as TotalDeathCount
FROM Covid19Data
where continent is NOT NULL
group by continent
order by TotalDeathCount DESC

---global numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Covid19Data
where continent is not null 
order by 1,2


----checking vaccinations
select *
FROM Covid19Data dea
join Covid19Vaccines vac
     On dea.location = vac.location
      AND dea.date = vac.date

---selecting columns from 2 tables--  
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
FROM Covid19Data dea
join Covid19Vaccines vac
     On dea.location = vac.location
      AND dea.date = vac.date
where dea.continent is not NULL
order by 1,2,3

----

---selecting columns from 2 tables---
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CAST(vac.new_vaccinations as INT))OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM Covid19Data dea
join Covid19Vaccines vac
     On dea.location = vac.location
      AND dea.date = vac.date
where dea.continent is not NULL
order by 2,3

-----use a CTE(Common Table Expression)------
with PopvsVac(continent,location,date,population,RollingPeopleVaccinated,new_vaccinations)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CAST(vac.new_vaccinations as INT))OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM Covid19Data dea
join Covid19Vaccines vac
     On dea.location = vac.location
      AND dea.date = vac.date
where dea.continent is not NULL
--order by 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac



--TEMP TABLE--
--DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

INSERT INTO #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CAST(vac.new_vaccinations as INT))OVER (partition by dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated
FROM Covid19Data dea
join Covid19Vaccines vac
     On dea.location = vac.location
      AND dea.date = vac.date
where dea.continent is not NULL
--order by 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

--Views
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM Covid19Data dea
join Covid19Vaccines vac
	On dea.location = vac.location
	and dea.date = vac.date
	
---TRIGGER

