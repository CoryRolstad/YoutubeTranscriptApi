# YouTube Transcript REST API

A lightweight, production-ready REST API service that extracts and formats YouTube video transcripts (subtitles/captions). Built with FastAPI and powered by the excellent [youtube-transcript-api](https://pypi.org/project/youtube-transcript-api/) Python library.

## What is this?

This Docker container provides a simple REST API interface to fetch YouTube video transcripts without needing the YouTube Data API or authentication. It's perfect for:

- Content analysis and NLP projects
- Accessibility tools
- Video summarization services
- Educational applications
- Research projects requiring video transcript data

## Key Features

- **Multiple Output Formats**: Export transcripts as JSON, Plain Text, WebVTT, or SRT subtitles
- **Language Support**: Fetch transcripts in any available language, including auto-generated captions
- **Discovery Endpoint**: List all available transcript languages for any video
- **Optional API Key Protection**: Secure your API with optional key-based authentication
- **CORS Enabled**: Ready for cross-origin requests from web applications
- **Comprehensive Error Handling**: Proper HTTP status codes for age-restricted, unavailable, or blocked content
- **Built-in Documentation**: Interactive Swagger UI and ReDoc documentation included
- **Health Checks**: Docker health monitoring built-in
- **Production Ready**: Built on FastAPI with Uvicorn ASGI server

## Quick Start

### Pull and Run

```bash
docker pull oldgrandpavanu/youtubetranscriptapi:latest
docker run -d -p 8000:8000 --name youtube-transcript-api oldgrandpavanu/youtubetranscriptapi:latest
```

Access the API at `http://localhost:8000` and documentation at `http://localhost:8000/docs`

### Run with API Key Protection

```bash
docker run -d -p 8000:8000 -e API_KEY=your_secret_key_here --name youtube-transcript-api oldgrandpavanu/youtubetranscriptapi:latest
```

## Docker Compose

Create a `compose.yaml` file:

```yaml
services:
  api:
    image: oldgrandpavanu/youtubetranscriptapi:latest
    ports:
      - "8000:8000"
    environment:
      - API_KEY=${API_KEY:-}  # Optional: set via environment variable
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/"]
      interval: 30s
      timeout: 10s
      retries: 3
```

Start the service:

```bash
# Without API key
docker compose up -d

# With API key protection
API_KEY=your_secret_key_here docker compose up -d
```

## API Usage

### Endpoint Overview

- `GET /` - Welcome message and API information
- `GET /transcript` - Fetch video transcript in various formats
- `GET /transcripts` - List all available transcripts for a video
- `GET /docs` - Interactive Swagger UI documentation
- `GET /redoc` - ReDoc API documentation

### Get Transcript

Fetch a transcript in JSON format (default):

```bash
curl "http://localhost:8000/transcript?video_id=dQw4w9WgXcQ&language=en"
```

Fetch as plain text:

```bash
curl "http://localhost:8000/transcript?video_id=dQw4w9WgXcQ&language=en&format=text"
```

Fetch as SRT subtitles:

```bash
curl "http://localhost:8000/transcript?video_id=dQw4w9WgXcQ&language=en&format=srt"
```

Fetch as WebVTT:

```bash
curl "http://localhost:8000/transcript?video_id=dQw4w9WgXcQ&language=en&format=webvtt"
```

**Parameters:**
- `video_id` (required): YouTube video ID
- `language` (optional, default: "en"): Language code (e.g., "en", "es", "fr", "de")
- `format` (optional, default: "json"): Output format - `json`, `text`, `webvtt`, or `srt`

### List Available Transcripts

Discover all available transcript languages for a video:

```bash
curl "http://localhost:8000/transcripts?video_id=dQw4w9WgXcQ"
```

**Response Example:**

```json
{
  "video_id": "dQw4w9WgXcQ",
  "available_transcripts": [
    {
      "language": "English",
      "language_code": "en",
      "is_generated": false,
      "is_translatable": true
    },
    {
      "language": "Spanish",
      "language_code": "es",
      "is_generated": true,
      "is_translatable": true
    }
  ]
}
```

### Using API Key Authentication

When the `API_KEY` environment variable is set, include the key in your requests:

```bash
curl -H "X-API-Key: your_secret_key_here" \
  "http://localhost:8000/transcript?video_id=dQw4w9WgXcQ&language=en"
```

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `API_KEY` | No | None | When set, requires X-API-Key header for all protected endpoints |

## Error Handling

The API provides meaningful HTTP status codes and error messages:

| Status Code | Scenario |
|-------------|----------|
| 200 | Success |
| 401 | Invalid or missing API key (when protection enabled) |
| 403 | Age-restricted content or IP blocked by YouTube |
| 404 | Video unavailable, transcript not found, or transcripts disabled |
| 429 | Request blocked by YouTube (rate limiting) |
| 500 | Internal server error |

## Technical Details

### Stack

- **Framework**: FastAPI 0.120.3
- **ASGI Server**: Uvicorn 0.38.0
- **Core Library**: youtube-transcript-api 1.2.3
- **Python Version**: 3.13 (slim)
- **Configuration**: python-dotenv 1.2.1

### Container Specifications

- **Base Image**: python:3.13-slim
- **Exposed Port**: 8000
- **Working Directory**: /app
- **Health Check**: Built-in HTTP health check on root endpoint
- **Restart Policy**: unless-stopped (in compose)

### Volume Mounting

For development, mount the application directory:

```bash
docker run -p 8000:8000 -v $(pwd):/app oldgrandpavanu/youtubetranscriptapi:latest
```

### Architecture

The application follows a clean, single-file architecture (main.py) with:
- FastAPI application initialization
- CORS middleware for cross-origin requests
- Optional API key security layer
- Two main endpoints with comprehensive error handling
- Integration with youtube-transcript-api for transcript fetching
- Multiple formatter support (JSON, Text, WebVTT, SRT)

## Use Cases

### Content Analysis
Extract transcripts for sentiment analysis, keyword extraction, or topic modeling.

### Accessibility
Convert video content to readable text or downloadable subtitle files.

### Education
Create study materials from educational videos or generate summaries.

### Research
Analyze large collections of video content for academic research.

### Integration
Integrate into workflows, automation tools, or content management systems.

## Documentation

Once the container is running, access the interactive documentation:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **OpenAPI Schema**: http://localhost:8000/openapi.json

## Source Code

GitHub Repository: [https://github.com/coryrolstad/YoutubeTranscriptApi](https://github.com/coryrolstad/YoutubeTranscriptApi)

## License

MIT License - Free for personal and commercial use.

## Credits

This project is a REST API wrapper around the excellent [youtube-transcript-api](https://pypi.org/project/youtube-transcript-api/) Python package maintained by Jonas Depoix.

## Support

For issues, feature requests, or contributions, please visit the [GitHub Issues page](https://github.com/coryrolstad/YoutubeTranscriptApi/issues).
