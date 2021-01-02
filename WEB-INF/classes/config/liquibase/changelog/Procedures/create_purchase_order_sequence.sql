//
CREATE PROCEDURE CreatePurchaseOrderSequence(IN  buyerId Long,OUT insertedId bigint)
BEGIN
DECLARE sequenceNumber int;
set sequenceNumber =(Select max(purchase_order_sequence.sequence)+1 from purchase_order_sequence where purchase_order_sequence.buyer_id=buyerId);
INSERT INTO purchase_order_sequence (created_date, modified_date, sequence,buyer_id)
VALUES (now(), now(), (select IF( sequenceNumber IS NULL,1,sequenceNumber)), buyerId);
set insertedId= LAST_INSERT_ID();
END //
