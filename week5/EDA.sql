# 1
select * from application limit 100;

select * from bureau limit 100;

select * from bureau_balance limit 100;

select * from credit_card_balance limit 100;

select * from installments_payments limit 100;

select * from previous_application limit 100;

select * from POS_CASH_balance limit 100;

# 2&3
describe application;
describe bureau;
describe bureau_balance;
describe credit_card_balance;
describe installments_payments;
describe previous_application;
describe POS_CASH_balance;

# 4
select count(*), count(distinct sk_id_curr) from application; 

select count(*), count(distinct sk_id_curr) from bureau; 

select count(*), count(distinct SK_ID_BUREAU) from bureau_balance; 

select count(*), count(distinct sk_id_curr) from credit_card_balance; 

select count(*), count(distinct sk_id_curr) from installments_payments; 

select count(*), count(distinct sk_id_curr) from previous_application; 

select count(*), count(distinct sk_id_curr) from POS_CASH_balance; 

# 5
select credit_type, count(*), count(distinct sk_id_curr)
from bureau group by 1;
-- one customer can help multiple same credit products

# 6
select a.*,
b.SK_BUREAU_ID,
b.CREDIT_ACTIVE,
b.CREDIT_CURRENCY,
b.DAYS_CREDIT,
b.AMT_CREDIT_SUM,
b.AMT_CREDIT_SUM_DEBT,
b.CREDIT_TYPE
from application as a
join bureau as b
on a.sk_id_curr=b.sk_id_curr
where a.sk_id_curr=215354;

# 7 
select count(distinct amt_credit) from application;
select AMT_CREDIT, count(*) from application group by 1 limit 6000;

# 8
select target, count(*) from application group by 1;

# 9
select NAME_CONTRACT_TYPE, count(*) from application group by 1;

# 10
select NAME_INCOME_TYPE, count(*) from application group by 1;

# 11
select NAME_EDUCATION_TYPE, count(*) from application group by 1;

# 12
select target, NAME_EDUCATION_TYPE, count(*) from application group by 1,2;

#13 
select target, OCCUPATION_TYPE, count(*) from application group by 1,2;

# 14 check average and median income by different job titles
	-- median is not supported by SQL, we need to use Python later
    
select ORGANIZATION_TYPE, avg(AMT_INCOME_TOTAL)
from application group by 1;

# 15 new variable creation
select *,
AMT_CREDIT/AMT_ANNUITY as NEW_CREDIT_TO_ANNUITY_RATIO,
AMT_CREDIT/AMT_GOODS_PRICE as NEW_CREDIT_TO_GOODS_RATIO,
OWN_CAR_AGE/DAYS_BIRTH as NEW_CAR_TO_BIRTH_RATIO,
OWN_CAR_AGE/DAYS_EMPLOYED as NEW_CAR_TO_EMPLOY_RATIO,
AMT_CREDIT/AMT_INCOME_TOTAL as NEW_CREDIT_TO_INCOME_RATIO, -- one of the most important variable! DTI
AMT_ANNUITY/AMT_INCOME_TOTAL as NEW_ANNUITY_TO_INCOME_RATIO
from application;

# 16

select a.*, 
AMT_CREDIT/AMT_ANNUITY as NEW_CREDIT_TO_ANNUITY_RATIO,
AMT_CREDIT/AMT_GOODS_PRICE as NEW_CREDIT_TO_GOODS_RATIO,
OWN_CAR_AGE/DAYS_BIRTH as NEW_CAR_TO_BIRTH_RATIO,
OWN_CAR_AGE/DAYS_EMPLOYED as NEW_CAR_TO_EMPLOY_RATIO,
AMT_CREDIT/AMT_INCOME_TOTAL as NEW_CREDIT_TO_INCOME_RATIO, -- one of the most important variable! DTI
AMT_ANNUITY/AMT_INCOME_TOTAL as NEW_ANNUITY_TO_INCOME_RATIO,
b.NEW_AVG_INC_BY_ORG
from
application as a
left join
(select ORGANIZATION_TYPE, avg(AMT_INCOME_TOTAL) as NEW_AVG_INC_BY_ORG
from application group by 1) as b
on a.ORGANIZATION_TYPE=b.ORGANIZATION_TYPE;

# 18
-- select * from bureau where sk_id_curr=215354;
-- select CREDIT_ACTIVE, credit_type, count(distinct SK_ID_CURR) from bureau group by 1,2;
-- select * from bureau_balance where sk_id_bureau=5714463;

