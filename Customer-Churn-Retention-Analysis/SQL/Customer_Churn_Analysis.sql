-- =====================================================
-- CUSTOMER CHURN & RETENTION ANALYSIS
-- SQL Analysis
-- =====================================================

use customerchurnandretention;

-- =====================================================
-- 1. BASIC CUSTOMER ANALYSIS
-- GOAL: UNDERSTANDING THE OVERALL CUSTOMER BASE
-- =====================================================

-- Q1. What is the total number of customers?--
    
	SELECT COUNT(customerID) AS total_customer FROM customer_account;
      
-- Q2. How many customers are active vs churned?--

	SELECT  Churn, COUNT(DISTINCT customerID) AS customer_count FROM customer_churn GROUP BY Churn;
     
-- Q3. What is the overall churn rate?--
    
	select count(case when churn = 'yes' Then 1 End)*100/ count(*) As Chrun_rate from customer_churn
    
-- Q4. What is the overall retention rate?--

      SELECT COUNT(CASE WHEN Churn = 'No' THEN 1 END) * 100.0 / COUNT(*) AS retention_rate from customer_churn;
      
-- Q5. What is the average customer tenure?--

      Select avg(tenure) as Average_Tenure from dim_customer;
      
-- Q6. What is the average monthly charges per customer?--
 
       Select avg(MonthlyCharges) as Average_Monthly_Charge from customer_account;
       
-- Q7. What is the total revenue generated?--
  
	 Select sum(totalcharges) as Total_Revenue from customer_account;
     
-- Q8. What is the minimum and maximum customer tenure?--
  
	select min(tenure) as minimum_customertenure, max(tenure) as maximum_customertenure from dim_customer;
    
-- Q9. How many customers belong to each customer segment?

     select count(distinct customerId), customervalue AS customer_count 
          from customer_account group by customervalue order by customer_count desc;
          
-- Q10. How many customers are in each contract type?--

     select count(distinct customerID), contract As Contract_type from customer_account group by contract;
     
     
-- =====================================================
-- 2. CHURN ANALYSIS
-- GOAL: UNDERSTAND WHO IS LEAVING AND HOW MUCH CHURN EXISTS.
-- =====================================================
     
-- Q11. What is the total number of churned customers?--
      
	select count(distinct customerid) as Churned_customer from customer_churn where churn = 'yes';
       
-- Q12. What is the churn rate by gender?--

	select gender,count(case when churn = 'yes' then 1 end)*100/ count(*)  as churn_rate_byGender 
       from customer_churn c JOIN dim_customer d on c.customerID = d.customerID group by d.gender order by churn_rate_bygender desc;

    ----- (Insight: Female customers have the higher churn rate at 26.92%, compared with 26.16% for Male customers.)
       
-- Q13. What is the churn rate by customer value/segment?--
       
	select customervalue, count(case when churn = 'yes' then 1 end)*100 / count(*) As Churn_Rate
	 from customer_churn c JOIN customer_account ca on  c.customerID = ca.customerID group by customervalue order by churn_rate desc;

   ----- ( INSIGHT :Low-value customers are the most likely to churn, with a churn rate of 39.51%, while high-value customers
		-- have the lowest churn rate at 16.51%. This suggests that low-value customers require greater retention attention.)--
 
-- Q14. What is the churn rate by contract type?--

	select contract, count(case when churn = 'yes' then 1 end)*100/ count(*) as churn_rate_bycontract 
	 from customer_churn c Join customer_account ca ON c.customerID = ca.customerID group by contract order by churn_rate_bycontract  desc;
     
    -- (Insight: Month-to-month contract customers have the higher churn rate at 42.71%, 
    -- compared with 11.28% for One year and 2.85% for Two year contracts.)--
 
-- Q15. What is the churn rate by payment method?--

	select paymentmethod, count(case when churn = 'yes' then 1 end)*100/ count(*) as churn_rateby_paymentmethod
	 from customer_churn c Join customer_account ca ON c.customerID = ca.customerID group by paymentmethod order by churn_rateby_paymentmethod desc;

	-- (Insight: Customers paying via Electronic check have the highest churn rate at 45.29%, compared to Mailed check (19.20%),
      --  Bank transfer (automatic) (16.73%),  and Credit card (automatic) (15.25%)).
      
