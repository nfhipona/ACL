--
-- UUID Conversion Settings
--

DELIMITER $$

-- BINARY to UUID
DROP FUNCTION IF EXISTS BIN_TO_UUID;
CREATE FUNCTION BIN_TO_UUID(b BINARY(16), f BOOLEAN)
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
CREATE FUNCTION UUID_TO_BIN(uuid CHAR(36), f BOOLEAN)
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

DELIMITER ;