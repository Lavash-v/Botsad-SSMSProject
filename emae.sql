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

-- Работники бот.сада (кураторы растений)
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    Position NVARCHAR(100) NULL,         -- Должность
    Phone NVARCHAR(30) NULL,
    Email NVARCHAR(100) NULL
);

-- Растения
CREATE TABLE Plants (
    PlantID INT IDENTITY(1,1) PRIMARY KEY,
    InventoryNumber NVARCHAR(30) NOT NULL UNIQUE, -- Инвентарный номер (бирка)
    RussianName NVARCHAR(150) NOT NULL,
    LatinName NVARCHAR(150) NOT NULL,
    Variety NVARCHAR(100) NULL,           -- Сорт
    FamilyID INT NOT NULL,
    LifeFormID INT NOT NULL,
    NativeRegion NVARCHAR(150) NULL,      -- Родина растения
    SourceID INT NOT NULL,
    SourceDescription NVARCHAR(500) NULL, -- Подробное описание источника
    LocationID INT NOT NULL,
    CuratorID INT NULL,                   -- Куратор растения
    AcquiredDate DATE NULL,               -- Дата поступления
    PlantingDate DATE NULL,               -- Дата высадки
    Status NVARCHAR(30) NOT NULL DEFAULT 'Активно', -- Активно/Погибло/Передано/Архив
    PhotoUrl NVARCHAR(300) NULL,          -- Основное фото (обложка)

    CONSTRAINT FK_Plants_Families FOREIGN KEY (FamilyID) 
        REFERENCES Families(FamilyID) ON DELETE CASCADE,

    CONSTRAINT FK_Plants_LifeForms FOREIGN KEY (LifeFormID) 
        REFERENCES LifeForms(LifeFormID) ON DELETE CASCADE,

    CONSTRAINT FK_Plants_Sources FOREIGN KEY (SourceID) 
        REFERENCES Sources(SourceID) ON DELETE CASCADE,

    CONSTRAINT FK_Plants_Locations FOREIGN KEY (LocationID) 
        REFERENCES Locations(LocationID) ON DELETE CASCADE,

    CONSTRAINT FK_Plants_Employees FOREIGN KEY (CuratorID) 
        REFERENCES Employees(EmployeeID) ON DELETE SET NULL
);

-- Фотографии растений (галерея)
CREATE TABLE PlantPhotos (
    PhotoID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT NOT NULL,
    PhotoUrl NVARCHAR(300) NOT NULL,
    Caption NVARCHAR(200) NULL,           -- Подпись
    TakenDate DATE NULL,                  -- Дата съёмки

    CONSTRAINT FK_PlantPhotos_Plants FOREIGN KEY (PlantID) 
        REFERENCES Plants(PlantID) ON DELETE CASCADE
);

-- История перемещений растений
CREATE TABLE Transfers (
    TransferID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT NOT NULL,
    FromLocationID INT NULL,              -- Откуда (NULL — первичное размещение)
    ToLocationID INT NOT NULL,            -- Куда
    TransferDate DATE NOT NULL,
    Reason NVARCHAR(300) NULL,            -- Причина перемещения
    EmployeeID INT NULL,                  -- Кто выполнил

    CONSTRAINT FK_Transfers_Plants FOREIGN KEY (PlantID) 
        REFERENCES Plants(PlantID) ON DELETE CASCADE,

    CONSTRAINT FK_Transfers_FromLocation FOREIGN KEY (FromLocationID) 
        REFERENCES Locations(LocationID) ON DELETE NO ACTION,

    CONSTRAINT FK_Transfers_ToLocation FOREIGN KEY (ToLocationID) 
        REFERENCES Locations(LocationID) ON DELETE NO ACTION,

    CONSTRAINT FK_Transfers_Employees FOREIGN KEY (EmployeeID) 
        REFERENCES Employees(EmployeeID) ON DELETE SET NULL
);