-- Q16. What is the churn rate by internet servuice?--

	select internetservice, count(case when churn = 'yes' then 1 end)*100/ count(*) as churn_rateby_internetservice
	 from customer_churn c Join dim_services d ON c.customerID = d.customerID group by internetservice order by churn_rateby_internetservice desc;
     
      -- (Insight:  Fiber optic customers have the highest churn rate at 41.89%,
      -- compared with 18.96% for DSL and 7.41% for customers with No internet service.)

-- Q17. What is the churn rate by tenure group?--
     
     select tenuregroup, count(case when churn = 'yes' then 1 end)*100/ count(*) as churn_rateby_tenuregroup
	 from customer_churn c Join dim_customer d ON c.customerID = d.customerID group by tenuregroup order by churn_rateby_tenuregroup desc;
     
     -- (Insight: 0-6 Months customers have the highest churn rate at 52.94%,
       -- compared with 35.89% for 7-12 Months, 28.71% for 13-24 Months, 
         -- 20.39% for 25-48 Months, and 9.51% for 49+ Months.)
     
-- Q18. Which customer segment/value has the highest churn rate?--

      select customervalue, count(case when churn = 'yes' then 1 end)*100 / count(*) As Churn_Rate
	     from customer_churn c JOIN customer_account ca on  c.customerID = ca.customerID group by customervalue order by churn_rate desc limit 1;

-- Q19. Which contract type has the highest churn rate?--
  
   select contract, count(case when churn = 'yes' then 1 end)*100/ count(*) as churn_rate_bycontract 
	 from customer_churn c Join customer_account ca ON c.customerID = ca.customerID group by contract order by churn_rate_bycontract desc limit 1;

-- Q20. Which payment method has the highest churn rate?--
    
	select paymentmethod, count(case when churn = 'yes' then 1 end)*100/ count(*) as churn_rateby_paymentmethod
	 from customer_churn c Join customer_account ca ON c.customerID = ca.customerID group by paymentmethod order by churn_rateby_paymentmethod desc limit 1;


-- =====================================================
-- 3. RETENTION ANALYSIS
-- GOAL: UNDERSTAND WHY CUSTOMER STAY 
-- =====================================================

-- Q21. What is the overall retention rate?--

   select count(case when customerstatus = 'Retained' then 1 end)*100/ count(*) as Retention_rate from customer_churn;
   
-- Q22. What is the retention rate by customer value?--

   select customervalue,count(case when customerstatus = 'Retained' then 1 end)*100/ count(*) as retention_rateby_customervalue
      from customer_churn c Join customer_account ca on c.customerID= ca.customerID group by customervalue order by retention_rateby_customervalue desc;
 
 -- (Insight:  High Value customers have the higher retention rate at 83.49%,
--         compared with 76.28% for Medium Value and 60.49% for Low Value.)

--  Q23. What is the retention rate by contract type?--
 
    select contract,count(case when customerstatus = 'Retained' then 1 end)*100/ count(*) as retention_rateby_contract
	from customer_churn c Join customer_account ca on c.customerID= ca.customerID group by contract order by retention_rateby_contract desc;
    
-- (Insight:  Two year contract customers have the highest retention rate at 97.15%,
--      compared with 88.72% for One year and 57.29% for Month-to-month contracts.)

-- Q24. What is the retention rate by payment method?--

    select paymentmethod,count(case when customerstatus = 'Retained' then 1 end)*100/ count(*) as retention_rateby_paymentmethod
	from customer_churn c Join customer_account ca on c.customerID= ca.customerID group by paymentmethod order by retention_rateby_paymentmethod desc;
    
-- Insight:  Credit card (automatic) customers have the highest retention rate at 84.75%,  compared with 83.27% for Bank transfer (automatic), 
--           80.80% for Mailed check, and 54.71% for Electronic check.)

-- Q25. What is the retention rate by Internetservice type?--
   
    SELECT InternetService, COUNT(CASE WHEN Churn = 'No' THEN 1 END) * 100.0/ COUNT(*) AS retention_rate
       FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID GROUP BY InternetService ORDER BY retention_rate DESC;

  -- (Insight: Customers without internet service have the highest retention rate, while fiber-optic customers have the lowest.)

