
-- Retrieve the List of Tables

SELECT 
    *
FROM 
    sqlite_schema
WHERE 
    type ='table' AND 
    name NOT LIKE 'sqlite_%';