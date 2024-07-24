USE project_fda;

###TASK-1 (Identifying Approval Trends)
#Question-1 (Determine the number of drugs approved each year and provide insights into the yearly trends)
SELECT COUNT(actiontype) AS "Total No of Drugs Approved", YEAR((actiondate)) AS "Approval year" 
FROM regactiondate WHERE actiontype = "AP" 
GROUP BY (YEAR((actiondate))) ORDER BY YEAR(actiondate) ASC;

#Question-2 (Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively)
#Years with highest approvals-
SELECT COUNT(actiontype) AS "Total No of Drugs Approved",
YEAR(actiondate) AS "Approval year" 
FROM regactiondate WHERE actiontype = "AP" 
GROUP BY (YEAR((actiondate))) ORDER BY (COUNT(actiontype)) DESC LIMIT 3;

#Years with lowest approvals-
SELECT COUNT(actiontype) AS "Total No of Drugs Approved", 
YEAR((actiondate)) AS "Approval year" 
FROM regactiondate WHERE actiontype = "AP" 
GROUP BY (YEAR((actiondate))) ORDER BY (COUNT(actiontype)) ASC LIMIT 4;

#Question-3 (Explore approval trends over the years based on sponsors)
SELECT COUNT(r.actiontype) AS "Total No of Drugs Approved", 
COUNT(a.sponsorapplicant) AS "Drugs with total no of sponsorers",
YEAR ((r.actiondate)) AS "Approval year", r.actiontype AS "Drug Approval"
FROM regactiondate as r INNER JOIN application AS a ON r.applno = a.applno WHERE r.actiontype = "AP" 
GROUP BY (YEAR(r.actiondate)) ORDER BY (YEAR(r.actiondate)) DESC;

#Question-4 (Rank sponsors based on the total number of approvals they received each year between 1939 and 1960)
SELECT (a.sponsorapplicant) AS "Name of Sponsorer", 
COUNT(YEAR(r.actiondate)) AS "Total Approvals"
FROM regactiondate as r INNER JOIN application AS a ON r.applno = a.applno
WHERE ((r.actiontype = "AP") AND (YEAR(r.actiondate) BETWEEN 1939 AND 1960))
GROUP BY (a.sponsorapplicant) ORDER BY (COUNT(YEAR(r.actiondate))) DESC;

###TASK-2 (Segmentation Analysis Based on Drug MarketingStatus)
#Question-1 (Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns)

#Group products based on MarketingStatus
SELECT productmktstatus AS "Product Market Status" , 
COUNT(productmktstatus) AS "Products to be Marketed Under Different Categories"
FROM product GROUP BY productmktstatus;

#Provide meaningful insights into the segmentation patterns.
SELECT productmktstatus, productno FROM product;
SELECT appltype, actiontype FROM application;

#Question-2 Calculate the total number of applications for each MarketingStatus year-wise after the year 2010.
SELECT COUNT(p.applno) AS "Total No of Application", p.productmktstatus AS "Marketing Status of the Product", 
YEAR(r.actiondate) AS "Year"
FROM product AS p INNER JOIN application AS a INNER JOIN regactiondate AS r 
ON p.applno = a.applno AND a.applno = r.applno
WHERE (YEAR(r.actiondate)>2010)
GROUP BY p.productmktstatus,YEAR(r.actiondate) ORDER BY (YEAR(r.actiondate)) ASC;

#Question-3 Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.
SELECT DISTINCT (YEAR(r.actiondate)) AS "YEAR", COUNT(p.applno) AS "Total_No_of_Applications", 
DENSE_RANK() OVER (ORDER BY COUNT(p.applno) DESC) AS "Rank_Order"
FROM product AS p INNER JOIN application AS a INNER JOIN regactiondate AS r 
ON a.applno = p.applno AND a.applno = r.applno
WHERE p.productmktstatus = 
(SELECT productmktstatus FROM product GROUP BY productmktstatus ORDER BY COUNT(applno) DESC LIMIT 1)
GROUP BY YEAR(r.actiondate);

### TASK-3 (Analyzing Products)
#Question-1 Categorize Products by dosage form and analyze their distribution.
SELECT dosage, form, COUNT(ProductNo) AS "Product_Count"
FROM product
GROUP BY dosage, form
ORDER BY "Product_Count" DESC;

#Question-2 Calculate the total number of approvals for each dosage form and identify the most successful forms.
SELECT p.dosage, p.form, COUNT(p.applno) AS "Total_No_of_Drugs_With_Approval"
FROM application as a inner join product as p ON a.applno=p.applno
WHERE actiontype = "AP"
GROUP BY p.dosage, P.form
ORDER BY COUNT(p.applno) DESC;

#Question-3 Investigate yearly trends related to successful forms
SELECT p.productno, p.form, YEAR (r.actiondate) as "Approval_Year",COUNT(r.applno) AS "Total_Approval_No"
FROM regactiondate AS r INNER JOIN product AS pn ON r.applno = p.applno
GROUP BY p.form, p.productno, YEAR(r.actiondate)
ORDER BY "Total_Approval_No" DESC;

###TASK-4 Exploring Therapeutic Classes and Approval Trends
#Question-1 Analyze drug approvals based on therapeutic evaluation code (TE_Code)
SELECT COUNT(a.ApplNo) AS "Drug_Approvals", p.tecode 
FROM application AS a INNER JOIN product AS p ON a.ApplNo = p.ApplNo 
WHERE ActionType = "AP"
GROUP BY p.tecode ORDER BY "Drug_Approvals" DESC;

#Question-2 Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.
SELECT p.tecode, YEAR (r.actiondate) AS "Year", COUNT(a.applno) as "Total_approvals_Received"
FROM application AS a INNER JOIN regactiondate AS r INNER JOIN product AS p ON a.applno = r.applno AND p.applno = a.applno
WHERE a.actiontype = "AP"
GROUP BY p.tecode, YEAR(r.actiondate)
ORDER BY "Total_approvals_Received" DESC;