select SK_ID_CURR, CREDIT_ACTIVE,
max(DAYS_CREDIT),
min(DAYS_CREDIT),
avg(DAYS_CREDIT),

max(DAYS_CREDIT_ENDDATE),
min(DAYS_CREDIT_ENDDATE),
avg(DAYS_CREDIT_ENDDATE),

max(CREDIT_DAY_OVERDUE),
avg(CREDIT_DAY_OVERDUE),

avg(AMT_CREDIT_MAX_OVERDUE),

avg(AMT_CREDIT_SUM),
sum(AMT_CREDIT_SUM),

avg(AMT_CREDIT_SUM_DEBT),
sum(AMT_CREDIT_SUM_DEBT),

avg(AMT_CREDIT_SUM_OVERDUE),
sum(AMT_CREDIT_SUM_OVERDUE),

avg(AMT_CREDIT_SUM_LIMIT),
sum(AMT_CREDIT_SUM_LIMIT),

avg(AMT_ANNUITY),
sum(AMT_ANNUITY)

from bureau 
-- use one account to test: where sk_id_curr=215354
group by 1,2;

# 19 flat the data
-- select distinct CREDIT_ACTIVE from bureau;

select SK_ID_CURR,
max(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT else null end) as cl_max_DAYS_CREDIT,
min(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT else null end) as cl_min_DAYS_CREDIT,
avg(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT else null end) as cl_avg_DAYS_CREDIT,
max(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT else null end) as ac_max_DAYS_CREDIT,
min(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT else null end) as ac_min_DAYS_CREDIT,
avg(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT else null end) as ac_avg_DAYS_CREDIT,
max(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT else null end) as sd_max_DAYS_CREDIT,
min(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT else null end) as sd_min_DAYS_CREDIT,
avg(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT else null end) as sd_avg_DAYS_CREDIT,
max(case when CREDIT_ACTIVE ='Bad Debt' then DAYS_CREDIT else null end) as bd_max_DAYS_CREDIT,
min(case when CREDIT_ACTIVE='Bad Debt' then DAYS_CREDIT else null end) as bd_min_DAYS_CREDIT,
avg(case when CREDIT_ACTIVE='Bad Debt' then DAYS_CREDIT else null end) as bd_avg_DAYS_CREDIT,

max(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT_ENDDATE else null end) as cl_max_DAYS_CREDIT_ENDDATE,
min(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT_ENDDATE else null end) as cl_min_DAYS_CREDIT_ENDDATE,
avg(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT_ENDDATE else null end) as cl_avg_DAYS_CREDIT_ENDDATE,
max(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT_ENDDATE else null end) as ac_max_DAYS_CREDIT_ENDDATE,
min(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT_ENDDATE else null end) as ac_min_DAYS_CREDIT_ENDDATE,
avg(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT_ENDDATE else null end) as ac_avg_DAYS_CREDIT_ENDDATE,
max(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT_ENDDATE else null end) as sd_max_DAYS_CREDIT_ENDDATE,
min(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT_ENDDATE else null end) as sd_min_DAYS_CREDIT_ENDDATE,
avg(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT_ENDDATE else null end) as sd_avg_DAYS_CREDIT_ENDDATE,
max(case when CREDIT_ACTIVE ='Bad Debt' then DAYS_CREDIT_ENDDATE else null end) as bd_max_DAYS_CREDIT_ENDDATE,
min(case when CREDIT_ACTIVE='Bad Debt' then DAYS_CREDIT_ENDDATE else null end) as bd_min_DAYS_CREDIT_ENDDATE,
avg(case when CREDIT_ACTIVE='Bad Debt' then DAYS_CREDIT_ENDDATE else null end) as bd_avg_DAYS_CREDIT_ENDDATE,

