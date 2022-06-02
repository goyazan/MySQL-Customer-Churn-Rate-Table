select
	date_format(timestamp, '%Y%m') as year_and_month,
	upper(replace(planid, '-', ' ')) as product_name,
	count(*) as cancellations
from
	btree_subscriptions_statushistory
where
	status = 'CANCELED'
group by
	year_and_month,
	product_name
order by
	year_and_month