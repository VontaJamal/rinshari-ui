#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage:
  sync-agents-baseline.sh --write [--repos <csv-local-paths>] [--skip-dirty <true|false>] [--branch <codex-branch>]
  sync-agents-baseline.sh --check [--repos <csv-local-paths>]

Defaults:
  --skip-dirty true
  --branch codex/agents-ts-zod-baseline
USAGE
}

mode=""
repos_csv=""
skip_dirty="true"
target_branch="codex/agents-ts-zod-baseline"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --write) mode="write"; shift ;;
    --check) mode="check"; shift ;;
    --repos) repos_csv="${2:-}"; shift 2 ;;
    --skip-dirty) skip_dirty="${2:-}"; shift 2 ;;
    --branch) target_branch="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$mode" ]]; then
  usage
  exit 1
fi

if [[ "$skip_dirty" != "true" && "$skip_dirty" != "false" ]]; then
  echo "--skip-dirty must be true or false" >&2
  exit 1
fi

if [[ -z "$target_branch" ]]; then
  echo "--branch cannot be empty" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCTRINE_TEMPLATE="$ROOT_DIR/templates/agents-baseline-doctrine.md"

if [[ ! -f "$DOCTRINE_TEMPLATE" ]]; then
  echo "Missing doctrine template: $DOCTRINE_TEMPLATE" >&2
  exit 1
fi

trim() {
  local s="$1"
  s="${s#${s%%[![:space:]]*}}"
  s="${s%${s##*[![:space:]]}}"
  printf '%s' "$s"
}

declare -a DEFAULT_REPO_ROOTS=(
  "/Users/vonta/Documents/Code Repos/Agent_Intro"
  "/Users/vonta/Documents/Code Repos/DJWS"
  "/Users/vonta/Documents/Code Repos/NexusCrypto"
  "/Users/vonta/Documents/Code Repos/Nexuslytics"
  "/Users/vonta/Documents/Code Repos/VontaJamal"
  "/Users/vonta/Documents/Code Repos/ck-at"
  "/Users/vonta/Documents/Code Repos/ck-flash"
  "/Users/vonta/Documents/Code Repos/link-tracker"
  "/Users/vonta/Documents/Code Repos/magic-lantern"
  "/Users/vonta/Documents/Code Repos/prediction-claw-culling-games"
  "/Users/vonta/Documents/Code Repos/rinshari-ui"
  "/Users/vonta/Documents/Code Repos/synclink"
  "/Users/vonta/Documents/Code Repos/agent-orchestration-lab"
  "/Users/vonta/Documents/Code Repos/your-next-watch"
)

declare -a REPO_ROOTS=()
if [[ -n "$repos_csv" ]]; then
  IFS=',' read -r -a requested_repos <<< "$repos_csv"
  for raw_repo in "${requested_repos[@]}"; do
    repo="$(trim "$raw_repo")"
    [[ -z "$repo" ]] && continue
    REPO_ROOTS+=("$repo")
  done
else
  REPO_ROOTS=("${DEFAULT_REPO_ROOTS[@]}")
fi

if [[ "${#REPO_ROOTS[@]}" -eq 0 ]]; then
  echo "No target repos resolved. Provide a non-empty --repos list." >&2
  exit 1
fi

START_MARKER="<!-- CORE-DOCTRINE:START -->"
END_MARKER="<!-- CORE-DOCTRINE:END -->"

DOCTRINE_CONTENT="$(cat "$DOCTRINE_TEMPLATE")"
MANAGED_BLOCK="$START_MARKER
$DOCTRINE_CONTENT
$END_MARKER"

upsert_file() {
  local target="$1"
  local block_file
  block_file="$(mktemp)"
  printf '%s\n' "$MANAGED_BLOCK" > "$block_file"

  if [[ ! -f "$target" ]]; then
    cat > "$target" <<NEWFILE
$MANAGED_BLOCK

## Local Repository Overrides
- Add repository-specific constraints, product requirements, and implementation notes below this line.
NEWFILE
    rm -f "$block_file"
    return
  fi

  if grep -q "$START_MARKER" "$target"; then
    awk -v s="$START_MARKER" -v e="$END_MARKER" -v cfile="$block_file" '
      function print_block(  line) {
        while ((getline line < cfile) > 0) print line
        close(cfile)
      }
      BEGIN { inblock=0 }
      {
        if (index($0, s)) {
          print_block()
          inblock=1
          next
        }
        if (index($0, e)) {
          inblock=0
          next
        }
        if (!inblock) print
      }
    ' "$target" > "$target.tmp"
    mv "$target.tmp" "$target"
  else
    {
      cat "$block_file"
      printf '\n'
      cat "$target"
    } > "$target.tmp"
    mv "$target.tmp" "$target"
  fi

  rm -f "$block_file"
}