max(case when CREDIT_ACTIVE='Closed' then CREDIT_DAY_OVERDUE else null end) as cl_max_CREDIT_DAY_OVERDUE,
max(case when CREDIT_ACTIVE='Active' then CREDIT_DAY_OVERDUE else null end) as ac_max_CREDIT_DAY_OVERDUE,
max(case when CREDIT_ACTIVE='Sold' then CREDIT_DAY_OVERDUE else null end) as sd_max_CREDIT_DAY_OVERDUE,
max(case when CREDIT_ACTIVE ='Bad Debt' then CREDIT_DAY_OVERDUE else null end) as bd_max_CREDIT_DAY_OVERDUE,
avg(case when CREDIT_ACTIVE='Closed' then CREDIT_DAY_OVERDUE else null end) as cl_avg_CREDIT_DAY_OVERDUE,
avg(case when CREDIT_ACTIVE='Active' then CREDIT_DAY_OVERDUE else null end) as ac_avg_CREDIT_DAY_OVERDUE,
avg(case when CREDIT_ACTIVE='Sold' then CREDIT_DAY_OVERDUE else null end) as sd_avg_CREDIT_DAY_OVERDUE,
avg(case when CREDIT_ACTIVE='Bad Debt' then CREDIT_DAY_OVERDUE else null end) as bd_avg_CREDIT_DAY_OVERDUE,

avg(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_MAX_OVERDUE else null end) as cl_avg_AMT_CREDIT_MAX_OVERDUE,
avg(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_MAX_OVERDUE else null end) as ac_avg_AMT_CREDIT_MAX_OVERDUE,
avg(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_MAX_OVERDUE else null end) as sd_avg_AMT_CREDIT_MAX_OVERDUE,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_MAX_OVERDUE else null end) as bd_avg_AMT_CREDIT_MAX_OVERDUE,

avg(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM else null end) as cl_avg_AMT_CREDIT_SUM,
sum(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM else null end) as cl_sum_AMT_CREDIT_SUM,
avg(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM else null end) as ac_avg_AMT_CREDIT_SUM,
sum(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM else null end) as ac_sum_AMT_CREDIT_SUM,
avg(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM else null end) as sd_avg_AMT_CREDIT_SUM,
sum(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM else null end) as sd_sum_AMT_CREDIT_SUM,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM else null end) as bd_avg_AMT_CREDIT_SUM,
sum(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM else null end) as bd_sum_AMT_CREDIT_SUM,

avg(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_DEBT else null end) as cl_avg_AMT_CREDIT_SUM_DEBT,
sum(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_DEBT else null end) as cl_sum_AMT_CREDIT_SUM_DEBT,
avg(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_DEBT else null end) as ac_avg_AMT_CREDIT_SUM_DEBT,
sum(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_DEBT else null end) as ac_sum_AMT_CREDIT_SUM_DEBT,
avg(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_DEBT else null end) as sd_avg_AMT_CREDIT_SUM_DEBT,
sum(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_DEBT else null end) as sd_sum_AMT_CREDIT_SUM_DEBT,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_DEBT else null end) as bd_avg_AMT_CREDIT_SUM_DEBT,
sum(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_DEBT else null end) as bd_sum_AMT_CREDIT_SUM_DEBT,

avg(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_OVERDUE else null end) as cl_avg_AMT_CREDIT_SUM_OVERDUE,
sum(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_OVERDUE else null end) as cl_sum_AMT_CREDIT_SUM_OVERDUE,
avg(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_OVERDUE else null end) as ac_avg_AMT_CREDIT_SUM_OVERDUE,
sum(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_OVERDUE else null end) as ac_sum_AMT_CREDIT_SUM_OVERDUE,
avg(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_OVERDUE else null end) as sd_avg_AMT_CREDIT_SUM_OVERDUE,
sum(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_OVERDUE else null end) as sd_sum_AMT_CREDIT_SUM_OVERDUE,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_OVERDUE else null end) as bd_avg_AMT_CREDIT_SUM_OVERDUE,
sum(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_OVERDUE else null end) as bd_sum_AMT_CREDIT_SUM_OVERDUE,

avg(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_LIMIT else null end) as cl_avg_AMT_CREDIT_SUM_LIMIT,
sum(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_LIMIT else null end) as cl_sum_AMT_CREDIT_SUM_LIMIT,
avg(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_LIMIT else null end) as ac_avg_AMT_CREDIT_SUM_LIMIT,
sum(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_LIMIT else null end) as ac_sum_AMT_CREDIT_SUM_LIMIT,
avg(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_LIMIT else null end) as sd_avg_AMT_CREDIT_SUM_LIMIT,
sum(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_LIMIT else null end) as sd_sum_AMT_CREDIT_SUM_LIMIT,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_LIMIT else null end) as bd_avg_AMT_CREDIT_SUM_LIMIT,
sum(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_LIMIT else null end) as bd_sum_AMT_CREDIT_SUM_LIMIT,

