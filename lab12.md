# Ćwiczenia z zaawansowanych elementów programowalnych T-SQL

Zacznij od wczytania bazy danych hr z plików umieszczonych w `scripts/hr`. Odpowiednio najpierw create a potem load.

Zadania zawarte w tym materiale przekraczają poziom wymagany na kolokwium końcowym, ale mają w założeniu pełnić rolę 
ostatecznego sprawdzenia umięjętności programowania w T-SQL

## Zadanie 1  (Migawka)

Baza w zaprezentowanej postaci jest typowym schematem produkcyjnym. Tj. pokazuje obecny stan po zmianach. Często jednak
potrzebujemy utworzyć migawki stanu bazy danych celem choćby analizowania zmian systemu w czasie. Osiąga się to najczęściej
wykonując do osobnych tabel kopię stanu danych komendą `SELECT INTO`. Takie migawki mają najczęściej postać tzw. hurtownii danych,
ale najprostszym jej rodzajem jest tu pojedyncza tabela.

Przygotuj procedurę tworzącą migawkę stanu zatrudnienia na dany miesiąc. Dane powinny zawierać 

- employee_id
- imie
- nazwisko
- salary
- manager_id
- job_title
- department_name
- location opisane za pomocą pojedynczego adresu (dowolny stały format zapisu składający się z region_name, country_name, city, street_address)
- rok tworzenia migawki
- miesiac tworzenia migawki

Jako pewnego rodzaju dodatkowy warunek dołączmy, że 
- w migawce nie powinny znaleźć się rekordy których hire_date jest w przyszłości względem czasu tworzenia migawki (przyjmijmy, że rok i miesiąc tworzenia migawki nie jest odczytywany z systemu ale przekazywany przez parametry procedury)
- procedura powinna składować wszystkie tworzone nią migawki w pojedynczej tabeli (możemy tworzyć tabele tymczasowe ale należy je na koniec procedury usuwać). Czyli dane z migawki z lutego i marca są dodane do tej samej tabeli w systemie
- jeśli nie istnieje tabela do składowania migawek, procedura powinna ją utworzyć
- jeśli generujemy migawkę dla miesiąca, który ma już swoją migawkę utworzoną, to przed utworzenie migawki należy usunąć poprzednią (nadpisanie migawki)

## Zadanie 2 (Migawka przyrostowa)

Migawki są elementem zajmującym znaczne obszary pamięciowo. Dlatego często zamiast składowąć same migawki, składujemy jedynie zmiany jakie następiły od poprzedniej migawki.

Zmodyfikować kod tworzenia migawki z zadania 1 w taki sposób, aby w sytuacjach gdy mamy rekord opisujący pracownika (employee_id, ...)  za miesiąc czerwiec to

- jeśli nie ma takiego wpisu w tabeli migawek dla żadnej pary rok, miesiąc tworzenia migawki -> to go dodajemy
- jeśli są już takie wpisy odnajdujemy ostatni z nich według chronologii i porównujemy go z nowym. Jeśli występuje zmiana wstawiamy do bazy danych
- jeśli jednak rekord pokrywa się z ostatnim stanem - nie wstawiamy nic.
- UWAGA! Jeśli jakiś wpis dotyczący pracownika został skasowany to jest to zmiana, którą należy wykazać w migawce (można to osiągnąć np. wprowadzając pole is_active do tabeli)
- sugeruje by migawka przyrostowa była składowana docelowo w innej tabeli niż migawka z zadania 1

## Zadanie 3 (Stan bieżący na podstawie migawki przyrostowej)

Napisać funkcję tabelaryczną, która na podstawie migawek przyrostowych podaje stan na wskazaną chwilę (rok, miesiąc). 
Oczywiście powinien posiadać on unikatowe wpisy dotyczące aktywnych pracowników i najświeższymi odnotowanymi dla nich danymi.

## Zadanie 4 (Przykład użycia)

Użyć migawek i funkcji z zadania 3 aby znaleźć sumy wypłat w wybranym miesiącu (zakładamy istnienie odpowiedniej migawki)
