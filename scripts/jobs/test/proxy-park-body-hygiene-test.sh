#!/bin/bash
# proxy-park-body-hygiene-test.sh — regression guard for the PROXY PARKS A CLEAN BODY
# fix (improve-promote-plan-doom-reset follow-up, 2026-07-29).
#
# THE GAP THIS CLOSES: proxy.sh's blocked-job parking pre-pass lifted the job's LIVE
# board file (jobs/doin/ then jobs/todo/) and wrote it into jobs/plan/<base>.md
# VERBATIM. A doin/ file carries the trailing `---`/`claim:` block claim-job.sh
# appends, and either may carry the reaper/gardener CYCLE MARKERS from earlier cycles
# (`<!-- garden-reaped: N -->`, `<!-- garden-deadline-overrun: N -->`, and the
# per-cycle reap-now / productive-cycle / outage-cycle hints). Both then survived the
# whole round trip: promote-plan.sh's strip_frontmatter removes only the LEADING plan
# frontmatter, so when the blocker cleared and unblock.sh promoted the job, the stale
# claim block rode back into todo/ — a claim record for a run that had already ended,
# which reads as live provenance to every consumer that greps for it — and, before the
# promotion-clears-the-counters fix, the counters rode back with it too, walking the
# job straight into the no-op-promotion trap that fix exists to close.
#
# THE FIX: a block-park is a "run this again once the blocker clears" act — the same
# clean slate a promotion grants — so proxy.sh routes the lifted body through the
# SHARED helpers now living in common.sh beside the marker regexes: cut_claim_block
# (the same last-`---`-followed-by-`claim:` anchor clean_body uses) and
# strip_cycle_markers (the filter promote-plan.sh already used). The reaper's
# deliberate doom-park path is untouched: it parks a body whose deadline-overrun
# counter must PERSIST, and promote-plan.sh clears it at the promotion instead.
#
# SUBTEST 1 — the parked plan carries the work body with the claim block cut and every
#             cycle marker cleared; a `---` rule INSIDE the body survives (the cut
#             anchors on `---`+`claim:`, never a stray rule); a marker-free, claim-free
#             todo/ job parks unchanged; and the promoted todo/ body is clean too.
# SUBTEST 2 — the reaper's doom park is NOT affected: its parked body still carries
#             the deadline-overrun counter (which promote-plan.sh, not the park,
#             clears).
#
# Usage: proxy-park-body-hygiene-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_* state underneath the fixture).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-park-hygiene.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
BRANCH=journal2

# seed_board <dir> — throwaway origin with the board structure; echoes the bare path.
seed_board() {
  local tr="$1" bare="$1/journal.git" seed="$1/seed" d
  local dirs=(jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries schedules cursors
              inbox/maintainer/unread inbox/maintainer/read)
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"; mkdir -p "${dirs[@]}"; for d in "${dirs[@]}"; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m "seed: board structure"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$BRANCH"
  printf '%s\n' "$bare"
}

# ============================================================================
hr; echo "SUBTEST 1 — the proxy parks a CLEAN body: claim block cut, cycle markers cleared"; hr
T1="$TR/park"; mkdir -p "$T1"
BARE1="$(seed_board "$T1")"
export JOURNAL_REMOTE="$BARE1" JOURNAL_BRANCH="$BRANCH"
export GARDEN=parkhost GARDEN_STATE="$T1/state" GARDEN_SCRATCH="$T1/scratch"
export GARDEN_POST_ATTEMPTS=50
mkdir -p "$GARDEN_SCRATCH"

place() {  # place <relpath> < body-on-stdin
  local rel="$1" wt; wt="$(mktemp -d "$T1/place.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE1" "$wt"
  mkdir -p "$(dirname "$wt/$rel")"; cat > "$wt/$rel"
  git -C "$wt" add "$rel"
  git -C "$wt" "${git_id[@]}" commit -q -m "place $rel"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}
