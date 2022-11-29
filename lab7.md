
# Zadanie transakcji w utrzymaniu spójności danych

Pamiętamy, że jednym z kluczowych zadań baz danych jest utrzymywanie spójności - rozumianej jako zgodność
danych w modelu cyfrowym z tym co powinno w nim się znajdować. W pierwszej części semestru skupialiśmy się 
utrzymywaniu spojności za pomocą odpowiedniego doboru tabel. Wykorzystywaliśmy do niego pojęcia takie jak postacie 
normalne - celem określania gotowości zbioru danych do utrzymania spójności. Okazuje się jednak za ochrania to 
jedynie te zaburzenia spójności które wiążą się z samą strukturą danych. 

Innymi słowy są to problemy, które występowałyby nawet gdy baza danych miała tylko jednego użytkownika. A przecież
baza danych ma nie tylko jednego użytkownika i na dodatek ich dostęp jest współbieżny. Wielu użytkowników wykonuje
jednoczesne operacje na tych samych danych. Dowolne zapytanie generowane do bazy danych jest jednak atomowe -
silnik bazy danych nie będzie go dzielił - nie ma więc ryzyka, że np. w czasie gdy mamy kwerendę z `WHERE` 
ktoś za pomocą komendy `UPDATE` zmodyfikuje wartości w naszej tabeli. Ryzyko pojawia się dla nas gdy myślimy o tym,
że wykonane przez nas sekwencyjnie kilka zapytań SQLowych będzie miało określony efekt - i nie przypuścimy, że
coś może nie potoczyć się po naszej myśli.

## Przykład `przelew bankowy`

Rozważmy sytuację gdy chcemy zmodyfikować stany konta bankowego na skutek dwóch przelewów

Użytkownik Z chce zrealizować przelew 300$ z konta A na konto B. Tworzy do tego następujący ciąg zapytań

```sql
UPDATE konta set stan_konta = stan_konta + 300 WHERE user = 'B'
UPDATE konta set stan_konta = stan_konta - 300 WHERE user = 'A'
```

Taki układ operacji jest poprawny i zakończył by się spójnym wynikiem. Ale użytkownik Y chce w tym samym czasie 
zrealizować przelew 400$ z konta A na konto C. Tworzy podobny ciąg zapytań

```sql
UPDATE konta set stan_konta = stan_konta - 400 WHERE user = 'A'
UPDATE konta set stan_konta = stan_konta + 400 WHERE user = 'C'
```

Ponownie - samo w sobie zapytanie nie zaburzy spójności. Ale wykonane współbieżnie mogą np zostać wykonane w kolejności

```sql
UPDATE konta set stan_konta = stan_konta + 300 WHERE user = 'B'
UPDATE konta set stan_konta = stan_konta - 400 WHERE user = 'A'
UPDATE konta set stan_konta = stan_konta - 300 WHERE user = 'A'
UPDATE konta set stan_konta = stan_konta + 400 WHERE user = 'C'
```

Bardzo naturalnym założeniem jest, że baza w banku będzie miała założony constraint nie pozwalający na ujemne saldo
rachunku. Jeśli jednak użytkownik ma na koncie 500$ to zauważmy, 

```sql
UPDATE konta set stan_konta = stan_konta + 300 WHERE user = 'B' -- wykona się poprawnie
UPDATE konta set stan_konta = stan_konta - 400 WHERE user = 'A' -- wykona sie zostawiajac 100 na saldzie
UPDATE konta set stan_konta = stan_konta - 300 WHERE user = 'A' -- nie wykona sie z uwagi na constraint - skrypt Z rzuci błędem
UPDATE konta set stan_konta = stan_konta + 400 WHERE user = 'C' -- wykona się dopisując 400 do salda C
```

W efekcie mamy saldo kont
``` 
A -= 400
B += 300
C += 400
```

I mamy manko na sumie pieniędzy w kontach równej -300$ względem poprzednich operacji

## Analiza przypadku

