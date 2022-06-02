select 
	year_and_month,
    product_name,
	ifnull(customers, 0) as customers,
	ifnull(cancellations, 0) as cancellations,
    ifnull(cancellations / customers, 0) as churn_rate
from
	(select
		t1.year_and_month,
		t1.product_name,
        
		(select
			customer_count
		from
			view_btree_churn_customers as t2 
		where
			t2.product_name = t1.product_name and t2.year_and_month < t1.year_and_month
		order by
			t2.product_name, t2.year_and_month desc
		limit 1
        ) as customers,
        
		ca.cancellations
	from
		view_btree_churn_customers as t1
        
	left outer join
		view_btree_churn_cancellations as ca
		on t1.year_and_month = ca.year_and_month and t1.product_name = ca.product_name
	) as x