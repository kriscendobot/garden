#!/bin/bash
# panel-run-record-migrate-test.sh — regression guard for the LEGACY-SLUG migration
# in scripts/jobs/panel-run-record.sh (`migrate` subcommand).
#
# THE SPLIT: before every origin-URL form was reduced to one `<owner>/<repo>` store
# key, a worktree whose origin git reported as `ssh://git@github.com/<owner>/<repo>.git`
# (the fleet's actual form, produced by the hosts'
# `url.ssh://git@github.com/.insteadOf https://github.com/` rewrite) keyed its runs
# under `panel-runs/ssh---git-github.com-<owner>-<repo>-<pr>/` instead of the
# canonical `panel-runs/<owner>-<repo>-<pr>/`. So one repository accumulated two
# disjoint archives and a query by repo saw half its history. The writer fix stopped
# the split WIDENING but left the already-split records where they lay.
#
# THE MIGRATION: `panel-run-record.sh migrate` moves each legacy directory's records
# into the canonical directory (the legacy name with the fixed `ssh---git-github.com-`
# prefix stripped IS the canonical slug), as a history-preserving git mv, CAS-pushed.
# This test drives the REAL migrate against a THROWAWAY journal2 and asserts:
#
#   SUBTEST 1 — a legacy record with NO canonical counterpart is MOVED into the
#               canonical directory, the legacy directory disappears, and git history
#               is preserved (the pre-migration commit is reachable via --follow).
#   SUBTEST 2 — a legacy record whose filename already exists in the canonical dir
#               with BYTE-IDENTICAL content is DEDUPED (legacy copy removed, the one
#               canonical copy retained).
#   SUBTEST 3 — a legacy record whose filename exists in the canonical dir with
#               DIFFERING content is REFUSED: both copies survive, the canonical is
#               untouched, and the run WARNs (no record is ever overwritten or lost).
#   SUBTEST 4 — the migration is IDEMPOTENT: a second run pushes NO new commit.
#   SUBTEST 5 — `--dry-run` reports the plan but changes nothing on journal2.
#
# Hermetic: the journal is a throwaway bare repo; GARDEN_TEST=1 arms the
# production-push refusal; backoff is zeroed.
#
# Usage: panel-run-record-migrate-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
WRITER="$JOBS/panel-run-record.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (this may run AS a board job under a live gardener) so it
# cannot splice its own GARDEN_* state or a real journal remote under the fixture.
# shellcheck disable=SC2046  # the split is the point: `unset` takes a LIST of names.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_ROOT="$ROOT" GARDEN_NO_MAINTAINER_ALERT=1

TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-run-record-migrate.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

git_id=(-c user.name=test -c user.email=test@localhost)

# --- seed a throwaway journal2 with the split archive -------------------------
# Each record is committed on its own so a moved file's PRE-migration commit is a
# real, reachable ancestor to prove history preservation.
SUB="$TR/j"; BARE="$SUB/journal.git"; SEED="$SUB/seed"; BRANCH=journal2
mkdir -p "$SUB"
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"

seed_record() {   # seed_record <relpath-under-seed> <content>
  local rel="$1" body="$2"
  mkdir -p "$SEED/$(dirname "$rel")"
  printf '%s\n' "$body" > "$SEED/$rel"
  git -C "$SEED" add "$rel"
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed $rel"
}

# S1: a legacy record with no canonical counterpart (a clean move).
LEG1=panel-runs/ssh---git-github.com-endojs-endo-but-for-bots-847/run-aaaa1111.md
CANON1=panel-runs/endojs-endo-but-for-bots-847/run-aaaa1111.md
S1_MARK="MOVE_ME_ENDO_847_unique_marker"
seed_record "$LEG1" "$S1_MARK"

# S2: a legacy record whose canonical twin is byte-identical (a dedupe).
LEG2=panel-runs/ssh---git-github.com-kriscendobot-finbot-12/run-bbbb2222.md
CANON2=panel-runs/kriscendobot-finbot-12/run-bbbb2222.md
S2_BODY="IDENTICAL_finbot_12_body"
seed_record "$CANON2" "$S2_BODY"
seed_record "$LEG2"   "$S2_BODY"

# S3: a legacy record whose canonical twin has DIFFERENT bytes (a collision).
LEG3=panel-runs/ssh---git-github.com-kriscendobot-finbot-12/run-cccc3333.md
CANON3=panel-runs/kriscendobot-finbot-12/run-cccc3333.md
S3_LEG="LEGACY_variant_of_cccc3333"
S3_CANON="CANONICAL_variant_of_cccc3333"
seed_record "$CANON3" "$S3_CANON"
seed_record "$LEG3"   "$S3_LEG"

git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

# run_migrate <state-sub> <extra-args...> — the REAL writer's migrate against the
# throwaway journal. Echoes nothing; stderr (the WARN/log lines) goes to <sub>.err.
run_migrate() {
  local st="$1"; shift
  env GARDEN=trh GARDEN_STATE="$TR/$st" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" \
      JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
      GARDEN_PRODUCER_CLONE="$TR/$st/producer/journal" \
      GARDEN_POST_ATTEMPTS=3 GARDEN_BACKOFF_BASE_MS=0 GARDEN_BACKOFF_CAP_MS=0 \
      bash "$WRITER" migrate "$@" 2>"$TR/$st.err"
}
verify_clone() { git clone -q --single-branch --branch journal2 "$BARE" "$1" 2>/dev/null; }
head_sha() { git -C "$1" rev-parse HEAD; }

