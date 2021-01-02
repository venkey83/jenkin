//
CREATE PROCEDURE CreateInvoiceApprovalSequence(IN  supplierId Long,OUT insertedId bigint)
BEGIN
DECLARE sequenceNumber int;
set sequenceNumber =(Select max(invoice_approval_request_sequence.sequence)+1 from invoice_approval_request_sequence where invoice_approval_request_sequence.supplier_id=supplierId);
INSERT INTO invoice_approval_request_sequence (created_date, modified_date, sequence, supplier_Id)
VALUES (now(), now(), (select IF( sequenceNumber IS NULL,1,sequenceNumber)), supplierId);
set insertedId= LAST_INSERT_ID();
END //