readback() {  # readback <relpath> — file contents from a fresh clone
  local v; v="$(mktemp -d "$T1/rb.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE1" "$v" 2>/dev/null
  cat "$v/$1" 2>/dev/null; rm -rf "$v"
}
has() {  # has <relpath>
  local v r; v="$(mktemp -d "$T1/hs.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE1" "$v" 2>/dev/null
  [ -e "$v/$1" ]; r=$?; rm -rf "$v"; return $r
}

# (a) a CLAIMED job mid-flight, dirtied exactly the way a real requeued claim is: every
#     cycle marker, a `---` rule inside its own body, and the trailing claim block.
place jobs/doin/dirty-job.md <<'EOF'
# dirty-job

do the PR-dependent work.

---

the section below the rule must survive the claim-block cut.

<!-- garden-reaped: 3 -->
<!-- garden-deadline-overrun: 2 -->
<!-- garden-reap-now -->
<!-- garden-productive-cycle -->
<!-- garden-outage-cycle -->

---
claim:
  host: parkhost
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-29T00:00:00Z
EOF

# (b) an UNCLAIMED todo/ job with nothing to clean — the cut must not truncate it.
place jobs/todo/clean-job.md <<'EOF'
# clean-job

do the job-dependent work.
EOF

PR_URL="https://github.com/endojs/endo-but-for-bots/pull/42"
b1="$(mktemp)"; echo "Cannot finish until the upstream PR lands."   > "$b1"
b2="$(mktemp)"; echo "Cannot finish until the prerequisite lands."  > "$b2"
"$JOBS/block-job.sh" dirty-job "$PR_URL"        "$b1" >/dev/null
"$JOBS/block-job.sh" clean-job some-blocker-job "$b2" >/dev/null

BPCALLS="$T1/block-pr-comment-calls"; : > "$BPCALLS"
PXCALLS="$T1/proxy-calls"; : > "$PXCALLS"
env GARDEN_PROXY_GRACE=3600 GARDEN_PROXY_HANDLER="$HERE/proxy-stub.sh" \
    GARDEN_PROXY_STUB_CALLS="$PXCALLS" \
    GARDEN_BLOCK_PR_COMMENT="$HERE/block-pr-comment-stub.sh" BLOCK_PR_COMMENT_CALLS="$BPCALLS" \
    "$JOBS/proxy.sh" > "$T1/proxy.log" 2>&1 \
  || { echo "  (proxy rc=$?)"; sed 's/^/    /' "$T1/proxy.log"; }

{ has jobs/plan/dirty-job.md && ! has jobs/doin/dirty-job.md; } \
  && ok "precondition: the blocked claim is parked in plan/ and gone from doin/" \
  || bad "the park did not happen (plan=$(has jobs/plan/dirty-job.md && echo y || echo n) doin=$(has jobs/doin/dirty-job.md && echo y || echo n))"

parked="$(readback jobs/plan/dirty-job.md)"

printf '%s\n' "$parked" | grep -q '^claim:' \
  && bad "the stale claim block survived the park" \
  || ok "the trailing claim block is cut from the parked body"

strip_ok=1
for m in 'garden-reaped:' 'garden-deadline-overrun:' 'garden-reap-now' 'garden-productive-cycle' 'garden-outage-cycle'; do
  printf '%s\n' "$parked" | grep -q -- "$m" && { strip_ok=0; echo "    marker survived the park: $m"; }
done
[ "$strip_ok" -eq 1 ] \
  && ok "every cycle marker (reaped / deadline-overrun / reap-now / productive / outage) is cleared at the park" \
  || bad "the park left cycle markers on the plan body"

{ printf '%s\n' "$parked" | grep -q 'do the PR-dependent work' \
  && printf '%s\n' "$parked" | grep -q 'the section below the rule must survive'; } \
  && ok "the work body survives — including the section below its own '---' rule (cut anchors on ---+claim:)" \
  || bad "the cut truncated the body at a stray '---' rule"