-- Q26. What is the average tenure of retained vs churned customers?

	select customerstatus, avg(tenure) as average_tenure from dim_customer d JOIN customer_churn c ON d.CustomerID= c.CustomerID group by customerstatus; 
    
     -- ( Insight:Retained customers have a higher average tenure at 37.57 months,
        -- compared with 17.98 months for Churned customers.)
        
-- Q27. What is the average revenue of retained vs churned customers?

     select customerstatus, avg(totalcharges) as average_revenue from customer_account ca JOIN customer_churn cc ON ca.customerID = cc.customerID group by customerstatus;
      
  -- (Insight: Retained customers generate higher average total charges than churned customers.)    

-- Q28. Which customer Value has the highest retention rate?

    select customervalue, count(case when churn = 'no' then 1 end)*100 / count(*) as highest_retentionrate from 
     customer_churn c JOIN customer_account a ON c.customerID = a.customerID group by customervalue order by highest_retentionrate desc limit 1;
   
-- Q29. Which contract type has the highest retention rate?--

    select contract, count(case when churn = 'no' then 1 end)*100 / count(*) as highest_retentionrate from 
     customer_churn c JOIN customer_account a ON c.customerID = a.customerID group by contract order by highest_retentionrate desc limit 1;

-- Q30. Do long-tenure customers have better retention?--
    
      select tenuregroup, count(case when churn = 'no' then 1 end)*100 / count(*) as retention_rate from 
     customer_churn c Join dim_customer d On c.customerID = d.customerID group by tenuregroup order by retention_rate desc;
     
  -- (Insight: Retention clearly improves as tenure increases. Customers with 49+ months have the highest retention rate at 90.49%,
   --           while customers with 0–6 months have the lowest at 47.06%.)
   
 -- Q31. Which services are most commonly used by retained customers?--
    
	SELECT 'PhoneService' AS service,
       COUNT(*) AS retained_customers
        FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID WHERE c.Churn = 'No' AND s.PhoneService = 'Yes'
       UNION ALL
	SELECT 'OnlineSecurity', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
        WHERE c.Churn = 'No' AND s.OnlineSecurity = 'Yes'
       UNION ALL
    SELECT 'OnlineBackup', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
      WHERE c.Churn = 'No' AND s.OnlineBackup = 'Yes'
        UNION ALL
    SELECT 'DeviceProtection', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
      WHERE c.Churn = 'No' AND s.DeviceProtection = 'Yes'
      UNION ALL
     SELECT 'TechSupport', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
       WHERE c.Churn = 'No' AND s.TechSupport = 'Yes'
      UNION ALL
     SELECT 'StreamingTV', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
      WHERE c.Churn = 'No' AND s.StreamingTV = 'Yes'
     UNION ALL
     SELECT 'StreamingMovies', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
      WHERE c.Churn = 'No' AND s.StreamingMovies = 'Yes' 
      ORDER BY retained_customers DESC;

-- Q32. Which services are most commonly used by churned customers?--

      SELECT 'PhoneService' AS service, COUNT(*) AS churned_customers FROM customer_churn c JOIN dim_services s
      ON c.customerID = s.customerID WHERE c.Churn = 'Yes' AND s.PhoneService = 'Yes'
     UNION ALL
      SELECT 'OnlineSecurity', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
      WHERE c.Churn = 'Yes' AND s.OnlineSecurity = 'Yes'
     UNION ALL
    SELECT 'OnlineBackup', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
     WHERE c.Churn = 'Yes' AND s.OnlineBackup = 'Yes'
     UNION ALL
	SELECT 'DeviceProtection', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
    WHERE c.Churn = 'Yes' AND s.DeviceProtection = 'Yes'
     UNION ALL
    SELECT 'TechSupport', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
     WHERE c.Churn = 'Yes' AND s.TechSupport = 'Yes'
    UNION ALL
    SELECT 'StreamingTV', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
     WHERE c.Churn = 'Yes' AND s.StreamingTV = 'Yes'
    UNION ALL
    SELECT 'StreamingMovies', COUNT(*) FROM customer_churn c JOIN dim_services s ON c.customerID = s.customerID
      WHERE c.Churn = 'Yes' AND s.StreamingMovies = 'Yes'
       ORDER BY churned_customers DESC; 
       
       
-- =====================================================
-- 4. REVENUE & CHURN IMPACT
-- GOAL: UNDERSTAND WHY CUSTOMER STAY 
-- =====================================================
	
