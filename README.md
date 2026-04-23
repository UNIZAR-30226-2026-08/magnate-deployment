# magnate-deployment

Magnate infrastructure repository

## Setup 

Magnate requires a `.env` file in the root directory. Here is an example:

```bash
# PostgreSQL
POSTGRES_DB=db_magnate
POSTGRES_USER=admin_magnate
POSTGRES_PASSWORD="unsafe_password"
DB_HOST=db
DB_PORT=5433

# Django
SECRET_KEY="another_unsafe_password"
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1
```