avg(case when CREDIT_ACTIVE='Closed' then AMT_ANNUITY else null end) as cl_avg_AMT_ANNUITY,
sum(case when CREDIT_ACTIVE='Closed' then AMT_ANNUITY else null end) as cl_sum_AMT_ANNUITY,
avg(case when CREDIT_ACTIVE='Active' then AMT_ANNUITY else null end) as ac_avg_AMT_ANNUITY,
sum(case when CREDIT_ACTIVE='Active' then AMT_ANNUITY else null end) as ac_sum_AMT_ANNUITY,
avg(case when CREDIT_ACTIVE='Sold' then AMT_ANNUITY else null end) as sd_avg_AMT_ANNUITY,
sum(case when CREDIT_ACTIVE='Sold' then AMT_ANNUITY else null end) as sd_sum_AMT_ANNUITY,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_ANNUITY else null end) as bd_avg_AMT_ANNUITY,
sum(case when CREDIT_ACTIVE='Bad Debt' then AMT_ANNUITY else null end) as bd_sum_AMT_ANNUITY

from bureau
-- use one account to test: where sk_id_curr=215354
group by 1;

# 20
-- describe bureau;
/* select sk_bureau_id, credit_active, count(distinct sk_id_curr), count(*) from bureau group by 1,2
having count(distinct sk_id_curr) <> count(*); */

select SK_ID_CURR, 
max(case when  CREDIT_ACTIVE='Bad Debt'  then 1 else 0 end) as bd_flag, 
sum(case when  CREDIT_ACTIVE='Bad Debt'  then 1 else 0 end) as bd_num
from bureau
group by 1;


# 21

select 
sum(case when  CREDIT_ACTIVE='Bad Debt'  then 1 else 0 end) as bd_num,
count(distinct SK_ID_CURR) from bureau;

-- select * from bureau where CREDIT_ACTIVE='Bad Debt' 

# 22

