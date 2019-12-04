CREATE OR REPLACE FUNCTION orderinfo_discount() RETURNS TRIGGER AS $$
DECLARE
    orders RECORD;
BEGIN
    SELECT COUNT(*) as cunt INTO orders FROM orderinfo WHERE customer_id = NEW.customer_id;
    IF orders.cunt % 10 = 0 THEN
        UPDATE customer SET discount = discount + 0.02 WHERE customer_id = NEW.customer_id;
    END IF;

    RETURN NEW;
END 
$$LANGUAGE 'plpgsql';

CREATE TRIGGER trig_orderinfo_discount AFTER INSERT ON orderinfo FOR EACH ROW
EXECUTE PROCEDURE orderinfo_discount();

