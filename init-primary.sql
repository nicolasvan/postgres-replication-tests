CREATE DATABASE test1;

\c test1

CREATE TABLE IF NOT EXISTS table1 (
    x int primary key, 
    y int
);

create publication pub_table1 for table table1;   