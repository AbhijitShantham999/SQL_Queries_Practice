select * from correct_answer;
select * from question_paper_code;
select * from student_list;
select * from student_response;

alter table question_paper_code change ï»¿paper_code paper_code int;
alter table student_list change ï»¿roll_number roll_number int;

-- OUTPUT_TABLE_COLUMN_NAMES
-- 	Roll_number
-- 	Student_name
-- 	Class
-- 	Section
-- 	School_name
-- 	Math_correct
-- 	Math_wrong
-- 	Math_yet_to_learn
-- 	Math_score
-- 	Math_percentage
-- 	Science_correct
-- 	Science_wrong
-- 	Science_yet_learn
-- 	Science_score
-- 	Science_percentage

with my_cte as (select  sl.Roll_number,Student_name,sl.class,Section,school_name
				,sum(case when subject = 'math' and option_marked = correct_option and option_marked <> 'e' then 1 else 0 end) as math_correct
				,sum(case when subject = 'math' and option_marked != correct_option and option_marked <> 'e' then 1 else 0 end) as math_wrong
				,sum(case when subject = 'math' and  option_marked = 'e' then 1 else 0 end) as math_yet_to_learn
				,sum(case when subject = 'math' then 1 else 0 end) as total_math_score
				,sum(case when subject = 'science' and option_marked = correct_option and option_marked <> 'e' then 1 else 0 end) as science_correct
				,sum(case when subject = 'science' and option_marked != correct_option and option_marked <> 'e' then 1 else 0 end) as science_wrong
				,sum(case when subject = 'science' and  option_marked = 'e' then 1 else 0 end) as science_yet_to_learn
				,sum(case when subject = 'science' then 1 else 0 end) as total_science_score
				from student_list sl
				join student_response sr on sl.roll_number = sr.roll_number
				join correct_answer ca on ca.question_paper_code = sr.question_paper_code and ca.question_number = sr.question_number
				join question_paper_code qpc on qpc.paper_code = ca.question_paper_code
				group by sl.Roll_number,Student_name,sl.class,Section,school_name
                )
select Roll_number,Student_name,class,Section,school_name,
math_correct,math_wrong,math_yet_to_learn,math_correct as math_score,
	round((math_correct/total_math_score)*100,2) as math_percentage,
science_correct,science_wrong,science_yet_to_learn,science_correct as science_score,
	round((science_correct/total_science_score)*100,2) as science_percentage
from my_cte