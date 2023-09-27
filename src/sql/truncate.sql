--
-- NOTE: Clears off staging data from database
--
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `acl_role`;
TRUNCATE TABLE `acl_resource`;
TRUNCATE TABLE `acl_access_type`;
TRUNCATE TABLE `acl_permission`;

SET FOREIGN_KEY_CHECKS = 1;