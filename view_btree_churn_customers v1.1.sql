select
	date_format(tr1.createdat, '%Y%m') as year_and_month,
    
	case
		when wo.order_item_name is not null then upper(wo.order_item_name)
		when tr1.planid is not null then upper(replace(tr1.planid, '-', ' '))
		else upper(replace(tr2.planid, '-', ' '))
	end as product_name,
    
	count(*) as customer_count
from 
	btree_transaction as tr1
    
left outer join 
	(select * from woo_order_items where order_item_type = 'line_item') as wo
	on tr1.orderid = wo.order_id
    
left outer join
	(select id, planid from btree_transaction where type = 'SALE' and planid is not null) as tr2
	on tr1.refundedtransactionid = tr2.id
    
where
	tr1.status = 'SETTLED' and tr1.type = 'SALE' and 
	
	(case
		when tr1.recurring = 1 then 'Subscription'
		when tr1.recurring = 0 and (wo.order_item_name in (select order_item_name from woo_product_groups where product_type = 'Subscription')) then 'Subscription'
		when tr1.recurring = 0 and replace(tr2.planid, '-', ' ') in (select order_item_name from woo_product_groups where product_type = 'Subscription') then 'Subscription'
		else 'One-time'
	end) = 'Subscription'
    
group by
	year_and_month,
	product_name
order by
	year_and_month,
	product_name