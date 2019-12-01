CREATE TYPE rownanie_record as (
    i INT,
    x NUMERIC,
    y NUMERIC
);

CREATE OR REPLACE FUNCTION rownanie_tables(
   a NUMERIC, 
   b NUMERIC,
   c NUMERIC,
   x0 NUMERIC,
   step NUMERIC,
   amount NUMERIC) 
RETURNS SETOF rownanie_record AS $$
DECLARE
    i INT;
    x NUMERIC;
    y NUMERIC;
    rec rownanie_record;
BEGIN
    i := 1;
    WHILE i <= amount
    LOOP
        x := x0 + (i - 1) * step;
        y := a * (x * x) + b * x + c;
        SELECT i, x, y INTO rec;
        RETURN NEXT rec;
        i = i + 1;
    END LOOP;
END; $$

CREATE TYPE rownanie_solve as (
    x1 VARCHAR,
    x2 VARCHAR
);

CREATE OR REPLACE FUNCTION rownanie_1(
   a INT, 
   b INT,
   c INT) 
RETURNS rownanie_solve AS $$
DECLARE
    delta NUMERIC;
    x1 NUMERIC;
    x2 NUMERIC;
    x1_i NUMERIC;
    x2_i NUMERIC;
    rec rownanie_solve;
BEGIN
    delta := (b * b) - 4 * a * c;
    RAISE NOTICE 'INFORMACJA:  DELTA = %', delta;
    IF delta > 0 THEN
        RAISE NOTICE 'INFORMACJA:  Rozwiazanie posiada dwa rzeczywiste pierwiastki';
        x1 := (-b - SQRT(delta)) / (2 * a);
        x2 := (-b + SQRT(delta)) / (2 * a);
        RAISE NOTICE 'INFORMACJA:  x1 = %', x1;
        RAISE NOTICE 'INFORMACJA:  x2 = %', x2;
        SELECT CAST(x1 AS VARCHAR), CAST(x2 AS VARCHAR) INTO rec;
        RETURN rec;
    ELSE
        RAISE NOTICE 'INFORMACJA:  Rozwiazanie w dziedzinie liczb zespolonych';
        x1 := (-1.0 * CAST(b AS NUMERIC)) / (2.0 * CAST(a AS NUMERIC));
        x1_i := SQRT(-delta) / (2 * a);
        x2 := (-1.0 * CAST(b AS NUMERIC)) / (2.0 * CAST(a AS NUMERIC));
        x2_i := SQRT(-delta) / (2 * a);
        RAISE NOTICE 'INFORMACJA:  x1 = % - %', x1, x1_i;
        RAISE NOTICE 'INFORMACJA:  x2 = % + %', x2, x2_i;
        SELECT CAST(x1 AS VARCHAR) || ' - ' || x1_i, CAST (x2 AS VARCHAR) || ' + ' || x2_i INTO rec;
        RETURN rec;
    END IF;
END; $$

LANGUAGE plpgsql;