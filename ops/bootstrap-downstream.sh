#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage:
  bootstrap-downstream.sh --guide-url <git-url> --repos <csv-local-paths> --owner <github-owner> --create-pr <true|false>

Example:
  bootstrap-downstream.sh \
    --guide-url https://github.com/VontaJamal/rinshari-ui.git \
    --repos /path/repoA,/path/repoB \
    --owner VontaJamal \
    --create-pr true
USAGE
}

GUIDE_URL=""
REPOS_CSV=""
OWNER=""
CREATE_PR="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --guide-url) GUIDE_URL="$2"; shift 2 ;;
    --repos) REPOS_CSV="$2"; shift 2 ;;
    --owner) OWNER="$2"; shift 2 ;;
    --create-pr) CREATE_PR="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$GUIDE_URL" || -z "$REPOS_CSV" || -z "$OWNER" ]]; then
  usage
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI is required" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PRE_TEMPLATE="$ROOT_DIR/templates/design-preflight.md"
SOUL_TEMPLATE="$ROOT_DIR/templates/site-soul-brief.md"

if [[ ! -f "$PRE_TEMPLATE" || ! -f "$SOUL_TEMPLATE" ]]; then
  echo "Expected templates not found in $ROOT_DIR/templates" >&2
  exit 1
fi

trim() {
  local s="$1"
  s="${s#${s%%[![:space:]]*}}"
  s="${s%${s##*[![:space:]]}}"
  printf '%s' "$s"
}

upsert_managed_block() {
  local file="$1"
  local start_marker="$2"
  local end_marker="$3"
  local content="$4"
  mkdir -p "$(dirname "$file")"
  touch "$file"

  if grep -q "$start_marker" "$file"; then
    awk -v s="$start_marker" -v e="$end_marker" -v c="$content" '
      BEGIN{inblock=0}
      {
        if (index($0,s)) {
          print c
          inblock=1
          next
        }
        if (index($0,e)) {
          inblock=0
          next
        }
        if (!inblock) print
      }
    ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
  else
    if [[ -s "$file" ]]; then
      printf '\n%s\n' "$content" >> "$file"
    else
      printf '%s\n' "$content" > "$file"
    fi
  fi
}

IFS=',' read -r -a REPO_PATHS <<< "$REPOS_CSV"

for raw_repo in "${REPO_PATHS[@]}"; do
  repo_path="$(trim "$raw_repo")"
  [[ -z "$repo_path" ]] && continue

  echo "=== Bootstrapping: $repo_path ==="

  if [[ ! -d "$repo_path/.git" ]]; then
    echo "Skipping: not a git repository: $repo_path" >&2
    continue
  fi

  if [[ -n "$(git -C "$repo_path" status --porcelain=v1)" ]]; then
    echo "Skipping dirty repo: $repo_path" >&2
    continue
  fi

  remote_url="$(git -C "$repo_path" remote get-url origin)"
  repo_name="$(basename "${remote_url%.git}")"
  default_branch="$(gh repo view "$OWNER/$repo_name" --json defaultBranchRef --jq '.defaultBranchRef.name')"

  bootstrap_branch="codex/design-guide-bootstrap-${repo_name}"

  git -C "$repo_path" fetch origin "$default_branch"
  git -C "$repo_path" checkout "$default_branch"
  git -C "$repo_path" pull --ff-only origin "$default_branch"
  git -C "$repo_path" checkout -B "$bootstrap_branch"

  if [[ ! -d "$repo_path/design/rinshari-ui" ]]; then
    mkdir -p "$repo_path/design"
    git -C "$repo_path" submodule add "$GUIDE_URL" design/rinshari-ui
  else
    git -C "$repo_path" submodule sync -- design/rinshari-ui || true
    git -C "$repo_path" submodule update --init -- design/rinshari-ui || true
  fi

  if [[ ! -f "$repo_path/docs/site-soul-brief.md" ]]; then
    mkdir -p "$repo_path/docs"
    cp "$SOUL_TEMPLATE" "$repo_path/docs/site-soul-brief.md"
  fi

  AGENTS_BLOCK=$(cat <<'AGENTS'
<!-- RINSHARI-UI:START -->
## Design Preflight Requirement (Managed)
For any UI/UX change, agents must do all of the following before implementation:
1. Read `design/rinshari-ui/templates/design-preflight.md`.
2. Read relevant files in `design/rinshari-ui/principles/`.
3. Read local `docs/site-soul-brief.md`.
4. In task output/PR, provide:
   - Applied principles
   - Site Soul alignment
<!-- RINSHARI-UI:END -->
AGENTS
)
  upsert_managed_block "$repo_path/AGENTS.md" "<!-- RINSHARI-UI:START -->" "<!-- RINSHARI-UI:END -->" "$AGENTS_BLOCK"

  PR_BLOCK=$(cat <<'PRTMP'
<!-- RINSHARI-UI:START -->
## Design preflight completed
- [ ] Yes

## Applied principles
- 

## Site Soul alignment
- 
<!-- RINSHARI-UI:END -->
PRTMP
)
  upsert_managed_block "$repo_path/.github/PULL_REQUEST_TEMPLATE.md" "<!-- RINSHARI-UI:START -->" "<!-- RINSHARI-UI:END -->" "$PR_BLOCK"

  mkdir -p "$repo_path/.github/workflows"

  cat > "$repo_path/.github/workflows/design-preflight-check.yml" <<'YAML'
