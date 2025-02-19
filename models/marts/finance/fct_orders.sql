with
    orders as (select * from {{ ref("stg_orders") }}),
    payments as (select * from {{ ref("stg_payments") }}),
    order_payments as (
        select
            payments.order_id,
            sum(
                case when payments.status = 'success' then payments.amount end
            ) as amount
        from payments
        group by payments.order_id
    ),
    final as (
        select
            orders.order_id,
            orders.customer_id,
            orders.order_date,
            coalesce(order_payments.amount, 0) as amount
        from orders
        left join order_payments using (order_id)
    )

select *
from final
