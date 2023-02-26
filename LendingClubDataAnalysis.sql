-- Exploring loans table
SELECT *
FROM dbo.loans;

-- Exploring Performance table
SELECT *
FROM dbo.perf;

--Exploring Transcations table
SELECT TOP  100 *
FROM dbo.trans;

SELECT COUNT(*)
FROM dbo.trans;


--Joining Loans and performance table on CustomerID 
SELECT lo.CustomerID, lo.loan_amnt, lo.funded_amnt, lo.term, pe.BadLoan
FROM dbo.loans lo
JOIN dbo.perf pe
    ON lo.CustomerID = pe.CustomerID
WHERE pe.BadLoan = 'Yes'
ORDER BY lo.loan_amnt DESC;

--Counting how many unqiue bad performer loans there are 
SELECT DISTINCT COUNT(lo.CustomerID)
FROM dbo.loans lo
JOIN dbo.perf pe
    ON lo.CustomerID = pe.CustomerID
WHERE pe.BadLoan = 'Yes';
-- 1168 Customers with Bad Loans

--Exploring number of Unique Loans
SELECT DISTINCT COUNT(CustomerID)
FROM dbo.loans;
-- 10,000 Unique Loans


--Finding the Most Common Purpose of Loans
SELECT Purpose, COUNT(purpose) AS Number
FROM dbo.loans
GROUP BY purpose
ORDER BY Number DESC;
-- Top 3 Uses - Debt Conslidation, Credit Card, Other

-- Finding average debt consolidation loan size
SELECT AVG(loan_amnt) AS AVG_Loan_Amount
FROM dbo.loans
WHERE purpose = 'debt_consolidation';
-- $12683

--Finding Average Credit Card Loan Size
SELECT AVG(loan_amnt) AS AVG_Loan_Amount
FROM dbo.loans
WHERE purpose = 'credit_card';
-- $11380

--Finding Average Other Loan Size
SELECT AVG(loan_amnt) AS AVG_Loan_Amount
FROM dbo.loans
WHERE purpose = 'Other';
-- $7830

--Finding the Loan Terms
SELECT term, COUNT(term)
FROM dbo.loans
GROUP BY term;
-- 36 Months and 60 Months Only

-- Finding Most Common States
SELECT addr_state, COUNT(addr_state) AS COUNT
FROM dbo.loans
GROUP BY addr_state
ORDER BY COUNT DESC;
-- California, New York and Florida have the largest loan origniations

-- Finding the states with the highest number of bad loans
SELECT lo.addr_state, COUNT(lo.addr_state) AS COUNT
FROM dbo.loans lo
JOIN dbo.perf pe
    ON lo.CustomerID = pe.CustomerID
WHERE pe.BadLoan = 'Yes'
GROUP BY lo.addr_state
ORDER BY COUNT DESC;
-- California, New York and Florida also possess the highest bad loans

--Finding Average Income for Ownership status
SELECT home_ownership, AVG(annual_inc) AS Avg_Income
FROM dbo.loans
GROUP BY home_ownership
ORDER BY Avg_Income DESC;

--Average Installemnt
SELECT AVG(installment)
FROM dbo.loans;

--Average Installment By State
SELECT addr_state, AVG(installment) AS AVG
FROM dbo.loans
GROUP BY addr_state
ORDER BY [AVG] DESC;
-- DC, NE and WY have the highest installments 

-- Average Loan Amount for the Top 3 Highest Instalment States
SELECT addr_state, AVG(loan_amnt) AS AVG_Loan, AVG(installment) AS AVG_Instal
FROM dbo.loans
WHERE addr_state = 'DC' OR addr_state = 'NE' OR addr_state = 'WY'
GROUP BY addr_state;

--Frequency of different Grades of Loans
SELECT grade, COUNT(grade) AS COUNT
FROM dbo.loans
GROUP BY grade
ORDER BY COUNT DESC;
--Most loans are A,B,C with B being the most common

--Average loan amount size by purpose
SELECT purpose, AVG(loan_amnt) AS AVG_Loan_Size
FROM dbo.loans
GROUP BY purpose
ORDER BY AVG_Loan_Size DESC;
--Small Businesses have the largest average loan Size

--Creating a Joined table for use in Tableau Visualisation
SELECT lo.loan_amnt, lo.term, lo.term, lo.installment, lo.grade, lo.home_ownership, lo.purpose, lo.addr_state, pe.BadLoan
FROM dbo.loans lo
JOIN dbo.perf pe
    ON lo.CustomerID = pe.CustomerID;
