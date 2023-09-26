--
-- UUID Conversion Settings
--

DELIMITER $$

-- BINARY to UUID
DROP FUNCTION IF EXISTS BIN_TO_UUID;
CREATE FUNCTION BIN_TO_UUID(
    b BINARY(16), 
    f BOOLEAN
)
RETURNS CHAR(36)
DETERMINISTIC
BEGIN
    DECLARE hexStr CHAR(36);
    DECLARE uuid CHAR(36);

    SET hexStr = HEX(b);
    SET uuid = CONCAT(
        IF(f, SUBSTR(hexStr, 9, 8), SUBSTR(hexStr, 1, 8)), '-',
        IF(f, SUBSTR(hexStr, 5, 4), SUBSTR(hexStr, 9, 4)), '-',
        IF(f, SUBSTR(hexStr, 1, 4), SUBSTR(hexStr, 13, 4)), '-',
        SUBSTR(hexStr, 17, 4), '-',
        SUBSTR(hexStr, 21)
    );

    RETURN uuid;
END $$

-- UUID to BINARY
DROP FUNCTION IF EXISTS UUID_TO_BIN;
CREATE FUNCTION UUID_TO_BIN(
    uuid CHAR(36), 
    f BOOLEAN
)
RETURNS BINARY(16)
DETERMINISTIC
BEGIN
    DECLARE hexStr CHAR(36);

    SET hexStr = CONCAT(
        IF(f, SUBSTRING(uuid, 15, 4), SUBSTRING(uuid, 1, 8)),
        SUBSTRING(uuid, 10, 4),
        IF(f, SUBSTRING(uuid, 1, 8), SUBSTRING(uuid, 15, 4)),
        SUBSTRING(uuid, 20, 4),
        SUBSTRING(uuid, 25)
    );

    RETURN UNHEX(hexStr);
END $$

--
-- ACL Validation Settings
--
DROP PROCEDURE IF EXISTS ACL_VALIDATE;
CREATE PROCEDURE ACL_VALIDATE(
    resource_code VARCHAR(255), 
    role_id CHAR(36), 
    mode CHAR(5), 
    f BOOLEAN
)
DETERMINISTIC
BEGIN
    SET @code = resource_code;
    SET @uuid = UUID_TO_BIN(role_id, f);
    SET @regExp = CONCAT('[', mode, ']');
    SET @query = CONCAT(
        'SELECT COUNT(p.role_id) FROM acl_permission p ',
        'INNER JOIN acl_role r ON r.id = p.role_id ',
        'INNER JOIN acl_resource s ON s.id = p.resource_id '
        'INNER JOIN acl_access_type a ON a.id = p.access_type_id ',
        'WHERE s.deleted <> 1 AND p.is_disabled <> 1 AND s.code = ? AND r.id = ? AND a.code REGEXP ? ',
        'INTO @hasPermission'
    );

    PREPARE stmt FROM @query;
    EXECUTE stmt USING @code, @uuid, @regExp;
    DEALLOCATE PREPARE stmt;
    
    SELECT @hasPermission;
END $$

DELIMITER ;