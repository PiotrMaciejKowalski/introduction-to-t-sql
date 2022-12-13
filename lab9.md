# Funkcje T-SQL

W T-SQL funkcje są tworem szczególnym, acz bardzo podobnym do procedur składowanych. Podstawowe różnice pomiędzy 
obydwoma zawierają się w tym, że funkcje są przeznaczone do zwracania określonych wartości: liczby, wartości, 
wyniku kwerendy.

W T-SQL dostępne do tworzenia są 3 rodzaje funkcji

* Funkcje skalarne - których efektem działania jest pojedyncza wartość
* Funkcje Tabelaryczne - w których zwracana wartość jest pewnego typu tabelarycznego (relacyjnego typu)
* Funkcje agregacyjne - wykorzystywane w grupowaniu

Najtrudniejsze są funkcje agregacyjne - gdyż do ich stworzenia konieczne jest zaprogramowanie ich spoza składni T-SQL. 
W efekcie tego nie zostaną omówione.

## Funkcje skalarne

Aby utworzyć funkcję skalarną postępujemy zupełnie analogicznie jak przy procedurze składowanej.

* Wybieramy bazę danych
* Sekcja programability
* Dalej functions
* Dalej scalar valued, i
* New Scalar-valued function

W efekcie utworzony zostanie szablon nowej funkcji postaci

```tsql
-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION <Scalar_Function_Name, sysname, FunctionName> 
(
	-- Add the parameters for the function here
	<@Param1, sysname, @p1> <Data_Type_For_Param1, , int>
)
RETURNS <Function_Data_Type, ,int>
AS
BEGIN
	-- Declare the return variable here
	DECLARE <@ResultVar, sysname, @Result> <Function_Data_Type, ,int>

	-- Add the T-SQL statements to compute the return value here
	SELECT <@ResultVar, sysname, @Result> = <@Param1, sysname, @p1>

	-- Return the result of the function
	RETURN <@ResultVar, sysname, @Result>

END
GO

```

Utwórzmy przykładową funkcję do przetwarzania

```tsql
CREATE FUNCTION Kwadrat 
(
	@liczba int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @wynik int;
	-- Add the T-SQL statements to compute the return value here
	SELECT @wynik=@liczba*@liczba;
	-- Return the result of the function
	RETURN @wynik;
END
```

Wtedy możemy wykorzystać nowo utworzoną funkcję w naszym przetwarzaniu.

```tsql
SELECT dbo.Kwadrat(7)
```

## Funkcje tabelaryczne

Funkcje tableryczne rozróżniane są na jedno i wieloliniowe

### Funkcje tabelaryczne Inline

Aby utworzyć funkcję tabelaryczną inline postępujemy znowu zupełnie analogicznie jak przy procedurze składowanej.

* Wybieramy bazę danych
* Sekcja programmability
* Dalej functions
* Dalej table valued, i
* New inline Table-valued function

W efekcie utworzony zostanie szablon nowej funkcji postaci

```tsql
-- ================================================
-- Template generated from Template Explorer using:
-- Create Inline Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION <Inline_Function_Name, sysname, FunctionName> 
(	
	-- Add the parameters for the function here
	<@param1, sysname, @p1> <Data_Type_For_Param1, , int>, 
	<@param2, sysname, @p2> <Data_Type_For_Param2, , char>
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT 0
)
GO

```

I tak

```tsql
CREATE FUNCTION NazwyAutorow()
RETURNS TABLE
AS
RETURN SELECT DISTINCT(imie+' '+nazwisko) as Nazwa FROM Autorzy;
```

I wtedy 

```tsql
SELECT * FROM NazwyAutorow();
```


### Funkcje tabelaryczne multi-line

Aby utworzyć funkcję tabelaryczną multi-line postępujemy znowu zupełnie analogicznie jak przy procedurze składowanej.

* Wybieramy bazę danych
* Sekcja programmability
* Dalej functions
* Dalej table valued, i
* New multi-statement Table-valued function

W efekcie utworzony zostanie szablon nowej funkcji postaci

```tsql
-- ================================================
-- Template generated from Template Explorer using:
-- Create Multi-Statement Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION <Table_Function_Name, sysname, FunctionName> 
(
	-- Add the parameters for the function here
	<@param1, sysname, @p1> <data_type_for_param1, , int>, 
	<@param2, sysname, @p2> <data_type_for_param2, , char>
)
RETURNS 
<@Table_Variable_Name, sysname, @Table_Var> TABLE 
(
	-- Add the column definitions for the TABLE variable here
	<Column_1, sysname, c1> <Data_Type_For_Column1, , int>, 
	<Column_2, sysname, c2> <Data_Type_For_Column2, , int>
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	
	RETURN 
END
GO
```

Zatem funkcje w tej postaci mają dodatkowe możliwości gdyż

* Mogą składać się z wielu komend,
* Deklarują dokładnie strukturę zwracanej tabeli
* Odróżniają się od inline - blokiem BEGIN-END

```tsql
CREATE FUNCTION BiezaceWypozyczeniaAutora
(
	-- Add the parameters for the function here
	@nazwisko nvarchar(30),
	@imie nvarchar(15)
)
RETURNS
@TempTab TABLE
(
    login nvarchar(10),
    tytul nvarchar(255),
    data_wypozyczenia date
)
AS
BEGIN
    DECLARE @id_autor int;
    select @id_autor=id_autor from Autorzy where imie=@imie and nazwisko=@nazwisko
	-- Fill the table variable with the rows for your result set

	-- zainicjowanie wartości zwracanej
	INSERT @TempTab
	SELECT login, tytul, data_wypozyczenia
	FROM Ksiazki k
	join Wypozyczenia W on k.id_ksiazka = W.id_ksiazka
	join Czytelnicy Cz on W.id_czytelnik = Cz.id_czytelnik
	WHERE k.id_autor = @id_autor and data_oddania is NULL
	RETURN
END
```

A wtedy

```tsql
select * from BiezaceWypozyczeniaAutora('GRZSNOKARCKI', 'Ada ')
```

# Zadania

## Zadanie 1

Przygotować funkcję, która dla id_autora, id_kategorii oraz tytułu tworzy łączny napis:
"Kategoria - Autor: tytuł". Uwaga funkcja musi dokonać podmiany id_autora i id_kategorii na właściwe napisy.

## Zadanie 2

Przygotować funkcję która zwraca top 3 najczęściej wypożyczanych autorów w podanym roku.