-- Наблюдения
CREATE TABLE Observations (
    ObservationID INT IDENTITY(1,1) PRIMARY KEY,
    PlantID INT NOT NULL,
    ObservationDate DATE NOT NULL,
    ObservationType NVARCHAR(50) NULL,    -- Полив/Осмотр/Болезнь/Пересадка/Цветение
    HealthState NVARCHAR(30) NULL,        -- Хорошее/Удовлетворительное/Болезнь/Вредители
    Temperature DECIMAL(4,1) NULL,        -- Температура (°C)
    Humidity INT NULL,                    -- Влажность (%)
    WateringVolumeMl INT NULL,            -- Объём полива (мл)
    IsBlooming BIT NOT NULL DEFAULT 0,    -- Признак цветения
    Notes NVARCHAR(500) NULL,             -- Примечание

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

INSERT INTO Employees (FullName, Position, Phone, Email) VALUES
('Иванова Анна Петровна', 'Старший научный сотрудник', '+7-900-111-22-33', 'ivanova@botsad.ru'),
('Петров Сергей Николаевич', 'Садовник', '+7-900-222-33-44', 'petrov@botsad.ru'),
('Сидорова Мария Ивановна', 'Куратор коллекции', '+7-900-333-44-55', 'sidorova@botsad.ru');


INSERT INTO Plants 
(InventoryNumber, RussianName, LatinName, Variety, FamilyID, LifeFormID, 
 NativeRegion, SourceID, SourceDescription, LocationID, CuratorID, 
 AcquiredDate, PlantingDate, Status, PhotoUrl) 
VALUES
('BS-2025-0001', 'Бальзамин бальзаминовый', 'Impatiens balsamina', 'Том Самб', 1, 3, 
 'Южная Азия', 1, 'Получен в подарок от ботанического сада в 2025 году.', 3, 1, 
 '2025-03-10', '2025-03-15', 'Активно', '/photos/bs-2025-0001.jpg'),

('BS-2023-0002', 'Лимон', 'Citrus limo', 'Мейер', 2, 1, 
 'Китай', 2, 'Закуплен в питомнике "Зеленый сад" в 2023 году.', 1, 2, 
 '2023-04-01', '2023-04-05', 'Активно', '/photos/bs-2023-0002.jpg'),

('BS-2022-0003', 'Роза морщинистая', 'Rosa rugosa', 'Альба', 3, 2, 
 'Дальний Восток', 6, 'Собрана во время экспедиции 2022 года.', 4, 3, 
 '2022-08-20', '2022-09-01', 'Активно', NULL),

('BS-2024-0004', 'Плющ обыкновенный', 'Hedera helix', NULL, 4, 4, 
 'Европа', 4, 'Передан коллекционером.', 2, 1, 
 '2024-02-14', '2024-02-20', 'Активно', NULL),

('BS-2023-0005', 'Фикус бенджамина', 'Ficus benjamina', 'Кинки', 4, 1, 
 'Юго-Восточная Азия', 2, 'Приобретен в питомнике.', 1, 2, 
 '2023-05-10', '2023-05-12', 'Активно', NULL),

('BS-2021-0006', 'Алоэ древовидное', 'Aloe arborescens', NULL, 6, 5, 
 'Южная Африка', 7, 'Выращено из собственного черенка.', 2, 1, 
 '2021-06-01', '2021-06-05', 'Активно', NULL),

('BS-2020-0007', 'Лаванда узколистная', 'Lavandula angustifolia', 'Вознесенская', 5, 2, 
 'Средиземноморье', 3, 'Получена из заповедника.', 5, 3, 
 '2020-04-15', '2020-04-20', 'Активно', NULL),

('BS-2024-0008', 'Гибискус китайский', 'Hibiscus rosa-sinensis', 'Купера', 7, 2, 
 'Восточная Азия', 5, 'Подарок от сотрудников университета.', 1, 2, 
 '2024-03-08', '2024-03-12', 'Активно', NULL),

('BS-2024-0009', 'Монстера деликатесная', 'Monstera deliciosa', NULL, 4, 4, 
 'Центральная Америка', 1, 'Обмен коллекционными экземплярами в 2024 году.', 1, 1, 
 '2024-04-01', '2024-04-03', 'Активно', NULL),

('BS-2023-0010', 'Арктотис стехасолистный', 'Arctotis stoechadifolia', NULL, 8, 3, 
 'Южная Африка', 7, 'Семенное размножение.', 4, 3, 
 '2023-03-20', '2023-04-01', 'Активно', NULL),

('BS-2026-0011', 'Базилик душистый', 'Ocimum basilicum', 'Фиолетовый', 5, 3, 
 'Индия', 7, 'Выращено из семян в 2026 году.', 5, 2, 
 '2026-02-10', '2026-02-15', 'Активно', NULL);


INSERT INTO PlantPhotos (PlantID, PhotoUrl, Caption, TakenDate) VALUES
(1, '/photos/bs-2025-0001_main.jpg', 'Общий вид', '2026-05-01'),
(1, '/photos/bs-2025-0001_flower.jpg', 'Цветение', '2026-05-18'),
(2, '/photos/bs-2023-0002_main.jpg', 'Общий вид', '2026-04-20'),
(2, '/photos/bs-2023-0002_fruit.jpg', 'Плоды', '2026-06-02'),
(3, '/photos/bs-2022-0003_main.jpg', 'Куст в открытом грунте', '2026-05-15');


INSERT INTO Transfers (PlantID, FromLocationID, ToLocationID, TransferDate, Reason, EmployeeID) VALUES
(1, 3, 3, '2025-03-15', 'Первичное размещение', 1),
(2, 1, 1, '2023-04-05', 'Первичное размещение', 2),
(2, 1, 3, '2024-10-01', 'Перенос в комнату селекции на зимовку', 2),
(2, 3, 1, '2025-04-10', 'Возврат в оранжерею', 2),
(3, NULL, 4, '2022-09-01', 'Первичная высадка в открытый грунт', 3),
(5, 2, 1, '2025-05-20', 'Перемещение в тропический блок', 1);


INSERT INTO Observations 
(PlantID, ObservationDate, ObservationType, HealthState, Temperature, Humidity, 
 WateringVolumeMl, IsBlooming, Notes) 
VALUES
(1, '2026-05-15', 'Осмотр', 'Хорошее', 22.0, 60, 500, 1, 'Появились первые бутоны.'),
(1, '2026-05-20', 'Цветение', 'Хорошее', 24.0, 58, 400, 1, 'Началось активное цветение.'),
(2, '2026-05-10', 'Полив', 'Хорошее', 21.5, 65, 1000, 0, 'Проведена плановая подкормка.'),
(2, '2026-06-01', 'Цветение', 'Хорошее', 25.0, 60, 1200, 1, 'Появились первые цветы.'),
(3, '2026-05-18', 'Осмотр', 'Хорошее', 18.0, 70, 800, 0, 'Начало активного роста побегов.'),
(6, '2026-05-12', 'Полив', 'Хорошее', 23.0, 40, 200, 0, 'Состояние хорошее, полив умеренный.'),
(8, '2026-05-22', 'Цветение', 'Хорошее', 24.5, 65, 600, 1, 'Распустился крупный бутон.'),
(5, '2026-05-25', 'Осмотр', 'Болезнь', 24.0, 55, 300, 0, 'Обнаружены следы щитовки, требуется обработка.'),
(5, '2026-06-05', 'Осмотр', 'Удовлетворительное', 24.5, 55, 300, 0, 'После обработки, состояние улучшается.');
GO*/

-- Запросики

SELECT * FROM Plants;
GO

-- все растения по имени на ру и латыни 
SELECT RussianName, LatinName 
FROM Plants;
GO

-- все яснотковые
SELECT PlantID, RussianName, LatinName, FamilyName
FROM Plants
JOIN Families ON Plants.FamilyID = Families.FamilyID
WHERE FamilyName = 'Яснотковые';
GO

-- все кустарники
SELECT PlantID, RussianName, FormName
FROM Plants
JOIN LifeForms ON Plants.LifeFormID = LifeForms.LifeFormID
WHERE FormName = 'Кустарник';
GO

-- все растения азиаты :)
SELECT PlantID, RussianName, LatinName, NativeRegion
FROM Plants
WHERE NativeRegion LIKE '%Азия%';
GO

