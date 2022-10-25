# Operacje JOIN

Mając świadomość tego, że dane w bazach relacyjnych są w silnej dekompozycji, aby uzyskać odpowiedzi na co trudniejsze kwerendy, konieczne może okazać się złączenie. Operacja złączenia tworzy tymczasowe tabele o rekordach utworzonych na podstawie danych z tabel składowych przy określonym warunku połączenia. Składnia ma postać:

```{}
SELECT [...nazwy kolumn] FROM [...Lewa_Tabela] JOIN [...Prawa Tabela] ON [...warunki]
```

Albo

```{}
SELECT [...nazwy kolumn] FROM [...Lewa_Tabela] INNER JOIN [...Prawa Tabela] ON [...warunki]
```

Warto jednak poznać od razu wszystkie rodzaje złączeń aby odpowiednio rozumieć jak działają.

Występują (podstawowe) 4 rodzaje złączeń. Trzy nazywane zewnętrznymi, oraz jedno wewnętrzne.

* INNER JOIN - gdy w parowaniu dwóch tabel muszą istnieć rekordy po obu stronach złączenia.
* OUTER JOIN - gdy w parowaniu dwóch tabel nie muszą istnieć rekordy po obu stronach złączenia.
* LEFT (OUTER) JOIN - gdy w tabeli po lewo musi istnieć rekord, ale tylko tam.
* RIGHT (OUTER) JOIN - gdy w tabeli po prawo musi istnieć rekord, ale tylko tam.

## Operacja full outer

Przypominijmy kwerendę postaci:

```
SELECT imie, nazwisko, przelozony, specjalizacja, Oddzialy.nazwa
FROM Lekarze,Oddzialy
```

W kwerendzie tej przy łączeniu tabel Lekarze i Oddziały nie było zdefiniowanych 
żadnych reguł ich połączenia w efekcie otrzymaliśmy tabelę zawierającą wszystkie 
możliwe pary rekordów. Chcąc ograniczyć rozmiar tabeli tymczasowej podajemy zasadę tworzenia par

```
SELECT imie, nazwisko, przelozony, specjalizacja, Oddzialy.nazwa
FROM Lekarze
JOIN Oddzialy 
ON Oddzialy.id = Lekarze.oddzial
```
## Ćwiczenie 

Przećwiczmy tworzenie pozostałych

```
SELECT imie, nazwisko, przelozony, specjalizacja, Oddzialy.nazwa
FROM Lekarze
LEFT OUTER JOIN Oddzialy ON Oddzialy.id = Lekarze.oddzial
```

```
SELECT imie, nazwisko, przelozony, specjalizacja, Oddzialy.nazwa
FROM Lekarze
RIGHT OUTER JOIN Oddzialy ON Oddzialy.id = Lekarze.oddzial
```

```
SELECT imie, nazwisko, przelozony, specjalizacja, Oddzialy.nazwa
FROM Lekarze
FULL OUTER JOIN Oddzialy ON Oddzialy.id = Lekarze.oddzial
```

## Ćwiczenie 

Wykonajmy skrypt z katalogu lab 3 `szpital_update.sql` i powtórzmy zadanie.


## Łączenie tabel w ralacji sam-ze-sobą.

SQL nie ogranicza nam możliwości które tabele mogą podlegać złączeniu. 
Łącząc to z faktem, że w bazach danych pojawią się związki między encjami o 
charakterze sam-ze-sobą oznacza to, że można połączyć tabelę z nią samą. 

Co jednak z nazwami kolumn w takim przypadku. Prezentujemy na przykładzie 
budowania tabeli z relacją lekarz - lekarz przełożony.

```
SELECT lek.imie, lek.nazwisko, ord.imie AS 'Imię przełożonego', ord.nazwisko AS 'Nazwisko przełożonego'
FROM Lekarze lek
LEFT JOIN Lekarze ord ON lek.przelozony = ord.id
```

# SQL kaskadowy