-- Q33. What is the total revenue generated by active customers?--
  
       select sum(totalcharges) as totalrevenue_by_activecustomers from customer_account c JOIN customer_churn cc 
         ON c.customerID= cc.customerID where churn = 'NO';
         
-- Q34. What is the total revenue associated with churned customers?--

       select sum(totalcharges) as totalrevenueassociated_bychurned from customer_account c JOIN customer_churn cc 
         ON c.customerID= cc.customerID where churn = 'YES';
         
-- Q35. What percentage of total revenue comes from churned customers?--

	 select sum(case when churn = 'yes' then totalcharges else 0  end)*100 / count(totalcharges) as churned_revenue_percentage 
      from customer_churn c JOIN customer_account ca ON c.customerid= ca.customerID;
      
-- Q36. Which customer segment generates the highest revenue?--

	select customervalue ,sum(totalcharges) as highest_revenue from customer_account group by customervalue order by highest_revenue desc;

-- Q37. Which customer segment generates the most revenue from churned customers?--

    select customervalue ,sum(totalcharges) as revenue_churnedcustomer from customer_account c JOIN customer_churn cc ON c.customerID = cc.customerID 
       where churn= 'YES' group by customervalue order by revenue_churnedcustomer desc ;
   
     -- (Insight: The High Value customer segment generates the highest revenuefrom churned customers)
     
-- Q38. Which contract type contributes the most revenue from churned customers?--

       select contract ,sum(totalcharges) as revenue_churnedcustomer from customer_account c JOIN customer_churn cc ON c.customerID = cc.customerID 
       where churn= 'YES' group by contract order by revenue_churnedcustomer desc ;
   
-- (Insight:  Month-to-month contracts contribute the highest revenue from  churned customers at 1,927,182.25, significantly higher than
--            one-year and two-year contracts.)

-- Q39. Which payment method is associated with the highest churn-related revenue?--

        select paymentmethod ,sum(totalcharges) as revenue_churned from customer_account c JOIN customer_churn cc ON c.customerID = cc.customerID 
       where churn= 'YES' group by paymentmethod order by revenue_churned desc ; 
       
-- (Insight: Electronic check customers account for the highest churn-related  revenue at 1,567,576.40, making this payment method the largest
--           contributor to revenue associated with churn.)

-- Q40. Which high-revenue customers have churned?--

     SELECT  c.customerID, TotalCharges, MonthlyCharges, Contract, PaymentMethod FROM customer_account c JOIN customer_churn cc
    ON c.customerID = cc.customerID WHERE Churn = 'Yes' AND CustomerValue = 'High Value' ORDER BY TotalCharges DESC LIMIT 10;
    
-- (Insight: The highest-revenue churned High Value customer has total charges  of 8,684.80. The top 10 high-revenue churned customers all have
--           total charges above 7,600, indicating a significant retention opportunity among valuable customers.)


-- =====================================================
-- 5. Customer Risk & Retention Priority 
-- GOAL: 
-- =====================================================

-- Q41. Which customers have revenue above the overall average?

	select customerID, totalcharges from customer_account where totalcharges > (select avg(totalcharges) from customer_account) order by totalcharges desc;

-- Q42. Which customers have below-average tenure?

	 select customerid, tenure from dim_customer where tenure < (select avg(tenure) from customer_account) order by tenure desc;

-- Q43. Which customers have high revenue and have already churned?

	select c.customerid, totalcharges, monthlycharges, contract, paymentmethod from customer_account c JOIN customer_churn cc
       ON c.customerID = cc.customerID where customervalue ='high value'AND churn ='yes' order by totalcharges desc;
       
