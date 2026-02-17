#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage:
  new-lesson-draft.sh --title <title> --source-type <transcript|clip|code_sample|mixed> \
    --source-ref <ref> --claims-file <path> --evidence <comma-separated>
USAGE
}

TITLE=""
SOURCE_TYPE=""
SOURCE_REF=""
CLAIMS_FILE=""
EVIDENCE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --source-type) SOURCE_TYPE="$2"; shift 2 ;;
    --source-ref) SOURCE_REF="$2"; shift 2 ;;
    --claims-file) CLAIMS_FILE="$2"; shift 2 ;;
    --evidence) EVIDENCE="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

[[ -n "$TITLE" && -n "$SOURCE_TYPE" && -n "$SOURCE_REF" && -n "$CLAIMS_FILE" ]] || { usage; exit 1; }

case "$SOURCE_TYPE" in
  transcript|clip|code_sample|mixed) ;;
  *) echo "Invalid source type: $SOURCE_TYPE" >&2; exit 1 ;;
esac

if [[ ! -f "$CLAIMS_FILE" ]]; then
  echo "Claims file not found: $CLAIMS_FILE" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT_DIR="$ROOT_DIR/ingestion/lessons"
mkdir -p "$OUT_DIR"

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/-\{2,\}/-/g; s/^-//; s/-$//'
}

DATE_STR="$(date +%F)"
SLUG="$(slugify "$TITLE")"
OUT_FILE="$OUT_DIR/${DATE_STR}-${SLUG}.md"

if [[ -e "$OUT_FILE" ]]; then
  n=2
  while [[ -e "$OUT_DIR/${DATE_STR}-${SLUG}-${n}.md" ]]; do
    n=$((n+1))
  done
  OUT_FILE="$OUT_DIR/${DATE_STR}-${SLUG}-${n}.md"
fi

mapfile -t claims < <(grep -v '^[[:space:]]*$' "$CLAIMS_FILE")
if [[ ${#claims[@]} -eq 0 ]]; then
  echo "Claims file is empty" >&2
  exit 1
fi

for line in "${claims[@]}"; do
  if (( ${#line} > 220 )); then
    echo "Claim line exceeds 220 chars. Keep claims paraphrased and concise: $line" >&2
    exit 1
  fi
done

IFS=',' read -r -a evidence_items <<< "$EVIDENCE"

{
  echo "# Lesson Card: $TITLE"
  echo
  echo "- lesson_title: $TITLE"
  echo "- source_type: $SOURCE_TYPE"
  echo "- source_refs:"
  echo "  - $SOURCE_REF"
  echo "- core_claims:"
  for c in "${claims[@]}"; do
    echo "  - $c"
  done
  echo "- ui_effect_goal:"
  echo "- evidence_items:"
  for e in "${evidence_items[@]}"; do
    item="$(echo "$e" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
    [[ -n "$item" ]] && echo "  - $item"
  done
  echo "- do:"
  echo "  - "
  echo "- dont:"
  echo "  - "
  echo "- candidate_principles:"
  echo "  - "
  echo "- a11y_notes:"
  echo "  - "
  echo "- promotion_status: draft"
  echo
  echo "## Policy"
  echo "- Paraphrase-only content. Do not include full transcript blocks or clip dumps."
} > "$OUT_FILE"

echo "Created: $OUT_FILE"
