//
CREATE PROCEDURE purchase_order_list(IN po_list LONGBLOB)
BEGIN
    DROP TABLE IF EXISTS t_selected;
    DROP TABLE IF EXISTS t_items;
    DROP TABLE IF EXISTS t_buyer_user;
    DROP TABLE IF EXISTS t_business;
    DROP TABLE IF EXISTS t_posequence;
    DROP TABLE IF EXISTS t_process_order;
    DROP TABLE IF EXISTS t_invoice;
    DROP TABLE IF EXISTS t_buyer_requirement;

                set @sql = concat("CREATE TEMPORARY TABLE IF NOT EXISTS t_selected AS (SELECT process_order.id,process_order.items_id, process_order.requirement_number,process_order.buyer_user_id,process_order.buyer_business_id from purchase_order  left join process_order on purchase_order.process_order_id=process_order.id where purchase_order_number in (",po_list,"))");
				PREPARE stmt FROM @sql;
				EXECUTE stmt ;
                        create temporary table t_invoice
                            select id as inv_id,invoice_number as inv_number,invoice_date,invoice_comment,delivery_charge as inv_delivery_charge,discount as inv_discount,invoice_sub_total,invoice_total,added_gst,grand_total,debit_note_status,debit_note_amount from invoice;
                        create temporary table t_posequence
                            select T.id as purchase_ordersequence_id,T.sequence,T.buyer_id as buyerId,buyer.buyer_code,buyer.company_name as buyer_company_name,buyer.company_address as buyer_company_address,buyer.company_postal_code,buyer.shipping_address as buyer_shipping_address,buyer.shipping_postal_code as buyer_shipping_postal_code,buyer.contact_person_name as buyer_contact_person,buyer.company_logo as buyer_company_logo,buyer.suppliers_limit,buyer.company_code,buyer.company_registration_number as buyer_company_registartion_number,buyer.tax as buyer_tax,buyer.gst_reg_no as buyer_gst_reg_no,sequence.invoice_number as sequence_invoice_number, sequence.supplier_id as sequence_supplier_id from purchase_order_sequence T left join buyer on T.buyer_id=buyer.id left join sequence on T.sequence=sequence.id;
                        create temporary table t_business
                            select T.id as buyer_business_id,T.business_outlet_name,T.brand_name,T.billing_address,T.shipping_address,T.contact_person_name as business_contact_person_name,T.contact_person_designation as business_contact_person_designation,T.email as buyer_business_email,T.business_outlet_code,T.business_outlet_logo,T.address as buyer_busineess_address,T.city as buyer_business_city,T.postal_code,T.shipping_postal_code,T.billing_postal_code,T.organization_number,T.location_number,T.department_code,T.default_purchase_order_type_id, C.name as default_purchase_order_type_name,C.code as default_purchase_order_type_code from buyer_business as T left join purchase_order_types C on T.default_purchase_order_type_id=C.id where T.id in (select buyer_business_id from t_selected);
                        create temporary table t_buyer_user
                            select buyer_user.id as buyer_user_id, buyer_user.parent_id,buyer_user.budget,buyer_user.secondary_email,buyer_user.favorite_view,buyer_user.budget_for_auto_order,buyer_user.phone_number,buyer_user.mobile_number,buyer_user.min_amount,buyer_user.max_amount,buyer_user.level, user_roles.id as user_role_id,user_roles.name as user_roles_name, user_roles.level as user_role_level,user_roles.is_active as user_roles_isActive from buyer_user left join user_roles on buyer_user.user_roles_id=user_roles.id where buyer_user.id in (select buyer_user_id from t_selected);
                        create temporary table t_items
                            SELECT items.id as items_id,items.item_code, items.item_name, items.item_description, items.item_keyword, items.moq, items.price,items.currency, items.image, items.item_type, items.deleted as items_deleted, supplier.id as items_supplier_id,supplier.company_name as supplier_company_name, supplier.company_address as supplier_company_address,supplier.supplier_type,supplier.phone,supplier.mobile,supplier.contact_person_name as supplier_contact_person_name,supplier.contact_person_designation as supplier_contact_person_designation, supplier.type_of_business,supplier.tax,supplier.gst,supplier.company_registration_number as supplier_company_registration_number,supplier.delivery_terms,supplier.payment_terms,supplier.payment_due_days,supplier.payment_discount_days,supplier.payment_discount_percent,supplier.delivery_conditions,supplier.delivery_charge,supplier.company_logo as supplier_company_logo,supplier.account_name,supplier.account_number,supplier.bank_name,supplier.deleted as supplier_deleted,supplier.supplier_code,supplier.order_time_for_friday,supplier.order_time_for_saturday,supplier.minimum_order_for_free_delivery,supplier.below_minimum_purchase_condition,supplier.order_time_for_today,supplier.no_delivery_on_saturday,supplier.no_delivery_on_holidays,supplier.no_delivery_on_sunday,supplier.buyers_limit,supplier.visibility_type,supplier.no_delivery_on_monday,supplier.gst_reg_no as supplier_gst_reg_no, uom.id as uom_id,uom.name as uom_name, uom.description as uom_description, uom.deleted as uom_deleted, uom.weight_required, uom.moq_based_price, item_group.id as item_group_id,item_group.name as item_group_name, item_group.deleted as item_group_deleted,item_group.description as item_group_description  from items left join uom on items.uom_id=uom.id left join supplier on items.supplier_id=supplier.id left join item_group on items.item_group_id=item_group.id where items.id in (select items_id from t_selected);
                        create temporary table t_process_order
                            SELECT process_order.id as process_orderId,process_order.requirement_number,process_order.delivery_date,process_order.quantity,process_order.special_request,process_order.process_order_status,process_order.supplier_feedback,process_order.weight,process_order.is_free_item,process_order.price as process_order_price,process_order.deleted as process_order_deleted, t_items.*,t_buyer_user.*,t_business.* FROM process_order left join t_items on process_order.items_id=t_items.items_id left join t_buyer_user on process_order.buyer_user_id=t_buyer_user.buyer_user_id left join t_business on t_business.buyer_business_id=process_order.buyer_business_id where process_order.id in (select id from t_selected);
                        create temporary table t_buyer_requirement
                            SELECT process_order.delivery_date as new_delivery_date, process_order.requirement_number as process_order_req,process_order.quantity as process_order_quantity,process_order.process_order_status as process_order_process_order_status,process_order.supplier_feedback as process_order_supplier_feedback,process_order.weight as process_order_weight,process_order.is_free_item as process_order_free_item,process_order.price as process_order_reqprice,process_order.items_id as req_item_id FROM process_order where process_order.requirement_number in (select requirement_number from t_selected) and process_order.process_order_status='SUPPLIER_DEMAND_MODIFIED' and process_order.is_free_item is false;
                set @sql = concat("SELECT id,purchase_order_number,purchase_order_date,purchase_order_type,purchase_order_status,e_signature ,process_order_id,response_date,buyer_action,buyer_rejected_quantity,buyer_remark,received_date,invoice_status,invoice_id,buyer_cancelpo_reason,supplier_reject_cancelpo_remark,goods_return_notice_id,rejected_weight,goods_return_status,cancel_po_status,ad_hoc_credit_notes_id,ocr_invoice_status,geo_exported,ocr_invoice_number,ocr_invoice_amount,amount,ocr_invoice_response_date,ocr_invoice_date,purchase_order_sequence_id,ocr_gst,adhoc_status,ax_exported,supplier_id,t_process_order.*,t_posequence.*,t_invoice.*,t_buyer_requirement.*,buyer_accepted_quantity from purchase_order left join t_process_order on purchase_order.process_order_id=t_process_order.process_orderId left join t_posequence on purchase_order.purchase_order_sequence_id=t_posequence.purchase_ordersequence_id left join t_invoice on purchase_order.invoice_id=t_invoice.inv_id left join t_buyer_requirement on CONCAT(t_process_order.requirement_number,t_process_order.items_id)=CONCAT(t_buyer_requirement.process_order_req,t_buyer_requirement.req_item_id)  where purchase_order_number in (",po_list,")");
				PREPARE stmt FROM @sql;
				EXECUTE stmt ;
    DROP TABLE IF EXISTS t_selected;
    DROP TABLE IF EXISTS t_items;
    DROP TABLE IF EXISTS t_buyer_user;
    DROP TABLE IF EXISTS t_business;
    DROP TABLE IF EXISTS t_posequence;
    DROP TABLE IF EXISTS t_process_order;
    DROP TABLE IF EXISTS t_buyer_requirement;
END
//

