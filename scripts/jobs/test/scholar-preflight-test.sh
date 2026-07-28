#!/bin/bash
# scholar-preflight-test.sh — coverage for the deterministic scholar schedule
# preflight gate (scholar-preflight.sh).
#
# The gate decides, in plain code, whether a scheduled scholar cycle has work:
#   exit 0 = work present → dispatch the scholar LLM cycle
#   exit 2 = no work      → advance the clock only, dispatch nothing
# Work is present when ANY of: (1) the scholar inbox has unread; (2) a claimable
# scholar-* job sits in jobs/todo/; (3) a role/scholar broadcast is newer than the
# schedule's last_dispatched AND carries an actionable scholar marker (an ingest
# `library_action:` field or a writeback-review request).
#
# The focus here is condition #3's actionability filter: a FRESH but purely
# informational broadcast (a deterministic-projection notice, a deploy/leadership
# announcement) must NOT trip the gate, because dispatching the LLM on it just
# drains and exits with nothing — the leaked idle dispatch the filter removes
# (the 2026-06-29T16:35:14Z scholar-library-cycle, journal entry
# entries/2026/06/29/163807Z-result-gardener-ef7244.md). A fresh broadcast that
# DOES carry `library_action: ingest-source` is real work and trips the gate.
#
# Hermetic: a throwaway bare journal stands in for origin/journal2; the gate's
# ensure_clone/sync_clone clone from it. No real systemd, no live journal.
#
# Usage: scholar-preflight-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PRE="$JOBS/scholar-preflight.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub any ambient garden env (this test is often run BY a live gardener whose
# process exports the fleet's own GARDEN_*/JOURNAL_* — they would splice the live
# journal underneath the gate). Only the test's throwaway $TR settings are
# authoritative below.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-scholar-preflight-test
rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
BRANCH=journal2
SCHED=scholar-library-cycle.md
git_id=(-c user.name=test -c user.email=test@localhost)

# --- seed a throwaway journal origin with the gate's required structure -------
# last_dispatched is a FIXED stamp; "fresh" messages are stamped strictly after
# it, "stale" ones strictly before, so freshness is clock-independent.
LAST_DISPATCHED=2026-06-29T16:00:00Z
FRESH_AT=2026-06-29T17:00:00Z       # after  last_dispatched → fresh
STALE_AT=2026-06-29T15:00:00Z       # before last_dispatched → not fresh

setup_fixture() {
  rm -rf "$BARE" "$TR/seed" "$TR/state"
  git init -q --bare "$BARE"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b "$BRANCH"
  ( cd "$SEED"
    mkdir -p jobs/todo inbox/scholar/unread msgs/role/scholar schedules
    for d in jobs/todo inbox/scholar/unread msgs/role/scholar schedules; do touch "$d/.gitkeep"; done
    printf 'name: %s\nlast_dispatched: %s\n' "$SCHED" "$LAST_DISPATCHED" > "schedules/$SCHED" )
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed scholar-preflight fixture"
  git -C "$SEED" remote add origin "$BARE"
  git -C "$SEED" push -q -u origin "$BRANCH"
}

# push a message file into msgs/role/scholar on origin/journal2
push_msg() {  # push_msg <basename> <sent_at> <body>
  local base="$1" sent="$2" body="$3" wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  {
    printf 'from_host: testhost\nfrom: send\nsent_at: %s\nto: role/scholar\n---\n' "$sent"
    printf '%s\n' "$body"
  } > "$wt/msgs/role/scholar/$base.md"
  git -C "$wt" add -A; git -C "$wt" "${git_id[@]}" commit -q -m "msg $base"
  git -C "$wt" push -q origin "$BRANCH"
  rm -rf "$wt"
}

# clear all msgs/role/scholar so each case starts from a clean broadcast set
clear_msgs() {
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q -f --ignore-unmatch 'msgs/role/scholar/*.md' >/dev/null 2>&1 || true
  if ! git -C "$wt" diff --cached --quiet; then
    git -C "$wt" "${git_id[@]}" commit -q -m "clear scholar broadcasts"
    git -C "$wt" push -q origin "$BRANCH"
  fi
  rm -rf "$wt"
}

run_pre() {  # fills $OUT / $RC — a fresh preflight clone each run (no caching)
  rm -rf "$TR/clone"
  set +e
  OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
             GARDEN=testhost GARDEN_STATE="$TR/state" \
             GARDEN_SCHOLAR_PREFLIGHT_CLONE="$TR/clone" \
             bash "$PRE" "$SCHED" 2>&1)"
  RC=$?
  set -e
}

# ============================================================================
hr; echo "STATIC — scholar-preflight.sh parses (bash -n)"; hr
bash -n "$PRE" && ok "scholar-preflight.sh parses" || bad "scholar-preflight.sh syntax error"

