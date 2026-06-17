-- =========================================================================
-- SYNCRIDE PL/SQL TRIGGERS 
-- =========================================================================

-- Trigger 1: BEFORE INSERT - Prevent joining full capacity ride
CREATE OR REPLACE TRIGGER trg_CheckGroupCapacity
BEFORE INSERT ON Group_Members
FOR EACH ROW
DECLARE
    v_CurrentMembers NUMBER;
    v_MaxCapacity NUMBER;
    v_VehicleID NUMBER;
    v_DriverID NUMBER;
BEGIN
    -- Get current count of members
    SELECT COUNT(*) INTO v_CurrentMembers 
    FROM Group_Members 
    WHERE GroupID = :NEW.GroupID;
    
    -- Get driver and vehicle capacity for the group
    SELECT DriverID INTO v_DriverID 
    FROM Ride_Groups 
    WHERE GroupID = :NEW.GroupID;
    
    IF v_DriverID IS NOT NULL THEN
        SELECT Capacity INTO v_MaxCapacity 
        FROM Vehicles V
        JOIN Drivers D ON V.VehicleID = D.VehicleID
        WHERE D.DriverID = v_DriverID;
        
        -- If current members exceed capacity, raise error
        IF v_CurrentMembers >= v_MaxCapacity THEN
            RAISE_APPLICATION_ERROR(-20010, 'Cannot join group. Vehicle capacity reached.');
        END IF;
    END IF;
END;
/

-- Trigger 2: AFTER UPDATE - Auto update total fare when a payment is successful
CREATE OR REPLACE TRIGGER trg_UpdateTotalFare
AFTER UPDATE OF Status ON Payments
FOR EACH ROW
WHEN (NEW.Status = 'Completed' AND OLD.Status != 'Completed')
BEGIN
    UPDATE Ride_Groups
    SET TotalFare = TotalFare + :NEW.Amount
    WHERE GroupID = :NEW.GroupID;
END;
/

-- Trigger 3: BEFORE DELETE - Prevent deletion of active ride requests
CREATE OR REPLACE TRIGGER trg_PreventActiveRequestDeletion
BEFORE DELETE ON Ride_Requests
FOR EACH ROW
BEGIN
    -- Only allow deleting Pending or Cancelled requests, NOT matched/active ones
    IF :OLD.Status = 'Matched' THEN
        RAISE_APPLICATION_ERROR(-20020, 'Cannot delete an active matched ride request.');
    END IF;
END;
/
