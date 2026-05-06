---------------------Which age group subscribes the most to term deposits---------------------
Select 
Case when age between 0 and 25 then '[0,26['
     when age between 26 and 45 then '[26,46['
     when age between 46 and 55 then '[46,56['
     Else '[56&+]'
END as age_groups,
count(*) NB_custo
from clients
Where y = 'yes'
Group by 1
order by NB_cust desc;
---------------------Which job type has the highest conversion rate---------------------
Select 
job,
round(
	cast(
		count(*)filter(where y = 'yes')
		as numeric)
	/count(*),2) as conversion_rate
from clients
Group by 1
order by conversion_rate desc
---------------------Does education level influence the likelihood of subscription?---------------------
Select
education,
Round(
	Cast(
	count(*) filter(where y='yes') as numeric)
	/count(*),2) as likelihood


from clients
Group by 1
order by likelihood desc
---------------------Do customers with a credit default subscribe less?---------------------
Select 
default_,
y,
count(*) nb_subs
From clients
group by 1,2
order by default_, nb_subs desc
---------------------Do customers with a higher balance subscribe more?---------------------
With source as (
Select
y,

BALANCE,
Case when balance > (select round(avg(balance),2)from clients) then 'High'
                else 'Low'
                End as balance_status
From clients
---group by 1,2
)
Select 
y,
count(y) High_balance_Count
from source
    Where balance_status = 'High'
group by 1
---------------------Does having a housing or personal loan reduce the likelihood of subscription?---------------------
----housing does reduce likelihood of subscription
Select 
housing,
loan,
round(
	Cast(Count(*) filter(where y = 'yes') as numeric)/ count(*),2) rate
From clients

Group by 1,2
---------------------Which contact channel converts the best?---------------------
---cellular does
Select 
contact, 
round(
cast(
	count(*) filter(where y = 'yes') as  numeric)/
	count(*)
	,2)  conversion_rate
From clients
Group by 1
order by conversion_rate




---------------------From how many calls does the conversion rate start to drop?---------------------
Select
campaign, 
count(*) filter(where y ='yes') converted_C,
count(*) all_C
From clients
Group by 1

---------------------What call duration is associated with the highest conversion rates?---------------------

Select 
Case 
when duration <300 then '[0-300['
when duration <600 then '[300-600['
when duration <900 then '[600-900['
else  '[900+['
End as classes,
round(cast (count(*)filter(where y ='yes') as numeric)/count(*),2) rate,
count(*)
from clients 
Group by 1

From how many calls does the conversion rate start to drop?
What call duration is associated with the highest conversion rates?
Which month of the year generates the most subscriptions?



---------------------Do customers previously contacted in a past campaign convert better?---------------------
Select 
Case when previous>0 then 'Yes'
Else 'No'
end as pre_status,
count(*)filter(where y='yes') converted,
count(*) all_Cust,  
round(cast(count(*)filter(where y='yes') as numeric)/count(*),2) conv_rate
from clients

Group by 1
---------------------Which month of the year generates the most subscriptions?---------------------
Select 
Case
when month = 'jan' then 1
when month = 'feb' then 2
when month = 'mar' then 3
when month = 'apr' then 4
when month = 'may' then 5
when month = 'jun' then 6
when month = 'jul' then 7
when month = 'aug' then 8
when month = 'sep' then 9
when month = 'oct' then 10
when month = 'nov' then 11
when month = 'dec' then 12
end as months,
count(*)filter(where y='yes')
From clients
Group by 1
order by months



---------------------Are there over-contacted customers (too many calls) who never convert?---------------------

Select 
previous,
Count(*)
From clients
Where previous>0
And poutcome = 'failure'
group by 1
Having previous>(Select avg(previous)
	
	from clients
Where previous>0) 
---------------------Which customer profile combines the most risk factors (default + loan + negative balance)?---------------------

Select
job,
education,
default_,
loan,
count(*) nbs
From 
clients
Where balance<1
And default_ = 'yes'
And loan = 'yes'
Group by 1,2,3,4
order by  nbs desc
---------------------Which customer segment is the most valuable to target for a future campaign?---------------------

Select 
job,
marital,
education,
Count(*) as Nb_Clients,
count(*) filter(where y = 'yes')AS converted,
round(cast(count(*) filter(where y = 'yes') as numeric)/Count(*),2)  Conv_rate
From 
clients
Group by 1,2,3

