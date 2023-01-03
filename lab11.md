# Ćwiczenia z elementów programowalnych T-SQL

Zacznij od wczytania bazy danych hr z plików umieszczonych w `scripts/hr`. Odpowiednio najpierw create a potem load.

## Zadanie 1 (View)

Utwórz widok zawierający podsumowanie min, średniej i maksymalnej pensji w każdej z lokalizacji firmy

## Zadanie 2 (Trigger)

Napisz wyzwalacz, który uniemożliwi wstawienie nowego pracownika z wartością pensji przekraczającą widełki zdefiniowane w tabeli jobs

## Zadanie 3 (Procedure)

Przygotuj procedurę zwalniającą dla menadżerów. Niech spełnia następujące reguły
- działa jedynie dla menadżerów (osób zarządzających innymi - według relacji employees-employees). Dla pozostałych może nie działać lub zwracać błąd
- usuwa rekord z tabeli employees
- odnajduje pracownika podległego kasowanemu rekordowi, który jest najstarszy stażem (hire_date) i uznaje go za przejmującego obowiązki
- kandydatowi temu należy zmienić jobs na job poprzedniego menadżera. Podnieść jego salary do min_salary dla jego nowego jobs
- zmienić menager_id pozostałym podopiecznym kasowanego rekordu na kandydata.

## Zadanie 4 (View+Trigger)

Utworzyć widok w którym w wierszach składowane są pary region_name i country_name. Country_name oczywiście w tym widoku będzie unikatowe.
Utworzyć trigger na insert na tym widoku który działa następująco:
- jeśli region i kraju nie ma - tworzy oba wpisy i łączy je w relacji
- jeśli region istnieje, ale kraju nie ma - wyszukuje region_id i tworzy z nim wpis w tabeli countries
- jeśli region nieistnieje, ale kraj istnieje - tworzy nowy region i wstawia jego id w odpowiedni record w countries
- jeśli oba istnieją kończy się błędem lub komunikatem.