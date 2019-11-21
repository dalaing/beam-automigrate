module Database.Beam.Migrate.Types where

import           Data.Map                       ( Map )
import           Data.Set                       ( Set )
import           Data.Text                      ( Text )

--
-- Types (sketched)
--

data Schema = Schema { schemaName   :: SchemaName
                     , schemaTables :: Tables
                     } deriving Show

type Tables = Map TableName Table

newtype SchemaName = SchemaName { unSchemaName :: Text } deriving Show

newtype TableName = TableName { tableName :: Text } deriving (Show, Eq, Ord)

newtype Table = Table { tableColumns :: Map ColumnName Column } deriving Show

instance Semigroup Table where
  (Table t1) <> (Table t2) = Table (t1 <> t2)

instance Monoid Table where
  mempty = Table mempty

newtype ColumnName = ColumnName { columnName :: Text } deriving (Show, Eq, Ord)

data Column = Column {
    columnType       :: ColumnType
  , columnConstrains :: Set ColumnConstraint
  } deriving Show

-- | Basic types for columns, everything is very naive for now.
type ColumnType = ()

noColumnConstraints :: Set ColumnConstraint
noColumnConstraints = mempty

data ColumnConstraint =
    PrimaryKey
    -- ^ This 'Column' is the Table's primary key.
    deriving (Show, Eq, Ord)

-- | A possible list of edits on a 'Schema'.
data Edit =
    ColumnAdded TableName ColumnName Column
  | ColumnRemoved TableName ColumnName
  | TableAdded TableName Table
  | TableRemoved TableName

-- | A possible enumerations of the reasons why a 'diff' operation might not work.
data DiffError =
    AutomaticDiffNotPossible
    -- ^ The diff couldn't be completed. TODO(adn) We need extra information
    -- we can later on reify into the raw SQL queries users can try to run
    -- themselves.
