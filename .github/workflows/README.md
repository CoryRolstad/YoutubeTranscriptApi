# GitHub Actions Workflows

This directory contains automated workflows for building and deploying the YouTube Transcript API Docker container.

## Workflows

### 1. Build and Push Docker Image (`docker.yml`)

**Triggers:**
- Push to `main` branch
- Pull requests to `main` branch
- Git tags matching version pattern (`*.*.*`)
- Manual trigger via workflow_dispatch

**What it does:**
- Reads the version from `requirements.txt`
- Builds multi-platform Docker images (linux/amd64, linux/arm64)
- Pushes to DockerHub with version tag and `latest` tag

### 2. Monthly Dependency Update (`monthly-update.yml`)

**Triggers:**
- **Scheduled**: Automatically runs at 00:00 UTC on the 1st of every month
- Manual trigger via workflow_dispatch (for testing)

**What it does:**
1. Queries PyPI to get the latest version of `youtube-transcript-api`
2. Compares it with the current version in `requirements.txt`
3. If a new version is available:
   - Updates `requirements.txt` with the new version
   - Commits the change to the repository
   - Builds multi-platform Docker images
   - Pushes images to DockerHub with:
     - Version-specific tag (e.g., `1.2.4`)
     - `latest` tag
   - Creates a GitHub Release with the version number
4. If already at the latest version:
   - Logs a message and exits (no build)

**Benefits:**
- Automatic dependency updates
- No manual intervention required
- Always stays current with upstream library
- Automatic versioning and tagging
- Release notes generated automatically

## Manual Testing

You can manually trigger either workflow from the GitHub Actions tab:

1. Go to **Actions** tab in your repository
2. Select the workflow (left sidebar)
3. Click **Run workflow** button
4. Choose the branch and click **Run workflow**

## Required Secrets and Variables

Make sure these are configured in your repository settings:

**Secrets** (Settings → Secrets and variables → Actions → Repository secrets):
- `DOCKERHUB_TOKEN`: Your DockerHub access token

**Variables** (Settings → Secrets and variables → Actions → Repository variables):
- `DOCKERHUB_USERNAME`: Your DockerHub username (e.g., `oldgrandpavanu`)

The `GITHUB_TOKEN` is automatically provided by GitHub Actions.

## Customizing the Schedule

To change the monthly schedule, edit the cron expression in `monthly-update.yml`:

```yaml
schedule:
  - cron: '0 0 1 * *'  # minute hour day month day-of-week
```

Examples:
- `'0 0 1 * *'` - First day of every month at midnight UTC
- `'0 0 15 * *'` - 15th day of every month at midnight UTC
- `'0 12 * * 1'` - Every Monday at noon UTC
- `'0 0 1 */3 *'` - First day of every 3rd month (quarterly)

Use [crontab.guru](https://crontab.guru/) to help build cron expressions.

## Workflow Permissions

The monthly update workflow needs write permissions to:
- Push commits to the repository
- Create releases
- Push Docker images

These permissions are configured automatically, but if you encounter permission errors, check:
**Settings → Actions → General → Workflow permissions** and ensure "Read and write permissions" is selected.
