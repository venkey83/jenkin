//
CREATE PROCEDURE CreateApprovalRequestSequence(IN  buyerId Long,OUT insertedId bigint)
BEGIN
DECLARE sequenceNumber int;
set sequenceNumber =(Select max(approval_request_sequence.sequence_number)+1 from approval_request_sequence);
INSERT INTO approval_request_sequence (created_date, modified_date, sequence_number)
VALUES (now(), now(), (select IF( sequenceNumber IS NULL,1,sequenceNumber)));
set insertedId= LAST_INSERT_ID();
END//
