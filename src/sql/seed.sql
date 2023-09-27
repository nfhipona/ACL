--
-- Data for table `role`
--
SET @sup_admin = UUID_TO_BIN(UUID(), 1);
SET @sys_admin = UUID_TO_BIN(UUID(), 1);
SET @std_user = UUID_TO_BIN(UUID(), 1);
SET @guest = UUID_TO_BIN(UUID(), 1);

INSERT INTO `acl_role` (`id`, `code`, `name`) VALUES
(@sup_admin, 'sup_admin', 'Super Admin'),
(@sys_admin, 'sys_admin', 'Admin'),
(@std_user, 'std_user', 'Standard User'),
(@guest, 'guest', 'Guest User');

--
-- Data for table `resource`
--
SET @admin_resource = UUID_TO_BIN(UUID(), 1);
SET @user_management = UUID_TO_BIN(UUID(), 1);
SET @media_resource = UUID_TO_BIN(UUID(), 1);
SET @profile_resource = UUID_TO_BIN(UUID(), 1);
SET @general_resource = UUID_TO_BIN(UUID(), 1);
SET @disabled_resource = UUID_TO_BIN(UUID(), 1);

INSERT INTO `acl_resource` (`id`, `code`, `name`, `description`) VALUES
(@admin_resource, 'adm_resource', 'System resource page', 'Critical app resources'),
(@user_management, 'user_management', 'User administration page', 'User admin resources'),
(@media_resource, 'media_resource', 'Media resource page', 'Media management resources'),
(@profile_resource, 'profile_resource', 'User profile page', 'User management resources'),
(@general_resource, 'general_resource', 'App resource page', 'General app resources'),
(@disabled_resource, 'disabled_resource', 'Disabled resource', 'Disabled resources');

--
-- Data for table `resource`
--
SET @read = UUID_TO_BIN(UUID(), 1);
SET @readwrite = UUID_TO_BIN(UUID(), 1);
SET @fullaccess = UUID_TO_BIN(UUID(), 1);

INSERT INTO `acl_access_type` (`id`, `code`, `description`) VALUES
(@read, '+r', 'Read'),
(@readwrite, '+rw', 'Read & Write'),
(@fullaccess, '+rwd', 'Full Access');

--
-- Data for table `permission`
--
INSERT INTO `acl_permission` (`role_id`, `resource_id`, `access_type_id`, `is_disabled`) VALUES
-- sup_admin
(@sup_admin, @admin_resource, @fullaccess, 0),
(@sup_admin, @user_management, @fullaccess, 0),
(@sup_admin, @media_resource, @fullaccess, 0),
(@sup_admin, @profile_resource, @fullaccess, 0),
(@sup_admin, @general_resource, @fullaccess, 0),
(@sup_admin, @disabled_resource, @fullaccess, 0),

-- sys_admin
(@sys_admin, @user_management, @fullaccess, 0),
(@sys_admin, @media_resource, @fullaccess, 0),
(@sys_admin, @profile_resource, @fullaccess, 0),
(@sys_admin, @general_resource, @fullaccess, 0),
(@sys_admin, @disabled_resource, @fullaccess, 0),

-- std_user
(@std_user, @media_resource, @readwrite, 0),
(@std_user, @profile_resource, @fullaccess, 0),
(@std_user, @general_resource, @read, 0),
(@std_user, @disabled_resource, @fullaccess, 0),

-- guest
(@guest, @general_resource, @read, 0),
(@guest, @disabled_resource, @read, 1);