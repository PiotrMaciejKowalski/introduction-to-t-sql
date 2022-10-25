# Uruchomienie i import danych

* Uruchom SQL Server Management Studio (SSMS),
* Połącz się do bazy danych zainstalowanej lokalnie na komputerze
* Wykonaj plik szpital_init.sql

# Wprowadzenie do SQL

## Kilka pierwszych komend 
Komenda use służy do wskazywania domyślnego zbioru danych
```
use [...baza]
```

Na przykład poniższe przełącza kontekst (można o tym myśleć trochę jak o zmianie katalogu roboczego)
```
use szpital
```
Poniższa komenda wymusza wykonanie wszystkich zadeklarowanych powyżej poleceń przed przejściem do następnych
```
GO
```

```
-- oznacza komentarz w kodzie SQL
```

## Kwerenda SELECT

Narzędziem do otrzymywania informacji o stanie danych przechowywanych w bazie jest instrukcja `SELECT` o następującej (podstawowej) składni. Składnie tej instrukcji będziemy rozwijać w dalszej części semestru.

```
SELECT [...kolumny] FROM [...tabele]
```

Przykład:

Wybiera wskazane kolumny z produktu kartezjańskiego podanych tabel. Jest to podstawowe polecenie SQL, zwracające wynik operacji.
```
SELECT Lekarze.imie FROM Lekarze
```

Tu bardziej jaskrawy przykład iloczynu kartezjańskiego.
```
SELECT Oddzialy.nazwa, Audyty.audytor FROM Oddzialy,Audyty 
```
Źródłowe nazwy kolumn można pomijać, o ile nie prowadzi to do nieporozumień (tzn.o ile nie mamy kilku tabel zawierających kolumnę o tej samej nazwie).
```
SELECT imie FROM Lekarze
```

Gwiazdka zastępuje wybór wszystkich kolumn.

```
SELECT * FROM Pacjenci																	
```

## SELECT z warunkiem WHERE

Aby wskazać podzbiór interesujących nas danych dołączana jest specjalna klauzula WHERE nadając operacji SELECT następującą postać:

```
SELECT [...kolumny] FROM [...tabele] WHERE [...warunki logiczne]
```

Przykłady:

Wybiera imiona lekarzy, którzy zarabiają powyżej 5000(zł). Ogólnie wybiera z tabeli wiersze, które spełniają zadany zestaw warunków logicznych i zwraca wskazane kolumny z nich

```
SELECT Lekarze.imie, Lekarze.wynagrodzenie FROM Lekarze WHERE Lekarze.wynagrodzenie > 5000 
```

WHERE może być używane do wybierania powiązanych ze sobą danych z różnych tabel. Tutaj wybieramy imiona i nazwiska pacjentów leczonych przez dra Nowaka

```
SELECT Lekarze.imie, Lekarze.nazwisko, Pacjenci.imie, Pacjenci.nazwisko 
FROM Lekarze,Pacjenci WHERE Lekarze.nazwisko =  'Nowak'
AND Lekarze.id = Pacjenci.lekarzRodzinny
```

## Klauzula DISTINCT

Klauzula dodatkowo sprawia, że wybierane są tylko unikatowe zestawy wartości

```
SELECT DISTINCT [...kolumny] FROM [...tabele]
```

Działa analogicznie do zwykłego SELECT, ale usuwa duplikaty informacji ze zwracanego wyniku. Można łączyć z innymi poleceniami.
```
SELECT DISTINCT Lekarze.imie, Lekarze.nazwisko FROM Lekarze, Pacjenci WHERE Lekarze.id = Pacjenci.lekarzRodzinny
```

## Funkcja Top

Powoduje ograniczenie wyników do określonej liczby początkowych rekordów.

```
SELECT TOP(k) [...kolumny] FROM [...tabele]
```

Na przykład - Zwraca k (w tym wypadku 3) górnych rekordów z tabeli. Polecenie nie sortuje rekordów!

```
SELECT TOP(3) Lekarze.imie FROM Lekarze 
``` 

## Klauzula sortująca ORDER BY

Aby dane zostały w określony sposób posortowane potrzebna jest klauzula ORDER BY o poniższej formule:

```
SELECT [...kolumny] FROM [...tabele] ORDER BY [...kolumny] DESC/ASC
```

Przykład:

Poniższe zwraca posortowaną odpowiedź na wskazane zapytanie względem zadanego atrybutu do sortowania (w tym wypadku nazwisko). Opcje DESC/ASC służą do zadania porządku (malejący/rosnący). Zapytanie nie sortuje danych w bazie!

```
SELECT Pacjenci.imie, Pacjenci.nazwisko
FROM Pacjenci ORDER BY Pacjenci.nazwisko ASC
```

## Przezwanie AS

Jeśli z jakiegoś powodu chcemy aby dane pewnej kolumny były podawane pod zmienioną nazwą potrzebna jest nam klauzula AS