Operacje złączeń są bardzo niewydajne pamięciowo. Dla niemal każdej bazy danych nie jest możliwe wygenerowanie złączenia wielu tabel bez złamania ograniczeń pamięciowych maszyny. 

Często skuteczniejszym sposobem jest zadawania kaskadowych zapytań SQL według formuły

```
SELECT ... from ... WHERE columna in (SELECT ... FROM ... WHERE ...)
```

Dla przykładu znajdźmy lekarzy 3 najstarszego pacjenta. Można z użyciem JOIN

```
select TOP 3 LEK.imie, LEK.nazwisko
FROM lekarze LEK 
JOIN Pacjenci PAC
ON LEK.id = PAC.lekarzRodzinny
ORDER BY PAC.wiek DESC
```

Ale można też z mniejszym obciążeniem serwera zapytać go o

```
select imie, nazwisko
from Lekarze
where id in (
    select top 3 lekarzRodzinny
    from Pacjenci
    order by wiek desc
)
```

Podobnie można również budować zagnieżdżenia generując tymczasowe tabele i przekazując je 
poprzez pole FROM

# Operacje mnogościowe na wynikach kwerend

Polecenie UNION pozwala złączyć ze sobą wyniki różnych zapytań. Oczywiście istnieją pewne warunki pod którymi sklejenie tabel może mieć miejsce. Wyniki obydwu łączonych zapytań muszą mieć tyle samo kolumn, a poszczególne kolumny muszą mieć kompatybilne typy danych.

```
SELECT [...nazwy kolumn] FROM [...nazwa tabeli_1] UNION
SELECT [...nazwy kolumn] FROM [...nazwa tabeli_2]
```

Np. poniższe wypisuje imiona i nazwiska wszystkich lekarzy i pacjentów w bazie.
```
SELECT imie, nazwisko FROM Pacjenci
UNION
SELECT imie, nazwisko FROM Lekarze		
```

Oprócz komend Union występują również inne operacje mnogościowe

* INTERSECT - przecięcie zbiorów
* MINUS - różnica zbiorów

* UNION ALL - jak union, ale dopuszcza duplikaty

# Warunek Like

Na koniec przedstawimy jeszcze jedno wartościowe polecenie.
Zliczymy tych pacjentów, których trzecia cyfra PESELu wynosi 7.
Wykorzystamy w tym celu polecenie LIKE i COUNT. 

```
SELECT COUNT(*) FROM Pacjenci -- zlicza liczbę pacjentów
```

Dostępne jest nam również przeszukanie pasujące do wzorca według formuły:

```
-- SELECT [...nazwy_kolumn] FROM [...nazwa tabeli] WHERE [...wyrażenie] LIKE 'format'
```

przy czym format musi składać się z następujących możliwych wyrażeń:
* % -- dowolna liczba znaków (w tym 0)
* _ -- dowolny pojedynczy znak
* [a-z] -- dowolna mała litera (ogólnie przedział znaków)
* [^a-z] -- dowolny znak nie będący małą literą (ogólnie nie należący do zakresu)
* pojedynczego konkretnego znaku (np. w naszym przypadku może być to 7)

```
SELECT COUNT(*) FROM Pacjenci WHERE pesel LIKE '__7%' 
```

# Zadania 

## Zadanie 1 

Odszukać pacjentów z rejestracją na oddział inny niż ten na którym pracuje ich rodzinny

## Zadanie 2

Wygenerować podsumowanie per każdy oddział ile rejestracji zostało wygenerowanych przez pacjentów, których lekarzem rodzinnym jest pracownik danego oddziału

## Zadanie 3

O ile przeciętnie przełożony zarabia więcej od swojego podwładnego

## Zadanie 4

Znaleźć do ilu lekarzy, są przypisani pacjenci z conajmniej jedną rejestracją w systemie.

## Zadanie 5 

Znaleźć per lekarz ilu jest pacjentów, którzy są do nich przypisani i mają conajmniej jedną rejestrację w systemie.

## Zadanie 6
 
Policzyć stosunek łącznego kosztu audytu na oddział per liczba podległych mu pacjentów (ich lekarze na nim pracują)

