# Authentication API

## Requirements
- Node.js
- PostgreSQL
- npm
- Docker
- Docker Compose
- Ubuntu 22.04

## Install Docker on Ubuntu 22.04

1. Run the installation script:
```bash
chmod +x install_docker.sh
sudo ./install_docker.sh
```


## Install Application

1. Clone the repository
 ```bash
git clone https://github.com/lumecore/reqistApi.git
cd reqistApi
```
3. Install dependencies:
```bash
npm install
```

3. Create `.env` file:
```
DB_HOST=postgres
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=auth_db
JWT_SECRET=your_jwt_secret_key
PORT=3000
```

## Run Project

### With Docker
```bash
docker compose up --build -d
```


### Manual Testing
1. Register:
```bash
curl -X POST http://localhost:3000/api/auth/register -H "Content-Type: application/json" -d '{"username":"testuser","email":"test@example.com","password":"Password123"}'
```

2. Login:
```bash
curl -X POST http://localhost:3000/api/auth/login -H "Content-Type: application/json" -d '{"email":"test@example.com","password":"Password123"}'
```

3. Protected Route:
```bash
curl -X GET http://localhost:3000/api/auth/protected -H "Authorization: Bearer <JWT_TOKEN>"
```

Password requirements: minimum 8 characters, English letters, digits (validated via Joi).
Email requirements: valid format (validated via Joi).
Username requirements: 3 to 50 characters.
