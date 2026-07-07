# PostgreSQL Setup Guide

This project has been converted from SQL Server to PostgreSQL. Follow these steps to set up and run the application.

## Prerequisites

- PostgreSQL 12 or higher installed and running
- Python 3.8+
- pip package manager

## Step 1: Install PostgreSQL

### On Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

### On macOS (using Homebrew)
```bash
brew install postgresql
brew services start postgresql
```

### On Windows
Download and install from [postgresql.org](https://www.postgresql.org/download/windows/)

## Step 2: Create the Database

Connect to PostgreSQL as the default `postgres` user:

```bash
psql -U postgres
```

Then create the database and user:

```sql
-- Create the database
CREATE DATABASE "PanneauSolaireDB";

-- Create a dedicated user (optional but recommended)
CREATE USER panneau_user WITH PASSWORD 'your_secure_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE "PanneauSolaireDB" TO panneau_user;
```

Exit psql:
```
\q
```

## Step 3: Initialize the Database Schema

Run the initialization script to create all tables:

```bash
psql -U postgres -d PanneauSolaireDB -f database/20262204-01-init.sql
```

Or if using a custom user:
```bash
psql -U panneau_user -d PanneauSolaireDB -f database/20262204-01-init.sql
```

## Step 4: Load Sample Data (Optional)

To populate the database with sample data:

```bash
psql -U postgres -d PanneauSolaireDB -f database/20262204-01-data.sql
```

## Step 5: Configure Python Environment

### Install Python Dependencies

```bash
# Create a virtual environment (recommended)
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### Configure Database Connection

The application can be configured in three ways (in order of priority):

1. **Environment Variable (Recommended for production)**
```bash
export PANNEAU_DATABASE_URL="postgresql+psycopg2://panneau_user:your_secure_password@localhost:5432/PanneauSolaireDB"
```

2. **Alternative Environment Variable**
```bash
export DATABASE_URL="postgresql+psycopg2://panneau_user:your_secure_password@localhost:5432/PanneauSolaireDB"
```

3. **Default Configuration (Development)**
The application defaults to:
```
postgresql+psycopg2://postgres:postgres@localhost:5432/PanneauSolaireDB
```

## Step 6: Verify the Connection

Test the connection by running the application:

```bash
python main.py
```

If the application starts without database connection errors, your setup is complete!

## Troubleshooting

### Connection Refused Error
```
psycopg2.OperationalError: could not connect to server: Connection refused
```
**Solution:** Ensure PostgreSQL is running:
```bash
# Linux
sudo systemctl start postgresql

# macOS
brew services start postgresql
```

### Authentication Failed
```
psycopg2.OperationalError: FATAL: password authentication failed for user "postgres"
```
**Solution:** Check your credentials in the connection URL. Default password is empty for `postgres` user on new installs.

### Database Does Not Exist
```
psycopg2.OperationalError: database "PanneauSolaireDB" does not exist
```
**Solution:** Run Step 2 (Create the Database) above.

### psycopg2 Not Installed
```
ModuleNotFoundError: No module named 'psycopg2'
```
**Solution:** Install dependencies:
```bash
pip install -r requirements.txt
```

## Backup and Restore

### Backup the Database
```bash
pg_dump -U postgres PanneauSolaireDB > backup_panneau.sql
```

### Restore from Backup
```bash
psql -U postgres -d PanneauSolaireDB -f backup_panneau.sql
```

## Additional Resources

- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [psycopg2 Documentation](https://www.psycopg.org/)
- [SQLAlchemy PostgreSQL Dialects](https://docs.sqlalchemy.org/en/20/dialects/postgresql.html)
