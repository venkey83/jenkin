//
CREATE PROCEDURE CreateEpdApprovalSequence(IN  buyerId Long,OUT insertedId bigint)
BEGIN
DECLARE sequenceNumber int;
set sequenceNumber =(Select max(epd_approval_sequence.sequence_number)+1 from epd_approval_sequence);
INSERT INTO epd_approval_sequence (created_date, sequence_number)
VALUES (now(), (select IF( sequenceNumber IS NULL,1,sequenceNumber)));
set insertedId= LAST_INSERT_ID();
END //
