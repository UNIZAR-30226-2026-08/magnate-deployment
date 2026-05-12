# magnate-deployment

Magnate infrastructure repository

## Setup 

Magnate requires a `.env` file in the root directory. Here is an example:

```bash
# PostgreSQL
DB_PASSWORD="unsafe_password"

# Django
SECRET_KEY="another_unsafe_password"
ALLOWED_HOSTS=localhost,127.0.0.1,your-domain.com

# Ports
FRONTEND_HTTP_PORT=80
FRONTEND_HTTPS_PORT=443

BACKEND_HOST="hostname:port/route"

SSL_BACKEND_IP=local-backend-ip
SSL_DOMAIN=your-domain.com

# Build names
LINUX_RELEASE_BINARY=Magnate.x86_64
WINDOWS_RELEASE_BINARY=Magnate.exe
MACOS_RELEASE_BINARY=Magnate.zip

```
