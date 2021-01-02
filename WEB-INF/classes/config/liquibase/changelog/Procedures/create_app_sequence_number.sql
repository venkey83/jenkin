//
CREATE PROCEDURE CreateAppSequenceNumber(IN seqId long, IN requestFor int, OUT outNumber bigint)
BEGIN
DECLARE sequenceNumber int;
START TRANSACTION;
SELECT (app_sequence_number.sequence_number + requestFor) INTO sequenceNumber FROM app_sequence_number WHERE app_sequence_number.id = seqId;
UPDATE app_sequence_number SET app_sequence_number.sequence_number = sequenceNumber WHERE id = seqId;
COMMIT;
SET outNumber = sequenceNumber;
END //
