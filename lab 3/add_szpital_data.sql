use szpital;

INSERT INTO Lekarze VALUES
('Janusz','Kowalski',NULL,'gastroenterolog', 3500, NULL),
('Korneliusz','Robaczyński', NULL, 'psycholog kliniczny', 5000, NULL)
GO
-- Poniższa zmiana rodzaju kolumny umożliwi wstawianie pustych wartości w pole ordynatora w tabeli oddziały.
ALTER TABLE Oddzialy
ALTER COLUMN ordynator int null
GO
INSERT INTO Oddzialy VALUES
('Oddzial gastroenterologii', NULL, 700700700, 'Oddzial widmo, przeznaczony do zamkniecia')

GO