check_file() {
  local target="$1"
  local repo_name="$2"

  if [[ ! -f "$target" ]]; then
    echo "[FAIL] $repo_name missing AGENTS.md"
    return 1
  fi

  local marker_count
  marker_count="$(grep -Ec '<!-- CORE-DOCTRINE:(START|END) -->' "$target" | tr -d ' ')"
  if [[ "$marker_count" -ne 2 ]]; then
    echo "[FAIL] $repo_name must contain exactly one CORE-DOCTRINE block"
    return 1
  fi

  local block
  block="$(awk -v s="$START_MARKER" -v e="$END_MARKER" '
    BEGIN { capture=0 }
    {
      if (index($0, s)) { capture=1; print; next }
      if (capture) print
      if (index($0, e)) { exit }
    }
  ' "$target")"

  if [[ "$block" != "$MANAGED_BLOCK" ]]; then
    echo "[FAIL] $repo_name CORE-DOCTRINE block does not match canonical template"
    return 1
  fi

  for required in \
    "The Seven Saints" \
    "Protagonist Commander" \
    "AI is a force multiplier under command discipline, not a substitute for judgment." \
    "Saint of Aesthetics" \
    "Saint of Security" \
    "Saint of Accessibility" \
    "Saint of Testing" \
    "Saint of Execution" \
    "Saint of Scales" \
    "Saint of Value" \
    "Script (AI Laws):" \
    "No raw secrets, credentials, or sensitive user data to external AI systems." \
    "TypeScript is the default language for all new implementation work" \
    "TypeScript strict mode is mandatory" \
    "is allowed only at uncontrolled external boundaries and must be narrowed immediately." \
    "Zod is required for TypeScript runtime validation" \
    "Python is a pre-approved exception and must use Pydantic" \
    "Any non-TypeScript/non-Python language requires explicit owner-approved exception." \
    "Language Exception Record" \
    "codex/*" \
    "feature-branch git tree clean before running verification/testing" \
    "never declare completion while the active feature branch is dirty" \
    "behavior-first tests" \
    "hourly/nightly" \
    "weekly/monthly/quarterly"; do
    if ! printf '%s\n' "$block" | grep -Fq "$required"; then
      echo "[FAIL] $repo_name CORE-DOCTRINE block missing: $required"
      return 1
    fi
  done

  echo "[OK] $repo_name"
}

ensure_feature_branch_for_write() {
  local repo_root="$1"
  local repo_name="$2"

  local current_branch
  current_branch="$(git -C "$repo_root" branch --show-current)"
  if [[ "$current_branch" == codex/* ]]; then
    return 0
  fi

  if [[ -n "$(git -C "$repo_root" status --porcelain=v1)" ]]; then
    echo "[FAIL] $repo_name dirty on non-codex branch (${current_branch:-detached}); cannot switch to $target_branch"
    return 1
  fi

  git -C "$repo_root" checkout -B "$target_branch" >/dev/null
  echo "[BRANCH] $repo_name switched to $target_branch"
}

status=0
for repo_root in "${REPO_ROOTS[@]}"; do
  if [[ ! -d "$repo_root/.git" ]]; then
    echo "[SKIP] Not a git repo: $repo_root"
    continue
  fi

  target="$repo_root/AGENTS.md"
  repo_name="$(basename "$repo_root")"

  if [[ "$mode" == "write" ]]; then
    if [[ "$skip_dirty" == "true" && -n "$(git -C "$repo_root" status --porcelain=v1)" ]]; then
      echo "[SKIP] Dirty repo: $repo_name"
      continue
    fi

    if ! ensure_feature_branch_for_write "$repo_root" "$repo_name"; then
      status=1
      continue
    fi

    upsert_file "$target"
    echo "[WRITE] $target"
  else
    if ! check_file "$target" "$repo_name"; then
      status=1
    fi
  fi
done

exit "$status"
