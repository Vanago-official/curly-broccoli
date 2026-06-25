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
create or replace procedure add_product_to_order(
    p_order_id int,
    p_product_id int,
    p_quantity int
)
LANGUAGE plpgsql
AS $$
BEGIN
if (select stock_quantity from products where product_id = p_product_id) - p_quantity >= 0 and p_quantity > 0 then
    INSERT INTO order_items (order_id, product_id, quantity, price)
    values (p_order_id, p_product_id, p_quantity, (select price from products where product_id = p_product_id));
    update products
    set stock_quantity = stock_quantity - p_quantity
    where product_id = p_product_id;
    else raise notice 'та ти шось нахімічив тут';
    END if;
END;
$$;