# Use the official Postgres 16 Alpine base image
FROM postgres:16-alpine

# Install necessary build dependencies
RUN apk update && apk add --no-cache \
    git \
    make \
    gcc \
    musl-dev \
    postgresql-dev

RUN apk add --no-cache clang15 llvm15-dev
ENV CC=clang-15
    

# Clone, build, and install pgvector
RUN git clone https://github.com/pgvector/pgvector.git \
    && cd pgvector \
    && make \
    && make install \
    && cd .. \
    && rm -rf pgvector

# (Optional) you can remove build tools if you want a smaller final image
# RUN apk del git make gcc musl-dev postgresql-dev clang llvm-dev

# This ensures Postgres’ default entrypoint runs
# (no change needed from the base image)
