SELECT *
FROM VideoGames

-- Changing few names from Pokémon To Pokaemon

SELECT Name
FROM VideoGames
WHERE Name LIKE 'Pok%'

SELECT Name, REPLACE(Name, 'é','e')
FROM VideoGames

UPDATE VideoGames
SET Name = 
REPLACE(Name, 'é','e')
FROM VideoGames

-- Total sales by Publisher

SELECT Publisher, MAX(NA_Sales) 
OVER (PARTITION BY Publisher)
FROM VideoGames

SELECT Publisher, SUM(NA_Sales) 
OVER (PARTITION BY Publisher ORDER BY Publisher,NA_Sales)
FROM VideoGames
WHERE Publisher IS NOT NULL

-- NA Sales
SELECT Publisher, SUM(NA_Sales) AS Total_Sales_NA
FROM VideoGames
WHERE Publisher IS NOT NULL
GROUP BY Publisher
ORDER BY Total_Sales_NA DESC

-- EU Sales
SELECT Publisher, SUM(EU_Sales) AS Total_Sales_EU
FROM VideoGames
WHERE Publisher IS NOT NULL
GROUP BY Publisher
ORDER BY Total_Sales_EU DESC

-- JP Sales
SELECT Publisher, SUM(JP_Sales) AS Total_Sales_JP
FROM VideoGames
WHERE Publisher IS NOT NULL
GROUP BY Publisher
ORDER BY Total_Sales_JP DESC

-- NA,JP,EU Total Sales
SELECT Publisher, SUM(NA_Sales) AS Total_Sales_NA,SUM(JP_Sales) AS Total_Sales_JP,SUM(EU_Sales) AS Total_Sales_EU
FROM VideoGames
WHERE Publisher IS NOT NULL
GROUP BY Publisher

-- Best Pokemon games version of all time
SELECT Name,Year_of_Release, User_Score
FROM VideoGames
WHERE Name LIKE 'Pokemon%' AND User_Score IS NOT NULL
ORDER BY User_Score DESC

-- Highest Global Sales games
SELECT Name,Platform,Year_of_Release,Developer, Global_Sales,SUM(Global_Sales) OVER (PARTITION BY Developer ORDER BY Publisher,Global_Sales) AS Total_GlobalSales_Developer
FROM VideoGames
WHERE Developer IS NOT NULL
ORDER BY Platform

-- Same Publisher and Developer Sales
SELECT Publisher,SUM(Global_Sales)AS Total_Sales_DeveloperNPublisher
FROM VideoGames
	WHERE Publisher = Developer
	AND Developer IS NOT NULL
GROUP BY Publisher
ORDER BY Total_Sales_DeveloperNPublisher DESC

-- Number of Games Developed
SELECT Publisher,Count(Name) AS Total_Games_Sold
FROM VideoGames
GROUP BY Publisher
ORDER BY Total_Games_Sold DESC

