//
CREATE PROCEDURE CreatePaymentApprovalSequence(IN  buyerId Long,OUT insertedId bigint)
BEGIN
DECLARE sequenceNumber int;
set sequenceNumber =(Select max(payment_approval_sequence.sequence_number)+1 from payment_approval_sequence);
INSERT INTO payment_approval_sequence (created_date,modified_date, sequence_number)
VALUES (now(),now(), (select IF( sequenceNumber IS NULL,1,sequenceNumber)));
set insertedId= LAST_INSERT_ID();
END //
