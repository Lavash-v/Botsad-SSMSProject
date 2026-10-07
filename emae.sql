/*-- Cемейства
CREATE TABLE Families (
    FamilyID INT IDENTITY(1,1) PRIMARY KEY,
    FamilyName NVARCHAR(100) NOT NULL UNIQUE
);

-- Жизненные формы (типа деревья, кустарники или трава)
CREATE TABLE LifeForms (
    LifeFormID INT IDENTITY(1,1) PRIMARY KEY,
    FormName NVARCHAR(50) NOT NULL UNIQUE
);

-- Источники поступления в бот.сад
CREATE TABLE Sources (
    SourceID INT IDENTITY(1,1) PRIMARY KEY,
    SourceName NVARCHAR(100) NOT NULL UNIQUE
);

-- Таблица конкретных местоположений
CREATE TABLE Locations (
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    Building NVARCHAR(100) NOT NULL,     -- Корпус/Помещение
    Sector NVARCHAR(100) NOT NULL,       -- Стеллаж/Участок/Сектор
    Description NVARCHAR(255) NULL       -- Дополнительное описание
);

-- Растения
CREATE TABLE Plants (
    PlantID INT IDENTITY(1,1) PRIMARY KEY,
    RussianName NVARCHAR(150) NOT NULL,
    LatinName NVARCHAR(150) NOT NULL,
    Variety NVARCHAR(100) NULL,           -- Сорт
    FamilyID INT NOT NULL,
    LifeFormID INT NOT NULL,
    NativeRegion NVARCHAR(150) NULL,      -- Родина растения
    SourceID INT NOT NULL,
    SourceDescription NVARCHAR(500) NULL, -- Подробное описание источника
    LocationID INT NOT NULL,

    CONSTRAINT FK_Plants_Families FOREIGN KEY (FamilyID) 
        REFERENCES Families(FamilyID) ON DELETE CASCADE,

    CONSTRAINT FK_Plants_LifeForms FOREIGN KEY (LifeFormID) 
        REFERENCES LifeForms(LifeFormID) ON DELETE CASCADE,

    CONSTRAINT FK_Plants_Sources FOREIGN KEY (SourceID) 
        REFERENCES Sources(SourceID) ON DELETE CASCADE,

    CONSTRAINT FK_Plants_Locations FOREIGN KEY (LocationID) 
        REFERENCES Locations(LocationID) ON DELETE CASCADE
);

-- Наблюдения
CREATE TABLE Observations (
    ObservationID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT NOT NULL,
    ObservationDate DATE NOT NULL,
    Temperature DECIMAL(4,1) NULL,       -- Температура (°C)
    Humidity INT NULL,                   -- Влажность (%)
    WateringVolumeMl INT NULL,           -- Объём полива (мл)
    IsBlooming BIT NOT NULL DEFAULT 0,   -- Признак цветения
    Notes NVARCHAR(500) NULL,            -- Примечание

    CONSTRAINT FK_Observations_Plants FOREIGN KEY (PlantID) 
        REFERENCES Plants(PlantID) ON DELETE CASCADE
);
GO

INSERT INTO Families (FamilyName) VALUES
('Бальзаминовые'),
('Рутовые'),
('Розовые'),
('Ароидные'),
('Яснотковые'),
('Асфоделовые'),
('Мальвовые'),
('Астровые');

INSERT INTO LifeForms (FormName) VALUES
('Дерево'),
('Кустарник'),
('Трава'),
('Лиана'),
('Суккулент');

INSERT INTO Sources (SourceName) VALUES
('Другой ботанический сад'),
('Питомник'),
('Заповедник'),
('Частное лицо'),
('Подарок'),
('Экспедиция'),
('Собственное выращивание');

INSERT INTO Locations (Building, Sector, Description) VALUES
('Оранжерея 1', 'Сектор А', 'Тропический климатический блок'),
('Оранжерея 2', 'Стеллаж 5', 'Субтропический отдел'),
('Корпус 4', 'Стеллаж 2', 'Комната селекции'),
('Открытый грунт', 'Участок 3', 'Альпийская горка'),
('Открытый грунт', 'Участок 7', 'Аптекарский огород');

INSERT INTO Plants (RussianName, LatinName, Variety, FamilyID, LifeFormID, NativeRegion, SourceID, SourceDescription, LocationID) VALUES
('Бальзамин бальзаминовый', 'Impatiens balsamina', 'Том Самб', 1, 3, 'Южная Азия', 1, 'Получен в подарок от ботанического сада в 2025 году.', 3),
('Лимон', 'Citrus limon', 'Мейер', 2, 1, 'Китай', 2, 'Закуплен в питомнике "Зеленый сад" в 2023 году.', 1),
('Роза морщинистая', 'Rosa rugosa', 'Альба', 3, 2, 'Дальний Восток', 6, 'Собрана во время экспедиции 2022 года.', 4),
('Плющ обыкновенный', 'Hedera helix', NULL, 4, 4, 'Европа', 4, 'Передан коллекционером.', 2),
('Фикус бенджамина', 'Ficus benjamina', 'Кинки', 4, 1, 'Юго-Восточная Азия', 2, 'Приобретен в питомнике.', 1),
('Алоэ древовидное', 'Aloe arborescens', NULL, 6, 5, 'Южная Африка', 7, 'Выращено из собственного черенка.', 2),
('Лаванда узколистная', 'Lavandula angustifolia', 'Вознесенская', 5, 2, 'Средиземноморье', 3, 'Получена из заповедника.', 5),
('Гибискус китайский', 'Hibiscus rosa-sinensis', 'Купера', 7, 2, 'Восточная Азия', 5, 'Подарок от сотрудников университета.', 1),
('Монстера деликатесная', 'Monstera deliciosa', NULL, 4, 4, 'Центральная Америка', 1, 'Обмен коллекционными экземплярами в 2024 году.', 1),
('Арктотис стехасолистный', 'Arctotis stoechadifolia', NULL, 8, 3, 'Южная Африка', 7, 'Семенное размножение.', 4),
('Базилик душистый', 'Ocimum basilicum', 'Фиолетовый', 5, 3, 'Индия', 7, 'Выращено из семян в 2026 году.', 5);

INSERT INTO Observations (PlantID, ObservationDate, Temperature, Humidity, WateringVolumeMl, IsBlooming, Notes) VALUES
(1, '2026-05-15', 22.0, 60, 500, 1, 'Появились первые бутоны.'),
(1, '2026-05-20', 24.0, 58, 400, 1, 'Началось активное цветение.'),
(2, '2026-05-10', 21.5, 65, 1000, 0, 'Проведена плановая подкормка.'),
(2, '2026-06-01', 25.0, 60, 1200, 1, 'Появились первые цветы.'),
(3, '2026-05-18', 18.0, 70, 800, 0, 'Начало активного роста побегов.'),
(6, '2026-05-12', 23.0, 40, 200, 0, 'Состояние хорошее, полив умеренный.'),
(8, '2026-05-22', 24.5, 65, 600, 1, 'Распустился крупный бутон.');
GO*/

