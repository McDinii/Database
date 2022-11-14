--Task 1--
use Exam;
select * from OFFICES O 
select * from ORDERS O 
select * from SALESREPS S
select REP_OFFICE,AVG(SALES) from ORDERS ORD, SALESREPS S where ORD.REP = S.EMPL_NUM group by REP_OFFICE


-- Task 2

select * from SALESREPS
Select top(2) EMPL_NUM from SALESREPS S join CUSTOMERS on  CUSTOMERS.CREDIT_LIMIT > 30000 group by EMPL_NUM
