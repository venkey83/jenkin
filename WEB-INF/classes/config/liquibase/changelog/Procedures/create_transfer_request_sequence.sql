//
CREATE PROCEDURE CreateTransferRequestSequence(IN  buyerId Long,OUT insertedId bigint)
BEGIN
DECLARE sequenceNumber int;
set sequenceNumber =(Select max(transfer_request_sequence.sequence)+1 from transfer_request_sequence where transfer_request_sequence.buyer_id=buyerId);
INSERT INTO transfer_request_sequence (created_date, modified_date, sequence, buyer_id)
VALUES (now(), now(), (select IF( sequenceNumber IS NULL,1,sequenceNumber)), buyerId);
set insertedId= LAST_INSERT_ID();
END //
