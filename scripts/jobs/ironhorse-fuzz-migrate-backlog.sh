#!/bin/bash
# ironhorse-fuzz-migrate-backlog.sh — one idempotent journal CAS operation that
# migrates the legacy per-finding ironhorse-fuzz repair backlog into the
# triage-and-batch lane, per designs/ironhorse-fuzz-triage-and-batch.md § Migration.
#
# The legacy lane opened one `ironhorse-fuzz-<finding-id>-repair` builder job per
# finding; the reaper quarantined ~77 of them into jobs/plan/ as
# `doom_signature: policy-refusal`. This op takes ownership of that backlog WITHOUT
# losing a single finding and WITHOUT promoting any doomed job (the audit's "not
# recommended, deliberately" rule stands: park-and-human-promote is correct; this is
# a CAS over board files, not a promoter).
#
# What it does, as ONE CAS push over a private clone (never the deployed root's
# journal worktree):
#   1. Enumerate every legacy `ironhorse-fuzz-<16hex>-repair` in jobs/{plan,todo},
#      require a matching finding marker, and record the basename→finding mapping
#      and source state in ironhorse-fuzz/migrations/triage-batch-v1.md.
#   2. Remove those old-shape jobs from claimable board states (rm the job file)
#      WITHOUT deleting their finding markers. Each is recorded superseded.
#   3. Mark ironhorse-fuzz-repromote-quarantined superseded (never promote the old
#      files one by one).
#   4. Seed a `status: pending` triage record for every unresolved finding marker
#      that lacks one, so the producer's backpressure counts the real backlog and
#      the triage stage works it down in bounded 12-finding jobs.
#   It FAILS CLOSED on a missing marker, a malformed finding hash, or a live
#   old-shape job in jobs/doin/ (actively claimed — never yanked from under a
#   worker) rather than losing ownership of a finding. A rerun produces no
#   additional records or jobs (idempotent).
#
# Clustering (design step 5) is NOT done here: it is the producer's batcher, which
# releases clusters under the eight-finding cap and the single-live-repair rule on
# its normal ticks once the triage stage has marked findings genuine. This op only
# takes custody of the backlog and seeds triage.
#
# Seams (all GARDEN_* overridable, mirroring ironhorse-fuzz.sh so the op is
# hermetically testable against a bare-repo stub):
#   GARDEN_IRONHORSE_FUZZ_CLONE   journal clone dir (default $GARDEN_STATE/ironhorse-fuzz/journal-migrate)
#
# Usage: ironhorse-fuzz-migrate-backlog.sh [--dry-run]
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="ironhorse-fuzz-migrate"

: "${GARDEN_IRONHORSE_FUZZ_STATE:=$GARDEN_STATE/ironhorse-fuzz}"
: "${GARDEN_IRONHORSE_FUZZ_CLONE:=$GARDEN_IRONHORSE_FUZZ_STATE/journal-migrate}"

DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

require_tools git sha256sum

CLONE="$GARDEN_IRONHORSE_FUZZ_CLONE"
mkdir -p "$(dirname "$CLONE")"
ensure_clone "$CLONE"
sync_clone "$CLONE"

field() { printf '%s\n' "$1" | sed -n "s/^$2: *//p" | head -n1; }
jshow() { git -C "$CLONE" show "origin/$JOURNAL_BRANCH:$1" 2>/dev/null || true; }
exists() { git -C "$CLONE" cat-file -e "origin/$JOURNAL_BRANCH:$1" 2>/dev/null; }

# --- 1. Enumerate the legacy backlog and validate before mutating anything -----
# Old-shape repair basename: ironhorse-fuzz-<exactly 16 lowercase hex>-repair.
legacy_in_state() {  # legacy_in_state <state-subdir> -> "base<TAB>fid" lines
  local sub="$1" rel base fid
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    base="$(basename "$rel" .md)"
    fid="${base#ironhorse-fuzz-}"; fid="${fid%-repair}"
    case "$fid" in
      *[!0-9a-f]*) continue ;;               # not hex
    esac
    [ "${#fid}" = 16 ] || continue
    printf '%s\t%s\n' "$base" "$fid"
  done < <(git -C "$CLONE" ls-tree -r --name-only "origin/$JOURNAL_BRANCH" -- "$sub" \
    | grep -E "^$sub/ironhorse-fuzz-[0-9a-f]{16}-repair\.md$" | sort || true)
}

