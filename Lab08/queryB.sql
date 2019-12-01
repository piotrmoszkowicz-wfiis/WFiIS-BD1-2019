CREATE OR REPLACE FUNCTION customer_trigger() RETURNS TRIGGER AS $$
DECLARE
    orders RECORD;
BEGIN
    SELECT COUNT(*) as cunt INTO orders FROM orderinfo WHERE customer_id = OLD.customer_id AND date_shipped IS NULL GROUP BY customer_id;
    IF orders.cunt THEN
        RETURN NULL;
    END IF;
    
    DELETE FROM orderline WHERE orderinfo_id IN (SELECT orderinfo_id FROM orderinfo WHERE customer_id = OLD.customer_id);
    DELETE FROM orderinfo WHERE customer_id = OLD.customer_id;
    RETURN OLD;
END 
$$LANGUAGE 'plpgsql';

CREATE TRIGGER trig_customer BEFORE DELETE ON customer FOR EACH ROW
EXECUTE PROCEDURE customer_trigger();