select a.*, 
AMT_CREDIT/AMT_ANNUITY as NEW_CREDIT_TO_ANNUITY_RATIO,
AMT_CREDIT/AMT_GOODS_PRICE as NEW_CREDIT_TO_GOODS_RATIO,
OWN_CAR_AGE/DAYS_BIRTH as NEW_CAR_TO_BIRTH_RATIO,
OWN_CAR_AGE/DAYS_EMPLOYED as NEW_CAR_TO_EMPLOY_RATIO,
AMT_CREDIT/AMT_INCOME_TOTAL as NEW_CREDIT_TO_INCOME_RATIO, -- one of the most important variable! DTI
AMT_ANNUITY/AMT_INCOME_TOTAL as NEW_ANNUITY_TO_INCOME_RATIO,
b.NEW_AVG_INC_BY_ORG,
c.cl_max_DAYS_CREDIT,
c.cl_min_DAYS_CREDIT,
c.cl_avg_DAYS_CREDIT,
c.ac_max_DAYS_CREDIT,
c.ac_min_DAYS_CREDIT,
c.ac_avg_DAYS_CREDIT,
c.sd_max_DAYS_CREDIT,
c.sd_min_DAYS_CREDIT,
c.sd_avg_DAYS_CREDIT,
c.bd_max_DAYS_CREDIT,
c.bd_min_DAYS_CREDIT,
c.bd_avg_DAYS_CREDIT,
c.cl_max_DAYS_CREDIT_ENDDATE,
c.cl_min_DAYS_CREDIT_ENDDATE,
c.cl_avg_DAYS_CREDIT_ENDDATE,
c.ac_max_DAYS_CREDIT_ENDDATE,
c.ac_min_DAYS_CREDIT_ENDDATE,
c.ac_avg_DAYS_CREDIT_ENDDATE,
c.sd_max_DAYS_CREDIT_ENDDATE,
c.sd_min_DAYS_CREDIT_ENDDATE,
c.sd_avg_DAYS_CREDIT_ENDDATE,
c.bd_max_DAYS_CREDIT_ENDDATE,
c.bd_min_DAYS_CREDIT_ENDDATE,
c.bd_avg_DAYS_CREDIT_ENDDATE,
c.cl_max_CREDIT_DAY_OVERDUE,
c.ac_max_CREDIT_DAY_OVERDUE,
c.sd_max_CREDIT_DAY_OVERDUE,
c.bd_max_CREDIT_DAY_OVERDUE,
c.cl_avg_CREDIT_DAY_OVERDUE,
c.ac_avg_CREDIT_DAY_OVERDUE,
c.sd_avg_CREDIT_DAY_OVERDUE,
c.bd_avg_CREDIT_DAY_OVERDUE,
c.cl_avg_AMT_CREDIT_MAX_OVERDUE,
c.ac_avg_AMT_CREDIT_MAX_OVERDUE,
c.sd_avg_AMT_CREDIT_MAX_OVERDUE,
c.bd_avg_AMT_CREDIT_MAX_OVERDUE,
c.cl_avg_AMT_CREDIT_SUM,
c.cl_sum_AMT_CREDIT_SUM,
c.ac_avg_AMT_CREDIT_SUM,
c.ac_sum_AMT_CREDIT_SUM,
c.sd_avg_AMT_CREDIT_SUM,
c.sd_sum_AMT_CREDIT_SUM,
c.bd_avg_AMT_CREDIT_SUM,
c.bd_sum_AMT_CREDIT_SUM,
c.cl_avg_AMT_CREDIT_SUM_DEBT,
c.cl_sum_AMT_CREDIT_SUM_DEBT,
c.ac_avg_AMT_CREDIT_SUM_DEBT,
c.ac_sum_AMT_CREDIT_SUM_DEBT,
c.sd_avg_AMT_CREDIT_SUM_DEBT,
c.sd_sum_AMT_CREDIT_SUM_DEBT,
c.bd_avg_AMT_CREDIT_SUM_DEBT,
c.bd_sum_AMT_CREDIT_SUM_DEBT,
c.cl_avg_AMT_CREDIT_SUM_OVERDUE,
c.cl_sum_AMT_CREDIT_SUM_OVERDUE,
c.ac_avg_AMT_CREDIT_SUM_OVERDUE,
c.ac_sum_AMT_CREDIT_SUM_OVERDUE,
c.sd_avg_AMT_CREDIT_SUM_OVERDUE,
c.sd_sum_AMT_CREDIT_SUM_OVERDUE,
c.bd_avg_AMT_CREDIT_SUM_OVERDUE,
c.bd_sum_AMT_CREDIT_SUM_OVERDUE,
c.cl_avg_AMT_CREDIT_SUM_LIMIT,
c.cl_sum_AMT_CREDIT_SUM_LIMIT,
c.ac_avg_AMT_CREDIT_SUM_LIMIT,
c.ac_sum_AMT_CREDIT_SUM_LIMIT,
c.sd_avg_AMT_CREDIT_SUM_LIMIT,
c.sd_sum_AMT_CREDIT_SUM_LIMIT,
c.bd_avg_AMT_CREDIT_SUM_LIMIT,
c.bd_sum_AMT_CREDIT_SUM_LIMIT,
c.cl_avg_AMT_ANNUITY,
c.cl_sum_AMT_ANNUITY,
c.ac_avg_AMT_ANNUITY,
c.ac_sum_AMT_ANNUITY,
c.sd_avg_AMT_ANNUITY,
c.sd_sum_AMT_ANNUITY,
c.bd_avg_AMT_ANNUITY,
c.bd_sum_AMT_ANNUITY,
c.bd_flag,
c.bd_num
from
application as a
left join
(select ORGANIZATION_TYPE, avg(AMT_INCOME_TOTAL) as NEW_AVG_INC_BY_ORG
from application group by 1) as b
on a.ORGANIZATION_TYPE=b.ORGANIZATION_TYPE
left join 
(
select SK_ID_CURR,
max(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT else null end) as cl_max_DAYS_CREDIT,
min(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT else null end) as cl_min_DAYS_CREDIT,
avg(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT else null end) as cl_avg_DAYS_CREDIT,
max(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT else null end) as ac_max_DAYS_CREDIT,
min(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT else null end) as ac_min_DAYS_CREDIT,
avg(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT else null end) as ac_avg_DAYS_CREDIT,
max(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT else null end) as sd_max_DAYS_CREDIT,
min(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT else null end) as sd_min_DAYS_CREDIT,
avg(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT else null end) as sd_avg_DAYS_CREDIT,
max(case when CREDIT_ACTIVE ='Bad Debt' then DAYS_CREDIT else null end) as bd_max_DAYS_CREDIT,
min(case when CREDIT_ACTIVE='Bad Debt' then DAYS_CREDIT else null end) as bd_min_DAYS_CREDIT,
avg(case when CREDIT_ACTIVE='Bad Debt' then DAYS_CREDIT else null end) as bd_avg_DAYS_CREDIT,

max(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT_ENDDATE else null end) as cl_max_DAYS_CREDIT_ENDDATE,
min(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT_ENDDATE else null end) as cl_min_DAYS_CREDIT_ENDDATE,
avg(case when CREDIT_ACTIVE='Closed' then DAYS_CREDIT_ENDDATE else null end) as cl_avg_DAYS_CREDIT_ENDDATE,
max(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT_ENDDATE else null end) as ac_max_DAYS_CREDIT_ENDDATE,
min(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT_ENDDATE else null end) as ac_min_DAYS_CREDIT_ENDDATE,
avg(case when CREDIT_ACTIVE='Active' then DAYS_CREDIT_ENDDATE else null end) as ac_avg_DAYS_CREDIT_ENDDATE,
max(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT_ENDDATE else null end) as sd_max_DAYS_CREDIT_ENDDATE,
min(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT_ENDDATE else null end) as sd_min_DAYS_CREDIT_ENDDATE,
avg(case when CREDIT_ACTIVE='Sold' then DAYS_CREDIT_ENDDATE else null end) as sd_avg_DAYS_CREDIT_ENDDATE,
max(case when CREDIT_ACTIVE ='Bad Debt' then DAYS_CREDIT_ENDDATE else null end) as bd_max_DAYS_CREDIT_ENDDATE,
min(case when CREDIT_ACTIVE='Bad Debt' then DAYS_CREDIT_ENDDATE else null end) as bd_min_DAYS_CREDIT_ENDDATE,
avg(case when CREDIT_ACTIVE='Bad Debt' then DAYS_CREDIT_ENDDATE else null end) as bd_avg_DAYS_CREDIT_ENDDATE,

max(case when CREDIT_ACTIVE='Closed' then CREDIT_DAY_OVERDUE else null end) as cl_max_CREDIT_DAY_OVERDUE,
max(case when CREDIT_ACTIVE='Active' then CREDIT_DAY_OVERDUE else null end) as ac_max_CREDIT_DAY_OVERDUE,
max(case when CREDIT_ACTIVE='Sold' then CREDIT_DAY_OVERDUE else null end) as sd_max_CREDIT_DAY_OVERDUE,
max(case when CREDIT_ACTIVE ='Bad Debt' then CREDIT_DAY_OVERDUE else null end) as bd_max_CREDIT_DAY_OVERDUE,
avg(case when CREDIT_ACTIVE='Closed' then CREDIT_DAY_OVERDUE else null end) as cl_avg_CREDIT_DAY_OVERDUE,
avg(case when CREDIT_ACTIVE='Active' then CREDIT_DAY_OVERDUE else null end) as ac_avg_CREDIT_DAY_OVERDUE,
avg(case when CREDIT_ACTIVE='Sold' then CREDIT_DAY_OVERDUE else null end) as sd_avg_CREDIT_DAY_OVERDUE,
avg(case when CREDIT_ACTIVE='Bad Debt' then CREDIT_DAY_OVERDUE else null end) as bd_avg_CREDIT_DAY_OVERDUE,

avg(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_MAX_OVERDUE else null end) as cl_avg_AMT_CREDIT_MAX_OVERDUE,
avg(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_MAX_OVERDUE else null end) as ac_avg_AMT_CREDIT_MAX_OVERDUE,
avg(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_MAX_OVERDUE else null end) as sd_avg_AMT_CREDIT_MAX_OVERDUE,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_MAX_OVERDUE else null end) as bd_avg_AMT_CREDIT_MAX_OVERDUE,

