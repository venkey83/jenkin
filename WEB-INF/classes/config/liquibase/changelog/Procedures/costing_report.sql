//
CREATE PROCEDURE costing_report(IN bo_list varchar(40),IN startdate varchar(30),IN enddate varchar(30), IN buyerid varchar(10))
BEGIN
DROP TABLE IF EXISTS table2;
CREATE TEMPORARY TABLE IF NOT EXISTS table2 AS
(SELECT gl_specific_item_groups.name AS GLGROUPNAME,  buyer_business.business_outlet_name AS OUTLETNAME, buyer_business.id,
  sum(process_order.quantity * process_order.price) AS ItemPurchaseAmount  FROM item_buyer_mapping LEFT JOIN items ON item_buyer_mapping.items_id = items.id
    LEFT JOIN item_group ON items.item_group_id = item_group.id LEFT JOIN process_order ON process_order.items_id = items.id
    LEFT JOIN gl_code_mappings ON process_order.gl_code_mappings_id = gl_code_mappings.ID LEFT JOIN gl_specific_item_groups ON gl_specific_item_groups.id = gl_code_mappings.gl_specific_item_groups_id
    LEFT JOIN purchase_order ON purchase_order.process_order_id = process_order.id LEFT JOIN invoice ON invoice.id = purchase_order.invoice_id
    LEFT JOIN buyer_business ON process_order.buyer_business_id = buyer_business.id
    WHERE
        process_order.created_date >= startdate
            AND process_order.created_date <= enddate
            AND item_buyer_mapping.buyer_id = buyerid
            AND item_buyer_mapping.deleted = FALSE
            AND items.deleted = FALSE
            AND  FIND_IN_SET(buyer_business.id, bo_list)
                and gl_code_mappings.gl_specific_item_groups_id <>''
GROUP BY buyer_business.id,gl_code_mappings.gl_specific_item_groups_id
order by buyer_business.business_outlet_name, gl_code_mappings.gl_specific_item_groups_id
);
SET @sql_dynamic =  (SELECT
  GROUP_CONCAT(DISTINCT
    CONCAT(
      'SUM(IF( OUTLETNAME = ''',
       OUTLETNAME,
      ''', ITEMPURCHASEAMOUNT, 0)) AS ''',
    OUTLETNAME,''''
    ))
  FROM  table2);

SET @sql = CONCAT('SELECT GLGROUPNAME, ',
			  @sql_dynamic, ',
   SUM(ITEMPURCHASEAMOUNT) AS total
		   FROM table2
		   GROUP BY  GLGROUPNAME
		   WITH ROLLUP'
	);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
DROP TABLE IF EXISTS table2;

END
//

