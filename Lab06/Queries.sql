CREATE TYPE "relation" AS ENUM (
  'parent',
  'kid',
  'sibling'
);

CREATE TABLE "people" (
  "id" SERIAL PRIMARY KEY,
  "first_name" varchar,
  "last_name" varchar,
  "date_of_birth" DATE,
  "birth_place" varchar,
  "date_of_death" DATE
);

CREATE TABLE "family_relations" (
  "id" SERIAL PRIMARY KEY,
  "relation_type" relation,
  "relation_main_person" int,
  "relation_secondary_person" int
);

ALTER TABLE "family_relations" ADD FOREIGN KEY ("relation_main_person") REFERENCES "people" ("id");

ALTER TABLE "family_relations" ADD FOREIGN KEY ("relation_secondary_person") REFERENCES "people" ("id");

INSERT INTO "public"."people" ("first_name", "last_name", "date_of_birth", "birth_place") VALUES ('Jan', 'Kowalski', '1990-01-23', 'Kraków');
INSERT INTO "public"."people" ("first_name", "last_name", "date_of_birth", "birth_place") VALUES ('Tadeusz', 'Kowalski', '1952-01-23', 'Warszawa');
INSERT INTO "public"."people" ("first_name", "last_name", "date_of_birth", "birth_place", "date_of_death") VALUES ('Małgorzata', 'Kowalska', '1965-05-14', 'Suwałki', NOW());
INSERT INTO "public"."people" ("first_name", "last_name", "date_of_birth", "birth_place") VALUES ('Albert', 'Kowalski', '1995-01-24', 'Kraków');

INSERT INTO "public"."family_relations" ("relation_type", "relation_main_person", "relation_secondary_person") VALUES ('parent', '2', '1');
INSERT INTO "public"."family_relations" ("relation_type", "relation_main_person", "relation_secondary_person") VALUES ('parent', '3', '1');
INSERT INTO "public"."family_relations" ("relation_type", "relation_main_person", "relation_secondary_person") VALUES ('sibling', '1', '4');
INSERT INTO "public"."family_relations" ("relation_type", "relation_main_person", "relation_secondary_person") VALUES ('sibling', '4', '1');
INSERT INTO "public"."family_relations" ("relation_type", "relation_main_person", "relation_secondary_person") VALUES ('parent', '2', '4');
INSERT INTO "public"."family_relations" ("relation_type", "relation_main_person", "relation_secondary_person") VALUES ('parent', '3', '4');
INSERT INTO "public"."family_relations" ("relation_type", "relation_main_person", "relation_secondary_person") VALUES ('kid', '1', '2');
INSERT INTO "public"."family_relations" ("relation_type", "relation_main_person", "relation_secondary_person") VALUES ('kid', '4', '2');
INSERT INTO "public"."family_relations" ("relation_type", "relation_main_person", "relation_secondary_person") VALUES ('kid', '1', '3');
INSERT INTO "public"."family_relations" ("relation_type", "relation_main_person", "relation_secondary_person") VALUES ('kid', '4', '3');

SELECT * FROM people WHERE first_name = 'Jan' AND last_name = 'Kowalski';
SELECT * FROM people JOIN family_relations ON family_relations.relation_main_person = people.id WHERE family_relations.relation_secondary_person = (SELECT id FROM people WHERE first_name = 'Jan' AND last_name = 'Kowalski' LIMIT 1) AND family_relations.relation_type = 'parent';
SELECT first_name FROM people JOIN family_relations ON family_relations.relation_secondary_person = people.id WHERE family_relations.relation_main_person = (SELECT id FROM people WHERE first_name = 'Tadeusz' AND last_name = 'Kowalski' LIMIT 1) AND family_relations.relation_type = 'parent';
SELECT * FROM people JOIN family_relations ON family_relations.relation_main_person = people.id WHERE family_relations.relation_secondary_person = (SELECT id FROM people WHERE first_name = 'Jan' AND last_name = 'Kowalski' LIMIT 1) AND family_relations.relation_type = 'sibling';

