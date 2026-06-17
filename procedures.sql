-- =========================================================================
-- SYNCRIDE STORED PROCEDURES & TRIGGERS
-- =========================================================================

USE syncride_db;

DELIMITER //

-- 1. Procedure to Join a Ride Group with Capacity Check
CREATE PROCEDURE IF NOT EXISTS sp_JoinRideGroup(
    IN p_GroupID INT,
    IN p_UserID INT,
    OUT p_Status VARCHAR(100)
)
BEGIN
    DECLARE v_CurrentCount INT;
    DECLARE v_MaxCapacity INT;
    DECLARE v_GroupGender VARCHAR(20);
    DECLARE v_UserGender VARCHAR(20);

    -- Get current count and capacity
    SELECT COUNT(*) INTO v_CurrentCount FROM Group_Members WHERE GroupID = p_GroupID;
    
    SELECT V.Capacity, RG.GenderPreference INTO v_MaxCapacity, v_GroupGender
    FROM Ride_Groups RG
    LEFT JOIN Drivers D ON RG.DriverID = D.DriverID
    LEFT JOIN Vehicles V ON D.VehicleID = V.VehicleID
    WHERE RG.GroupID = p_GroupID;

    -- Get user gender
    SELECT Gender INTO v_UserGender FROM Users WHERE UserID = p_UserID;

    -- Checks
    IF v_CurrentCount >= IFNULL(v_MaxCapacity, 4) THEN
        SET p_Status = 'Error: Group is full.';
    ELSEIF v_GroupGender != 'None' AND v_GroupGender != CONCAT(v_UserGender, 'Only') THEN
        SET p_Status = 'Error: Gender mismatch for this group.';
    ELSE
        INSERT INTO Group_Members (GroupID, UserID) VALUES (p_GroupID, p_UserID);
        SET p_Status = 'Success: Joined group.';
    END IF;
END //

-- 2. Procedure to Calculate and Update Fares
CREATE PROCEDURE IF NOT EXISTS sp_FinalizeGroupFares(
    IN p_GroupID INT
)
BEGIN
    DECLARE v_TotalFare DECIMAL(8,2);
    DECLARE v_MemberCount INT;
    DECLARE v_Share DECIMAL(6,2);

    SELECT TotalFare INTO v_TotalFare FROM Ride_Groups WHERE GroupID = p_GroupID;
    SELECT COUNT(*) INTO v_MemberCount FROM Group_Members WHERE GroupID = p_GroupID;

    IF v_MemberCount > 0 THEN
        SET v_Share = v_TotalFare / v_MemberCount;
        UPDATE Group_Members SET FareContribution = v_Share WHERE GroupID = p_GroupID;
    END IF;
END //

-- 3. Trigger to prevent joining if status is not 'Forming'
CREATE TRIGGER IF NOT EXISTS trg_BeforeJoinGroup
BEFORE INSERT ON Group_Members
FOR EACH ROW
BEGIN
    DECLARE v_Status VARCHAR(20);
    SELECT Status INTO v_Status FROM Ride_Groups WHERE GroupID = NEW.GroupID;
    IF v_Status != 'Forming' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot join a group that is already confirmed or completed.';
    END IF;
END //

DELIMITER ;
