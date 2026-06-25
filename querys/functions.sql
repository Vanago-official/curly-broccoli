create or replace function calculate_order_total(p_order_id int) returns numeric(10, 2) AS $$
select coalesce(sum(quantity * price), 0)
from order_items
where order_id = p_order_id $$ Language SQL;
CREATE OR REPLACE PROCEDURE create_order(
        p_customer_id int,
        p_order_id int
    ) LANGUAGE plpgsql AS $$ BEGIN
INSERT INTO orders (customer_id, order_date, total_amount)
values (p_customer_id, current_timestamp, 0);
END;
$$;