plan_legacy="$(legacy_in_state "$JOBS_PLAN")"
todo_legacy="$(legacy_in_state "$JOBS_TODO")"
doin_legacy="$(legacy_in_state "$JOBS_DOIN")"

# Fail closed on a live (claimed) old-shape job: never yank one from under a worker.
if [ -n "$doin_legacy" ]; then
  log "FAIL-CLOSED: legacy old-shape repair job(s) are live in jobs/doin/ (claimed):"
  printf '%s\n' "$doin_legacy" | cut -f1 | sed 's/^/  /'
  log "refusing to migrate while a worker owns one — retry once doin/ is clear"
  exit 3
fi

# Fail closed on any legacy job whose finding marker is missing or malformed.
migrate_lines=""   # base<TAB>fid<TAB>source-state
while IFS=$'\t' read -r base fid; do
  [ -n "$base" ] || continue
  if ! exists "ironhorse-fuzz/findings/$fid.md"; then
    log "FAIL-CLOSED: legacy job $base has no finding marker ironhorse-fuzz/findings/$fid.md"; exit 4
  fi
  migrate_lines="${migrate_lines}${base}	${fid}	plan
"
done < <(printf '%s\n' "$plan_legacy")
while IFS=$'\t' read -r base fid; do
  [ -n "$base" ] || continue
  if ! exists "ironhorse-fuzz/findings/$fid.md"; then
    log "FAIL-CLOSED: legacy job $base has no finding marker ironhorse-fuzz/findings/$fid.md"; exit 4
  fi
  migrate_lines="${migrate_lines}${base}	${fid}	todo
"
done < <(printf '%s\n' "$todo_legacy")

legacy_count="$(printf '%s' "$migrate_lines" | grep -c . || true)"
repromote_present=0
exists "$JOBS_PLAN/ironhorse-fuzz-repromote-quarantined.md" && repromote_present=1
exists "$JOBS_TODO/ironhorse-fuzz-repromote-quarantined.md" && repromote_present=1

# Findings that still need a seeded triage record.
findings_all="$(git -C "$CLONE" ls-tree -r --name-only "origin/$JOURNAL_BRANCH" -- ironhorse-fuzz/findings \
  | grep -E '^ironhorse-fuzz/findings/[0-9a-f]+\.md$' | sort || true)"
seed_lines=""
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  fid="$(basename "$rel" .md)"
  exists "ironhorse-fuzz/triage/$fid.md" && continue    # already has a triage record
  seed_lines="${seed_lines}${fid}
"
done < <(printf '%s\n' "$findings_all")
seed_count="$(printf '%s' "$seed_lines" | grep -c . || true)"

log "migration plan: $legacy_count legacy job(s) to supersede, repromote-quarantined present=$repromote_present, $seed_count triage record(s) to seed"

if [ "$DRY_RUN" = 1 ]; then
  log "--dry-run: no journal writes"
  printf '%s' "$migrate_lines" | grep -q . && { echo "-- legacy jobs --"; printf '%s' "$migrate_lines"; }
  exit 0
fi

if [ "$legacy_count" = 0 ] && [ "$repromote_present" = 0 ] && [ "$seed_count" = 0 ]; then
  log "nothing to migrate (idempotent no-op)"
  exit 0
fi

