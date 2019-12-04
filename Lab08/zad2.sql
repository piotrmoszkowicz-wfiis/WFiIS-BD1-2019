CREATE OR REPLACE FUNCTION free_shipping_time() RETURNS TRIGGER AS $$
DECLARE
    order_date DATE;
BEGIN
    SELECT date_placed INTO order_date FROM orderinfo WHERE orderinfo_id = NEW.orderinfo_id LIMIT 1;

    IF DATE_PART('day', now()::timestamp - order_date::timestamp) > 3 THEN 
        UPDATE orderinfo SET shipping = 0.00 WHERE orderinfo_id = NEW.orderinfo_id;
    END IF; 

    RETURN NEW;
END
$$LANGUAGE 'plpgsql';


CREATE TRIGGER trig_free_shipping_time BEFORE UPDATE ON orderinfo
FOR EACH ROW EXECUTE PROCEDURE free_shipping_time();