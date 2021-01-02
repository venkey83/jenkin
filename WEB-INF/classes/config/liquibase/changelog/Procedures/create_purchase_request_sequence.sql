//
CREATE PROCEDURE CreatePurchaseRequestSequence(IN  buyerId Long,OUT insertedId bigint)
BEGIN
DECLARE sequenceNumber int;
set sequenceNumber =(Select max(purchase_request_sequence.sequence_number)+1 from purchase_request_sequence);
INSERT INTO purchase_request_sequence (created_date, modified_date, sequence_number)
VALUES (now(), now(), (select IF( sequenceNumber IS NULL,1,sequenceNumber)));
set insertedId= LAST_INSERT_ID();
END //
