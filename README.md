# YouTube Transcript REST API

A REST API wrapper around [youtube-transcript-api](https://pypi.org/project/youtube-transcript-api/) Python package. This API allows you to fetch YouTube video transcripts (subtitles) in various formats.

## Features

- Get transcripts in multiple formats (JSON, Text, WebVTT, SRT)
- List available transcripts for a video
- Optional API key protection
- Docker ready

## Quick Start

One-liner to run with Docker:
```bash
docker run -p 8000:8000 oldgrandpavanu/youtubetranscriptapi:latest
```

## Installation

### Using Docker Compose (recommended)
```bash
# Without API key protection
docker compose up -d

# With API key protection
API_KEY=your_secret_key_here docker compose up -d
```

### Manual Installation
```bash
# Clone repository
git clone https://github.com/yourusername/YoutubeTranscriptApi.git
cd YoutubeTranscriptApi

# Install dependencies
pip install -r requirements.txt

# Run server
uvicorn main:app --reload
```

## API Usage

### Get Transcript
```bash
# JSON format (default)
curl "http://localhost:8000/transcript?video_id=VIDEO_ID&language=en"

# Other formats (text, webvtt, srt)
curl "http://localhost:8000/transcript?video_id=VIDEO_ID&language=en&format=srt"
```

### List Available Transcripts
```bash
curl "http://localhost:8000/transcripts?video_id=VIDEO_ID"
```

### Using API Key (if enabled)
```bash
curl -H "X-API-Key: your_secret_key_here" "http://localhost:8000/transcript?video_id=VIDEO_ID"
```

## API Documentation

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
- OpenAPI JSON: http://localhost:8000/openapi.json

## Environment Variables

- `API_KEY`: Optional. If set, will require this key for protected endpoints.
- `API_KEY_FILE`: Optional. Path to a file containing the API key (recommended for production). Mutually exclusive with `API_KEY`.

## Docker Secrets (Recommended for Production)

For enhanced security, use Docker secrets instead of environment variables. The API supports the `_FILE` suffix pattern used by official Docker images.

### Using Docker Secrets with Docker Compose

1. Create a secrets file:
```bash
mkdir -p secrets
echo "your_secret_key_here" > secrets/api_key.txt
chmod 600 secrets/api_key.txt
```

2. Update `compose.yaml` to use secrets (see commented examples in the file)

3. Start the service:
```bash
docker compose up -d
```

### Using Docker Secrets with Docker Swarm

```bash
# Create the secret
echo "your_secret_key_here" | docker secret create api_key -

# Deploy with secrets
docker service create \
  --name youtube-transcript-api \
  --secret api_key \
  --env API_KEY_FILE=/run/secrets/api_key \
  -p 8000:8000 \
  oldgrandpavanu/youtubetranscriptapi:latest
```

### Why Use Docker Secrets?

- **Security**: Secrets are never exposed in `docker inspect` or container logs
- **Encryption**: Secrets are encrypted at rest and in transit (in Swarm mode)
- **Access Control**: Fine-grained control over which services can access secrets
- **Compliance**: Meets security best practices for production deployments

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

This project is a REST API wrapper around the excellent [youtube-transcript-api](https://pypi.org/project/youtube-transcript-api/) Python package.
