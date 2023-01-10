use hr;
GO
SELECT * FROM jobs;

-- zabronic usuwania jobs

CREATE TRIGGER BLOCK_DELETE_ON_JOBS
    ON jobs
    INSTEAD OF DELETE
    AS
    Begin
        declare @job_title varchar(35);
        declare @del_counter int;
        select @del_counter=count(*) from deleted;
        if @del_counter > 1
            begin
                SELECT 'Administrator zablokował możliwość usuwania rekordów z tej Tabeli - próbujesz usunąć wiele rekordów '
            end
        else if @del_counter = 1
            begin
                SELECT @job_title = job_title from deleted
                SELECT 'Administrator zablokował możliwość usuwania rekordów z tej Tabeli - próbujesz skasowac wpis dla '+@job_title
            end
        else
        begin
            SELECT 'Niepoprawna ilosc usuwanych rekordów'
        end
    End

DROP TRIGGER BLOCK_DELETE_ON_JOBS

SELECT * FROM jobs
DELETE FROM jobs where job_id IN (7,8)

CREATE VIEW lista_departmentow AS
SELECT region_name, country_name, city, street_address, state_province, postal_code, department_name
    FROM departments d
JOin locations l on d.location_id = l.location_id
JOIN countries c on c.country_id = l.country_id
JOIN regions r2 on r2.region_id = c.region_id

--DROP View lista_departmentow

SELECT * FROM lista_departmentow WHERE city = 'Seattle'
SELECT * FROM lista_departmentow

INSERT INTO lista_departmentow VALUES('Americas', 'United States of America', 'New York', '10 lane', 'NY', '00000', 'Office')

CREATE TRIGGER Add_department_with_region
    ON lista_departmentow
    INSTEAD OF INSERT
    AS
    BEGIN
        select * INTO temp_inserted_table
        FROM inserted
        SELECT 'Zapamietano wpisy w zewnetrznej tabeli'
    end
SELECT * From temp_inserted_table
DROP TRIGGER Add_department_with_region

CREATE TRIGGER check_update
    on lista_departmentow
    INSTEAD OF UPDATE
    AS
    BEGIN
        IF UPDATE(city) SELECT 'Aktualizacja miasta'
        ELSE IF UPDATE(country_name) SELECT 'Aktualizacja kraju'
        ELSE SELECT 'Aktualizacja innej kolumny'
        SELECT * FROM inserted
    end

DROP TRIGGER check_update
select * FROM lista_departmentow

update lista_departmentow set country_name = 'USA' where department_name = 'Administration'