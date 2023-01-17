# Wyzwalacze

Niezależnie czy procedura czy funkcja - obie pozwalaja nam na automatyczne wykonywanie dużych przetworzeń informacji. 
Ich cechą wspólną jest jednak to, że za każdym razem muszą zostać wywołane na wyraźne życzenie użytkownika. Oprócz tego 
istnieją jeszcze instrukcje które mogą zostać wywołane w sposób automatyczny. 
Tzw. Wyzwalacze lub z języka angielskiego triggery.

W T-SQL dostępne są dwa rodzaje wyzwalaczy.

* Wyzwalacze dla danych,
* Wyzwalacze dla struktur,
* Wyzwalacze dla logowań.

Dwoma ostatnimi nie będziemy się w ogóle zajmować.

## Wyzwalacze dla danych

Składnia wyzwalacza dla danych ma następującą postać:

```tsql
CREATE TRIGGER nazwa
ON [Tabela | Widok] 
[FOR | AFTER | INSTEAD] [INSERT | UPDATE |  DELETE] 
AS
BEGIN
-- kod wyzwalacza
END
```

W miejsce akcji może być wskazana jedna z poniższych akcji:

* INSERT kiedy wstawiane są nowe dane
* UPDATE kiedy dane są modyfikowane
* DELETE kiedy dane są usuwane

W zależności od rodzaju akcji informacje przekazane do triggera odnośnie rekordów podlegających przekształceniu 
zorganizowane są w tymczasowej tabeli odpowiednio

* inserted
* ~~updated~~ (nie ma tabeli updated, jak pracować w triggerem UPDATE sprawdź w pliku [https://github.com/PiotrMaciejKowalski/introduction-to-t-sql/blob/main/examples/example-lab12.sql](https://github.com/PiotrMaciejKowalski/introduction-to-t-sql/blob/main/examples/example-lab12.sql)
* deleted

Jeśli chodzi o wybór chwili akcji interpretuje się je następująco

* FOR oraz AFTER - oznaczaja wywołanie triggera po udanym wywołanu akcji 
* INSTEAD - oznaczają pełne zastąpienie kodu

### Triggery na widokach

Wyjątkowo ciekawą koncepcją jest utworzenie triggera na widoku. Przypominamy, że wiele 
(większość, a w zasadzie wszystkie ciekawe widoki) nie pozwalają na wykonywanie na sobie operacji insert, update, delete

# Zadania 

## Zadanie 1

W bazie Biblioteka dodać trigger, który przy usuwaniu rekordu danego pracownika przenosi 
wszystkie wypożyczenia z nim związane na pracownika który został rekord wartownika
(czyli pracownika o ustalonej nazwie, który nie jest związany z żadną faktyczną osobą). 
Jeśli nie ma tego rekordu należy do w triggerze uruchomić
