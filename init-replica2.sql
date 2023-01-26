CREATE DATABASE test1;

\c test1

CREATE TABLE IF NOT EXISTS table1 (
    x int primary key, 
    y int
);

CREATE SUBSCRIPTION sub_table1
CONNECTION 'host=replica1 port=5432 dbname=test1 user=postgres password=postgres' PUBLICATION pub_table1;