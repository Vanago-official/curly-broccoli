**Що зроблено:**
1. **calculate_order_total(p_order_id)** - функція. Приймає id замовлення, повертає суму. Якщо пусто - 0. Користується quantity * price з order_items
2. **create_order(p_customer_id)** - процедура. Створює замовлення, ставить поточну дату, total_amount = 0
3. **add_product_to_order(p_order_id, p_product_id, p_quantity)** - процедура. Додає товар в замовлення. Бере актуальну ціну з products, зменшує stock_quantity. Якщо нема стільки на складі або кількість <= 0 - вибиває повідомлення
4. **recount_total_amount** - тригер на order_items. Після INSERT/UPDATE/DELETE сам перераховує total_amount через функцію з пункту 1
5. **logger** - тригер на orders. Після INSERT пише в order_log: id замовлення, id клієнта, 'ORDER CREATED', дату
6. **Тести** - для всіх тригерів, функцій та процедур зроблені тести в файлі querys/tests.sql