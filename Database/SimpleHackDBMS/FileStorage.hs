module Database.SimpleHackDBMS.FileStorage where

import Data.Persistence (writeData, writeData_typDed, readData)
import Data.Property (PropertyPredicate, propNot)
import Data.ListX (insertAfter)
import Control.Monad (void)


type TableName = String

allocate :: TableName -> FilePath
allocate tableName = "var/" ++ tableName ++ ".table"

writeTable :: Show record => TableName -> [record] -> IO ()
writeTable = writeData . allocate

writeTable_typDed :: Show record => TableName -> [record] -> IO [record]
writeTable_typDed = writeData_typDed . allocate

readTable :: Read record => TableName -> IO [record]
readTable = readData . allocate

truncateTable :: Show record => TableName -> IO [record]
truncateTable tableName = writeTable_typDed tableName []

modifyTable :: (Read record, Show record) => TableName -> ([record] -> [record]) -> IO [record]
modifyTable tableName f = do
    records <- readTable tableName
    writeTable tableName $ f records
    return records

insertIntoTable :: (Read record, Show record) => TableName -> record -> IO ()
insertIntoTable tableName = void . modifyTable tableName . flip insertAfter

appendToTable :: (Read record, Show record) => TableName -> [record] -> IO ()
appendToTable = mapM_ . insertIntoTable

updateTable :: (Read record, Show record) => TableName -> (record -> record) -> IO [record]
updateTable tableName = modifyTable tableName . map

selectFromTable, deleteFromTable :: (Read record, Show record) => TableName -> PropertyPredicate record -> IO [record]
selectFromTable tableName = modifyTable tableName . filter
deleteFromTable tableName = selectFromTable tableName . propNot
