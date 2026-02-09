# Docker Deployment Guide

This guide explains how to build and run the xiaozhi-esp32-server application using Docker.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- At least 8GB RAM available for containers

## Quick Start (Local Development)

```bash
# Navigate to main directory
cd main

# Copy environment file
cp .env.local .env

# Build and start all services
docker-compose -f docker-compose.local.yml up -d --build

# View logs
docker-compose -f docker-compose.local.yml logs -f
```

## Access Points

| Service    | URL                                      |
| ---------- | ---------------------------------------- |
| Web Admin  | http://localhost:8080                    |
| API        | http://localhost:8002                    |
| WebSocket  | ws://localhost:8000/xiaozhi/v1/          |
| Vision API | http://localhost:8003/mcp/vision/explain |

## Environment Files

| File              | Purpose                                |
| ----------------- | -------------------------------------- |
| `.env.local`      | Local development (default passwords)  |
| `.env.staging`    | Staging environment                    |
| `.env.production` | Production (secure passwords required) |

## Commands

### Local Development

```bash
docker-compose -f docker-compose.local.yml up -d --build
docker-compose -f docker-compose.local.yml down
docker-compose -f docker-compose.local.yml logs -f [service]
```

### Staging

```bash
cp .env.staging .env
# Edit .env with staging credentials
docker-compose -f docker-compose.staging.yml up -d --build
```

### Production

```bash
cp .env.production .env
# Edit .env with SECURE production credentials
docker-compose -f docker-compose.production.yml up -d --build
```

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Docker Network                        │
├─────────────┬─────────────┬──────────────┬─────────────────┤
│ xiaozhi-web │ manager-api │ xiaozhi-srv  │                 │
│   (nginx)   │  (java 21)  │ (python)     │                 │
│   :80/8080  │    :8002    │ :8000/:8003  │                 │
├─────────────┴──────┬──────┴──────────────┤                 │
│                    │                     │                 │
│            ┌───────┴───────┐             │                 │
│            │   xiaozhi-db  │  xiaozhi-redis               │
│            │   (mysql:8)   │  (redis:8)                   │
│            │     :3306     │    :6379                     │
│            └───────────────┴─────────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

## Volumes

| Volume                    | Purpose                |
| ------------------------- | ---------------------- |
| `xiaozhi-mysql-*`         | MySQL data persistence |
| `xiaozhi-redis-*`         | Redis AOF persistence  |
| `uploadfile-*`            | User uploaded files    |
| `./xiaozhi-server/data`   | Server data files      |
| `./xiaozhi-server/models` | AI models              |
