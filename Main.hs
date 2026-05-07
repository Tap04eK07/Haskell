import Data.List (maximumBy, minimumBy)
import System.IO (hFlush, stdout)

-- Определение основных типов [cite: 12]
data Sale = Sale { 
    name :: String, 
    quantity :: Int, 
    price :: Double 
} deriving (Show, Eq)

-- 1. Подсчёт общей выручки 
totalRevenue :: [Sale] -> Double
totalRevenue sales = sum $ map (\s -> fromIntegral (quantity s) * price s) sales -- [cite: 12]

-- 2. Фильтрация товаров по выручке 
filterByRevenue :: Double -> [Sale] -> [Sale]
filterByRevenue threshold sales = filter (\s -> fromIntegral (quantity s) * price s > threshold) sales -- [cite: 12]

-- Вспомогательная функция для вычисления выручки с одного товара
revenue :: Sale -> Double
revenue s = fromIntegral (quantity s) * price s

-- 3. Поиск наиболее прибыльного товара 
topSale :: [Sale] -> Sale
topSale sales = maximumBy (\a b -> compare (revenue a) (revenue b)) sales -- [cite: 12]

-- 3. Поиск наименее прибыльного товара 
worstSale :: [Sale] -> Sale
worstSale sales = minimumBy (\a b -> compare (revenue a) (revenue b)) sales

-- 4. Загрузка списка продаж из файла 
-- Простой парсинг CSV (разделение по запятой)
parseLine :: String -> Sale
parseLine line =
    let parts = words [if c == ',' then ' ' else c | c <- line] 
    in Sale (parts !! 0) (read (parts !! 1)) (read (parts !! 2))

loadSales :: FilePath -> IO [Sale]
loadSales path = do
    contents <- readFile path
    return $ map parseLine (lines contents)

-- Основное меню приложения [cite: 12]
mainLoop :: [Sale] -> IO ()
mainLoop sales = do
    putStrLn "\n--- Меню Анализа Продаж ---"
    putStrLn "1 - Подсчитать общую выручку"
    putStrLn "2 - Показать товары выше заданного порога выручки"
    putStrLn "3 - Найти наиболее прибыльный товар"
    putStrLn "4 - Найти наименее прибыльный товар"
    putStrLn "5 - Загрузить список продаж из файла"
    putStrLn "0 - Выход"
    putStr "Выберите действие: "
    hFlush stdout
    choice <- getLine
    
    case choice of
        "1" -> do
            putStrLn $ "Общая выручка: " ++ show (totalRevenue sales)
            mainLoop sales
        "2" -> do
            putStr "Введите порог выручки: "
            hFlush stdout
            thresholdStr <- getLine
            let threshold = read thresholdStr :: Double
            putStrLn "Товары, превышающие порог:"
            mapM_ print (filterByRevenue threshold sales)
            mainLoop sales
        "3" -> do
            if null sales
                then putStrLn "Список продаж пуст."
                else putStrLn $ "Наиболее прибыльный товар: " ++ show (topSale sales)
            mainLoop sales
        "4" -> do
            if null sales
                then putStrLn "Список продаж пуст."
                else putStrLn $ "Наименее прибыльный товар: " ++ show (worstSale sales)
            mainLoop sales
        "5" -> do
            putStr "Введите путь к файлу (например, sales.csv): "
            hFlush stdout
            path <- getLine
            newSales <- loadSales path
            putStrLn "Файл успешно загружен!"
            mainLoop newSales
        "0" -> putStrLn "Завершение программы. До свидания!"
        _   -> do
            putStrLn "Неверный ввод. Попробуйте снова."
            mainLoop sales

-- Точка входа в программу
main :: IO ()
main = mainLoop []