//
CREATE PROCEDURE CreateReferenceNoSequence(IN  buyerId Long,OUT insertedId bigint)
BEGIN
DECLARE sequenceNumber int;
set sequenceNumber =(Select max(reference_no_sequence.sequence_number)+1 from reference_no_sequence);
INSERT INTO reference_no_sequence (sequence_number, created_date, modified_date)
VALUES ((select IF( sequenceNumber IS NULL,1,sequenceNumber)), now(), now());
set insertedId= LAST_INSERT_ID();
END //
