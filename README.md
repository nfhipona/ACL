# ACL
Access Control List for NodeJs server.

```sql

-- validating matrix data -- base on the loaded seed
mysql> SELECT BIN_TO_UUID(id,1), code FROM acl_role;
+--------------------------------------+-----------+
| BIN_TO_UUID(id,1)                    | code      |
+--------------------------------------+-----------+
| 1b6236c2-5c7e-11ee-bf62-f66b38d5861d | guest     |
| 1b6234e2-5c7e-11ee-bf62-f66b38d5861d | std_user  |
| 1b623064-5c7e-11ee-bf62-f66b38d5861d | sup_admin |
| 1b6232c6-5c7e-11ee-bf62-f66b38d5861d | sys_admin |
+--------------------------------------+-----------+
4 rows in set (0.01 sec)

-- validating procedure call -- base on the loaded seed
mysql> CALL ACL_VALIDATE('general_resource', '1b6236c2-5c7e-11ee-bf62-f66b38d5861d', 'r', 1);
+----------------+
| @hasPermission |
+----------------+
|              1 |
+----------------+
1 row in set (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

-- validating using long query -- base on the loaded seed
SELECT r.code AS roleCode, r.name AS roleName, s.name AS resourceName, s.code AS resourceCode, a.code AS accessCode, a.description AS accessDesc, s.deleted AS disabledResource, p.is_disabled AS disabledPermission FROM acl_permission p  
INNER JOIN acl_role r ON r.id = p.role_id 
INNER JOIN acl_resource s ON s.id = p.resource_id 
INNER JOIN acl_access_type a ON a.id = p.access_type_id 
WHERE s.deleted <> 1 AND p.is_disabled <> 1 AND s.code = 'general_resource' AND r.id = UUID_TO_BIN('1b6236c2-5c7e-11ee-bf62-f66b38d5861d', 1);

+----------+------------+-------------------+------------------+------------+------------+------------------+--------------------+
| roleCode | roleName   | resourceName      | resourceCode     | accessCode | accessDesc | disabledResource | disabledPermission |
+----------+------------+-------------------+------------------+------------+------------+------------------+--------------------+
| guest    | Guest User | App resource page | general_resource | +r         | Read       |                0 |                  0 |
+----------+------------+-------------------+------------------+------------+------------+------------------+--------------------+
1 row in set (0.00 sec)

```