name: Design Preflight Check

on:
  pull_request:
    types: [opened, edited, synchronize, reopened]

permissions:
  contents: read
  pull-requests: read

jobs:
  preflight:
    runs-on: ubuntu-latest
    steps:
      - name: Validate PR body design preflight sections
        shell: bash
        run: |
          set -euo pipefail

          body="$(jq -r '.pull_request.body // ""' "$GITHUB_EVENT_PATH")"

          fail() {
            echo "$1" >&2
            exit 1
          }

          [[ -n "$body" ]] || fail "PR body is empty. Fill required design preflight fields."

          printf '%s\n' "$body" | grep -q '^## Design preflight completed' || fail "Missing section: Design preflight completed"
          printf '%s\n' "$body" | grep -q '^## Applied principles' || fail "Missing section: Applied principles"
          printf '%s\n' "$body" | grep -q '^## Site Soul alignment' || fail "Missing section: Site Soul alignment"

          printf '%s\n' "$body" | grep -Eq '^- \[[xX]\] Yes' || fail "You must check '- [x] Yes' under Design preflight completed"

          applied="$(printf '%s\n' "$body" | awk '/^## Applied principles/{flag=1;next}/^## /{flag=0}flag')"
          soul="$(printf '%s\n' "$body" | awk '/^## Site Soul alignment/{flag=1;next}/^## /{flag=0}flag')"

          applied_clean="$(printf '%s' "$applied" | sed 's/[[:space:]-]//g')"
          soul_clean="$(printf '%s' "$soul" | sed 's/[[:space:]-]//g')"

          [[ -n "$applied_clean" ]] || fail "Applied principles section cannot be empty"
          [[ -n "$soul_clean" ]] || fail "Site Soul alignment section cannot be empty"
YAML

  cat > "$repo_path/.github/workflows/update-rinshari-ui-submodule.yml" <<'YAML'
name: Update rinshari-ui submodule

on:
  schedule:
    - cron: '0 14 * * 1,4'
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

jobs:
  update-submodule:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          submodules: true

      - name: Update submodule pointer to latest main
        shell: bash
        run: |
          set -euo pipefail
          git submodule sync --recursive
          git submodule update --init --recursive
          git -C design/rinshari-ui fetch origin main
          git -C design/rinshari-ui checkout origin/main

      - name: Create pull request
        uses: peter-evans/create-pull-request@v6
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          branch: codex/bump-rinshari-ui-submodule
          base: main
          title: "chore: bump rinshari-ui submodule"
          commit-message: "chore: bump rinshari-ui submodule"
          body: |
            Automated update of `design/rinshari-ui` to latest `main`.
          labels: |
            automation
            design-system
          add-paths: |
            design/rinshari-ui
YAML

  git -C "$repo_path" add .gitmodules design/rinshari-ui docs/site-soul-brief.md AGENTS.md .github/PULL_REQUEST_TEMPLATE.md .github/workflows/design-preflight-check.yml .github/workflows/update-rinshari-ui-submodule.yml

  if git -C "$repo_path" diff --cached --quiet; then
    echo "No changes to commit for $repo_name"
    git -C "$repo_path" checkout "$default_branch"
    git -C "$repo_path" branch -D "$bootstrap_branch" || true
    continue
  fi

  git -C "$repo_path" commit -m "chore: bootstrap rinshari-ui design guide integration"
  git -C "$repo_path" push -u origin "$bootstrap_branch"

  if [[ "$CREATE_PR" == "true" ]]; then
    if ! gh pr create \
      --repo "$OWNER/$repo_name" \
      --base "$default_branch" \
      --head "$bootstrap_branch" \
      --title "chore: bootstrap rinshari-ui design integration" \
      --body "This PR bootstraps rinshari-ui integration with submodule, agent preflight policy, PR template fields, and CI workflows."; then
      echo "PR may already exist for $repo_name; continuing"
    fi
  fi

done
