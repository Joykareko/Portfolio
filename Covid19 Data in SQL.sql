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

