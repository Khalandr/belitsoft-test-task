# HTTPBin Test Automation
## Prerequisites

- Python 3.13+
- UV package manager: `pip install uv`

## Installation

```bash
uv sync
```

## Running Tests
### Local Execution

```bash
# Run all tests (with timestamp)
uv run robot --outputdir reports/$(date +%Y%m%d_%H%M%S) tests/

# Run specific category
uv run robot --outputdir reports/$(date +%Y%m%d_%H%M%S) tests/response_formats/
uv run robot --outputdir reports/$(date +%Y%m%d_%H%M%S) tests/request_inspection/
uv run robot --outputdir reports/$(date +%Y%m%d_%H%M%S) tests/dynamic_data/

# Run by tag
uv run robot --outputdir reports/$(date +%Y%m%d_%H%M%S) --include positive tests/
uv run robot --outputdir reports/$(date +%Y%m%d_%H%M%S) --include negative tests/
uv run robot --outputdir reports/$(date +%Y%m%d_%H%M%S) --include edge-case tests/
```

### Docker Execution

```bash
# Start HTTPBin and run tests
docker-compose up --build

# Stop services
docker-compose down -v
```

## Viewing Reports
### Dashboard (Historical Trends)

The dashboard provides a web interface to view test results over time.

```bash
# Process all test results from reports folder (accumulates in single database)
uv run robotdashboard -f reports -d robot_results.db -n robot_dashboard.html

# Open the dashboard HTML in browser
open robot_dashboard.html

# Or start interactive dashboard server
uv run robotdashboard --server default

# Server runs on http://127.0.0.1:8543
# Open in browser to view interactive charts and historical trends
```

The dashboard tracks all test runs with timestamps in a single database, showing historical trends, test execution statistics, and allows filtering by date ranges.

## GitHub Pages Setup

To view the dashboard live on GitHub Pages after CI runs:

1. **Enable GitHub Pages** in repository settings:
   - Go to `Settings` → `Pages`
   - Under "Source", select `Deploy from a branch`
   - Select branch: `gh-pages`
   - Select folder: `/ (root)`
   - Click `Save`

2. **Wait for first deployment** (happens automatically on next push to `main`)

3. **Access dashboard** at: `https://<your-username>.github.io/<repo-name>/`

The dashboard updates automatically with each test run on the `main` branch.

---

**63 tests** • **Tags:** `positive`, `negative`, `edge-case`
