//
CREATE PROCEDURE `CreateInvoiceSequence`(IN supplierId LONG,OUT lastGeneratedId LONG)
BEGIN
DECLARE sequenceNumber int;
set sequenceNumber=(SELECT MAX(sequence_number)+1 FROM invoice_sequence WHERE invoice_sequence.supplier_id=supplierId);
INSERT INTO invoice_sequence(created_date, modified_date, sequence_number,supplier_id)
VALUES(now(), now(),(SELECT IF(sequenceNumber is NULL,1,sequenceNumber)),supplierid);
set lastGeneratedId=LAST_INSERT_ID();
END
//