# --- 2/3/4. One CAS commit: manifest + rm legacy jobs + supersede repromote +
#            seed triage records. A push race re-syncs and rebuilds from state. ---
now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
attempts="${GARDEN_POST_ATTEMPTS:-50}"
for attempt in $(seq 1 "$attempts"); do
  sync_clone "$CLONE"
  git -C "$CLONE" reset -q --hard "origin/$JOURNAL_BRANCH"

  # (2) remove legacy jobs from claimable states (keep finding markers).
  while IFS=$'\t' read -r base fid src; do
    [ -n "$base" ] || continue
    rm -f "$CLONE/jobs/$src/$base.md"
    git -C "$CLONE" rm -q --cached --ignore-unmatch -- "jobs/$src/$base.md" >/dev/null 2>&1 || true
  done < <(printf '%s' "$migrate_lines")

  # (3) supersede the repromote-quarantined job wherever it is claimable.
  for st in plan todo; do
    if [ -f "$CLONE/jobs/$st/ironhorse-fuzz-repromote-quarantined.md" ]; then
      rm -f "$CLONE/jobs/$st/ironhorse-fuzz-repromote-quarantined.md"
      git -C "$CLONE" rm -q --cached --ignore-unmatch -- "jobs/$st/ironhorse-fuzz-repromote-quarantined.md" >/dev/null 2>&1 || true
    fi
  done

  # (4) seed pending triage records for unresolved markers lacking one.
  while IFS= read -r fid; do
    [ -n "$fid" ] || continue
    [ -e "$CLONE/ironhorse-fuzz/triage/$fid.md" ] && continue
    tgt="$(field "$(cat "$CLONE/ironhorse-fuzz/findings/$fid.md" 2>/dev/null)" target)"
    proj="$(field "$(cat "$CLONE/ironhorse-fuzz/findings/$fid.md" 2>/dev/null)" project_sha)"
    mkdir -p "$CLONE/ironhorse-fuzz/triage"
    {
      printf 'schema: 1\n'
      printf 'finding_id: %s\n' "$fid"
      printf 'status: pending\n'
      printf 'target: %s\n' "$tgt"
      printf 'reason: seeded-by-migration-triage-batch-v1\n'
      printf 'classified_at_project_sha: %s\n' "$proj"
      printf 'seeded_at: %s\n' "$now"
    } > "$CLONE/ironhorse-fuzz/triage/$fid.md"
  done < <(printf '%s' "$seed_lines")

  # (1) manifest — the durable record of what was superseded and seeded.
  mkdir -p "$CLONE/ironhorse-fuzz/migrations"
  {
    printf 'schema: 1\n'
    printf 'migration: triage-batch-v1\n'
    printf 'ran_at: %s\n' "$now"
    printf 'ran_by: %s\n' "$GARDEN"
    printf 'legacy_superseded_count: %s\n' "$legacy_count"
    printf 'repromote_quarantined_superseded: %s\n' "$repromote_present"
    printf 'triage_records_seeded: %s\n' "$seed_count"
    printf 'superseded_jobs:\n'
    while IFS=$'\t' read -r base fid src; do
      [ -n "$base" ] || continue
      printf -- '  - base: %s\n' "$base"
      printf -- '    finding: %s\n' "$fid"
      printf -- '    from_state: %s\n' "$src"
      printf -- '    disposition: superseded-by-triage-batch\n'
    done < <(printf '%s' "$migrate_lines")
  } > "$CLONE/ironhorse-fuzz/migrations/triage-batch-v1.md"

  git -C "$CLONE" add -A -- ironhorse-fuzz jobs >/dev/null 2>&1 || true
  rc=0; commit_and_push "$CLONE" "ironhorse-fuzz: migrate legacy backlog into triage-and-batch (triage-batch-v1)" || rc=$?
  case "$rc" in
    0) log "migration landed: superseded $legacy_count legacy job(s), repromote-quarantined=$repromote_present, seeded $seed_count triage record(s)"; exit 0 ;;
    2) log "migration already applied (nothing to commit) — idempotent"; exit 0 ;;
    *) backoff "$attempt" ;;
  esac
done
log "FAIL: could not land migration after $attempts attempts (push contention)"
exit 1