-- Запросики

SELECT * FROM Plants;

SELECT RussianName, LatinName 
FROM Plants;

SELECT PlantID, RussianName, LatinName, FamilyName
FROM Plants P
JOIN Families F ON P.FamilyID = F.FamilyID
WHERE F.FamilyName = 'Яснотковые';

SELECT P.PlantID, P.RussianName, L.FormName
FROM Plants P
JOIN LifeForms L ON P.LifeFormID = L.LifeFormID
WHERE L.FormName = 'Кустарник';

SELECT PlantID, RussianName, LatinName, NativeRegion
FROM Plants
WHERE NativeRegion LIKE '%Азия%';

SELECT P.PlantID, P.RussianName, P.LatinName, F.FamilyName
FROM Plants P
JOIN Families F ON P.FamilyID = F.FamilyID;

SELECT P.PlantID, P.RussianName, L.Building, L.Sector, L.Description
FROM Plants P
JOIN Locations L ON P.LocationID = L.LocationID;

SELECT O.ObservationID, P.RussianName, O.ObservationDate, O.Temperature, O.Humidity, O.WateringVolumeMl, O.IsBlooming, O.Notes
FROM Observations O
JOIN Plants P ON O.PlantID = P.PlantID
WHERE O.PlantID = 1
ORDER BY O.ObservationDate ASC;

SELECT P.RussianName, O.ObservationDate, O.Notes
FROM Observations O
JOIN Plants P ON O.PlantID = P.PlantID
WHERE O.IsBlooming = 1;

SELECT COUNT(*) AS TotalPlants 
FROM Plants;
