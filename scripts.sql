1. 
    a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
SELECT npi, SUM(total_claim_count)
FROM prescription
GROUP BY npi 
ORDER BY SUM(total_claim_count) DESC
LIMIT 1;

-1881634483/99707
  
   
    b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

SELECT pr.nppes_provider_first_name, pr.nppes_provider_last_org_name, pr.specialty_description, COUNT(pn.total_claim_count)
FROM prescriber AS pr
LEFT JOIN prescription AS pn
ON pr.npi = pn.npi
GROUP BY pr.nppes_provider_first_name, pr.nppes_provider_last_org_name, pr.specialty_description
ORDER BY COUNT(pn.total_claim_count) DESC
LIMIT 1;

-John Williams, Internal Medicine, 528

2. 
    a. Which specialty had the most total number of claims (totaled over all drugs)?
	
SELECT pr.specialty_description, COUNT(pn.total_claim_count)
FROM prescriber AS pr
LEFT JOIN prescription AS pn
ON pr.npi = pn.npi
GROUP BY pr.specialty_description
ORDER BY COUNT(pn.total_claim_count) DESC;

-Nurse Practitioner, 5991

    b. Which specialty had the most total number of claims for opioids?
	
SELECT pr.specialty_description, d.opioid_drug_flag, COUNT(pn.total_claim_count)
FROM prescriber AS pr
LEFT JOIN prescription AS pn
ON pr.npi = pn.npi
LEFT JOIN drug AS d
ON pn.drug_name = d.drug_name
WHERE d.opioid_drug_flag = 'Y'
GROUP BY pr.specialty_description, d.opioid_drug_flag 
ORDER BY COUNT(pn.total_claim_count) DESC
LIMIT 1;

-Nurse Practitioner, 9551

    c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

    d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

3. 
    a. Which drug (generic_name) had the highest total drug cost?
	
	SELECT d.generic_name, COUNT(pn.total_drug_cost)
	FROM drug AS d
	LEFT JOIN prescription AS pn
	ON d.drug_name = pn.drug_name
	GROUP BY d.generic_name
	ORDER BY COUNT(pn.total_drug_cost) DESC
	LIMIT 1;
	
	-HYDROCODONE/ACETAMINOPHEN, 9618

    b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**

SELECT (d.generic_name), ROUND((pn.total_drug_cost/pn.total_day_supply), 2) AS cost_per_day  
FROM drug AS d
LEFT JOIN prescription AS pn
ON pn.drug_name = d.drug_name
WHERE pn.total_drug_cost IS NOT NULL
ORDER BY cost_per_day DESC
LIMIT 1;
	
	-IMMUN GLOB, $7,141.11
	 
	

4. 
    a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

SELECT drug_name,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
ELSE 'neither'
END AS drug_type
FROM drug;


    b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.


SELECT d.drug_name, pn.total_drug_cost AS money,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
ELSE 'neither'
END AS drug_type
FROM drug AS d
LEFT JOIN prescription AS pn
ON d.drug_name = pn.drug_name






5. 
    a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

SELECT COUNT(cbsaname)
FROM cbsa
WHERE cbsaname  LIKE '%TN%'

-56

    b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

    c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

6. 
    a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

    b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

    c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

    a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Managment') in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

    b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
    
    c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.
