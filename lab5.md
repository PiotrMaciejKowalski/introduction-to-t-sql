# Wybrane elementy języka Data Definition Language (DDL) w SQL

Nasze zainteresowania aż do tego momentu skupiały sie głównie wokół pracy z danymi. Ich wyszukiwaniu czy modyfikowaniu. Tak to prawda, mieliśmy również zadanie dotyczące utworzenie nowego zbioru dla danych - i wykonaliśmy je szybko i sukcesem z wykorzystaniem schematu bazy danych i narzędziu do tworzenia takich diagramów. Teraz chcielibyśmy dowiedzieć się czegoś więcej na temat wszystkich tych rzeczy, które trochę niejawnie działy się pod spodem narzędzia do diagramów. W tej lekcji zaprezentowany będzie jedynie zarys, temat jest bowiem bardzo obszerny - a zastosowania dość ograniczone. Najczęściej skłonni bedziemy sięgnąć po tę część języka SQL, kiedy trzeba zmodyfikować w niewielki sposób istniejące zbiory danych lub zrozumieć i poprawić skrypty inicjalizujące stan bazy danych.

## Podstawowa składnia DDL

W przypadku DML język SQL wyszczególnił 3 główne komendy do pracy.

* INSERT
* UPDATE
* DELETE

Każda z nich odpowiada za tworzenie, zmianę i usuwanie danych. W sumie to dokładnie takich samych funkcjonalności wymagalibyśmy od narzędzia do tworzenia danych. Jednak użycie tych samych słów kluczowych mogłoby się okazać zgubne. W przypadku pracy na strukturach danych, nieopatrzny błąd znacząco wpływa na kształ danych. Jeśli składnie byłyby podobne - ewentualna literówka mogłaby spowodować usunięcie znacznej ilość zasobów danych. Stąd do pracy ze strukturami bazy danych. Odpowiednikami w DDL dla Insert, Update i Delete są

* CREATE - do tworzenia nowych struktur
* ALTER - do ich modyfikowania
* DROP - doich usuwania

Ano tak ... pewnie każdy już słyszał dowcip o praktykancie który na bazie produkcyjnej wywołał instrukcję

```{}
DROP DATABASE Produkcja;
```

To właśnie odpowiadałoby komendzie kasującej wszystkie zasoby bazy danych. Komendę tą wykorzystują również osoby chcące dokonać nieuprawnione wstrzyknięcia złośliwego kodu do źle zabezpieczonych aplikacji i baz danych.

