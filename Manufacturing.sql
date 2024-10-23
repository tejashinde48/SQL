-- create database manufacturing_project_2;
-- alter table manufacturingdata2 rename column `ï»¿Buyer` to Buyer;

select * from manufacturingdata2;

/* ********************************************************************************************************       
										KPI 1,2,3,4
   ******************************************************************************************************** */

select sum(`Manufactured Qty`) as 'Total Manufactured Qty' from manufacturingdata2;

select sum(`Rejected Qty`) as 'Total Rejected Qty' from manufacturingdata2;

select sum(`Processed Qty`) as 'Total Processed Qty' from manufacturingdata2;

select (sum(`Produced Qty`)-sum(`Manufactured Qty`)) as 'Total Wastage Qty', 
	   ((sum(`Produced Qty`)-sum(`Manufactured Qty`))/sum(`Produced Qty`))*100 as 'Total Wastage in %' 
       from manufacturingdata2;
       
/* ********************************************************************************************************       
                                   KPI 5 Employee wise Rejected Qty 
   ******************************************************************************************************** */

select distinct(`Emp Name`), sum(`Rejected Qty`) as 'Total Rejected Qty'from manufacturingdata2
	   group by `Emp Name` 
       order by sum(`Rejected Qty`) desc;
       
/* ********************************************************************************************************       
                                   KPI 6 Machine wise Rejected Qty 
   ******************************************************************************************************** */

select distinct(`Machine Code`), sum(`Rejected Qty`) as 'Total Rejected Qty'
	   from manufacturingdata2
	   group by `Machine Code` 
       order by sum(`Rejected Qty`) desc;
       
/* ********************************************************************************************************       
                                   KPI 7 Production Comparison Trend
   ******************************************************************************************************** */

select `Fiscal Date`, sum(`Produced Qty`) as 'Total Produced Quantity'
		from manufacturingdata2
        group by `Fiscal Date`
        order by sum(`Produced Qty`) desc;
        
/* ********************************************************************************************************       
                                   KPI 8 Manufactured vs Rejected Quantity
   ******************************************************************************************************** */

select sum(`Manufactured Qty`) as 'Total Manufactured Quantity',
	   sum(`Rejected Qty`) as 'Total Rejected Quantity'
       from manufacturingdata2;
       
/* ********************************************************************************************************       
                                   KPI 9 Department wise Manufactured vs Rejected Quantity
   ******************************************************************************************************** */

select distinct `Department Name`, 
	   sum(`Manufactured Qty`) as 'Total Manufactured Qty', 
       sum(`Rejected Qty`) as 'Total Rejected Qty'
	   from manufacturingdata2
       group by `Department Name`;

