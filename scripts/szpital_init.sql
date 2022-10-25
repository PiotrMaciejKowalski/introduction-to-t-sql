use master;
create database szpital;
go
use szpital;

--Tworzenie struktury bazy

create table Oddzialy(
id int primary key identity(1,1) not null,
nazwa varchar(30) not null unique,
ordynator int not null,
telefon varchar(9) unique,
wytyczne varchar(200),

constraint nazwaOddzialuZDuzejLitery check (ASCII(LEFT(nazwa, 1)) BETWEEN ASCII('A') and ASCII('Z')),--(nazwa like '[A-Z]%'),
constraint postacNumeruTelefonuOddzialu check (telefon like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

create table Audyty(
id int primary key identity(1,1) not null,
oddzial int foreign key references Oddzialy(id) not null,
audytor varchar(30) not null,
koszt money,
rezultat varchar(200),

constraint audytorImieINazwisko check (audytor like '[A-Z]% [A-Z]%'),
constraint kosztAudytuWiekszyOdZera check (koszt > 0)
);


create table Lekarze(
id int primary key identity(1,1) not null,
imie varchar(20),
nazwisko varchar(30),
przelozony int foreign key references Lekarze(id),
specjalizacja varchar(20) not null,
wynagrodzenie smallmoney,
oddzial int foreign key references Oddzialy(id),

constraint imieLekarzaZDuzejLitery check (ASCII(LEFT(imie, 1)) BETWEEN ASCII('A') and ASCII('Z')),
constraint nazwiskoLekarzaZDuzejLitery check (ASCII(LEFT(nazwisko, 1)) BETWEEN ASCII('A') and ASCII('Z')),
constraint wynagrodzenieWiekszeOdZera check (wynagrodzenie > 0)
);

create table Pacjenci(
id int primary key identity(1,1) not null,
imie varchar(20),
nazwisko varchar(30),
lekarzRodzinny int foreign key references Lekarze(id) not null,
pesel varchar(11) not null unique,
zalecenia varchar(200),
wiek int,

constraint imiePacjentaZDuzejLitery check (ASCII(LEFT(imie, 1)) BETWEEN ASCII('A') and ASCII('Z')),
constraint nazwiskoPacjentaZDuzejLitery check (ASCII(LEFT(nazwisko, 1)) BETWEEN ASCII('A') and ASCII('Z')),
constraint postacPeselu check (pesel like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
constraint wiekWiekszyRownyZero check (wiek >= 0)
);

create table Rejestracje(
id int primary key identity(1,1) not null,
idPacjenta int foreign key references Pacjenci(id) not null,
idOddzialu int foreign key references Oddzialy(id) not null,
opis varchar(200),
dataPoczatkowa date not null,
dataKoncowa date,

constraint dataKoncowaWiekszaOdPoczatkowej check (dataKoncowa > dataPoczatkowa)
);



--Wprowadzanie danych

insert into Oddzialy values
('Oddzial kardiologiczny',1,'111111111','Należy zwiększyć efektywność badań chorób serca.'),
('Oddzial urologiczny',2,'222222222',null),
('Oddzial neurologiczny',3,'333333333','Rejestracja proszona jest o skrócenie czasu oczekiwania na wizytą z 5 lat do 4.'),
('Oddzial ortopedyczny',4,'444444444','Personel powinien pobierać wyższe opłaty za założenie gipsu.'),
('Oddzial ginekologiczny',5,'555555555',null)
;

insert into Lekarze values
('Adam','Nowak',null,'kardiologia',20000.00,1),
('Rafał','Hermaszewski',null,'urologia',15000.00,2),
('Krzysztof','Selmaj',null,'neurologia',50000.00,3),
('Beata','Janos',null,'ortopedia',14000.00,4),
('Adam','Buda',null,'ginekologia',13000.00,5),

('Adam','Sota',1,'kardiologia',10000.00,1),
('Mirosław','Baśta',1,'kardiologia',6000.00,1),
('Andrzej','Buda',2,'urologia',13500.00,2),
('Monika','Ustkowska',2,'urologia',5000.00,2),
('Anna','Siuda',3,'neurologia',12000.00,3),
('Bartłomiej','Ugandowski',3,'neurologia',6000.00,3),
('Michał','Boski',4,'ortopedia',4000.00,4),
('Anna','Sumra',4,'ortopedia',8000.00,4),
('James','Watson',5,'ginekologia',17000.00,5),
('Bill','Gates',5,'ginekologia',0.01,5),
('Stefan','Pagórkowy',5,'ginekologia',3000.00,5)
;

insert into Audyty values
(1,'Marian Kowalski', 20000.00, 'Bez zastrzeżeń.'),
(2,'Anna Fikowska', 7500.22,'Pielęgniarki skarżą się na zbyt małe wynagrodzenie. Pozostałe obszary bez zastrzeżeń.'),
(3,'Ekun Drah', 25300.00, 'The ward is in good condition. Employees are satisfied with their salary.'),
(4,'Stefan Kisełek',995.00,'Na oddziale istnieje wiele nieprawidłowości. Lekarze skarżą się na niskie zarobki, a pacjenci na długie czasy oczekiwania na wizyty. Należy poczynić niezbędne kroki do poprawy sytuacji.'),
(5,'Andrzej Buda', 100000.00, 'Oddział jest w doskonałej kondycji. Jeszcze nigdy nie widziałem lepiej współpracującego zespołu.')
;

insert into Pacjenci values
('Adam', 'Foseł', (select id from Lekarze where nazwisko = 'Sumra'), '99060202977', 'Pacjent powinien regularnie przyjmować tabletki.', 52),
('Anna', 'Duzełka', 1, '11223344555', null, 18),
('Tadeusz', 'Fiziełek', 5, '00886644537', null, 42),
('Maria', 'Okrolewska',12,'85926584658', 'Pacjentka powinna dbać o zdrowie.', 74),
('John', 'Walker', 3, '00000000000', null, 38),
('Anastazja', 'Gylińska', 7, '11223333221', null, 16),
('Alfred', 'Omeszkowski', 12, '02749674883', null, 54),
('Bogusław', 'Dziadowski', 10, '95730573110', null, 22),
('Zuzanna', 'Alewska', 6, '58205285002', null, 28),
('Julia', 'Zobuch', 1, '54750317445', null, 20),
('Bożenka', 'Wacławiak', 15, '28502749554', null, 102)
;

insert into Rejestracje values
(1,4,'Trzecia rejestracja w tym roku.',getdate(),null),
(2,1,null,getdate(),null),
(3,5,'PILNE','2015-01-10','2016-01-01'),
(5,3,null,getdate(),null),
(4,4,'Mało pilne','2017-02-20','2017-02-27'),
(3,2,null,'2013-02-20','2013-12-12'),
(7,4,null,getdate(),null),
(10,1,'Pacjent jest w stanie zagrożenia życia.',getdate(),null),
(8,3,null,'2013-12-12','2013-12-13'),
(4,2,null,'2010-06-03','2010-06-22'),
(6,1,null,'2019-08-10',null)
;

--Klucz obcy dla ordynatora w tabeli oddzialy zostal dodany dopiero po wstepnym wprowadzeniu danych, poniewaz uczyniwszy to wczesniej nie bylibysmy zdolni do dodania oddzialu bez lekarza ani lekarza bez oddzialu.
alter table Oddzialy add constraint ordynatorForeignKey foreign key (ordynator) references Lekarze(id);

--use master
--go
--alter database szpital set single_user with rollback immediate
--go
--drop database szpital
--go