# ============================================================================
hr; echo "NO WORK — empty inbox, no job, no broadcast: exit 2"; hr
setup_fixture
run_pre
[ "$RC" -eq 2 ] && ok "exit 2 with nothing present" || bad "exit $RC (want 2) with nothing present"

# ============================================================================
hr; echo "INFORMATIONAL — fresh broadcast with NO actionable marker: exit 2"; hr
# Mirrors msgs/role/scholar/20260629T154517Z-423c15.md: a deterministic-projection
# notice. Fresh (after last_dispatched) but carries no library_action/writeback,
# so it must NOT dispatch — the leaked idle cycle the filter removes.
setup_fixture
push_msg 20260629T170000Z-info "$FRESH_AT" \
  "Two deterministic projections now replace hand-work. topics/README.md Sections-count column is regenerated, not hand-counted. Deploy/leadership notice; no scholar work here."
run_pre
[ "$RC" -eq 2 ] && ok "fresh informational broadcast → exit 2 (no idle dispatch)" || bad "exit $RC (want 2) on informational broadcast"
grep -qi "skipping informational" <<<"$OUT" && ok "logged the skip of the informational broadcast" || bad "no 'skipping informational' log ($OUT)"

# ============================================================================
hr; echo "ACTIONABLE INGEST — fresh broadcast with library_action: ingest-source: exit 0"; hr
clear_msgs
push_msg 20260629T170000Z-ingest "$FRESH_AT" \
  "$(printf 'library_action: ingest-source\nsource_repo: endojs/endo\nsource_path: packages/ses/README.md\n\nPlease ingest this source.')"
run_pre
[ "$RC" -eq 0 ] && ok "fresh ingest-source broadcast → exit 0 (work present)" || bad "exit $RC (want 0) on ingest broadcast"
grep -qi "actionable role/scholar broadcast" <<<"$OUT" && ok "logged the actionable-broadcast pickup" || bad "no actionable-broadcast log ($OUT)"

# ============================================================================
hr; echo "ACTIONABLE WRITEBACK — fresh broadcast asking writeback review: exit 0"; hr
# The library-lookup handoff: "library-lookup writebacks this job: <summary>".
clear_msgs
push_msg 20260629T170000Z-wb "$FRESH_AT" \
  "library-lookup writebacks this job: added keywords for the ocap-kernel topic; please audit and integrate the drafts."
run_pre
[ "$RC" -eq 0 ] && ok "fresh writeback-review broadcast → exit 0 (work present)" || bad "exit $RC (want 0) on writeback broadcast"

# ============================================================================
hr; echo "STALE ACTIONABLE — actionable marker but NOT fresh: exit 2"; hr
# Even an ingest ask does not count if it predates last_dispatched (already seen).
clear_msgs
push_msg 20260629T150000Z-old-ingest "$STALE_AT" \
  "$(printf 'library_action: ingest-source\nsource_repo: endojs/endo\nsource_path: README.md\n')"
run_pre
[ "$RC" -eq 2 ] && ok "stale (pre-last_dispatched) ingest broadcast → exit 2 (already seen)" || bad "exit $RC (want 2) on stale ingest broadcast"

# ============================================================================
hr; echo "MIXED — a stale ingest plus a fresh informational: exit 2"; hr
# Neither qualifies: the actionable one is stale, the fresh one is informational.
# Guards against the timestamp-only regression where ANY fresh broadcast tripped.
clear_msgs
push_msg 20260629T150000Z-old-ingest "$STALE_AT" \
  "$(printf 'library_action: ingest-source\nsource_path: README.md\n')"
push_msg 20260629T170000Z-info2 "$FRESH_AT" \
  "Deploy complete; leadership re-pointed to endolinbot2. Informational only."
run_pre
[ "$RC" -eq 2 ] && ok "stale-ingest + fresh-informational → exit 2 (no leaked dispatch)" || bad "exit $RC (want 2) on mixed set"

# ============================================================================
hr; echo "INBOX SHORT-CIRCUIT — unread scholar inbox: exit 0 (condition #1)"; hr
# Sanity that the actionability filter did not disturb conditions #1/#2.
clear_msgs
( wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  printf 'from: x\nsent_at: %s\n---\nan ask\n' "$FRESH_AT" > "$wt/inbox/scholar/unread/ask-1.md"
  git -C "$wt" add -A; git -C "$wt" "${git_id[@]}" commit -q -m "scholar inbox ask"
  git -C "$wt" push -q origin "$BRANCH"; rm -rf "$wt" )
run_pre
[ "$RC" -eq 0 ] && ok "unread scholar inbox → exit 0 (condition #1 intact)" || bad "exit $RC (want 0) on unread inbox"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