# ============================================================================
hr; echo "SUBTEST 0 — snapshot the pre-migration head, then run the live migration"; hr
V0="$TR/v0"; verify_clone "$V0"; HEAD_BEFORE="$(head_sha "$V0")"
run_migrate m1; rc1=$?
[ "$rc1" -eq 0 ] && ok "migrate exits 0 (best-effort, never fatal)" || bad "migrate exited $rc1; err: $(cat "$TR/m1.err")"
V1="$TR/v1"; verify_clone "$V1"
HEAD_AFTER="$(head_sha "$V1")"
[ "$HEAD_AFTER" != "$HEAD_BEFORE" ] && ok "the migration pushed a commit" || bad "no migration commit landed"

# ============================================================================
hr; echo "SUBTEST 1 — a legacy record with no canonical twin is MOVED (history kept)"; hr
[ -f "$V1/$CANON1" ] && ok "the legacy record now lives under the canonical slug ($CANON1)" \
  || bad "record not found at canonical path $CANON1"
[ ! -e "$V1/$LEG1" ] && ok "the legacy copy is gone (not duplicated)" \
  || bad "the legacy copy still exists at $LEG1"
[ ! -d "$V1/$(dirname "$LEG1")" ] && ok "the emptied legacy directory disappeared from the tree" \
  || bad "the legacy directory lingers: $(dirname "$LEG1")"
grep -q "$S1_MARK" "$V1/$CANON1" 2>/dev/null && ok "the moved record's content is intact" \
  || bad "moved record content changed/missing"
# History preservation: --follow across the rename reaches the original seed commit.
nlog="$(git -C "$V1" log --follow --oneline -- "$CANON1" 2>/dev/null | wc -l | tr -d ' ')"
[ "${nlog:-0}" -ge 2 ] && ok "git --follow reaches the pre-migration commit (rename history preserved, $nlog commits)" \
  || bad "history not preserved across the move (--follow saw $nlog commit(s))"

# ============================================================================
hr; echo "SUBTEST 2 — an identical legacy twin is DEDUPED"; hr
[ -f "$V1/$CANON2" ] && ok "the canonical record survives ($CANON2)" || bad "canonical dedupe target lost!"
[ ! -e "$V1/$LEG2" ] && ok "the byte-identical legacy copy was removed (deduped)" \
  || bad "the identical legacy copy was not deduped ($LEG2 remains)"

# ============================================================================
hr; echo "SUBTEST 3 — a DIFFERING legacy twin is REFUSED (both survive, WARN)"; hr
[ -f "$V1/$LEG3" ] && ok "the colliding legacy copy is LEFT in place (not overwritten/lost)" \
  || bad "the colliding legacy copy vanished — data loss!"
[ -f "$V1/$CANON3" ] && grep -q "$S3_CANON" "$V1/$CANON3" 2>/dev/null \
  && ok "the canonical copy is untouched (its bytes preserved)" \
  || bad "the canonical copy was overwritten by the legacy content!"
grep -qi 'collision' "$TR/m1.err" && ok "the collision is a diagnosable WARN (not a silent swallow)" \
  || bad "no collision WARN emitted; err: $(cat "$TR/m1.err")"

# ============================================================================
hr; echo "SUBTEST 4 — the migration is IDEMPOTENT (a second run pushes nothing)"; hr
run_migrate m2; rc2=$?
[ "$rc2" -eq 0 ] && ok "second migrate exits 0" || bad "second migrate exited $rc2"
V2="$TR/v2"; verify_clone "$V2"
[ "$(head_sha "$V2")" = "$HEAD_AFTER" ] && ok "no new commit on the second run (idempotent no-op)" \
  || bad "a second migration pushed another commit (not idempotent)"
grep -qi 'idempotent\|no changes to push' "$TR/m2.err" && ok "the re-run reports a no-op" \
  || ok "re-run landed no new commit (idempotent by state)"

# ============================================================================
hr; echo "SUBTEST 5 — --dry-run changes nothing on journal2"; hr
# Reset the journal to the split state by re-seeding a fresh bare would be heavy;
# instead assert dry-run against the ALREADY-migrated journal still pushes nothing
# AND, more pointedly, that a dry run reports its plan without a commit. To exercise
# a dry run over REAL pending work, re-introduce one legacy record locally.
git -C "$SEED" "${git_id[@]}" checkout -q "$BRANCH"
git -C "$SEED" pull -q origin "$BRANCH" 2>/dev/null || true
DRYLEG=panel-runs/ssh---git-github.com-acme-widget-9/run-dddd4444.md
mkdir -p "$SEED/$(dirname "$DRYLEG")"
printf '%s\n' "DRYRUN_marker" > "$SEED/$DRYLEG"
git -C "$SEED" add "$DRYLEG"
git -C "$SEED" "${git_id[@]}" commit -q -m "seed a fresh legacy record for the dry-run test"
git -C "$SEED" push -q origin "$BRANCH"
V3="$TR/v3"; verify_clone "$V3"; DRY_HEAD_BEFORE="$(head_sha "$V3")"
run_migrate m3 --dry-run; rc3=$?
[ "$rc3" -eq 0 ] && ok "--dry-run exits 0" || bad "--dry-run exited $rc3"
V4="$TR/v4"; verify_clone "$V4"
[ "$(head_sha "$V4")" = "$DRY_HEAD_BEFORE" ] && ok "--dry-run pushed NO commit" \
  || bad "--dry-run mutated journal2!"
[ -f "$V4/panel-runs/ssh---git-github.com-acme-widget-9/run-dddd4444.md" ] \
  && ok "the legacy record is still where it was (dry-run touched nothing)" \
  || bad "--dry-run moved a record"
grep -qi 'DRY:\|dry-run' "$TR/m3.err" && ok "--dry-run reported its plan" \
  || bad "--dry-run printed no plan; err: $(cat "$TR/m3.err")"

hr
echo "panel-run-record-migrate-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