-- Q44. Which customers have high revenue and characteristics associated with high churn?

	 SELECT a.customerID, a.TotalCharges, a.MonthlyCharges, a.Contract, a.PaymentMethod, s.InternetService, d.tenure,
       (CASE WHEN a.Contract = 'Month-to-month' THEN 1 ELSE 0 END +
        CASE WHEN a.PaymentMethod = 'Electronic check' THEN 1 ELSE 0 END +
        CASE WHEN s.InternetService = 'Fiber optic' THEN 1 ELSE 0 END +
        CASE WHEN d.tenure <= 12 THEN 1 ELSE 0 END
       ) AS RiskScore
      FROM customer_account a JOIN customer_churn c ON a.customerID = c.customerID
       JOIN dim_customer d  ON a.customerID = d.customerID
        JOIN Dim_Services s ON a.customerID = s.customerID
       WHERE a.TotalCharges > ( SELECT AVG(TotalCharges) FROM customer_account)
       AND
       (CASE WHEN a.Contract = 'Month-to-month' THEN 1 ELSE 0 END +
        CASE WHEN a.PaymentMethod = 'Electronic check' THEN 1 ELSE 0 END +
        CASE WHEN s.InternetService = 'Fiber optic' THEN 1 ELSE 0 END +
        CASE WHEN d.tenure <= 12 THEN 1 ELSE 0 END
        ) >= 2 ORDER BY a.TotalCharges DESC;
       
  -- Q45. Which customers have short tenure and high monthly charges?'
  
          SELECT a.customerID, d.tenure, a.MonthlyCharges, a.TotalCharges, a.Contract FROM customer_account a JOIN dim_customer d 
           ON a.customerID = d.customerID WHERE d.tenure <= 12
          AND a.MonthlyCharges >(
        SELECT AVG(MonthlyCharges)
        FROM customer_account)
         ORDER BY a.MonthlyCharges DESC;

-- (Insight: Customers with short tenure and high monthly charges represent an important early-stage retention-risk group.)

  -- Q46. Which customer segments have both high churn and high revenue?

       WITH segment_analysis AS
       ( SELECT a.CustomerValue, COUNT(*) AS total_customers,
        COUNT( CASE WHEN c.Churn = 'Yes' THEN 1 END ) AS churned_customers, SUM(a.TotalCharges) AS total_revenue
        FROM customer_account a JOIN customer_churn c ON a.customerID = c.customerID
       GROUP BY a.CustomerValue)
       SELECT CustomerValue, total_customers, churned_customers, total_revenue,
       ROUND( churned_customers * 100.0 / total_customers, 2 ) AS churn_rate
        FROM segment_analysis ORDER BY total_revenue DESC;
        
  -- Q47. Which customers should be given HIGH RETENTION PRIORITY? 
     
         SELECT a.customerID, a.TotalCharges, a.MonthlyCharges, a.CustomerValue, c.Churn, a.Contract, a.PaymentMethod, s.InternetService,
	   CASE WHEN a.CustomerValue = 'High Value'
		AND(c.Churn = 'Yes'
		    OR a.Contract = 'Month-to-month'
		    OR a.PaymentMethod = 'Electronic check'
			OR s.InternetService = 'Fiber optic')
        THEN 'High Priority'
       WHEN a.CustomerValue = 'High Value'
		OR c.Churn = 'Yes'
        THEN 'Medium Priority'
         ELSE 'Low Priority'
         END AS Retention_Priority
        FROM customer_account a JOIN customer_churn c ON a.customerID = c.customerID
        JOIN Dim_Services s ON a.customerID = s.customerID;
        
 -- Q48. What percentage of revenue is at risk?

      SELECT ROUND( SUM( CASE WHEN c.Churn = 'Yes' THEN a.TotalCharges ELSE 0 END) * 100.0 / SUM(a.TotalCharges),2) AS Revenue_At_Risk_Pct
       FROM customer_account a JOIN customer_churn c ON a.customerID = c.customerID;

  -- Q49. Who are the top 10 highest-value customers at risk?
     
        WITH highpriority AS ( SELECT a.customerID, a.TotalCharges,a.MonthlyCharges, a.CustomerValue, c.Churn, a.Contract,a.PaymentMethod, s.InternetService
        FROM customer_account a JOIN customer_churn c ON a.customerID = c.customerID
         JOIN Dim_Services s ON a.customerID = s.customerID
          WHERE a.CustomerValue = 'High Value' 
          AND( c.Churn = 'Yes'
			  OR a.Contract = 'Month-to-month'
			  OR a.PaymentMethod = 'Electronic check'
			  OR s.InternetService = 'Fiber optic'))
       SELECT * FROM highpriority ORDER BY TotalCharges DESC LIMIT 10;
       
