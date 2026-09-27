#!/bin/bash
# assert-panel-head-fresh.sh — deterministic panel-coverage freshness sensor.
#
# Contract: a PR head is covered by the latest completed panel iff the presented
# head is exactly the panel-reviewed commit.  Legacy panel-run records retained
# only an eight-hex display prefix; those compare by prefix.  Any commit movement
# is conservatively review-relevant.  PR title/body/label/comment edits do not move
# headRefOid and are therefore the explicit metadata-only negative case.
#
# Exit status:
#   0  fresh, unreviewed (ordinary pre-gauntlet draft), or not applicable
#  10  stale: a completed panel exists and the presented head moved
#  11  --require-reviewed-head was requested but no completed panel is durable
#  12  the PR/journal state was unreadable; callers should retry, not forget
#   2  usage

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="assert-panel-head-fresh"

usage() {
  cat >&2 <<'EOF'
usage:
  assert-panel-head-fresh.sh compare <reviewed-head> <presented-head> [label]
  assert-panel-head-fresh.sh pr [--require-reviewed-head] <owner/repo> <pr-number>
  assert-panel-head-fresh.sh completion <job-base> <job-file> <completion-report>
EOF
  exit 2
}

valid_head() { [[ "${1:-}" =~ ^[0-9A-Fa-f]{7,64}$ ]]; }

compare_heads() { # <reviewed> <presented> [label]
  local reviewed="${1:-}" presented="${2:-}" label="${3:-pr}"
  if ! valid_head "$reviewed" || ! valid_head "$presented"; then
    log "panel-head-freshness: unreadable head identity for $label (reviewed='${reviewed:-missing}', presented='${presented:-missing}')"
    return 12
  fi
  reviewed="${reviewed,,}"; presented="${presented,,}"
  if [ "$reviewed" = "$presented" ] \
     || { [ "${#reviewed}" -lt "${#presented}" ] && [ "${presented:0:${#reviewed}}" = "$reviewed" ]; }; then
    printf 'panel-head-freshness: fresh target=%s reviewed_head=%s presented_head=%s disposition=covered\n' \
      "$label" "$reviewed" "$presented"
    return 0
  fi
  printf 'panel-head-freshness: stale target=%s reviewed_head=%s presented_head=%s disposition=review-required\n' \
    "$label" "$reviewed" "$presented"
  return 10
}

record_reviewed_head() { # <record>
  local record="$1" head
  head="$(plan_field "$record" reviewed_head)"
  if ! valid_head "$head"; then
    # Records predating the exact-head field retain the reviewed head in every
    # round heading.  The final heading is the latest round in that run.
    head="$(sed -nE 's/^## Round [0-9]+ .*head `([0-9A-Fa-f]+)`.*/\1/p' "$record" | tail -1)"
  fi
  valid_head "$head" || return 1
  printf '%s\n' "${head,,}"
}

latest_reviewed_head() { # <journal-clone> <owner/repo> <pr>
  local clone="$1" repo="$2" pr="$3" slug store path disposition head
  slug="${repo%/*}-${repo#*/}-$pr"
  store="panel-runs/$slug"
  [ -d "$clone/$store" ] || return 1

  # Journal commit order is the authoritative completion order.  Panel records
  # are append-only, so the first valid record path in reverse history is the
  # latest completed panel even when filesystem mtimes were recreated by clone.
  while IFS= read -r path; do
    case "$path" in "$store"/*.md) : ;; *) continue ;; esac
    [ -f "$clone/$path" ] || continue
    disposition="$(plan_field "$clone/$path" disposition)"
    case "$disposition" in
      passed|must-fix|max-rounds-exceeded) ;;
      *) continue ;;
    esac
    head="$(record_reviewed_head "$clone/$path" || true)"
    [ -n "$head" ] || continue
    printf '%s\n' "$head"
    return 0
  done < <(git -C "$clone" log --format= --name-only --diff-filter=AM -- "$store" 2>/dev/null | awk 'NF && !seen[$0]++')
  return 1
}

check_pr() { # [--require-reviewed-head] <repo> <pr>
  local require=0
  if [ "${1:-}" = --require-reviewed-head ]; then require=1; shift; fi
  local repo="${1:-}" pr="${2:-}" clone reviewed doc state presented gh_bin
  if [ -z "$repo" ] || [[ "$repo" != */* ]] || [[ ! "$pr" =~ ^[0-9]+$ ]]; then usage; fi

  clone="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
  if ! ensure_clone "$clone" >/dev/null 2>&1 || ! sync_clone "$clone" >/dev/null 2>&1; then
    log "panel-head-freshness: journal unavailable for $repo#$pr; retry required"
    return 12
  fi
  reviewed="$(latest_reviewed_head "$clone" "$repo" "$pr" || true)"
  if [ -z "$reviewed" ]; then
    if [ "$require" -eq 1 ]; then
      log "panel-head-freshness: no completed panel head is durable for $repo#$pr; refusing a presentation that requires review coverage"
      return 11
    fi
    printf 'panel-head-freshness: unreviewed target=%s#%s disposition=manual-gauntlet-not-triggered\n' "$repo" "$pr"
    return 0
  fi

  gh_bin="${GARDEN_GH:-gh}"
  if ! doc="$("$gh_bin" pr view "$pr" -R "$repo" --json headRefOid,state 2>/dev/null)" || [ -z "$doc" ]; then
    log "panel-head-freshness: GitHub head unreadable for $repo#$pr; retry required"
    return 12
  fi
  state="$(jq -r '.state // empty' <<<"$doc" 2>/dev/null || true)"
  case "$state" in
    OPEN) ;;
    CLOSED|MERGED)
      printf 'panel-head-freshness: not-applicable target=%s#%s state=%s\n' "$repo" "$pr" "$state"
      return 0 ;;
    *) log "panel-head-freshness: GitHub state unreadable for $repo#$pr; retry required"; return 12 ;;
  esac
  presented="$(jq -r '.headRefOid // empty' <<<"$doc" 2>/dev/null || true)"
  compare_heads "$reviewed" "$presented" "$repo#$pr"
}

case "${1:-}" in
  compare)
    if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then usage; fi
    compare_heads "$2" "$3" "${4:-historical-sequence}"
    ;;
  pr)
    shift
    check_pr "$@"
    ;;
  completion)
    [ "$#" -eq 4 ] || usage
    base="$2"; jobfile="$3"; report="$4"
    if [ ! -f "$jobfile" ] || [ ! -f "$report" ]; then usage; fi
    # A staged gauntlet already owns its panel/fix succession.  Its fix delta is
    # intentionally stale until the driver posts the next panel; do not mint an
    # out-of-band manual trigger for work already inside that explicit gauntlet.
    if [ -n "$(plan_field "$jobfile" gauntlet)" ]; then
      printf 'panel-head-freshness: managed target=%s disposition=gauntlet-driver-owns-next-panel\n' "$base"
      exit 0
    fi
    pr_url="$(extract_pr_refs_from_text "$report" | head -1 || true)"
    [ -n "$pr_url" ] || {
      printf 'panel-head-freshness: not-applicable target=%s reason=no-presented-pr\n' "$base"
      exit 0
    }
    ref="$(parse_pr_ref "$pr_url" 2>/dev/null || true)"
    [ -n "$ref" ] || { log "panel-head-freshness: could not parse presented PR '$pr_url'"; exit 12; }
    repo="$(printf '%s' "$ref" | cut -f1)"
    pr="$(printf '%s' "$ref" | cut -f2)"
    check_pr "$repo" "$pr"
    ;;
  *) usage ;;
esac
