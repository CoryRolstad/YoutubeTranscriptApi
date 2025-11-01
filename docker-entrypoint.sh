#!/usr/bin/env bash
# Docker entrypoint script for YouTube Transcript API
# Implements _FILE suffix pattern for Docker secrets support
# Based on official PostgreSQL/MySQL docker-entrypoint.sh pattern

set -Eeo pipefail

# file_env: Load environment variable from file (Docker secrets pattern)
# Usage: file_env VAR [DEFAULT]
#
# If both $VAR and ${VAR}_FILE are set, this is an error.
# If ${VAR}_FILE is set, read the file and set $VAR to its contents.
# If neither is set, use DEFAULT value (if provided).
#
# This allows using Docker secrets by setting API_KEY_FILE=/run/secrets/api_key
# instead of directly exposing API_KEY in environment variables.
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"

    # Check if both VAR and VAR_FILE are set (mutually exclusive)
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi

    local val="$def"

    # Use direct environment variable if set
    if [ "${!var:-}" ]; then
        val="${!var}"
    # Otherwise, read from file if FILE variant is set
    elif [ "${!fileVar:-}" ]; then
        if [ ! -f "${!fileVar}" ]; then
            echo >&2 "error: file '${!fileVar}' (from $fileVar) does not exist"
            exit 1
        fi
        val="$(< "${!fileVar}")"
    fi

    export "$var"="$val"
    unset "$fileVar"
}

# Process environment variables that support _FILE suffix
file_env 'API_KEY'

# Execute the main command (defaults to uvicorn)
exec "$@"
