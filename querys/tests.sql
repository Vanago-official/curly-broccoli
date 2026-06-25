-- create clients
insert into customers (full_name, email) values ('Іван Петров', 'ivan@mail.com');
insert into customers (full_name, email) values ('Марія Коваль', 'maria@mail.com');

-- create products
insert into products (product_name, price, stock_quantity) values ('Ноутбук', 25000.00, 5);
insert into products (product_name, price, stock_quantity) values ('Мишка', 500.00, 20);
insert into products (product_name, price, stock_quantity) values ('Клавіатура', 1200.00, 10);

-- create order via procedure
call create_order(1);
call create_order(2);

-- add item to order via procedure
call add_product_to_order(1, 1, 2);  -- 2 laptop
call add_product_to_order(1, 2, 3);  -- 3 mouse
call add_product_to_order(2, 3, 1);  -- 1 keyboard

-- check order's total cost
select * from orders;

-- check how many items left
select * from products;

-- check log
select * from order_log;

-- check calculate order func
select calculate_order_total(1);
select calculate_order_total(2);