-- Q50. Rank customers based on revenue--
   
      SELECT customerID, TotalCharges, RANK() OVER ( ORDER BY TotalCharges DESC) AS Revenue_Rank FROM customer_account;

 -- Q51. Top 3 customers by revenue in each segment--
      
      WITH ranked_customers AS (
        SELECT customerID, CustomerValue, TotalCharges,
        ROW_NUMBER() OVER
        (PARTITION BY CustomerValue
		 ORDER BY TotalCharges DESC ) AS rn FROM customer_account )
       SELECT customerID, CustomerValue, TotalCharges FROM ranked_customers WHERE rn <= 3 ORDER BY CustomerValue, TotalCharges DESC;
   
	-- Q52. Rank customer segments based on churn rate	
          
           WITH segment_churn AS ( SELECT a.CustomerValue, COUNT(CASE WHEN c.Churn = 'Yes' THEN 1 END ) * 100.0 / COUNT(*) AS Churn_Rate
           FROM customer_account a JOIN customer_churn c ON a.customerID = c.customerID GROUP BY a.CustomerValue )
          SELECT CustomerValue, ROUND(Churn_Rate, 2) AS Churn_Rate,
         RANK() OVER ( ORDER BY Churn_Rate DESC ) AS Churn_Rank FROM segment_churn;
-- Q53. Customers whose revenue is above their segment average

       WITH segment_avg AS ( SELECT CustomerValue, AVG(TotalCharges) AS Avg_Segment_Revenue FROM customer_account GROUP BY CustomerValue)
	   SELECT a.customerID, a.CustomerValue, a.TotalCharges, s.Avg_Segment_Revenue FROM customer_account a JOIN segment_avg s ON 
       a.CustomerValue = s.CustomerValue WHERE a.TotalCharges > s.Avg_Segment_Revenue ORDER BY a.TotalCharges DESC;

-- Q54. Highest-revenue customer in each segment--

      WITH ranked_customers AS ( SELECT customerID, CustomerValue, TotalCharges, ROW_NUMBER() OVER ( PARTITION BY CustomerValue
	  ORDER BY TotalCharges DESC) AS rn FROM customer_account)
      SELECT customerID, CustomerValue, TotalCharges FROM ranked_customers WHERE rn = 1; 

-- Q65. Which segments have a churn rate higher than the overall company churn rate?

     WITH segment_churn AS ( SELECT a.CustomerValue, COUNT( CASE WHEN c.Churn = 'Yes' THEN 1 END) * 100.0 / COUNT(*) AS Segment_Churn_Rate
     FROM customer_account a JOIN customer_churn c ON a.customerID = c.customerID
       GROUP BY a.CustomerValue )
      SELECT CustomerValue, ROUND(Segment_Churn_Rate, 2) AS Segment_Churn_Rate FROM segment_churn
      WHERE Segment_Churn_Rate > (
     SELECT COUNT(
                CASE WHEN Churn = 'Yes' THEN 1 END ) * 100.0 / COUNT(*) FROM customer_churn );


-- Final SQL Analysis Summary

-- 1. Customer Churn: The overall churn rate is approximately 26.54%, indicating that more than one-fourth of the customer base has churned.
-- 2.Customer Retention: The overall retention rate is approximately 73.46%, showing that the majority of customers are still retained.
-- 3.Customer Segments: Low Value customers have the highest churn rate (39.51%), while High Value customers have the lowest churn rate (16.51%).
-- 4.Revenue: High Value customers contribute the largest share of customer revenue, making their retention particularly important.
-- 5.Tenure: Customers with shorter tenure tend to show higher churn, indicating that the early customer lifecycle is an important retention period.
-- 6.Contract: Customers on month-to-month contracts show higher churn compared with customers on longer-term contracts.
-- 7.Payment Method: Certain payment methods show noticeably higher churn and therefore represent potential areas for retention improvement.
-- 8.Revenue at Risk:Approximately 17.83% of historical revenue is associated with customers who have churned, highlighting the financial importance of retention.
-- 9.High-Value Churn: High-value customers who have churned represent an important revenue-loss opportunity and should be investigated for targeted retention strategies.
-- 10.Customer Risk: Customers combining high revenue with short tenure or other high-risk characteristics should receive higher retention priority.


-- Conclusion: The SQL analysis shows that customer churn is strongly associated with factors such as shorter tenure, month-to-month contracts,
--             and certain customer segments and payment methods. Low-value customers have the highest churn rate, while high-value customers
--             contribute significantly to revenue and therefore require stronger retention efforts. These findings provide a foundation for
--             further exploratory analysis in Python and the development of an interactive Power BI dashboard.