Problemy ze spójnością mają tu dwie przyczyny. Pierwszą z nich jest to, że dwa procesy dwóch użytkowników mogą
uzyskiwać jednocześnie dostęp do tych samych danych. W efekcie tego odczyt stanu konta może być zaburzony przez 
równoległy proces. Drugim problemem jest spójność zapisu. Jeśli proces użytkownika Z się nie powiódł 
w połowie - nie powinno się dopuścić do zapisania tej połowy w bazie danych. 

# Blokady

Pierwszym z problemów w bazie danych radzą sobie tzw. blokady. Inaczej nazywane poziomami izolacji.
Blokady spełniają rolę zatrzymującą wykonanie kwerend do czasu zdjęcia blokady. Naturalnie nie można również zakładać
blokady na element, który jest już zablokowany. TSQL wyszczególnia następujące poziomy izolacji
```
READ UNCOMMITTED / NOLOCK - brak blokady
READ COMMITTED - czytanie tylko oficjalnie zapisane dane
REPEATABLE READ - nie pozwala na modyfikowanie danych zanim blokada nie zostanie zdjęta 
SNAPSHOT - zmiany wnoszenie przy tej izolacji z automatu nie trafiają do oryginalnej tabeli po zdjęciu
SERIALIZABLE - wszystkie zmiany/transakcja muszą być przetwarzane pokolej.
```

Poziom izolacji można wykorzystać choćby na poziomie zadania kwerendy

```sql 
SELECT * FROM Tabela WITH (Poziom_izolacji)
```

Blokady są zaawansowanym elementem składni T-SQL i ich poznanie nie jest wymagane do uzyskania oceny w tym kursie.
Sygnalizujemy jednak uczestnikom kursu ich istnienie - celem świadomości.

# Transakcje 

Drugi problem wziął się z tego, że wykonana została tylko połowa potrzebnych operacji. Bardzo często będzie
dochodzić do sytuacji w której oczekujemy, że wszystkie operacje jakie zlecimy zostaną wykonane ... lub żadne.

Elementem programowalnym, który służy do grupowania zapytań SQL w niepodzielne ciągiu operacji jest transakcja.

``` 
BEGIN TRAN

BEGIN TRY
  -- Komendy SQL
  
  COMMIT TRAN
END TRY

BEGIN CATCH
  ROLLBACK TRAN
END CATCH
```

Warto w składni powyżej wyszczególnić:

* BEGIN TRAN - to otwiera blok transakcji
* BEGIN TRY - END TRY - blok potencjalnie narażony na błąd
* BEGIN CATCH - END CATCH - blok obsługi błędu
* COMMIT TRAN - zapis efektu transakcji do bazy danych
* ROLLBACK TRAN - wycofanie zmian transakcji (powrót do stanu z chwili BEGIN TRAN)

## Problem zakleszczeń 

Stosowanie współbieżne transakcji niesie za sobą ryzyko znane pod nazwą zakleszczenia. Do zakleszczenie dochodzi np. 
w sytuacji gdy 

* Transakcja A posiada blokadę na tabeli T1 i próbuje nałożyć blokadę na tabeli T2,
* Transakcja B posiada blokadę na tabeli T2 i próbuje nałożyć blokadę na tabeli T1.

W takiej sytuacji każda z transakcji czeka na zwolnienie blokady - samemy swojej nie zdejmując - w efekcie blokując
oba zasoby. Temat rozwiązywania zakleszczeń wykracza poza ramy naszego kursu.

# Zadania 

W bazie danych biblioteka 

## Zadanie 1

Przygotować transakcję, która 
* dodaje nowego czytelnika
* przenosi wszystkie aktywne wypożyczenia innego użytkownia na nowego użytkownika
* kasuje tego innego użytkownika

## Zadanie 2

Przygotować transakcję, która tworzy tabelę z danymi czytelników którzy wypożyczyli dowolną książkę ustalonego
autora. Autora należy traktować jako cenzurowanego. Jego dane osobowe w bazie należy usunąć oraz skasować dane
opisujące jego ksiażki. Nie należy jednak kasować wypożyczeń, bo część jego książek może powrócić do biblioteki. 

## Zadanie 3

Zmodyfikować bazę danych tak aby była możliwość przypisania do książki więcej niż jednego autora