-- растение + семейство
SELECT PlantID, RussianName, LatinName, FamilyName
FROM Plants
JOIN Families ON Plants.FamilyID = Families.FamilyID;
GO

-- где что растёт
SELECT PlantID, RussianName, Building, Sector, Description
FROM Plants
JOIN Locations ON Plants.LocationID = Locations.LocationID;
GO

-- поиск растения по бирке
SELECT PlantID, InventoryNumber, RussianName, LatinName, Status
FROM Plants
WHERE InventoryNumber = 'BS-2023-0002';
GO

-- только активные растения
SELECT InventoryNumber, RussianName, LatinName, Status
FROM Plants
WHERE Status = N'Активно'
ORDER BY InventoryNumber;
GO

-- архивные / погибшие
SELECT InventoryNumber, RussianName, Status, AcquiredDate
FROM Plants
WHERE Status != 'Активно';
GO

-- сколько растений в каждом статусе
SELECT Status, COUNT(*) AS Cnt
FROM Plants
GROUP BY Status;
GO

-- растения, поступившие за последний год
SELECT InventoryNumber, RussianName, AcquiredDate
FROM Plants
WHERE AcquiredDate >= '2025-10-07'
ORDER BY AcquiredDate DESC;
GO

-- все растения с указанием куратора
SELECT InventoryNumber, RussianName, FullName AS Curator
FROM Plants
LEFT JOIN Employees ON Plants.CuratorID = Employees.EmployeeID
ORDER BY FullName;
GO

