
SELECT * FROM finance_data;

alter table finance_data modify issue_d date;
alter table finance_data modify earliest_cr_line date;
alter table finance_data modify last_pymnt_d date;
alter table finance_data modify last_credit_pull_d date;

desc finance_data;

CREATE VIEW finance_data_summary AS
Select count(id) as Application_Count, concat(round(sum(funded_amnt) / 1000000.00, 2), ' M') as Total_Funded_Amount, 
concat(round(sum(total_pymnt) / 1000000.00, 2), ' M') as Total_loan_Payment_Received, 
concat(round(sum(total_rec_int)/ 1000000.00, 2), ' M') as Total_Interest_Received, 
concat(round(Avg(int_rate),2),' %') as Average_Interest_rate from finance_data;

select * from finance_data_summary;

-- Year wise loan amount Stats

CREATE VIEW KPI_1 AS
Select distinct monthname(issue_d), loan_status, concat(round(sum(loan_amnt) / 1000000.00, 2),' M') as Total_Amount from finance_data
group by monthname(issue_d),loan_status
order by loan_status desc,Total_Amount desc;

select * from KPI_1;

-- Grade & Sub Grade wise Revolutionary balances

CREATE VIEW KPI_2 AS
Select Grade, sub_grade, concat(round(sum(revol_bal) / 1000000.00, 2),' M') as Revolving_Balance from finance_data
group by Grade, sub_grade
order by Grade , Revolving_Balance desc;

select * from KPI_2;

-- Total Payment for Verification Status

CREATE VIEW KPI_3 AS
Select verification_status, concat(round(sum(total_pymnt) / 1000000.00, 2),' M') as Total_Payment from finance_data
group by verification_status
order by Total_Payment desc;

select * from KPI_3;

-- State wise and last_credit_pull_d wise loan status

CREATE VIEW KPI_4 AS
Select addr_state, year(last_credit_pull_d), concat(round(sum(total_pymnt) / 1000000.00, 2),' M') as Total_Payment from finance_data
group by addr_state, year(last_credit_pull_d)
order by addr_state, year(last_credit_pull_d), Total_Payment desc;

select * from KPI_4;

-- Home ownership Vs last payment date stats

CREATE VIEW KPI_5 AS
Select home_ownership, year(last_pymnt_d), concat(round(sum(total_pymnt) / 1000000.00, 2),' M') as Total_Payment from finance_data
group by home_ownership, year(last_pymnt_d)
order by home_ownership, year(last_pymnt_d), Total_Payment desc;

select * from KPI_5;

-- Total Application and Total Funded Amt by Purpose

CREATE VIEW KPI_6 AS
Select purpose, count(id) as Application_Count, concat(round(sum(funded_amnt) / 1000000.00, 2),' M') as Total_Funded_Amount from finance_data
group by purpose
order by Total_Funded_Amount desc;

select * from KPI_6;

-- Total Applications By Employment length of Years 

CREATE VIEW KPI_7 AS
Select emp_length, count(id) as Application_Count from finance_data
group by emp_length
order by Application_Count desc;

select * from KPI_7;

-- Grade Wise Avg Interest rate

CREATE VIEW KPI_8 AS
Select grade, concat(round(Avg(int_rate),2),'%') as Average_Interest_rate from finance_data
group by grade
order by Average_Interest_rate desc;

select * from KPI_8;

-- Grade Wise Remaining Outstanding principal 

CREATE VIEW KPI_9 AS
Select grade, concat(round(sum(out_prncp)/1000.00),' K') as Outstanding_Principal from finance_data
group by grade
order by Outstanding_Principal desc;

select * from KPI_9;

-- Purpose Wise 30+ days past-due delinquency For 2 years

CREATE VIEW KPI_10 AS
Select purpose, sum(delinq_2yrs) as Delinquency_2years from finance_data
group by purpose
order by Delinquency_2years desc;

select * from KPI_10;

-- Loan Status of Fully Paid Vs Charged Off

CREATE VIEW KPI_11 AS
select loan_status, concat(round((count(id) / sum(count(id)) over ()) * 100, 2), ' %') as Percentage, count(id) as Application_Count,
concat(round(sum(funded_amnt) / 1000000.00, 2), ' M') as Total_Funded_Amount,
concat(round(sum(total_pymnt) / 1000000.00, 2), ' M') as Total_Payment from finance_data
where loan_status <> 'Current'
group by loan_status
order by Total_Payment desc;

select * from KPI_11;

