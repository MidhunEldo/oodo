# Dockerized Odoo 16 Setup

This repository contains all necessary files to run Odoo 16 in Docker containers.

## Files Overview

- `Dockerfile`: Builds the Odoo container using Python 3.8
- `docker-compose.yml`: Orchestrates Odoo and PostgreSQL services
- `odoo.conf`: Configuration settings for Odoo
- `entrypoint.sh`: Script that runs when the container starts
- `requirements-docker.txt`: Python dependencies with fixed versions
- `.dockerignore`: Prevents unnecessary files from being included
- `setup.sh`: Script to create necessary directories

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1. **Create required directories**:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

2. **Make the entrypoint script executable**:
   ```bash
   chmod +x entrypoint.sh
   ```

3. **Build and start the containers**:
   ```bash
   docker-compose up -d
   ```

4. **Access Odoo**:
   Open your web browser and go to: http://localhost:8069

## File Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── odoo.conf
├── entrypoint.sh
├── requirements-docker.txt
├── .dockerignore
├── setup.sh
├── custom-addons/  # Place your custom modules here
└── data/           # Odoo data storage
```

## Configuration

### Database Settings

The PostgreSQL settings are defined in `docker-compose.yml`:

```yaml
environment:
  - POSTGRES_USER=odoo
  - POSTGRES_PASSWORD=odoo
  - POSTGRES_DB=postgres
```

You should change these values for production use.

### Odoo Configuration

The main Odoo settings are in `odoo.conf`. You can modify this file to suit your needs.

## Custom Modules

Place your custom Odoo modules in the `custom-addons` directory. After adding new modules, restart the Odoo container:

```bash
docker-compose restart odoo
```

## Backup and Restore

**Backup Database**:
```bash
docker exec -t odoo-docker_db_1 pg_dump -U odoo DATABASE_NAME > backup.sql
```

**Restore Database**:
```bash
cat backup.sql | docker exec -i odoo-docker_db_1 psql -U odoo DATABASE_NAME
```

## Logs

**View Odoo logs**:
```bash
docker-compose logs -f odoo
```

**View PostgreSQL logs**:
```bash
docker-compose logs -f db
```

## Troubleshooting

### Can't connect to the database

If Odoo can't connect to the database, check:
1. The PostgreSQL container is running: `docker ps`
2. The database credentials in `odoo.conf` match those in `docker-compose.yml`
3. The database network is working: `docker network ls`

### Changes not showing up

If your configuration changes aren't taking effect:
1. Restart the containers: `docker-compose restart`
2. If necessary, rebuild: `docker-compose up -d --build`

## Production Use

For production environments:
1. Change default passwords in `docker-compose.yml` and `odoo.conf`
2. Use volumes for persistent storage
3. Set up proper backups
4. Consider implementing SSL termination with a reverse proxy
