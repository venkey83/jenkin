//
CREATE PROCEDURE UpdateInvoiceSequence(IN  supplierId Long,OUT sequenceNumber long)
BEGIN
set sequenceNumber =(Select max(sequence.invoice_number)+1 from sequence where sequence.supplier_id=supplierId);
update sequence set modified_date=now(),invoice_number=sequenceNumber where supplier_id=supplierId;
END//
