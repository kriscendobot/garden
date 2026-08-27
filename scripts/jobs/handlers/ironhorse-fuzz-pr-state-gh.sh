#!/bin/bash
# ironhorse-fuzz-pr-state-gh.sh — default STANDING-PR-STATE seam for ironhorse-fuzz.sh.
#
# Invoked as: ironhorse-fuzz-pr-state-gh.sh <repo> <marker-base> <author> [--number]
#
# Resolves the standing PR by the DURABLE marker `<!-- garden-job: <marker-base> -->`
# (byte-identical to ensure-pr.sh's marker), the same way ensure-pr discovers it, and
# echoes:
#   default   -> OPEN | MERGED | CLOSED | NONE   (the lifecycle state the service rolls over on)
#   --number  -> the PR number (prefer an OPEN one), or 0 if none matches
#
# On a transient gh/API failure it echoes UNKNOWN (default) / 0 (--number) so the
# service NEVER rolls a generation over on a blip — it waits for a definite MERGED/CLOSED.
#
# Read-only: this lists only the bot's OWN PRs by author+marker and feeds nothing to an
# LLM; it is injection-safe by construction (CLAUDE.md § Monitoring safety constraint).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="ironhorse-fuzz-pr-state"

repo="${1:?usage: <repo> <marker-base> <author> [--number]}"
marker_base="${2:?marker-base}"
author="${3:?author}"
mode="${4:-}"

: "${GARDEN_IRONHORSE_FUZZ_PR_LIMIT:=200}"
marker="<!-- garden-job: $marker_base -->"

want_number=""
[ "$mode" = "--number" ] && want_number=1

emit_unknown() { if [ -n "$want_number" ]; then echo 0; else echo UNKNOWN; fi; }

command -v gh >/dev/null 2>&1 || { emit_unknown; exit 0; }
command -v jq >/dev/null 2>&1 || { emit_unknown; exit 0; }

json="$(gh pr list --repo "$repo" --author "$author" --state all \
          --limit "$GARDEN_IRONHORSE_FUZZ_PR_LIMIT" --json number,state,body,url 2>/dev/null || true)"
if [ -z "$json" ]; then emit_unknown; exit 0; fi

# Matching PRs (body carries the marker), newest-number first.
matches="$(printf '%s' "$json" \
  | jq -c --arg m "$marker" '[ .[] | select((.body // "") | contains($m)) ] | sort_by(-.number)' 2>/dev/null || true)"
if [ -z "$matches" ] || [ "$matches" = "[]" ] || [ "$matches" = "null" ]; then
  if [ -n "$want_number" ]; then echo 0; else echo NONE; fi
  exit 0
fi

# Prefer an OPEN match; else fall back to the newest match's state.
open_num="$(printf '%s' "$matches" | jq -r 'map(select(.state=="OPEN")) | .[0].number // empty' 2>/dev/null || true)"
if [ -n "$want_number" ]; then
  if [ -n "$open_num" ]; then echo "$open_num"; else
    printf '%s' "$matches" | jq -r '.[0].number // 0' 2>/dev/null || echo 0
  fi
  exit 0
fi

if [ -n "$open_num" ]; then echo OPEN; exit 0; fi
state="$(printf '%s' "$matches" | jq -r '.[0].state // "UNKNOWN"' 2>/dev/null || echo UNKNOWN)"
case "$state" in
  MERGED) echo MERGED ;;
  CLOSED) echo CLOSED ;;
  OPEN)   echo OPEN ;;
  *)      echo UNKNOWN ;;
esac
