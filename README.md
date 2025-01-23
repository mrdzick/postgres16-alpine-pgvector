# Postgres 16 Alpine with pgvector

This repository provides a Docker image that extends the official Postgres 16 Alpine image by installing [pgvector](https://github.com/pgvector/pgvector). pgvector is an open-source PostgreSQL extension that provides efficient vector operations, enabling you to store embeddings and perform similarity searches.

## Overview
This Dockerfile:
1. Starts from the official postgres:16-alpine image.
2. Installs necessary build dependencies (e.g., git, make, gcc, clang-15, etc.).
3. Clones the [pgvector](https://github.com/pgvector/pgvector) repository.
4. Builds and installs the pgvector extension into the PostgreSQL instance.

This setup is useful for anyone who wants to use Postgres for vector similarity search, such as for machine learning embeddings or other vector-based data operations.

## Features
- **Minimal Image**: Based on the Alpine variant of Postgres 16, keeping the size small.
- **pgvector Support**: Includes pgvector extension for efficient vector operations.
- **Easy Integration**: Can be dropped into any existing workflow that relies on Postgres, with the added benefit of pgvector functionality.

## Requirements
- [Docker](https://docker.com) installed on your system.
- A machine that can run Docker (Linux, macOS, or Windows with Docker Desktop).

## Usage
### Pull from GHCR
A pre-built image is available on GitHub Container Registry (GHCR). You can pull it directly without needing to build from source:

`
  docker pull ghcr.io/mrdzick/postgres16-alpine-pgvector:latest
`
### Build Locally
If you’d prefer to build the image yourself (for example, to customize it), follow these steps:

1. Clone this repository to your local machine:

    ```
    git clone https://github.com/mrdzick/postgres16-alpine-pgvector
    cd postgres16-alpine-pgvector
    ```
2. Build the Docker image:

    `
      docker build -t my-postgres-pgvector:latest .
    `
  
    This command will:
    - Pull the base **postgres:16-alpine** image (if not already available locally).
    - Install all required dependencies.
    - Clone and build the **pgvector** extension.
    - Optionally remove any temporary build files as defined in the Dockerfile.

### Run the Container
Whether you have pulled the image from GHCR or built it locally, you can run a container using the image:

```
docker run --name my_pgvector_container \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  -d my-postgres-pgvector:latest
```
Or, if you pulled from GHCR:

`
docker run --name my_pgvector_container \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -p 5432:5432 \
  -d ghcr.io/mrdzick/postgres16-alpine-pgvector:latest
`

- `--name my_pgvector_container` sets the container name for easier reference.
- `-e POSTGRES_PASSWORD=mysecretpassword` sets the default password for the `postgres` user.
- `-p 5432:5432` maps the default PostgreSQL port inside the container to port 5432 on your host machine.
- `-d` runs the container in the background.

You can then connect to PostgreSQL using:

`
psql -h localhost -p 5432 -U postgres
`

(You will be prompted for the password specified above.)

### Configuration
Like the official Postgres image, you can customize the environment and configuration using the same variables and mount points:
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`, etc.

For a complete list of environment variables, refer to the [official Postgres Docker documentation](https://hub.docker.com/_/postgres).

To enable pgvector in a database, connect to the database and run:

`
CREATE EXTENSION IF NOT EXISTS vector;
`

### Optional Cleanup
If you want a smaller final image (if you're building locally), you can remove build tools after pgvector is installed. Uncomment (or add) the following lines in the Dockerfile:

```# RUN apk del git make gcc musl-dev postgresql-dev clang15 llvm15-dev```

This step will reduce the size of the final image by removing unnecessary build dependencies.