```
SELECT [...kolumna] AS [...nazwa] FROM [...tabele]
```

Nadaje etykietę odpowiedzi na zapytanie.
```
SELECT Pacjenci.wiek AS 'Starość' FROM Pacjenci
```

## Funkcje aggregujące SQL

Do wyliczania statystyk z liczb w SQL używamy funkcji agregujących. 

```
AVG/MIN/MAX/COUNT([...kolumna])
```

Oblicza średnią z zadanej kolumny tabeli wynikowej dla zapytania

```
SELECT AVG(Lekarze.wynagrodzenie) FROM Lekarze
```

Oblicza minimum zadanej kolumny tabeli wynikowej dla zapytania

```
SELECT MIN(Lekarze.wynagrodzenie) FROM Lekarze
```

Oblicza maximum zadanej kolumny tabeli wynikowej dla zapytania

```
SELECT MAX(Lekarze.wynagrodzenie) FROM Lekarze 
``` 

Szczególną rolę ma agregacja COUNT która zlicza liczbę wierszy

```
SELECT COUNT(*) FROM Lekarze 
```

## Funkcja do konwersji

Wszystkie dane składowane w bazie są interpretowane na podstawie przypisanego im typu. Możliwe są zmiany tych reprezentacji przy użyciu jawnej konwersji

```
CONVERT([...typ docelowy], [...wartosc])
```

Dokonuje konwersji zadanej zmiennej na zmienną innego typu.
```
SELECT CONVERT(DECIMAL(10,2),40.9129)
```

W przypadku danych liczbowych można to polecenie wykorzystać do zaokrągleń.

```
SELECT CONVERT(DECIMAL(10,2),40.9279)
```

Oczywiście konwersji można dokonywać pomiędzy różnymi typami.

```
SELECT CONVERT(smalldatetime, '2012-07-02 12:02:05') -- 
```

## Obsługa wartości pustej

```
SELECT * FROM Rejestracje WHERE opis IS NULL     -- sprawdza, czy opis jest brakującą wartością
SELECT * FROM Rejestracje WHERE opis IS NOT NULL -- sprawdza, czy opis jest brakującą wartością
SELECT * FROM Rejestracje WHERE opis = NULL      -- nie działa dlaczego?
```

## Operacje na ciągach znaków

Mamy dostęp również do funkcji, które potrafią modyfikować dane tekstowe

```
LEFT/RIGHT/SUBSTRING
```

Wybiera pacjentów, których trzy litery nazwiska z prawej strony to 'ski'

```
SELECT * FROM Pacjenci WHERE RIGHT(Pacjenci.nazwisko,3) = 'ski'
```

Czy porównywanie nie uwzględnia wielkości liter

```
SELECT * FROM Pacjenci WHERE LEFT(Pacjenci.imie,1) = 'b'
```

wybiera podciąg od 3 miejsca o długości 5.

```
SELECT imie, nazwisko, SUBSTRING(Pacjenci.pesel, 3, 5) FROM Pacjenci
```

## Agregacja z grupowaniem (GROUP BY)

Aby uzyskać wyniki agregacji ale w podgrupach posługujemy się połączeniem klauzul GROUP BY oraz funkcji agregujących

```
SELECT [...polecenia agregujące/kolumny] FROM [...tabele] GROUP BY [...kolumny ]
```

Na przykład - zlicza ile jest lekarzy o poszczególnych imionach w bazie.

```
SELECT COUNT(*), imie FROM Lekarze GROUP BY imie
```

# Zadania

## Zad 1. 

Wskaż tych pacjentów (imię/nazwisko/wiek), którzy ukończyli 30 lat

## Zad 2. 

Wskaż tych lekarzy (imię/nazwisko/specjalizacja/zarobki), którzy zarabiają powyżej 10000zł

## Zad 3. 
Przyjmując, że zarobki lekarzy są obarczone 21% podatkiem liniowym i 9% składką zdrowotną
(obydwie wielkości naliczane od podstawy wynagrodzenia), podaj zarobki "na rękę" każdego z lekarzy.

## Zad 4. 

Wskaż najdroższy audyt (oddział/koszt/rezultat/osoba przeprowadzająca) przeprowadzony w szpitalu.

## Zad 5. 
Wskaż trzy najstarsze rejestracje (ID Pacjenta/ID Oddziału/Opis/Data) odnotowane w systemie

## Zad 6. 
Wypisz imiona i nazwiska pacjentów razem z imionami i nazwiskami ich lekarzy rodzinnych

## Zad 7. 
Wypisz imiona, nazwiska i specjalizacje lekarzy pracujących na oddziale kardiologicznym


## Zad 8. 
Wypisz imiona i nazwiska lekarzy, którzy nie posiadają przełożonego w bazie danych

## Zad 9. 
Wypisz imiona i nazwiska ordynatorów oddziałów


