#!/usr/bin/env bash
# Check steering: marker correctness + which baseline steering files are missing.
# Marker checks (steering-id line, no HTML comments, unique rule IDs) are errors.
# Missing baseline files are listed as warnings — you decide which to fill in.
#
# Usage: bash .kiro/tools/check-steering.sh [project-root]   (default root: current dir)
# Exit code: 0 = no errors (warnings allowed), 1 = errors found.

# The 10 baseline steering files a fully set-up project is expected to have.
# Keep in sync with template/.kiro/steering/ when files are added or removed.
expected_steering="api-standards coding-discipline lessons-index principles product red-lines structure style tech testing"

root="${1:-.}"
errors=0
warnings=0
ids_seen=""

err()  { echo "ERROR  $1: $2"; errors=$((errors + 1)); }
warn() { echo "WARN   $1: $2"; warnings=$((warnings + 1)); }

files=()
for f in "$root"/.kiro/steering/*.md "$root"/AGENTS.md; do
  [ -f "$f" ] && files+=("$f")
done
[ ${#files[@]} -eq 0 ] && { echo "no steering files under $root"; exit 1; }

for f in "${files[@]}"; do
  name="${f#"$root"/}"

  id_lines=$(grep -cE '^steering-id: [A-Z]{2}-[0-9a-f]{4}$' "$f")
  if [ "$id_lines" -eq 0 ]; then
    err "$name" "missing 'steering-id: XX-xxxx' line under the title"
  elif [ "$id_lines" -gt 1 ]; then
    err "$name" "more than one steering-id line"
  else
    id=$(grep -E '^steering-id: ' "$f" | awk '{print $2}')
    case " $ids_seen " in
      *" $id "*) err "$name" "steering-id $id is also used by another file" ;;
    esac
    ids_seen="$ids_seen $id"
  fi

  grep -q '<!--' "$f" && err "$name" "contains HTML comments (<!-- -->)"

  dups=$(grep -oE '^(- |#+ )\[[A-Z][0-9]+\]' "$f" | grep -oE '\[[A-Z][0-9]+\]' | sort | uniq -d | tr '\n' ' ')
  [ -n "$dups" ] && err "$name" "duplicate rule IDs: $dups"

  grep -q '{{' "$f" && warn "$name" "unfilled {{placeholders}} remain"
done

# List baseline steering files that are missing — always a warning, never blocks.
# A half-set-up project legitimately has only some of these; you decide which to fill.
for base in $expected_steering; do
  [ -f "$root/.kiro/steering/$base.md" ] || warn ".kiro/steering/$base.md" "baseline steering file is missing"
done

echo "checked ${#files[@]} files: $errors error(s), $warnings warning(s)"
[ "$errors" -eq 0 ]
