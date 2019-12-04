CREATE or REPLACE FUNCTION customer_max_quantity_trigger() RETURNS TRIGGER AS $$
DECLARE
    orderrow RECORD;
    quantity_to_response INT;
    quantity_to_add INT;
    new_order_id INT;
BEGIN
    quantity_to_response := NEW.quantity;

    IF quantity_to_response > 10 THEN
        SELECT * FROM orderinfo INTO orderrow WHERE orderinfo_id = NEW.orderinfo_id;
        WHILE quantity_to_response != 0 LOOP
            quantity_to_add := quantity_to_response;
            IF quantity_to_response > 10 THEN 
                quantity_to_add = 10;
                INSERT INTO orderinfo VALUES (DEFAULT, orderrow.customer_id, NOW(), NULL, orderrow.shipping);
                SELECT orderinfo_id INTO new_order_id FROM orderinfo ORDER BY orderinfo_id DESC LIMIT 1;
                INSERT INTO orderline VALUES (new_order_id, NEW.item_id, quantity_to_add);
            ELSE
                NEW.quantity = quantity_to_add;
            END IF;

            quantity_to_response = quantity_to_response - quantity_to_add;
        END LOOP;
    END IF;

    RETURN NEW;
END
$$LANGUAGE 'plpgsql';

CREATE TRIGGER trig_max_quantity BEFORE INSERT ON orderline FOR EACH ROW
EXECUTE PROCEDURE customer_max_quantity_trigger();