# Docker Secrets Directory

This directory is used for storing Docker secrets for local development with Docker Compose.

## Usage

### Local Development with Docker Compose

1. **Create your API key secret file:**
   ```bash
   echo "your_secret_api_key_here" > secrets/api_key.txt
   ```

2. **Update `compose.yaml`:**
   - Comment out the `API_KEY=${API_KEY:-}` line
   - Uncomment the `API_KEY_FILE=/run/secrets/api_key` line
   - Uncomment the `secrets:` section in the service
   - Uncomment the `secrets:` section at the bottom (file-based)

3. **Start the service:**
   ```bash
   docker compose up -d
   ```

### Production Deployment with Docker Swarm

1. **Create a Docker secret:**
   ```bash
   echo "your_production_api_key" | docker secret create api_key -
   ```

2. **Update your stack/compose file:**
   ```yaml
   services:
     api:
       environment:
         - API_KEY_FILE=/run/secrets/api_key
       secrets:
         - api_key

   secrets:
     api_key:
       external: true
   ```

3. **Deploy the stack:**
   ```bash
   docker stack deploy -c compose.yaml youtube-transcript-api
   ```

## Security Notes

- **Never commit actual secret files to git** - they are excluded via `.gitignore`
- Secrets are mounted at `/run/secrets/<secret_name>` inside containers
- The `_FILE` suffix pattern is supported by the `docker-entrypoint.sh` script
- Both `API_KEY` and `API_KEY_FILE` cannot be set simultaneously (error will be thrown)

## File Permissions

For security, ensure secret files have restrictive permissions:
```bash
chmod 600 secrets/api_key.txt
```

## Kubernetes Secrets

For Kubernetes deployments, create secrets using:
```bash
kubectl create secret generic api-key --from-literal=API_KEY=your_secret_key
```

Then mount as environment variable or file in your deployment manifest.
