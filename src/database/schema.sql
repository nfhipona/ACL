--
-- Table structure for table `role`
--
DROP TABLE IF EXISTS `acl_role`;
CREATE TABLE `acl_role` (
    `id` binary(16) NOT NULL,
    `code` varchar(255) NOT NULL,
    `name` varchar(255) NOT NULL,
    `description` varchar(255),

    `deleted` tinyint(1) NOT NULL DEFAULT 0,
    `updatedAt` timestamp NOT NULL DEFAULT CURRENt_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT `acl_role_id_pk` PRIMARY KEY (`id`),
    CONSTRAINT `acl_role_code_u_key` UNIQUE (`code`)
);

--
-- Table structure for table `resource`
--
DROP TABLE IF EXISTS `acl_resource`;
CREATE TABLE `acl_resource` (
    `id` binary(16) NOT NULL,
    `name` varchar(150) NOT NULL COMMENT 'resource access name',
    `code` varchar(255) NOT NULL COMMENT 'resource access unique code',
    `description` varchar(255) NULL,

    `deleted` tinyint(1) NOT NULL DEFAULT 0,
    `updatedAt` timestamp NOT NULL DEFAULT CURRENt_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT `acl_resource_id_pk` PRIMARY KEY (`id`)
);

--
-- Table structure for table `mode`
--
DROP TABLE IF EXISTS `acl_mode`;
CREATE TABLE `acl_mode` (
    `id` binary(16) NOT NULL,
    `code` varchar(5) NOT NULL COMMENT 'ex: +r, +w, +d',
    `description` varchar(255) NULL,

    `deleted` tinyint(1) NOT NULL DEFAULT 0,
    `updatedAt` timestamp NOT NULL DEFAULT CURRENt_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT `acl_mode_id_pk` PRIMARY KEY (`id`),
    CONSTRAINT `acl_mode_code_u_key` UNIQUE (`code`)
);

--
-- Table structure for table `permission`
--
DROP TABLE IF EXISTS `acl_permission`;
CREATE TABLE `acl_permission` (
    `role_id` binary(16) NOT NULL,
    `resource_id` binary(16) NOT NULL,
    `mode` varchar(5) NOT NULL COMMENT 'refer to acl_mode.code',

    `is_disabled` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'No entry means access disabled',

    `updatedAt` timestamp NOT NULL DEFAULT CURRENt_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT `acl_permission_u_key` UNIQUE (`role_id`, `resource_id`, `mode`),
    CONSTRAINT `acl_permission_role_id_fk` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE,
    CONSTRAINT `acl_permission_resource_id_fk` FOREIGN KEY (`resource_id`) REFERENCES `resource` (`id`) ON DELETE CASCADE
);