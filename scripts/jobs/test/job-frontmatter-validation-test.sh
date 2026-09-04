#!/bin/bash
# job-frontmatter-validation-test.sh — write-side job-frontmatter validation
# (cybernetics audit § 7 [wrong sensor], recommendation 7).
#
# The gap it closes: job frontmatter is an interface with a CLOSED vocabulary on
# the READ side — job_tier (common.sh) accepts exactly mentat|mentor|minion|
# myrmidon and fails closed on anything else; gardener.sh honors handler-timeout
# only when it matches ^[1-9][0-9]*$ — but historically NO validation on the
# WRITE side. A `tier: builder` mis-spelling (§ 2.6) was ADMITTED silently, read
# downstream as "no tier", and the job ran at its role/default budget (2400 s)
# instead of the tier the producer meant to name; the overrun doom was correct on
# its own terms while the real defect sat upstream at admission.
#
# Asserts (write-side guard in post-job.sh / post-plan.sh + the read-side WARN in
# job_tier):
#   1. post-job WARN-first: an out-of-vocabulary `tier:` still POSTS (default),
#      but emits a WARN naming the bad value.
#   2. post-job STRICT: the same post is REFUSED (non-zero, no job) under
#      GARDEN_JOB_FRONTMATTER_STRICT=1.
#   3. post-job: a non-integer `handler-timeout:` WARNs (default) and refuses
#      (strict).
#   4. post-job: a VALID tier + integer handler-timeout is CLEAN — posts, no WARN.
#   5. Backward compat: a body with NO tier and NO handler-timeout posts CLEAN
#      (empty stays valid) — existing producers are unaffected.
#   6. post-plan mirrors post-job: out-of-vocab tier WARNs (default) / refuses
#      (strict); the parked body is what promote-plan later serves, so the mis-spec
#      must be caught at park time too.
#   7. job_tier logs ONE WARN on the silent rc-1 path (a non-empty tier outside
#      the vocabulary): rc is 1 AND a WARN was emitted (previously silent).
#   8. job_tier stays SILENT and rc-1 for an EMPTY tier with an unknown model
#      (the empty-tier fall-through is NOT a mis-spec; no WARN there).
#
# Hermetic: a throwaway bare journal; no real garden, journal, or network.
#
# Usage: job-frontmatter-validation-test.sh

# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/job-frontmatter-validation-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# Scrub any ambient fleet GARDEN_*/JOURNAL_* so a live gardener invoking this test
# cannot splice the real journal under it (the run-test.sh isolation rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# --- throwaway journal ------------------------------------------------------
BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
( cd "$SEED"
  mkdir -p jobs/todo jobs/plan jobs/doin jobs/tada jobs/index
  touch jobs/todo/.gitkeep jobs/plan/.gitkeep jobs/doin/.gitkeep jobs/tada/.gitkeep jobs/index/.gitkeep
  git add -A
  git -c user.name=test -c user.email=test@localhost commit -q -m seed
  git remote add origin "$BARE"
  git push -q -u origin journal2 )

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
       GARDEN_STATE="$TR/state" GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
       GARDEN=fmhost GARDEN_ROLE=gardener GARDEN_NO_MAINTAINER_ALERT=1

# job_tier / validate_job_frontmatter for the unit-level assertions.
# shellcheck source=../common.sh
source "$JOBS/common.sh"

tree()  { git -C "$BARE" ls-tree -r --name-only journal2; }
has()   { tree | grep -qx "jobs/$1.md"; }   # is jobs/<todo|plan>/<base> present
bodyfile() { local f; f="$(mktemp "$TR/body.XXXXXX")"; printf '%s\n' "$1" > "$f"; printf '%s' "$f"; }

echo "================================================================"
echo "JOB-FRONTMATTER VALIDATION (write-side, audit § 7)"
echo "================================================================"

BAD_TIER_BODY='---
tier: builder
---

a job whose producer mistyped the tier (meant a role, wrote a tier)'

BAD_HT_BODY='---
handler-timeout: soon
---

a job with a non-integer handler-timeout'

GOOD_BODY='---
tier: mentor
handler-timeout: 7200
---

a well-formed job'

BARE_BODY='an ordinary job with no tier and no handler-timeout at all'

# --- 1: post-job WARN-first — out-of-vocab tier still posts, with a WARN -----
err="$("$JOBS/post-job.sh" warn-bad-tier "$(bodyfile "$BAD_TIER_BODY")" 2>&1 >/dev/null)"; rc=$?
[ "$rc" -eq 0 ] && has todo/warn-bad-tier \
  && ok "1a out-of-vocab tier still POSTS by default (warn-first)" \
  || bad "1a out-of-vocab tier post did not land (rc=$rc)"
printf '%s' "$err" | grep -qi "WARN.*tier 'builder'" \
  && ok "1b post-job emitted a WARN naming the bad tier" \
  || bad "1b post-job did not WARN on the bad tier (got: $err)"

# --- 2: post-job STRICT — the same post is REFUSED, no job ------------------
err="$(GARDEN_JOB_FRONTMATTER_STRICT=1 "$JOBS/post-job.sh" strict-bad-tier "$(bodyfile "$BAD_TIER_BODY")" 2>&1 >/dev/null)"; rc=$?
[ "$rc" -ne 0 ] && ! has todo/strict-bad-tier \
  && ok "2a STRICT refuses the out-of-vocab-tier post (non-zero, no job)" \
  || bad "2a STRICT did not refuse (rc=$rc, present=$(has todo/strict-bad-tier && echo yes || echo no))"