-- все растения конкретного куратора
SELECT InventoryNumber, RussianName, LatinName
FROM Plants
JOIN Employees ON Plants.CuratorID = Employees.EmployeeID
WHERE FullName = 'Иванова Анна Петровна';
GO

-- cколько растений у каждого куратора
SELECT FullName, COUNT(PlantID) AS PlantCount
FROM Employees
LEFT JOIN Plants ON Plants.CuratorID = Employees.EmployeeID
GROUP BY FullName
ORDER BY PlantCount DESC;
GO

-- растения БЕЗ куратора
SELECT InventoryNumber, RussianName
FROM Plants
WHERE CuratorID IS NULL;
GO

-- куратор + контакты для конкретного растения
SELECT InventoryNumber, RussianName,
       FullName, Position, Phone, Email
FROM Plants
JOIN Employees ON Plants.CuratorID = Employees.EmployeeID
WHERE InventoryNumber = 'BS-2023-0002';
GO

-- все фото конкретного растения
SELECT PlantPhotos.PhotoID, Plants.RussianName,
       PlantPhotos.PhotoUrl,                -- ← фото из галереи
       PlantPhotos.Caption, PlantPhotos.TakenDate
FROM PlantPhotos
JOIN Plants ON PlantPhotos.PlantID = Plants.PlantID
WHERE Plants.InventoryNumber = 'BS-2025-0001'
ORDER BY PlantPhotos.TakenDate;

-- сколько фото у каждого растения
SELECT InventoryNumber, RussianName, COUNT(PhotoID) AS PhotoCount
FROM Plants
LEFT JOIN PlantPhotos ON PlantPhotos.PlantID = Plants.PlantID
GROUP BY InventoryNumber, RussianName
ORDER BY PhotoCount DESC;
GO

-- растения вообще без фотографий
SELECT InventoryNumber, RussianName
FROM Plants
LEFT JOIN PlantPhotos ON PlantPhotos.PlantID = Plants.PlantID
WHERE PhotoID IS NULL;
GO

-- обложка + количество фото в галерее
SELECT InventoryNumber, RussianName,
       Plants.PhotoUrl AS CoverPhoto,
       COUNT(PlantPhotos.PhotoID) AS GalleryCount
FROM Plants
LEFT JOIN PlantPhotos ON PlantPhotos.PlantID = Plants.PlantID
GROUP BY Plants.InventoryNumber, Plants.RussianName, Plants.PhotoUrl;
GO

-- вся история перемещений конкретного растения
SELECT TransferDate,
       FromLoc.Building AS FromBuilding, FromLoc.Sector AS FromSector, -- откуда переехало
       ToLoc.Building   AS ToBuilding,   ToLoc.Sector   AS ToSector, -- куда переехало
       Reason, FullName AS DoneBy
FROM Transfers
JOIN Plants ON Transfers.PlantID = Plants.PlantID -- присоединяю Plants, чтобы получить доступ к InventoryNumber
LEFT JOIN Locations AS FromLoc ON Transfers.FromLocationID = FromLoc.LocationID
JOIN Locations AS ToLoc ON Transfers.ToLocationID = ToLoc.LocationID
LEFT JOIN Employees ON Transfers.EmployeeID = Employees.EmployeeID -- присоединение работника, который выполнил перемещение
WHERE InventoryNumber = 'BS-2023-0002'
ORDER BY TransferDate;
GO

-- все перемещения за последний год
SELECT InventoryNumber, RussianName, TransferDate, Reason
FROM Transfers
JOIN Plants ON Transfers.PlantID = Plants.PlantID
WHERE TransferDate >= '2025-10-07'
ORDER BY TransferDate DESC;
GO

-- сколько раз переезжало каждое растение
SELECT InventoryNumber, RussianName, COUNT(TransferID) AS Moves
FROM Plants
LEFT JOIN Transfers ON Transfers.PlantID = Plants.PlantID
GROUP BY InventoryNumber, RussianName
ORDER BY Moves DESC;
GO