{ printf '%s\n' "$parked" | grep -q '^gate: blocked$' \
  && printf '%s\n' "$parked" | grep -qF "blocked_on: $PR_URL"; } \
  && ok "the plan frontmatter (gate: blocked + blocked_on) is intact — hygiene did not eat it" \
  || bad "the parked plan lost its gate/blocked_on frontmatter"

# The claim-free, marker-free job must come through byte-identical below its frontmatter.
clean_parked="$(readback jobs/plan/clean-job.md)"
{ printf '%s\n' "$clean_parked" | grep -q '^# clean-job$' \
  && printf '%s\n' "$clean_parked" | grep -q 'do the job-dependent work'; } \
  && ok "a claim-free, marker-free body parks unchanged (no blind truncation)" \
  || bad "the cut damaged a body that had nothing to clean"

# (c) round trip: the promoted todo/ body is clean too — the point of cleaning at the
#     park is that promote-plan.sh's strip_frontmatter cannot remove a claim block.
"$JOBS/promote-plan.sh" dirty-job > "$T1/promote.log" 2>&1 \
  || { echo "  (promote-plan rc=$?)"; sed 's/^/    /' "$T1/promote.log"; }
promoted="$(readback jobs/todo/dirty-job.md)"
{ ! printf '%s\n' "$promoted" | grep -q '^claim:' \
  && ! printf '%s\n' "$promoted" | grep -q 'garden-deadline-overrun:' \
  && printf '%s\n' "$promoted" | grep -q 'do the PR-dependent work'; } \
  && ok "round trip: the unblocked job returns to todo/ with no stale claim block and no counters" \
  || bad "the promoted body still carries the claim block / counters"

# ============================================================================
hr; echo "SUBTEST 2 — the reaper's doom park is untouched (its counter must PERSIST)"; hr
T2="$TR/doom"; mkdir -p "$T2"
BARE2="$(seed_board "$T2")"
export JOURNAL_REMOTE="$BARE2" GARDEN=reaphost GARDEN_STATE="$T2/state" GARDEN_SCRATCH="$T2/scratch"
export GARDEN_REAP_PUSH_ATTEMPTS=50 GARDEN_CLAIM_TTL=3600
export GARDEN_REAP_DOOM_THRESHOLD=5 GARDEN_REAP_OVERRUN_THRESHOLD=1
mkdir -p "$GARDEN_SCRATCH"

wt="$(mktemp -d "$T2/edit.XXXXXX")"
git clone -q --single-branch --branch "$BRANCH" "$BARE2" "$wt"
cat > "$wt/jobs/doin/ovrjob.md" <<'EOF'
# ovrjob

the original work body for ovrjob

<!-- garden-deadline-overrun: 1 -->

---
claim:
  host: reaphost
  gardener: 7
  claimed_at: 2020-01-01T00:00:00Z
EOF
printf 'worktree_dir: %s\n' "$T2/nonexistent-wt-ovrjob" > "$wt/work/ovrjob"
git -C "$wt" add jobs/doin/ovrjob.md work/ovrjob
git -C "$wt" "${git_id[@]}" commit -q -m "place stale ovrjob"
git -C "$wt" push -q origin "HEAD:$BRANCH"
rm -rf "$wt"

"$JOBS/reaper.sh" > "$T2/reap.log" 2>&1 || { echo "  (reaper rc=$?)"; sed 's/^/    /' "$T2/reap.log"; }
V="$T2/v"; rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE2" "$V"
{ [ -f "$V/jobs/plan/ovrjob.md" ] && grep -q '^doomed: true$' "$V/jobs/plan/ovrjob.md" \
  && grep -Eq '^<!-- garden-deadline-overrun: 1 -->$' "$V/jobs/plan/ovrjob.md"; } \
  && ok "the reaper still doom-parks with its deadline-overrun counter in the body (cleared at promotion, not at the park)" \
  || bad "the proxy's park hygiene leaked into the reaper's doom-park path"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
