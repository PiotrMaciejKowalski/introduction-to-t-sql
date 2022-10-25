---
title: "Lab 4"
author: "Piotr Kowalski"
date: "`r format(Sys.time(), '%d %B %Y')`"
output: 
  html_document:
     toc: true
---

# Operacje w składni DML

Po poznaniu operacji `SELECT` stanowiącej podzbiów języka SQL - wyróżniany nazwą DQL - Data Query Language, 
przyszła pora na zaznajomienie się z drugą grupą operacji DML - Data Modification Language. Jest to podzbiór
operacji języka SQL służący do modyfikowania danych. A, że tych podstawowych rodzajów zmian są 3: 
* wstawianie nowych danych,
* modyfikowanie tych wstawionych, oraz
* usuwanie tych istniejących,

to nasze zadanie będzie skupiać się wokół 3 operacji SQL: `INSERT`, `UPDATE` oraz `DELETE`. Zanim jednak poznamy
składnię tych operacji to mając na uwadze, że będziemy przekazywać do bazy danych wartości (VALUE) warto poznać
ich ograniczenia, czyli typ danych (DATA TYPE). Tych w bazie danych jest mnóstwo, ale część z nich trzeba znać 
na wyrywki aby nie wprowadzić niepoprawnych danych do bazy (lub otrzymać błędu).

# Typy danych

Modelowanie zjawisk z wykorzystaniem baz danych posiada swoje pewne ograniczenia na płaszczyźnie typowo fizycznej. Na pewnym poziomie bowiem wszystkie dane muszą zostać zapisane w pamięci komputera. Te pojedyncze wartości stanowią atomy modelu cyfrowego bazy danych i koniec końców każdy model po dogłębnej analizie musi zakończyć swoją dekompozycję na jednym z kilkudziesięciu reprezentacji uznanych we współczesnej informatyce.

Do podstawowych grup typów danych jakie wyszczególniamy w MS SQL Server zaliczamy:

* Liczby całkowite (dokładne)
* Liczby zmiennoprzecinkowe (przybliżone)
* Daty i czasy
* Ciągi znaków 
* Inne

## Typy całkowite (całkowitoliczbowe)

Służą do reprezentowania liczb całkowitych. Prawie wszystkie reprezentacje w tej postaci są liczbami ze znakiem. Podstawowe różnice dotyczą ilości miejsca zajmowanego w pamięci komputera oraz zakresu liczb, który odwzorowywują. W przypadku baz danych prócz liczb całkowitych używane są również ich odpowiedniki z przesuniętym separatorem części ułamkowej. I tak liczby całkowite reprezentowane są przez typy

* int - 4 bajty - od -2 147 483 648 do 2 147 483 647
* bigint - 8 bajtów - od -9 223 372 036 854 775 808 do 9 223 372 036 854 775 807 (9 trylionów)
* smallint - 2 bajty - od -32,768 do 32,767
* tinyint - 1 bajt - od 0 do 255

Typ int należy do najpopularniejszych typów w całym programowaniu. Nie inaczej jest w bazach danych. Int jest podstawowym typem danych do reprezentacji klucza tabeli. 4 bajty oznacza 32bity, które są bardzo wydajnie przeliczane zarówno przez procesory 32 co 64 bitowe. Jednoczesnie dopuszcza naprawdę znaczną liczbę unikatowych wartości (ponad 4 mld)

### Liczby określonej precyzji

MS SQL posiada możliwość utworzenia typu danych liczb z częścią ułamkową określonej precyzji. Typ ten wyrażany jest przez decimal(p,s) lub synonimicznie przez numeric(p,s). SZBD nie pozwala jednak na rozszerzenie tego typu poza zakres od $-10^{38} + 1$ do $10^{38} - 1$. Parametr p oznacza maksymalną ilość cyfr w notacji dziesiętnej jaką może posiadać liczba danego typu, natomiast parametr s wskazuje ile z tych liczb służy do reprezentacji części ułamkowej. Naturalnym ograniczeniem jest $0 \leq s \leq p$.

I tak np. liczba $14.36$ jest typu decimal(4,2), ale liczba $114.36$ czy $14.367$ już nie.

