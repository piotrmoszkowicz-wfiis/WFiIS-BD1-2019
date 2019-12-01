CREATE or REPLACE FUNCTION customer_magazine_trigger() RETURNS TRIGGER AS $$
DECLARE
    customerrow RECORD;
    orderrow RECORD;
BEGIN
    IF NEW.description LIKE '%Magazyn%' THEN
        FOR customerrow IN
            SELECT customer_id FROM customer
        LOOP
            RAISE NOTICE 'INFORMACJA:  cid = %', customerrow.customer_id;
            INSERT INTO orderinfo VALUES (DEFAULT, customerrow.customer_id, NOW(), NULL, 0.0);
            SELECT MAX(orderinfo_id) as id INTO orderrow FROM orderinfo;
            RAISE NOTICE 'ORDERID: id = %', orderrow.id;
            INSERT INTO orderline VALUES (orderrow.id, NEW.item_id, 1);
        END LOOP;
    END IF;
    RETURN NEW;
END
$$LANGUAGE 'plpgsql';

CREATE TRIGGER trig_new_magazine AFTER INSERT ON item FOR EACH ROW
EXECUTE PROCEDURE customer_magazine_trigger();