printf '%s' "$err" | grep -qi 'refusing to post' \
  && ok "2b STRICT refusal explains itself" \
  || bad "2b STRICT refusal message missing (got: $err)"

# --- 3: post-job — non-integer handler-timeout WARNs / refuses -------------
err="$("$JOBS/post-job.sh" warn-bad-ht "$(bodyfile "$BAD_HT_BODY")" 2>&1 >/dev/null)"; rc=$?
[ "$rc" -eq 0 ] && has todo/warn-bad-ht \
  && printf '%s' "$err" | grep -qi 'WARN.*handler-timeout' \
  && ok "3a non-integer handler-timeout WARNs and still posts (default)" \
  || bad "3a non-integer handler-timeout default behavior wrong (rc=$rc; $err)"
err="$(GARDEN_JOB_FRONTMATTER_STRICT=1 "$JOBS/post-job.sh" strict-bad-ht "$(bodyfile "$BAD_HT_BODY")" 2>&1 >/dev/null)"; rc=$?
[ "$rc" -ne 0 ] && ! has todo/strict-bad-ht \
  && ok "3b STRICT refuses the non-integer handler-timeout post" \
  || bad "3b STRICT did not refuse non-integer handler-timeout (rc=$rc)"

# --- 4: a VALID tier + integer handler-timeout is CLEAN --------------------
err="$(GARDEN_JOB_FRONTMATTER_STRICT=1 "$JOBS/post-job.sh" clean-good "$(bodyfile "$GOOD_BODY")" 2>&1 >/dev/null)"; rc=$?
[ "$rc" -eq 0 ] && has todo/clean-good \
  && ok "4a a well-formed job posts even under STRICT" \
  || bad "4a well-formed job wrongly refused/failed (rc=$rc; $err)"
printf '%s' "$err" | grep -qi 'WARN.*tier\|WARN.*handler-timeout' \
  && bad "4b well-formed job wrongly emitted a validation WARN ($err)" \
  || ok "4b no validation WARN for a well-formed job"

# --- 5: backward compat — no tier, no handler-timeout posts CLEAN ----------
err="$(GARDEN_JOB_FRONTMATTER_STRICT=1 "$JOBS/post-job.sh" clean-bare "$(bodyfile "$BARE_BODY")" 2>&1 >/dev/null)"; rc=$?
[ "$rc" -eq 0 ] && has todo/clean-bare \
  && ok "5a a tier-less/timeout-less body posts CLEAN (empty stays valid)" \
  || bad "5a plain body wrongly refused/failed (rc=$rc; $err)"
printf '%s' "$err" | grep -qi 'WARN.*tier\|WARN.*handler-timeout' \
  && bad "5b plain body wrongly emitted a validation WARN ($err)" \
  || ok "5b no validation WARN for a plain body"

# --- 6: post-plan mirrors post-job -----------------------------------------
err="$("$JOBS/post-plan.sh" warn-plan-bad-tier "$(bodyfile "$BAD_TIER_BODY")" 2>&1 >/dev/null)"; rc=$?
[ "$rc" -eq 0 ] && has plan/warn-plan-bad-tier \
  && printf '%s' "$err" | grep -qi "WARN.*tier 'builder'" \
  && ok "6a post-plan WARNs and still parks an out-of-vocab tier (default)" \
  || bad "6a post-plan default behavior wrong (rc=$rc; $err)"
err="$(GARDEN_JOB_FRONTMATTER_STRICT=1 "$JOBS/post-plan.sh" strict-plan-bad-tier "$(bodyfile "$BAD_TIER_BODY")" 2>&1 >/dev/null)"; rc=$?
[ "$rc" -ne 0 ] && ! has plan/strict-plan-bad-tier \
  && ok "6b post-plan STRICT refuses the out-of-vocab tier (non-zero, no job)" \
  || bad "6b post-plan STRICT did not refuse (rc=$rc)"

# --- 7: job_tier logs ONE WARN on the silent rc-1 path ---------------------
jt="$TR/jt-bad.md"; printf '%s\n' "$BAD_TIER_BODY" > "$jt"
out="$(job_tier "$jt" 2>/dev/null)"; rc=$?
[ "$rc" -ne 0 ] && [ -z "$out" ] \
  && ok "7a job_tier still fails closed (rc-1, no stdout) on a bad tier" \
  || bad "7a job_tier did not fail closed (rc=$rc out='$out')"
werr="$(job_tier "$jt" 2>&1 >/dev/null || true)"
printf '%s' "$werr" | grep -qi "WARN.*tier 'builder'" \
  && ok "7b job_tier logs a WARN on the previously-silent rc-1 path" \
  || bad "7b job_tier did not WARN on the rc-1 path (got: $werr)"

# --- 8: job_tier stays SILENT for an EMPTY tier (not a mis-spec) ------------
jt2="$TR/jt-empty.md"; printf '%s\n' '---
model: no-such-model-xyz
---

empty tier, unknown model' > "$jt2"
werr="$(job_tier "$jt2" 2>&1 >/dev/null || true)"
printf '%s' "$werr" | grep -qi 'WARN.*tier' \
  && bad "8 job_tier wrongly WARNed on an EMPTY tier (empty is not a mis-spec)" \
  || ok "8 job_tier stays silent on an empty tier (only the closed-vocab violation WARNs)"

echo "----------------------------------------------------------------"
echo "job-frontmatter-validation-test: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
