--3.1
SELECT name FROM program;

select distinct duration from project
order by duration

select distinct exec from project
order by exec

SELECT p.title as Project_title
from project p
where p.start_date < current_date()
and p.exec = '{}' and p.duration = '{}' and ((p.start_date > '{}')  and (p.end_date < '{}'));

select t.Full_name from
(select p.title , concat(r.last_name," ", r.first_name) as Full_name
from researcher r
inner join worksfor w on r.id = w.id
inner join project p on w.title = p.title
where p.title = '{}'
order by Full_name) t
ORDER BY t.Full_name;

--3.2

SELECT concat(r.last_name," ", r.first_name) as Full_name, p.title as title_of_project
FROM researcher r
INNER JOIN worksfor w ON r.id = w.id
INNER JOIN project p ON w.title = p.title
ORDER BY Full_name;


SELECT o.name as organization_name, p.title as title_of_project
FROM organization o
INNER JOIN project p on o.name = p.from_org
ORDER BY organization_name;


--3.3
select * from scientific_field;

SELECT p.title, concat(r.last_name," ", r.first_name) as Full_name  FROM fieldthatdescribes f
INNER JOIN project p ON f.title = p.title
INNER JOIN worksfor w ON p.title = w.title
INNER JOIN researcher r ON w.id = r.id
WHERE r.works_since <= current_date() AND f.name = '{}'
AND p.end_date > current_date() AND p.start_date < current_date()
union
SELECT p.title, p.exec as Full_name  FROM fieldthatdescribes f
INNER JOIN project p ON f.title = p.title
WHERE f.name = '{}'
AND p.end_date > current_date() AND p.start_date < current_date()
ORDER BY title;

--3.4

select o1.name, o1.year, o2.year,o1.projects
from (select o.name, extract( year from p.start_date) as year, count(*) as projects
from organization o
inner join project p on o.name = p.from_org
group by year, name) o1
inner join (select o.name, extract( year from p.start_date) as year, count(*) as projects
from organization o
inner join project p on o.name = p.from_org
group by year, name) o2 on o1.name = o2.name
where ( o1.year <> o2.year and o1.year < o2.year)
and o2.year - o1.year = 1 and o1.projects = o2.projects and o1.projects >= 10;

--3.5
SELECT s1.name as project_1, s2.name as project_2
FROM scientific_field s1
INNER JOIN fieldthatdescribes f1 ON s1.name = f1.name
INNER JOIN fieldthatdescribes f2 ON f1.title = f2.title
INNER JOIN scientific_field s2 ON f2.name = s2.name
WHERE s1.name <> s2.name
GROUP BY s1.name, s2.name
LIMIT 3;


--3.6
SELECT concat(r.first_name," ", r.last_name) as Full_name, COUNT(*) as number_of_projects
FROM researcher r
INNER JOIN worksfor w ON r.id = w.id
INNER JOIN project p ON w.title = p.title
WHERE r.age < 40
AND p.end_date > curdate() AND p.start_date < curdate()
GROUP BY Full_name
ORDER BY number_of_projects DESC

--3.7
SELECT p.exec as project_executive, c.name as company_name, SUM(p.amount) as total_amount
FROM project p
INNER JOIN organization o ON p.from_org = o.name
INNER JOIN company c ON o.name = c.name
GROUP BY p.exec, o.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

--3.8
select * from (
select concat(last_name, " ", first_name) as Full_name, count(*) as projects  from (
(select r.last_name, r.first_name
from researcher r
inner join worksfor w on r.id = w.id
inner join project p on w.title = p.title
left join deliverable d on p.title = d.title_project
where d.title_project is null )) A
group by A.last_name, A.first_name ) B
where projects >= 5
order by projects desc;
