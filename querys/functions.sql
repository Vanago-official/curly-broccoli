create or replace function calculate_order_total(p_order_id int) returns numeric(10, 2) AS $$
select coalesce(sum(quantity * price), 0)
from order_items
where order_id = p_order_id $$ Language SQL;
CREATE OR REPLACE PROCEDURE create_order(
        p_customer_id int
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
    end if;
END;
$$;

CREATE OR REPLACE FUNCTION update_orders_total()
RETURNS TRIGGER
AS $$
declare 
    t_order_id int;
BEGIN
    if tg_op = 'DELETE' then
    t_order_id = old.order_id;
    else 
    t_order_id = new.order_id;
    end if;

    update orders
    set total_amount = calculate_order_total(t_order_id)
    where order_id = t_order_id;

    return null;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS recount_total_amount ON order_items;

CREATE TRIGGER recount_total_amount
AFTER UPDATE or DELETE or INSERT on order_items
FOR EACH ROW
EXECUTE FUNCTION
update_orders_total();

CREATE OR REPLACE FUNCTION log_order()
RETURNS TRIGGER
AS $$
BEGIN
    INSERT INTO order_log(order_id, customer_id, action, log_date)
    values(new.order_id, new.customer_id, 'ORDER CREATED', current_timestamp);
    RETURN new;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS logger ON orders;

CREATE TRIGGER logger
AFTER INSERT on orders
FOR EACH ROW
EXECUTE FUNCTION
log_order();