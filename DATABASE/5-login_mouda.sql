-- Check if the login 'mouda' exists and create it if it doesn't
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'mouda')
BEGIN
    CREATE LOGIN mouda WITH PASSWORD = 'P3$$W0rD';
END

-- Check if the user 'mouda' exists in the current database and create it if it doesn't
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'mouda')
BEGIN
    CREATE USER mouda FOR LOGIN mouda;
END

-- Grant privileges to 'mouda' if they don't already have them
IF NOT EXISTS (SELECT * FROM sys.database_role_members WHERE member_principal_id = USER_ID('mouda') AND role_principal_id = USER_ID('db_datareader'))
BEGIN
    ALTER ROLE db_datareader ADD MEMBER mouda; -- Grants read access to all tables
END

IF NOT EXISTS (SELECT * FROM sys.database_role_members WHERE member_principal_id = USER_ID('mouda') AND role_principal_id = USER_ID('db_datawriter'))
BEGIN
    ALTER ROLE db_datawriter ADD MEMBER mouda; -- Grants write access to all tables
END

-- Check if the login 'sayed' exists and create it if it doesn't
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'sayed')
BEGIN
    CREATE LOGIN sayed WITH PASSWORD = 'WhateverSuitsY0u';
END

-- Check if the user 'sayed' exists in the current database and create it if it doesn't
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'sayed')
BEGIN
    CREATE USER sayed FOR LOGIN sayed;
END

-- Grant privileges to 'sayed' if they don't already have them
IF NOT EXISTS (SELECT * FROM sys.database_role_members WHERE member_principal_id = USER_ID('sayed') AND role_principal_id = USER_ID('db_datareader'))
BEGIN
    ALTER ROLE db_datareader ADD MEMBER sayed; -- Grants read access to all tables
END

IF NOT EXISTS (SELECT * FROM sys.database_role_members WHERE member_principal_id = USER_ID('sayed') AND role_principal_id = USER_ID('db_datawriter'))
BEGIN
    ALTER ROLE db_datawriter ADD MEMBER sayed; -- Grants write access to all tables
END

-- Grant execute permissions to 'mouda' if they don't already have them
IF NOT EXISTS (SELECT * FROM sys.database_permissions WHERE grantee_principal_id = USER_ID('mouda') AND permission_name = 'EXECUTE')
BEGIN
    GRANT EXECUTE TO mouda; 
END

-- Grant execute permissions to 'sayed' if they don't already have them
IF NOT EXISTS (SELECT * FROM sys.database_permissions WHERE grantee_principal_id = USER_ID('sayed') AND permission_name = 'EXECUTE')
BEGIN
    GRANT EXECUTE TO sayed; 
END

GO