avg(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM else null end) as cl_avg_AMT_CREDIT_SUM,
sum(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM else null end) as cl_sum_AMT_CREDIT_SUM,
avg(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM else null end) as ac_avg_AMT_CREDIT_SUM,
sum(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM else null end) as ac_sum_AMT_CREDIT_SUM,
avg(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM else null end) as sd_avg_AMT_CREDIT_SUM,
sum(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM else null end) as sd_sum_AMT_CREDIT_SUM,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM else null end) as bd_avg_AMT_CREDIT_SUM,
sum(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM else null end) as bd_sum_AMT_CREDIT_SUM,

avg(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_DEBT else null end) as cl_avg_AMT_CREDIT_SUM_DEBT,
sum(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_DEBT else null end) as cl_sum_AMT_CREDIT_SUM_DEBT,
avg(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_DEBT else null end) as ac_avg_AMT_CREDIT_SUM_DEBT,
sum(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_DEBT else null end) as ac_sum_AMT_CREDIT_SUM_DEBT,
avg(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_DEBT else null end) as sd_avg_AMT_CREDIT_SUM_DEBT,
sum(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_DEBT else null end) as sd_sum_AMT_CREDIT_SUM_DEBT,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_DEBT else null end) as bd_avg_AMT_CREDIT_SUM_DEBT,
sum(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_DEBT else null end) as bd_sum_AMT_CREDIT_SUM_DEBT,