### Typy money

Szczególnym przypadkiem liczb określonej precyzji są typy danych money oraz smallmoney. Są to typy pozycyjne o 4 miejscach po przecinku i służą głównie do reprezentowania kwot pieniędzy po stronie bazy danych.

* smallmoney 4 bajtowy typ o zakresach od -214 748.3648 do 214 748.3647
* money 8 bajtowy typ o zakresach od -922 337 203 685 477.5808 do 922 337 203 685 477.5807 (922 biliony)

### Typ bit

Ostatnim typem całkowito liczboym jest bit. Zmienne typu bit pozwalają składować jedną z 3 wartości: 0,1 lub null. Pojedyncza zmienna bit zajmuje 1 bajt. Jednak jeśli tabela posiada więcej kolumn w typie bitu to ich zajętość pamięciowa jest optymalizowana i tak np. 8 kolumn bitowych dalej zajmuje 1 bajt w pamięci komputera. Typ ten jest używany najczęściej do składowania informacji o charakterze: prawda czy fałsz.

## Liczby zmienno przecinkowe

MS SQL oferuje nam ponadto możliwość tworzenia liczb zmiennoprzecinkowych. Do zrozumienia postaci takiej liczby można odpowiedzić następujące źródło [wiki o liczbach zmiennoprzecinkowych](https://pl.wikipedia.org/wiki/Liczba_zmiennoprzecinkowa) lub po prostu zaakceptować fakt, że jest to formuła reprezentowania w sposób przybliżony liczb rzeczywistych. Typ ten można zadeklarować używając terminu float(n). n ogólnie oznacza ilość bitów przeznaczony na mantysę w zapisie zmiennoprzecinkowym. W praktyce w SQL server wystepują jednak tylko dwa typy float(24) oraz float(53). Pozostałe zapewniają zgodność ze standardem ISO. Domyślnie pisząc float SQL używa float(53). Aby użyć typu float(24) można użyć terminu real.

W tych typach

* najmniejsza liczba: float -> - 1.79E+308, real -> - 3.40E + 38
* największa ujemna: float-> -2.23E-308, real -> -1.18E - 38
* największa liczba: float -> 1.79E+308, real -> 3.40E + 38
* najmniejsza dodatnia: float-> 2.23E-308, real -> 1.18E - 38


## Typy daty i czasu

Jednym ze znacznych problemów w początkach przygody z programowaniem jest pracowanie z datami. Z uwagi na wiele zmieniających zakresów (0-60 dla minut, 0-23 dla godzin, ilość dni w miesiącu, ilość dni w roku) arytmetyka na typach opisujacych czas od zawsze była wyzwaniem. Aby uniknąć problemów w tym zakresie bazy danych implementują typy daty i czasu gwarantujące poprawność obliczeń w arytmetyce czasu (tak np. aby plus 1 dzień do 28 lutego dał 29 luty lub 1 marca w zależności od roku).

Bazy SQL Server wprowadzają sześć takich typów o różnym przeznaczeniu i precyzji:

* time - reprezentuje czas w czasie trwania pojedynczego dnia bez strefy czasowej. time(n) pozwala dodatkowo określić precyzję sekundową. Domyślnie precyzja jest ustawiana na 7 co oznacza dokładnośc do 10 ns. Zajmuje 5 bajtów. Zajmuje 3 do 5 bajtów.
* date - reprezentuje datę w kalendarzu gregoriańskim w zakresie rok 1 - 1 stycznia do rok 9999 - 31 grudnia z dokładnością do pojedynczego dnia
* datetime - reprezentuje datę oraz czas łącznie wg kalendarza gregoriańskiego w zakresie dat 1 styczeń 1753 do 31 grudnia 9999 z pełnym zakresem dobowym 00:00:00 do 23:59:59.997 (krok 3 tysięczne sekundy). Zajmuje 8 bajtów.
* datetime2 - reprezentuje datę oraz czas łącznie wg kalendarza gregoriańskiego w zakresie dat 1 styczeń 0001 do 31 grudnia 9999 z pełnym zakresem dobowym 00:00:00 do 23:59:59.99.9999999. Zajmuje 6 do 8 bajtów.
* smalldatetime - reprezentuje datę oraz czas łącznie wg kalendarza gregoriańskiego w zakresie dat 1 styczeń 1900 do 6 czerwca 2079 z pełnym zakresem dobowym 00:00:00 do 23:59:59 (1 sekunda). Zajmuje 4 bajty.
* datetimeoffset - jest odpowiednim datetime2 z uwzględnieniem strefy czasowej. Zajmuje 10 bajtów

## Typy znakowe

Ostatnią dużą grupę typów danych stanowią ciągi znaków. Są one nader powszechne - w końcu składująca bazach danych

* loginy
* hasła
* imienia i nazwiska
* adresy email

Podstawowy problem z danymi w tym typie jest to, że tylko w rzadkich przypadkach znamy najdłuższy ciąg znaków jaki może nam wystąpić. I tak dostępne są nam typy danych dla ciągów znakowych to:

* char(size) - max 8000 znaków typ o stałym rozmiarze uzupełnianyspacjami. Nie unicode
* varchar(size),text - max 8000 znaków, skracany przez parametr max typ o zmiennym rozmiarze. Nie unicode
* nchar(size) - max 40000 znaków typ o stałym rozmiarze uzupełniany spacjami. Znaki unicode 
* nvarchar(size), ntext - max 4000 znaków, skracany przez parametr max typ o zmiennym rozmiarze. Znaki unicode
* binary(size) - max 8000 znaków typ o stałym rozmiarze uzupełniany spacjami. Dane w postaci binarnej
* varbinary(size) -  max 8000 znaków, skracane przez parametr max typ o zmiennym rozmiarze dla danych binarnych
* image - max 2GB typ dla duzych plików o zmiennym rozmiarze, postac binarna

## O doborze typu danych

Jednym z najistotniejszych cech etapu projektowania baz danych jest
dobranie odpowiedniej reprezentacji danych w pamieci. W
szczególnosci dotyczy to zgrupowan duzej ilosci danych takich jak np.
opisy czy teksty. Stosuje sie zasade
złotego srodka do rozwiazywania konfliktów interesów:

* Gdy ustalono zbyt mało pamieci dla danych - okazuje sie, ze pojawia sie bardzo rzadki przypadek, którego baza danych nie jest w stanie składowac w sobie. Baza danych nie moze wtedy zrealizowac zadania.
* Gdy ustalono zbyt duzo pamieci dla danych - okazuje sie, ze baza danych zajmuje znacznie wieksze obszary zasobów fizycznych. Wymusza to dzielenie bazy danych pomiedzy wiele stacji, kupno wiekszych dysków, tworzenie połaczen miedzy elementami bazy danych, a w ostatecznosci prowadzi do spowolnienia jej działania.

Pamiętajmy zawsze zatem dobierać typ danych do naszych potrzeb.

### Odnośniki
[Dokumentacja od typach w T-SQL](https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql)

# Literały

Literałami nazywa się sposoby wprowadzania wartości, tak aby były łączone z odpowiednimi typami danych - to 
nazewnictwo zgodne z wszystkimi językami używanymi do programowania. 
Przypuśćmy, że chcemy wstawić w bazie jakiś łańcuch tekstu. Sprawdzamy, że faktycznie dana kolumna posiada typ
`nvarchar` czyli przyjmie tekst.

Wtedy wystarczy odwołać się do wartości `'w pojedynczej klamrze'`. Z pominięciem tego cudzysłowia instrukcja byłaby 
niezrozumiała dla bazy SQL. Sensu nabiera po ich dodaniu. 

## Literał NULL

Przykładem literału jest `NULL` czyli wartość nieznana (czasem określana jako NA - not available). Ciekawostką 
jest to, że NULL może wystąpić w dowolnym typie danych dostępnym w bazie. Wyjaśnia to również czemu podnosiliśmy
że do sprawdzania warunków należy używać
```
kolumna IS NULL
```
zamiast potencjalnie źle działąjącego
```
kolumna = NULL
```

Polecam dla ćwiczenia sprawdzić sobie działanie takich dwóch zapytań
```
SELECT case WHEN (NULL = NULL) THEN 1 ELSE 0 END
SELECT case WHEN (NULL IS NULL) THEN 1 ELSE 0 END
```

## Literały Liczbowe

Podstawowymi literałami liczbowy są ... jawne ciągi cyfr. Warto jednak dla porządku podać, że
występują jeszcze jawne wersje znakowe

```
1234
+1234
-1234
```

W przypadku liczb o typie decimals dopuszczalny jest jeszcze separator dziesiętny pod postacią kropki

```
1234.56
+1234.56
-1234.56
```

## Literał typów zmienno przecinkowych

``` 
1720
172E1
17.2E2
+172000E-2
0.172E4
-0.172E4
```

## Literały money

Dodatkowo literały dla money mogą być poprzedzone znakiem $

``` 
$1720
```

poza tym mają szablon zgodny z decimal - którym faktycznie są ...

## Literały ciągów znaków

są to oczywiście literały w postaci ciągów znaków ograniczonych pojedynczym apostrofem

```
'tekst'
'01234'
```
występują jednak jeszcze wersje dla szerszego typu danych dla liter NVARCHAR czyli z kodowaniem znaków unicode. 
W tym kodowaniu zamiast pojedynczego bajtu na znak, używane są dwa bajty - co pozwala na składowanie znacznie 
bogatszego w znaki ciągu. Czyli w szczególności posiadającego polskie znaki diakrytyczne 
```
N'Łódź'
```

## Literały daty 

Teoretycznie MS SQL Server wspiera podawanie literałów również dla wartości Dat i czasów. W praktyce jednak 
jedynie daty uzyskane przez konwersję ciągu znaków na datę okazują się czytelne i niezawodne

```
CONVERT(DATE,'17.02.2010', 104 )
CONVERT(DATETIME,'17.02.2010 08:20:44', 120 ) 
```

Ostatni parametr to kod formatowania daty, który można odczytać z dokumantacji lub [tutaj](https://www.w3schools.com/sql/func_sqlserver_convert.asp)

## Testowanie literałów

Aby przetestować poprawność literału można zbudować proste zapytania

``` 
SELECT [literał]
```

i zobaczyć czy został on poprawnie opracowany

### Ćwiczenie

Wykorzystać składnię do budowania literałów by potwierdzić, że np. nie pozwoli ona na stworzenie nieistniejącej
daty.

# Ograniczenia (CONSTRAINT) w bazie danych

Relacyjne bazy danych mają w czasie swojego działania zachowywać spójność. Część odpowiedzialności za to spoczywa
na osobach projektujących jej użycie (i zapytań), ale część z nich może być obsłużona już na etapie tworzenia
tabel - wymuszając warunki poprawności dla danych kolumn.

Przykład ... chcemy w bazie danych składować PESEL. Z reguły nie wprowadza się na poziomie bazy danych 
warunku sprawdzającego poprawność sumy kontrolnej (są osoby z nadanym prawnie niepoprawnym peselem), ale 
co by się nie waliło, paliło - PESEL ma zawsze 11 znaków. PESEL będzie zadany z pewnością typem VARCHAR(11) 
ale można go dodatkowo wyposażyć w sprawdzenie by np.

* zawierał on same cyfry,
* zawierał dokładnie 11 znaków.

Wtedy w opisie tabeli obok typu znajduje się podane ograniczenie czyli `CONSTRAINT`. Wymieńmy najważniejsze
ograniczenia dostępne w MSSQL

* PRIMARY KEY - sprawia, że wartości tego pola nie mogą być puste, muszą być unikatowe i nie wolno ich modyfikować
* FOREIGH KEY - sprawia, że baza sprawdza czy wartość tego pola występuje w polu kluczowym innej tabeli (wpływa na kolejność ooeracji INSERT)
* DEFAULT - sprawia, że podawana jest wartość domyślna jeśli nie została wyspecyfikowana inna przy tworzeniu
* NOT NULL - nie można wstawić wartości NULL
* CHECK - wymusza spełnienie przez wartość zadanego warunku
* UNIQUE - wymusza by kolumna miała unikatowe wartości dla wszystkich rekordów.
* IDENTITY - jak default ale wprowadza coraz to większe liczby

# Komenda Insert 

Insert jest komendą służącą do wstawiania danych do bazy SQL. Posiada prostą składnię postaci

```{}
INSERT INTO Nazwa_Tabeli[(Nazwy kolumn,...)] VALUES Lista_Wartosci_W_Nawiasach ;
```
*UWAGA* Przy podawaniu nazwy tabeli może wystąpić kilka wersji - które różnie zadziałają 
i w każdej z nich wiele zależy od typów danych pod spodem

* jeśli nie podamy listy kolumn - komenda insert spodziewa się, że podamy w każdej krotce wartości wszystkich kolumn (wyjątek kolumny identity - te mają wartości autogenerowane) 
* jeśli podamy listę kolumn - to podajemy wartości w tej samej kolejności kolumn. Kolumna musi być na liście jeśli ma blokadę `NOT NULL`
* jeśli podamy listę kolumn, i nie ma tam konkretnej kolumny, i nie ma na tej kolumnie blokady `NOT NULL` - to wstawiane jest tam `NULL`
* jeśli chcemy podać również wartość o typie identity to 
  * Na kolumnie musi być zdjęta odpowiednia blokada (IDENTITY_INSERT), oraz
  * trzeba podać pełną listę kolumn.

## SELECT INTO

W T-SQL występuje ponadto możliwość wykonania kopii pewnego zbioru danych poprzez zapisanie jej stanu w nowej tabeli. Jest to nad pozór dość często wykorzystywana możliwość przez analityków - którzy tym sposobem pobierają sobie dane ze środowisk produkcyjnych (wybrane) celem przeprowadzenia pewnej analizy.

Składnia tej operacji jest łudząco podobna do operacji SELECT

```{}
SELECT nazwy_kolumn,... Into nowa_tabela FROM TABELA ... 
```

Końcowe ... oznaczają możliwość włączenia w to klauzuli WHERE albo i JOIN lub GROUP.

# UPDATE

Do modyfikowania danych używana jest z kolei komenda UPDATE.
Również i ona posiada prostą składnię postaci:

```{}
UPDATE Nazwa_Tabeli SET Kolumna1=Wartość1 [,Kolumna2=Wartość2], ...
```

... również i tutaj twórcy języka sugerują możliwość użycia Klauzuli WHERE 
(z reguły chcemy edytować tylko poszczególne rekordy, a nie ustawiać na wartość całe kolumny). 
Najczęściej spotykana składnia to

```{}
UPDATE Nazwa_Tabeli SET Kolumna=Wartość WHERE Id='Okreslone ID';
```

## DELETE

Ostatnią operacją jest usuwanie elementów ze zbioru. Ona również cechuje się prostotą składni.

```{}
DELETE FROM Nazwa_Tabeli ...
```

Ponownie ... dodają możliwość dołączenia klauzuli WHERE.

UWAGA! Niektórzy klienci baz danych (programy do łaczenia się z bazami danych, np. SSMS) 
domyślnie blokują możliwość wykonania nieograniczonego DELETE. tj

```{}
DELETE FROM Nazwa_Tabeli; 
```

Wykonanie takiej komendy kasuje bowiem wszystkie krotki w bazie danych - a moze zostać całkiem niechcący wykonane.

## TRUNCATE

Blokowanie opcji DELETE FROM Tabela jest podyktowane jeszcze jednym. Istnieje w standardzie SQL 
specjalna komenda służąca kasowania całej zawartości Tabeli. Jest to komenda truncate. 
Truncate nie dość, że kasuje elementy z tabeli to jeszcze resetuje pewne charakterystyki tabeli 
do wartości domyślnych.

```
TRUNCATE TABLE [Tabela];
```

Do porównania działania DELETE i TRUNCATE można posłużyć się metaforą budowlaną. 
Bowiem by można wynając koparkę i pokolej - piętro po piętrze, ściana po ścianie przeprowadzać
burzenie. To opcja DELETE, delikatna i precyzyjna. Można również podłożyć dynamit i cały dom zburzy się 
od razu. To opcja TRUNCATE, całościowa i natychmiastowa.
