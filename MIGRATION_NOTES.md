# Database Migration: SQL Server to PostgreSQL

## Overview

This project has been successfully migrated from Microsoft SQL Server to PostgreSQL. All SQL scripts have been converted and the Python database layer has been updated to use PostgreSQL.

## Key Changes

### 1. SQL Scripts Converted

#### `database/20262204-01-init.sql`
**SQL Server → PostgreSQL changes:**
- ❌ Removed: `IF DB_ID(N'PanneauSolaireDB') IS NULL` and `BEGIN...END` blocks
- ❌ Removed: `GO` batch separator (PostgreSQL doesn't use it)
- ❌ Replaced: `INT IDENTITY(1,1)` → `SERIAL`
- ❌ Replaced: `NVARCHAR(n)` → `VARCHAR(n)`
- ❌ Replaced: `FLOAT` → `REAL`
- ❌ Replaced: `TIME(0)` → `TIME`
- ✅ Added: `CREATE TABLE IF NOT EXISTS` for idempotency
- ✅ Improved: Inline foreign key definitions (cleaner syntax)

#### `database/20262204-01-data.sql`
**Fixes:**
- ✅ Fixed: Malformed INSERT statements (missing commas, extra parentheses)
- ✅ Fixed: Removed invalid `insert into` statement fragment
- ✅ Removed: All `GO` batch separators
- ✅ Removed: N-prefix from strings (SQL Server Unicode notation)
- ✅ Corrected: Model IDs in INSERT statements (changed from hardcoded `3` to actual IDs `1` and `2`)

### 2. Python Database Layer

#### `app/database.py`
**Connection Changes:**
- ❌ Removed: `mssql+pyodbc://sa:Sqlserver123!@localhost:1433/...`
- ✅ Added: Support for environment variables: `PANNEAU_DATABASE_URL` or `DATABASE_URL`
- ✅ Added: Default PostgreSQL connection: `postgresql+psycopg2://postgres:postgres@localhost:5432/PanneauSolaireDB`
- ✅ Added: Missing `import os` for environment variable access

#### `requirements.txt`
- ✅ Already contains: `psycopg2-binary>=2.9.0` (PostgreSQL adapter)
- ✅ Already contains: `SQLAlchemy>=2.0.0` (ORM)

### 3. Configuration Files

#### `.env.example`
- ✅ New file: Template for database connection configuration
- Provides clear examples for both `PANNEAU_DATABASE_URL` and `DATABASE_URL`

#### `POSTGRESQL_SETUP.md`
- ✅ New file: Comprehensive PostgreSQL setup guide
- Includes installation steps for all major platforms
- Contains troubleshooting section
- Provides backup/restore procedures

## Data Type Mapping

| SQL Server | PostgreSQL | Notes |
|-----------|-----------|-------|
| `INT IDENTITY(1,1)` | `SERIAL` | Auto-incrementing integer |
| `NVARCHAR(n)` | `VARCHAR(n)` | Variable-length text |
| `FLOAT` | `REAL` | Single-precision floating point |
| `TIME(0)` | `TIME` | No microseconds |

## Compatibility

### Python ORM Layer
✅ **No changes required** to SQLAlchemy models:
- All model definitions use database-agnostic column types
- `Column(Integer, primary_key=True, autoincrement=True)` works with both systems
- Foreign key relationships are unchanged

### Application Code
✅ **Fully compatible** - No changes to application logic:
- The `session_scope()` context manager works identically
- All query operations are database-agnostic
- Exception handling unchanged

## Migration Steps for Existing Data

If you have existing SQL Server data to migrate:

1. **Export data from SQL Server:**
   ```bash
   # Use SQL Server Management Studio or sqlcmd
   bcp dbo.modelePanneau out modelePanneau.dat -T
   ```

2. **Convert the data** (if needed - may require format conversion)

3. **Import to PostgreSQL:**
   ```sql
   COPY modelePanneau FROM '/path/to/modelePanneau.dat';
   ```

Or use third-party tools like:
- [pgAdmin](https://www.pgadmin.org/) - Visual interface for PostgreSQL
- [DBeaver](https://dbeaver.io/) - Multi-database tool with import/export

## Verification Checklist

- [ ] PostgreSQL installed and running
- [ ] Database `PanneauSolaireDB` created
- [ ] `database/20262204-01-init.sql` executed successfully
- [ ] `database/20262204-01-data.sql` executed (if sample data desired)
- [ ] `requirements.txt` dependencies installed
- [ ] Environment variable set: `PANNEAU_DATABASE_URL` (optional)
- [ ] Application starts without DB connection errors
- [ ] All forms and queries work as expected

## Rollback

If you need to revert to SQL Server:

1. Restore `app/database.py` connection string to:
   ```python
   'mssql+pyodbc://sa:Sqlserver123!@localhost:1433/PanneauSolaireDB?driver=ODBC+Driver+17+for+SQL+Server'
   ```

2. Install SQL Server ODBC driver (if not present)

3. Restore database from SQL Server backup

## Support

For PostgreSQL setup issues, see [POSTGRESQL_SETUP.md](./POSTGRESQL_SETUP.md)

For application issues, check:
- `app/database.py` for connection configuration
- `app/models/*.py` for data model definitions
- Application logs for detailed error messages