![Przykład SQL-Injection](http://1.bp.blogspot.com/-URBVGKEBRss/U0GgQetIwEI/AAAAAAAAC20/b0DEdUTSCwo/s1600/i.img.jpe)

# Dokumentacja komend DDL

Informacji o szczegółach poszczególnych komend DDL można odszukać w dokumentacji T-SQL np. w linkach poniżej

[CREATE Statement](https://technet.microsoft.com/en-us/library/cc879262(v=sql.110).aspx)
[ALTER Statement](https://technet.microsoft.com/en-us/library/cc879314(v=sql.110).aspx)
[DROP Statement](https://technet.microsoft.com/en-us/library/cc879259(v=sql.110).aspx)

My skupimy się tylko na (na razie) jednym wybranym przykładzie

# Table

## CREATE TABLE

```sql
CREATE TABLE 
    [ database_name . [ schema_name ] . | schema_name . ] table_name 
    [ AS FileTable ]
    ( { <column_definition> | <computed_column_definition> 
        | <column_set_definition> | [ <table_constraint> ] [ ,...n ] } )
    [ ON { partition_scheme_name ( partition_column_name ) | filegroup 
        | "default" } ] 
    [ { TEXTIMAGE_ON { filegroup | "default" } ] 
    [ FILESTREAM_ON { partition_scheme_name | filegroup 
        | "default" } ]
    [ WITH ( <table_option> [ ,...n ] ) ]
[ ; ]

<column_definition> ::= 
column_name <data_type>
    [ FILESTREAM ]
    [ COLLATE collation_name ] 
    [ SPARSE ]
    [ NULL | NOT NULL ]
    [ 
        [ CONSTRAINT constraint_name ] DEFAULT constant_expression ] 
      | [ IDENTITY [ ( seed ,increment ) ] [ NOT FOR REPLICATION ] 
    ]
    [ ROWGUIDCOL ] 
    [ <column_constraint> [ ...n ] ] 

<data type> ::= 
[ type_schema_name . ] type_name 
    [ ( precision [ , scale ] | max | 
        [ { CONTENT | DOCUMENT } ] xml_schema_collection ) ] 

<column_constraint> ::= 
[ CONSTRAINT constraint_name ] 
{     { PRIMARY KEY | UNIQUE } 
        [ CLUSTERED | NONCLUSTERED ] 
        [ 
            WITH FILLFACTOR = fillfactor  
          | WITH ( < index_option > [ , ...n ] ) 
        ] 
        [ ON { partition_scheme_name ( partition_column_name ) 
            | filegroup | "default" } ]

  | [ FOREIGN KEY ] 
        REFERENCES [ schema_name . ] referenced_table_name [ ( ref_column ) ] 
        [ ON DELETE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ] 
        [ ON UPDATE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ] 
        [ NOT FOR REPLICATION ] 

  | CHECK [ NOT FOR REPLICATION ] ( logical_expression ) 
} 

<computed_column_definition> ::= 
column_name AS computed_column_expression 
[ PERSISTED [ NOT NULL ] ]
[ 
    [ CONSTRAINT constraint_name ]
    { PRIMARY KEY | UNIQUE }
        [ CLUSTERED | NONCLUSTERED ]
        [ 
            WITH FILLFACTOR = fillfactor 
          | WITH ( <index_option> [ , ...n ] )
        ]
        [ ON { partition_scheme_name ( partition_column_name ) 
        | filegroup | "default" } ]

    | [ FOREIGN KEY ] 
        REFERENCES referenced_table_name [ ( ref_column ) ] 
        [ ON DELETE { NO ACTION | CASCADE } ] 
        [ ON UPDATE { NO ACTION } ] 
        [ NOT FOR REPLICATION ] 

    | CHECK [ NOT FOR REPLICATION ] ( logical_expression ) 
] 

<column_set_definition> ::= 
column_set_name XML COLUMN_SET FOR ALL_SPARSE_COLUMNS

< table_constraint > ::=
[ CONSTRAINT constraint_name ] 
{ 
    { PRIMARY KEY | UNIQUE } 
        [ CLUSTERED | NONCLUSTERED ] 
        (column [ ASC | DESC ] [ ,...n ] ) 
        [ 
            WITH FILLFACTOR = fillfactor 
           |WITH ( <index_option> [ , ...n ] ) 
        ]
        [ ON { partition_scheme_name (partition_column_name)
            | filegroup | "default" } ] 
    | FOREIGN KEY 
        ( column [ ,...n ] ) 
        REFERENCES referenced_table_name [ ( ref_column [ ,...n ] ) ] 
        [ ON DELETE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ] 
        [ ON UPDATE { NO ACTION | CASCADE | SET NULL | SET DEFAULT } ] 
        [ NOT FOR REPLICATION ] 
    | CHECK [ NOT FOR REPLICATION ] ( logical_expression ) 
} 
<table_option> ::=
{
    [DATA_COMPRESSION = { NONE | ROW | PAGE }
      [ ON PARTITIONS ( { <partition_number_expression> | <range> } 
      [ , ...n ] ) ]]
    [ FILETABLE_DIRECTORY = <directory_name> ] 
    [ FILETABLE_COLLATE_FILENAME = { <collation_name> | database_default } ]
    [ FILETABLE_PRIMARY_KEY_CONSTRAINT_NAME = <constraint_name> ]
    [ FILETABLE_STREAMID_UNIQUE_CONSTRAINT_NAME = <constraint_name> ]
    [ FILETABLE_FULLPATH_UNIQUE_CONSTRAINT_NAME = <constraint_name> ]
}

<index_option> ::=
{ 
    PAD_INDEX = { ON | OFF } 
  | FILLFACTOR = fillfactor 
  | IGNORE_DUP_KEY = { ON | OFF } 
  | STATISTICS_NORECOMPUTE = { ON | OFF } 
  | ALLOW_ROW_LOCKS = { ON | OFF} 
  | ALLOW_PAGE_LOCKS ={ ON | OFF} 
  | DATA_COMPRESSION = { NONE | ROW | PAGE }
       [ ON PARTITIONS ( { <partition_number_expression> | <range> } 
       [ , ...n ] ) ]
}
<range> ::= 
<partition_number_expression> TO <partition_number_expression>
```

Tak zaprezentowana składnia pozwala nam co prawda dostrzec ogrom różnych możliwych w T-SQL opcji do 
uruchomienia, jednak zaciera nam ideę działania tej komendy. Przyjrzyjmy się prostszemu formatowi.

```sql
CREATE TABLE [dbo].[dostawcy](
	[id_dost] [int] NOT NULL,
	[nazwa_dost] [char](50) NOT NULL,
	[adres_dost] [char](50) NULL,
	[miasto_dost] [char](50) NULL,
	[woj_dost] [char](5) NULL,
	[kod_dost] [char](10) NULL,
	[kraj_dost] [char](50) NULL,
 CONSTRAINT [pk_dostawcy] PRIMARY KEY CLUSTERED 
(
	[id_dost] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
```

Widzimy iż dominują tutaj sposoby na definiowanie poszczególnych składowych
np. 

```sql
[nazwa_dost] [char](50) NOT NULL
```

służy do zdefiniowania odpowiedniej kolumny. Poza tym wyróżnia się jeszcze jedna linijka tej komendy

```sql
CONSTRAINT [pk_dostawcy] PRIMARY KEY CLUSTERED 
(
	[id_dost] ASC
) ...
```

Powyższa linijka definiuje więza integralności związane z kluczem. Utworzona nazwa więzów integralności to pk_dostawcy. Choć być może lubicie swojego prowadzącego - uczulam, że pk w tym wypadku to skrót od Primary Key czyli klucza głównego.

## ALTER TABLE

Z reguły najcześciej wykorzystywaną komendą z DDL w odniesieniu do tablic jest polecenie jej modyfikacji.
Najczęściej wykorzystywane jest ponieważ

* Trzeba np. powiększyć zapas pamięci dla danego pola (jakieś dane się nie mieszczą),
* Zdefiniować dodatkowe więzy integralności,
* Dodać nową kolumnę,
* Włączyć klucz obcy,

Przykładowe formaty użycia

```sql
SELECT * FROM Produkty;
```

| id\_prod | id\_dost | nazwa\_prod | cena\_prod | opis\_prod |
| :--- | :--- | :--- | :--- | :--- |
| ANV01      | 1001 | Kowadlo .5 t                                                                                                                                                                                                                                                    | 5.99 | Kowadlo .5 t, czarne, w komplecie z uchwytem |
| ANV02      | 1001 | Kowadlo 1 t                                                                                                                                                                                                                                                     | 9.99 | Kowadlo 1 t, czarne, w komplecie z uchwytem i futeralem |
| ANV03      | 1001 | Kowadlo 2 t                                                                                                                                                                                                                                                     | 14.99 | Kowadlo 2 t, czarne, w komplecie z uchwytem i futeralem |
| DTNTR      | 1003 | Detonator                                                                                                                                                                                                                                                       | 13.00 | Detonator \(zasilany tlokiem\), Lonty nie sa dolaczone |
| FB         | 1003 | Karma dla ptaków                                                                                                                                                                                                                                                | 10.00 | Duza torba \(odpowiednia dla strusi\) |
| FC         | 1003 | Marchewki                                                                                                                                                                                                                                                       | 2.50 | Marchewki \(tylko w sezonie polowan na króliki\) |
| FU1        | 1002 | Lonty                                                                                                                                                                                                                                                           | 3.42 | tuzin, bardzo dlugie |
| JP1000     | 1005 | JetPack 1000                                                                                                                                                                                                                                                    | 35.00 | JetPack 1000, przeznaczony do jednorazowego uzytku |
| JP2000     | 1005 | JetPack 2000                                                                                                                                                                                                                                                    | 55.00 | JetPack 2000, do wielokrotnego uzytku |
| OL1        | 1002 | Puszka oleju                                                                                                                                                                                                                                                    | 8.99 | Puszka oleju, czerwona |
| SAFE       | 1003 | Sejf                                                                                                                                                                                                                                                            | 50.00 | Sejf z zamkiem szyfrowym |
| SLING      | 1003 | Proca                                                                                                                                                                                                                                                           | 4.49 | Proca, rozmiar uniwersalny |
| TNT1       | 1003 | Dynamit \(1 laska\)                                                                                                                                                                                                                                               | 2.50 | Dynamit, czerowy, jedna laska |
| TNT2       | 1003 | Dynamit \(5 lasek\)                                                                                                                                                                                                                                               | 10.00 | Dynamit, czerwony, komplet 10 lasek |



Dodajmy nową kolumnę

```sql
ALTER TABLE Produkty ADD NowaKolumna varchar(5);
```

```sql
SELECT * FROM Produkty;
```

| id\_prod | id\_dost | nazwa\_prod | cena\_prod | opis\_prod | NowaKolumna |
| :--- | :--- | :--- | :--- | :--- | :--- |
| ANV01      | 1001 | Kowadlo .5 t                                                                                                                                                                                                                                                    | 5.99 | Kowadlo .5 t, czarne, w komplecie z uchwytem | null |
| ANV02      | 1001 | Kowadlo 1 t                                                                                                                                                                                                                                                     | 9.99 | Kowadlo 1 t, czarne, w komplecie z uchwytem i futeralem | null |
| ANV03      | 1001 | Kowadlo 2 t                                                                                                                                                                                                                                                     | 14.99 | Kowadlo 2 t, czarne, w komplecie z uchwytem i futeralem | null |
| DTNTR      | 1003 | Detonator                                                                                                                                                                                                                                                       | 13.00 | Detonator \(zasilany tlokiem\), Lonty nie sa dolaczone | null |
| FB         | 1003 | Karma dla ptaków                                                                                                                                                                                                                                                | 10.00 | Duza torba \(odpowiednia dla strusi\) | null |
| FC         | 1003 | Marchewki                                                                                                                                                                                                                                                       | 2.50 | Marchewki \(tylko w sezonie polowan na króliki\) | null |
| FU1        | 1002 | Lonty                                                                                                                                                                                                                                                           | 3.42 | tuzin, bardzo dlugie | null |
| JP1000     | 1005 | JetPack 1000                                                                                                                                                                                                                                                    | 35.00 | JetPack 1000, przeznaczony do jednorazowego uzytku | null |
| JP2000     | 1005 | JetPack 2000                                                                                                                                                                                                                                                    | 55.00 | JetPack 2000, do wielokrotnego uzytku | null |
| OL1        | 1002 | Puszka oleju                                                                                                                                                                                                                                                    | 8.99 | Puszka oleju, czerwona | null |
| SAFE       | 1003 | Sejf                                                                                                                                                                                                                                                            | 50.00 | Sejf z zamkiem szyfrowym | null |
| SLING      | 1003 | Proca                                                                                                                                                                                                                                                           | 4.49 | Proca, rozmiar uniwersalny | null |
| TNT1       | 1003 | Dynamit \(1 laska\)                                                                                                                                                                                                                                               | 2.50 | Dynamit, czerowy, jedna laska | null |
| TNT2       | 1003 | Dynamit \(5 lasek\)                                                                                                                                                                                                                                               | 10.00 | Dynamit, czerwony, komplet 10 lasek | null |

Zupełnie analogicznie kolumnę można usunąć 

```sql
ALTER TABLE Produkty DROP COLUMN NowaKolumna;
```

```sql
SELECT * FROM Produkty;
```

| id\_prod | id\_dost | nazwa\_prod | cena\_prod | opis\_prod |
| :--- | :--- | :--- | :--- | :--- |
| ANV01      | 1001 | Kowadlo .5 t                                                                                                                                                                                                                                                    | 5.99 | Kowadlo .5 t, czarne, w komplecie z uchwytem |
| ANV02      | 1001 | Kowadlo 1 t                                                                                                                                                                                                                                                     | 9.99 | Kowadlo 1 t, czarne, w komplecie z uchwytem i futeralem |
| ANV03      | 1001 | Kowadlo 2 t                                                                                                                                                                                                                                                     | 14.99 | Kowadlo 2 t, czarne, w komplecie z uchwytem i futeralem |
| DTNTR      | 1003 | Detonator                                                                                                                                                                                                                                                       | 13.00 | Detonator \(zasilany tlokiem\), Lonty nie sa dolaczone |
| FB         | 1003 | Karma dla ptaków                                                                                                                                                                                                                                                | 10.00 | Duza torba \(odpowiednia dla strusi\) |
| FC         | 1003 | Marchewki                                                                                                                                                                                                                                                       | 2.50 | Marchewki \(tylko w sezonie polowan na króliki\) |
| FU1        | 1002 | Lonty                                                                                                                                                                                                                                                           | 3.42 | tuzin, bardzo dlugie |
| JP1000     | 1005 | JetPack 1000                                                                                                                                                                                                                                                    | 35.00 | JetPack 1000, przeznaczony do jednorazowego uzytku |
| JP2000     | 1005 | JetPack 2000                                                                                                                                                                                                                                                    | 55.00 | JetPack 2000, do wielokrotnego uzytku |
| OL1        | 1002 | Puszka oleju                                                                                                                                                                                                                                                    | 8.99 | Puszka oleju, czerwona |
| SAFE       | 1003 | Sejf                                                                                                                                                                                                                                                            | 50.00 | Sejf z zamkiem szyfrowym |
| SLING      | 1003 | Proca                                                                                                                                                                                                                                                           | 4.49 | Proca, rozmiar uniwersalny |
| TNT1       | 1003 | Dynamit \(1 laska\)                                                                                                                                                                                                                                               | 2.50 | Dynamit, czerowy, jedna laska |
| TNT2       | 1003 | Dynamit \(5 lasek\)                                                                                                                                                                                                                                               | 10.00 | Dynamit, czerwony, komplet 10 lasek |


Można również wykonać modyfikacje typu naszej bazy danych. Wykonajmy kopię danych aby nie spowodować utraty danych.
```sql
SELECT * INTO KopiaProdukty FROM Produkty;
```

```sql
ALTER TABLE KopiaProdukty ALTER COLUMN nazwa_prod char(100)
```

```sql
SELECT * FROM KopiaProdukty;
```

| id\_prod | id\_dost | nazwa\_prod | cena\_prod | opis\_prod |
| :--- | :--- | :--- | :--- | :--- |
| ANV01      | 1001 | Kowadlo .5 t                                                                                         | 5.99 | Kowadlo .5 t, czarne, w komplecie z uchwytem |
| ANV02      | 1001 | Kowadlo 1 t                                                                                          | 9.99 | Kowadlo 1 t, czarne, w komplecie z uchwytem i futeralem |
| ANV03      | 1001 | Kowadlo 2 t                                                                                          | 14.99 | Kowadlo 2 t, czarne, w komplecie z uchwytem i futeralem |
| DTNTR      | 1003 | Detonator                                                                                            | 13.00 | Detonator \(zasilany tlokiem\), Lonty nie sa dolaczone |
| FB         | 1003 | Karma dla ptaków                                                                                     | 10.00 | Duza torba \(odpowiednia dla strusi\) |
| FC         | 1003 | Marchewki                                                                                            | 2.50 | Marchewki \(tylko w sezonie polowan na króliki\) |
| FU1        | 1002 | Lonty                                                                                                | 3.42 | tuzin, bardzo dlugie |
| JP1000     | 1005 | JetPack 1000                                                                                         | 35.00 | JetPack 1000, przeznaczony do jednorazowego uzytku |
| JP2000     | 1005 | JetPack 2000                                                                                         | 55.00 | JetPack 2000, do wielokrotnego uzytku |
| OL1        | 1002 | Puszka oleju                                                                                         | 8.99 | Puszka oleju, czerwona |
| SAFE       | 1003 | Sejf                                                                                                 | 50.00 | Sejf z zamkiem szyfrowym |
| SLING      | 1003 | Proca                                                                                                | 4.49 | Proca, rozmiar uniwersalny |
| TNT1       | 1003 | Dynamit \(1 laska\)                                                                                    | 2.50 | Dynamit, czerowy, jedna laska |
| TNT2       | 1003 | Dynamit \(5 lasek\)                                                                                    | 10.00 | Dynamit, czerwony, komplet 10 lasek |


Baza danych zrobi co tylko potrafi aby zachować nasze dane, w pewnym jednak momencie będzie zmuszona się poddać

```sql
ALTER TABLE KopiaProdukty ALTER COLUMN opis_prod varchar(100)
```

Spowoduje błąd, gdyż dane mogą być przycięte.

```sql
SELECT * FROM KopiaProdukty;
```

| id\_prod | id\_dost | nazwa\_prod | cena\_prod | opis\_prod |
| :--- | :--- | :--- | :--- | :--- |
| ANV01      | 1001 | Kowadlo .5 t                                                                                         | 5.99 | Kowadlo .5 t, czarne, w komplecie z uchwytem |
| ANV02      | 1001 | Kowadlo 1 t                                                                                          | 9.99 | Kowadlo 1 t, czarne, w komplecie z uchwytem i futeralem |
| ANV03      | 1001 | Kowadlo 2 t                                                                                          | 14.99 | Kowadlo 2 t, czarne, w komplecie z uchwytem i futeralem |
| DTNTR      | 1003 | Detonator                                                                                            | 13.00 | Detonator \(zasilany tlokiem\), Lonty nie sa dolaczone |
| FB         | 1003 | Karma dla ptaków                                                                                     | 10.00 | Duza torba \(odpowiednia dla strusi\) |
| FC         | 1003 | Marchewki                                                                                            | 2.50 | Marchewki \(tylko w sezonie polowan na króliki\) |
| FU1        | 1002 | Lonty                                                                                                | 3.42 | tuzin, bardzo dlugie |
| JP1000     | 1005 | JetPack 1000                                                                                         | 35.00 | JetPack 1000, przeznaczony do jednorazowego uzytku |
| JP2000     | 1005 | JetPack 2000                                                                                         | 55.00 | JetPack 2000, do wielokrotnego uzytku |
| OL1        | 1002 | Puszka oleju                                                                                         | 8.99 | Puszka oleju, czerwona |
| SAFE       | 1003 | Sejf                                                                                                 | 50.00 | Sejf z zamkiem szyfrowym |
| SLING      | 1003 | Proca                                                                                                | 4.49 | Proca, rozmiar uniwersalny |
| TNT1       | 1003 | Dynamit \(1 laska\)                                                                                    | 2.50 | Dynamit, czerowy, jedna laska |
| TNT2       | 1003 | Dynamit \(5 lasek\)                                                                                    | 10.00 | Dynamit, czerwony, komplet 10 lasek |


## Drop TABLE

Na koniec usuńmy naszę kopię, pokazując, że DROP jest nam również znany.

```sql
DROP TABLE KopiaProdukty;
```

# Czym są i czemu służą widoki

w procesie projektowanie bazy dany wyszczególniane są często encje na bardzo ogólnym 
poziomie. Zadania postawione przed bazą danych wymagają aby dane były w odpowiedniej
dekompozycji - celem optymalizacji i bezpieczeństwa ich przetwarzania. Do celów etapu
projektowania nie jest jednak zaliczana prostota pracy z taką bazą danych. Do 
uzyskania istotnych dla nas informacji, trzeba dokonywać kaskad lub złączeń wielu
zbiorów danych. Działanie w ten sposób jest zarówno trudne, co i mało wydajne. 
Rozwiązaniem tego problemu są widoki. Widoki często też nazywa się wirtualnymi
tabelami. Wirtualnymi gdyż dane przez nie grupowane, nie są fizycznie gromadzone
w ramach pojedynczej struktury w pamięci komputera. 

# Tworzenie widoków

Składnia języka SQL pozwalająca nam na utworzenie widoku przedstawia się nastepująco

```sql
CREATE VIEW NazwaWidoku AS SELECT ... ;
```

Widok pozwala nam zatem utworzyć szybki dostęp do najczęściej stosowanych kwerend
Rozpocznijmy od utworzenie pewnej pożytecznej kwerendy. Np. połączmy w bazie klienci produkty z ich dostawcami

```sql
SELECT p.id_prod AS Id, d.nazwa_dost AS Dostawca, p.nazwa_prod AS Produkt, p.cena_prod AS Cena, p.opis_prod AS Opis FROM Produkty p Left Join Dostawcy d ON p.id_dost=d.id_dost;
```

| Id | Dostawca | Produkt | Cena | Opis |
| :--- | :--- | :--- | :--- | :--- |
| ANV01      | Anvils R Us                                        | Kowadlo .5 t                                                                                                                                                                                                                                                    | 5.99 | Kowadlo .5 t, czarne, w komplecie z uchwytem |
| ANV02      | Anvils R Us                                        | Kowadlo 1 t                                                                                                                                                                                                                                                     | 9.99 | Kowadlo 1 t, czarne, w komplecie z uchwytem i futeralem |
| ANV03      | Anvils R Us                                        | Kowadlo 2 t                                                                                                                                                                                                                                                     | 14.99 | Kowadlo 2 t, czarne, w komplecie z uchwytem i futeralem |
| DTNTR      | ACME                                               | Detonator                                                                                                                                                                                                                                                       | 13.00 | Detonator \(zasilany tlokiem\), Lonty nie sa dolaczone |
| FB         | ACME                                               | Karma dla ptaków                                                                                                                                                                                                                                                | 10.00 | Duza torba \(odpowiednia dla strusi\) |
| FC         | ACME                                               | Marchewki                                                                                                                                                                                                                                                       | 2.50 | Marchewki \(tylko w sezonie polowan na króliki\) |
| FU1        | LT Supplies                                        | Lonty                                                                                                                                                                                                                                                           | 3.42 | tuzin, bardzo dlugie |
| JP1000     | Jet Set                                            | JetPack 1000                                                                                                                                                                                                                                                    | 35.00 | JetPack 1000, przeznaczony do jednorazowego uzytku |
| JP2000     | Jet Set                                            | JetPack 2000                                                                                                                                                                                                                                                    | 55.00 | JetPack 2000, do wielokrotnego uzytku |
| OL1        | LT Supplies                                        | Puszka oleju                                                                                                                                                                                                                                                    | 8.99 | Puszka oleju, czerwona |
| SAFE       | ACME                                               | Sejf                                                                                                                                                                                                                                                            | 50.00 | Sejf z zamkiem szyfrowym |
| SLING      | ACME                                               | Proca                                                                                                                                                                                                                                                           | 4.49 | Proca, rozmiar uniwersalny |
| TNT1       | ACME                                               | Dynamit \(1 laska\)                                                                                                                                                                                                                                               | 2.50 | Dynamit, czerowy, jedna laska |
| TNT2       | ACME                                               | Dynamit \(5 lasek\)                                                                                                                                                                                                                                               | 10.00 | Dynamit, czerwony, komplet 10 lasek |


Kwerendę tę oczywiście można dowolnie rozbudować o restrykcje, grupowania czy podsumowania. My natomiast po prostu utwórzmy na jej podstawie widok

```sql
CREATE VIEW MojeProdukty AS SELECT p.id_prod AS Id, d.nazwa_dost AS Dostawca, p.nazwa_prod AS Produkt, p.cena_prod AS Cena, p.opis_prod AS Opis FROM Produkty p Left Join Dostawcy d ON p.id_dost=d.id_dost;
```

W efekcie czego możemy wykonywać

```sql
SELECT * FROM MojeProdukty;
```

| Id | Dostawca | Produkt | Cena | Opis |
| :--- | :--- | :--- | :--- | :--- |
| ANV01      | Anvils R Us                                        | Kowadlo .5 t                                                                                                                                                                                                                                                    | 5.99 | Kowadlo .5 t, czarne, w komplecie z uchwytem |
| ANV02      | Anvils R Us                                        | Kowadlo 1 t                                                                                                                                                                                                                                                     | 9.99 | Kowadlo 1 t, czarne, w komplecie z uchwytem i futeralem |
| ANV03      | Anvils R Us                                        | Kowadlo 2 t                                                                                                                                                                                                                                                     | 14.99 | Kowadlo 2 t, czarne, w komplecie z uchwytem i futeralem |
| DTNTR      | ACME                                               | Detonator                                                                                                                                                                                                                                                       | 13.00 | Detonator \(zasilany tlokiem\), Lonty nie sa dolaczone |
| FB         | ACME                                               | Karma dla ptaków                                                                                                                                                                                                                                                | 10.00 | Duza torba \(odpowiednia dla strusi\) |
| FC         | ACME                                               | Marchewki                                                                                                                                                                                                                                                       | 2.50 | Marchewki \(tylko w sezonie polowan na króliki\) |
| FU1        | LT Supplies                                        | Lonty                                                                                                                                                                                                                                                           | 3.42 | tuzin, bardzo dlugie |
| JP1000     | Jet Set                                            | JetPack 1000                                                                                                                                                                                                                                                    | 35.00 | JetPack 1000, przeznaczony do jednorazowego uzytku |
| JP2000     | Jet Set                                            | JetPack 2000                                                                                                                                                                                                                                                    | 55.00 | JetPack 2000, do wielokrotnego uzytku |
| OL1        | LT Supplies                                        | Puszka oleju                                                                                                                                                                                                                                                    | 8.99 | Puszka oleju, czerwona |
| SAFE       | ACME                                               | Sejf                                                                                                                                                                                                                                                            | 50.00 | Sejf z zamkiem szyfrowym |
| SLING      | ACME                                               | Proca                                                                                                                                                                                                                                                           | 4.49 | Proca, rozmiar uniwersalny |
| TNT1       | ACME                                               | Dynamit \(1 laska\)                                                                                                                                                                                                                                               | 2.50 | Dynamit, czerowy, jedna laska |
| TNT2       | ACME                                               | Dynamit \(5 lasek\)                                                                                                                                                                                                                                               | 10.00 | Dynamit, czerwony, komplet 10 lasek |


Nie ma również problemu aby wykonywać

```sql
SELECT * FROM MojeProdukty WHERE Cena > 10;
```

| Id | Dostawca | Produkt | Cena | Opis |
| :--- | :--- | :--- | :--- | :--- |
| ANV03      | Anvils R Us                                        | Kowadlo 2 t                                                                                                                                                                                                                                                     | 14.99 | Kowadlo 2 t, czarne, w komplecie z uchwytem i futeralem |
| DTNTR      | ACME                                               | Detonator                                                                                                                                                                                                                                                       | 13.00 | Detonator \(zasilany tlokiem\), Lonty nie sa dolaczone |
| JP1000     | Jet Set                                            | JetPack 1000                                                                                                                                                                                                                                                    | 35.00 | JetPack 1000, przeznaczony do jednorazowego uzytku |
| JP2000     | Jet Set                                            | JetPack 2000                                                                                                                                                                                                                                                    | 55.00 | JetPack 2000, do wielokrotnego uzytku |
| SAFE       | ACME                                               | Sejf                                                                                                                                                                                                                                                            | 50.00 | Sejf z zamkiem szyfrowym |


# Modyfikowanie widoków

Aby zmodyfikować widok wykonujemy na nim polecenie alter podając nowy schemat wyznaczania jego postaci

```sql
ALTER VIEW MojeProdukty AS SELECT p.id_prod AS Id, d.nazwa_dost AS Dostawca, p.nazwa_prod AS Produkt, p.cena_prod AS Cena, p.opis_prod AS Opis FROM Produkty p Left Join Dostawcy d ON p.id_dost=d.id_dost WHERE p.cena_prod > 10;
```


W efekcie czego

```sql
SELECT * FROM MojeProdukty;
```

| Id | Dostawca | Produkt | Cena | Opis |
| :--- | :--- | :--- | :--- | :--- |
| ANV03      | Anvils R Us                                        | Kowadlo 2 t                                                                                                                                                                                                                                                     | 14.99 | Kowadlo 2 t, czarne, w komplecie z uchwytem i futeralem |
| DTNTR      | ACME                                               | Detonator                                                                                                                                                                                                                                                       | 13.00 | Detonator \(zasilany tlokiem\), Lonty nie sa dolaczone |
| JP1000     | Jet Set                                            | JetPack 1000                                                                                                                                                                                                                                                    | 35.00 | JetPack 1000, przeznaczony do jednorazowego uzytku |
| JP2000     | Jet Set                                            | JetPack 2000                                                                                                                                                                                                                                                    | 55.00 | JetPack 2000, do wielokrotnego uzytku |
| SAFE       | ACME                                               | Sejf                                                                                                                                                                                                                                                            | 50.00 | Sejf z zamkiem szyfrowym |


# Kasowanie widoków 

Aby skasować widok, przesyłamy do bazy danych komendę

```sql
DROP VIEW MojeProdukty;
```

