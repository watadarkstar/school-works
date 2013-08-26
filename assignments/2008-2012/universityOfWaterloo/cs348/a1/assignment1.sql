-- Q1
select distinct p.pnum, pname, p.dept \
from professor p, class c, schedule s \
where s.cnum = c.cnum \
and s.term = c.term \
and s.section = c.section \
and (s.day = 'Monday' or \
     s.day = 'Friday') \
and c.pnum = p.pnum \
and exists (select * \
	    from mark m \
	    where m.cnum = c.cnum \
	    and   m.term = c.term \
	    and   m.section = c.section \
	    )


-- Q2
select s.snum, s.sname \
from student s, enrollment e \
where s.year = '2' \
and e.snum = s.snum \
and e.cnum = 'CS348' \
and not exists (select * \
		from mark m \
		where m.snum = e.snum \
		and   m.cnum = e.cnum \
		and   m.term = e.term \
		and   m.section = e.section \
		)


-- Q3
select s.snum, co.cnum, co.cname, m.grade \
from student s, enrollment e, class c, professor p, course co, mark m \
where s.sname = 'Smith, Fred' \
and s.snum = e.snum \
and e.cnum = c.cnum \
and e.term = c.term \
and e.section = c.section \
and c.pnum = p.pnum \
and p.dept <> 'Computer Science' \
and c.cnum = co.cnum \
and m.snum = e.snum \
and m.cnum = e.cnum \
and m.section = e.section \
and m.term = e.term 


-- Q4
select snum, sname, s.year \
from student s \
where s.year = '3' \
or s.year = '4' \
and exists (select * \
	    from mark m \
	    where m.snum = s.snum \
	    and m.grade >= 90 \
	    ) \
and not exists (select * \
		from enrollment e, class c, professor p \
		where s.snum = e.snum \
		and e.cnum = c.cnum \
		and e.term = c.term \
		and e.section = c.section \
		and c.pnum = p.pnum \
		and p.dept = 'Philosophy' \
		)


-- Q5
select distinct p.pnum, p.pname, p.dept \
from professor p, class c, schedule s \
where c.pnum = p.pnum \
and s.cnum = c.cnum \
and s.term = c.term \
and s.section = c.section \
and exists (select * \
	    from class c, schedule s, professor p \
	    where c.cnum = s.cnum \
	    and   c.term = s.term \
	    and   c.section = s.section \
	    and   s.day = 'Monday' \
	    and   p.pnum = c.pnum \
	    ) \
and exists (select * \
	    from class c, schedule s, professor p \
	    where c.cnum = s.cnum \
	    and   c.term = s.term \
	    and   c.section = s.section \
	    and   s.day = 'Friday' \
	    and   p.pnum = c.pnum \
	    ) \
and not exists (select * \
		from mark m \
		where m.cnum = c.cnum \
		and   m.term = c.term \
		and   m.section = c.section \
		) \
order by p.dept ASC, p.pname ASC


-- Q6
select distinct c.cnum, c.section, p.pnum, p.dept \
from class c, professor p \
where c.pnum = p.pnum \
and not exists (select * \
		from mark m \
		where m.cnum = c.cnum \
		and   m.term = c.term \
		and   m.section = c.section \
		)


-- Q7
select e.cnum, COUNT(*) as total_enrollment \
from enrollment e \
group by e.cnum, e.term \
having COUNT(*) in ( \
	select * \
	from (select distinct COUNT (*) as num1 \
	      from enrollment temp1 \
	      group by temp1.cnum, temp1.term ) as a \
	where (select COUNT(*) \
	       from (select distinct COUNT(*) as num2 \
		     from enrollment temp2 \
		     group by temp2.cnum, temp2.term ) as b \
	       where b.num2 < a.num1) < 2)


-- Q8
select p.pnum, p.pname, c.cnum, c.term, c.section, COUNT(*) as num_of_students \
from professor p, class c, student s, enrollment e \
where (s.year = 3 \
or s.year = 4) \
and p.dept = 'Pure Mathematics' \
and s.snum = e.snum \
and e.cnum = c.cnum \
and e.term = c.term \
and e.section = c.section \
and exists (select * \
	    from mark m \
	    where m.snum = e.snum \
	    and	  m.cnum = e.cnum \
	    and   m.term = e.term \
	    and   m.section = e.section \
	    ) \
group by p.pname, p.pnum, c.cnum, c.term, c.section \
order by p.pname ASC, p.pnum ASC, c.cnum ASC, c.term ASC, c.section ASC


-- Q9
select p.pnum, p.pname, c.cnum, co.cname, c.term, c.section, MIN(m.grade) as min_grade, MAX(m.grade) as max_grade \
from professor p, class c, course co, mark m \
where c.pnum = p.pnum \
and c.cnum = co.cnum \
and p.dept = 'Computer Science' \
and m.cnum = c.cnum \
and m.term = c.term \
and m.section = c.section \
group by p.pnum, p.pname, c.cnum, co.cname, c.term, c.section


-- Q10
select (COUNT(*)*100/(select COUNT(*) \
		      from professor p \
	              where p.dept = 'Pure Mathematics')) as Percents \
from professor p \
where p.dept = 'Pure Mathematics' \
and p.pnum not in (select p.pnum \
		   from professor p, class c \
		   where p.pnum = c.pnum \
		   group by p.pnum, c.term \
		   having COUNT(c.term) > 1 \
)