avg(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_OVERDUE else null end) as cl_avg_AMT_CREDIT_SUM_OVERDUE,
sum(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_OVERDUE else null end) as cl_sum_AMT_CREDIT_SUM_OVERDUE,
avg(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_OVERDUE else null end) as ac_avg_AMT_CREDIT_SUM_OVERDUE,
sum(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_OVERDUE else null end) as ac_sum_AMT_CREDIT_SUM_OVERDUE,
avg(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_OVERDUE else null end) as sd_avg_AMT_CREDIT_SUM_OVERDUE,
sum(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_OVERDUE else null end) as sd_sum_AMT_CREDIT_SUM_OVERDUE,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_OVERDUE else null end) as bd_avg_AMT_CREDIT_SUM_OVERDUE,
sum(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_OVERDUE else null end) as bd_sum_AMT_CREDIT_SUM_OVERDUE,

avg(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_LIMIT else null end) as cl_avg_AMT_CREDIT_SUM_LIMIT,
sum(case when CREDIT_ACTIVE='Closed' then AMT_CREDIT_SUM_LIMIT else null end) as cl_sum_AMT_CREDIT_SUM_LIMIT,
avg(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_LIMIT else null end) as ac_avg_AMT_CREDIT_SUM_LIMIT,
sum(case when CREDIT_ACTIVE='Active' then AMT_CREDIT_SUM_LIMIT else null end) as ac_sum_AMT_CREDIT_SUM_LIMIT,
avg(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_LIMIT else null end) as sd_avg_AMT_CREDIT_SUM_LIMIT,
sum(case when CREDIT_ACTIVE='Sold' then AMT_CREDIT_SUM_LIMIT else null end) as sd_sum_AMT_CREDIT_SUM_LIMIT,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_LIMIT else null end) as bd_avg_AMT_CREDIT_SUM_LIMIT,
sum(case when CREDIT_ACTIVE='Bad Debt' then AMT_CREDIT_SUM_LIMIT else null end) as bd_sum_AMT_CREDIT_SUM_LIMIT,

avg(case when CREDIT_ACTIVE='Closed' then AMT_ANNUITY else null end) as cl_avg_AMT_ANNUITY,
sum(case when CREDIT_ACTIVE='Closed' then AMT_ANNUITY else null end) as cl_sum_AMT_ANNUITY,
avg(case when CREDIT_ACTIVE='Active' then AMT_ANNUITY else null end) as ac_avg_AMT_ANNUITY,
sum(case when CREDIT_ACTIVE='Active' then AMT_ANNUITY else null end) as ac_sum_AMT_ANNUITY,
avg(case when CREDIT_ACTIVE='Sold' then AMT_ANNUITY else null end) as sd_avg_AMT_ANNUITY,
sum(case when CREDIT_ACTIVE='Sold' then AMT_ANNUITY else null end) as sd_sum_AMT_ANNUITY,
avg(case when CREDIT_ACTIVE='Bad Debt' then AMT_ANNUITY else null end) as bd_avg_AMT_ANNUITY,
sum(case when CREDIT_ACTIVE='Bad Debt' then AMT_ANNUITY else null end) as bd_sum_AMT_ANNUITY,
max(case when  CREDIT_ACTIVE='Bad Debt'  then 1 else 0 end) as bd_flag, 
sum(case when  CREDIT_ACTIVE='Bad Debt'  then 1 else 0 end) as bd_num
from bureau
group by 1) as c
on a.SK_ID_CURR=c.SK_ID_CURR;


