//
CREATE PROCEDURE CreateBatchPaymentReferenceSequence(IN  buyerId Long,OUT insertedId bigint)
BEGIN
DECLARE sequenceNumber int;
set sequenceNumber =(Select max(batch_payment_reference_sequence.sequence_number)+1 from batch_payment_reference_sequence);
INSERT INTO batch_payment_reference_sequence (sequence_number, created_date, modified_date)
VALUES ((select IF( sequenceNumber IS NULL,1,sequenceNumber)), now(), now());
set insertedId= LAST_INSERT_ID();
END //