-- кто чаще всего перемещал растения
SELECT FullName, COUNT(*) AS TransferCount
FROM Transfers
JOIN Employees ON Transfers.EmployeeID = Employees.EmployeeID
GROUP BY FullName
ORDER BY TransferCount DESC;
GO

-- последнее перемещение каждого растения
SELECT InventoryNumber, RussianName, TransferDate AS LastMove, Building, Sector
FROM Plants
JOIN Transfers ON Transfers.PlantID = Plants.PlantID
JOIN Locations ON Plants.LocationID = Locations.LocationID
WHERE TransferDate = (
    SELECT MAX(TransferDate)
    FROM Transfers AS T2
    WHERE T2.PlantID = Plants.PlantID
);
GO

-- все наблюдения по конкретному растению
SELECT ObservationID, RussianName, ObservationDate,
       ObservationType, HealthState,
       Temperature, Humidity, WateringVolumeMl,
       IsBlooming, Notes
FROM Observations
JOIN Plants ON Observations.PlantID = Plants.PlantID
WHERE Observations.PlantID = 1
ORDER BY ObservationDate ASC;
GO

-- все цветущие наблюдения
SELECT RussianName, ObservationDate, Notes
FROM Observations
JOIN Plants ON Observations.PlantID = Plants.PlantID
WHERE IsBlooming = 1;
GO

-- только записи о болезнях
SELECT InventoryNumber, RussianName,
       ObservationDate, HealthState, Notes
FROM Observations
JOIN Plants ON Observations.PlantID = Plants.PlantID
WHERE HealthState IN ('Болезнь', 'Вредители')
ORDER BY ObservationDate DESC;
GO

-- только поливы
SELECT InventoryNumber, RussianName,
       ObservationDate, WateringVolumeMl, Notes
FROM Observations
JOIN Plants ON Observations.PlantID = Plants.PlantID
WHERE ObservationType = 'Полив'
ORDER BY ObservationDate DESC;
GO

-- по типам наблюдений
SELECT ObservationType, COUNT(*) AS Cnt
FROM Observations
GROUP BY ObservationType
ORDER BY Cnt DESC;
GO

-- по состоянию здоровья
SELECT HealthState, COUNT(*) AS Cnt
FROM Observations
GROUP BY HealthState
ORDER BY Cnt DESC;
GO

-- средняя температура и влажность по каждому растению
SELECT InventoryNumber, RussianName,
       AVG(Temperature) AS AvgTemp,
       AVG(Humidity)    AS AvgHumidity
FROM Observations
JOIN Plants ON Observations.PlantID = Plants.PlantID
GROUP BY InventoryNumber, RussianName;


-- общее количество растений
SELECT COUNT(*) AS TotalPlants FROM Plants;
GO

-- полная карточка растения
SELECT InventoryNumber, RussianName, LatinName, Variety,
       FamilyName, FormName, SourceName,
       NativeRegion,
       Building, Sector,
       FullName AS Curator,
       Status, AcquiredDate
FROM Plants
JOIN Families  ON Plants.FamilyID  = Families.FamilyID
JOIN LifeForms ON Plants.LifeFormID = LifeForms.LifeFormID
JOIN Sources   ON Plants.SourceID  = Sources.SourceID
JOIN Locations ON Plants.LocationID = Locations.LocationID
LEFT JOIN Employees ON Plants.CuratorID = Employees.EmployeeID
ORDER BY InventoryNumber;
GO

-- сколько растений в каждой локации
SELECT Building, Sector, COUNT(PlantID) AS PlantCount
FROM Locations
LEFT JOIN Plants ON Plants.LocationID = Locations.LocationID
GROUP BY Building, Sector
ORDER BY PlantCount DESC;
GO

-- сколько растений по семействам
SELECT FamilyName, COUNT(PlantID) AS PlantCount
FROM Families
LEFT JOIN Plants ON Plants.FamilyID = Families.FamilyID
GROUP BY FamilyName
ORDER BY PlantCount DESC;
GO

-- сколько растений по жизненным формам
SELECT FormName, COUNT(PlantID) AS PlantCount
FROM LifeForms
LEFT JOIN Plants ON Plants.LifeFormID = LifeForms.LifeFormID
GROUP BY FormName
ORDER BY PlantCount DESC;
GO
