#!/bin/bash
# rerecord-reputation-arm-test.sh — the stealth-id-unmask reputation migration
# (rerecord-reputation-arm.sh), exercised deterministically and hermetically.
#
# The migration relabels the identity fields of every event belonging to an unmasked
# stealth arm onto the now-named model's arm, going through the reducer's single source
# of truth (the event log) rather than editing a projection. Subtests:
#
#   ATTEST     — refuses with no --authorized-by, and with a login NOT on the journal
#                maintainers/allowlist; a listed maintainer is accepted.
#   RENAME     — a stealth arm's events are relabeled; the next reducer tick projects
#                the FULL history onto the new (named) arm, and the old projection
#                subtree is GC'd (no stale arm lingers).
#   MERGE      — relabeling onto a target arm that ALREADY has history folds the two
#                together exactly (Welford over the combined event set) on the next tick.
#   PENDING    — a not-yet-finalized pending event migrates too.
#   RECORD     — an append-only reputation/migrations/ record captures old/new/by/count.
#   IDEMPOTENT — a second identical run finds no old-arm events and makes no new commit.
#
# systemd is not required. Usage: rerecord-reputation-arm-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_|AUCTION_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_ROOT="$ROOT" GARDEN_NO_MAINTAINER_ALERT=1
# openrouter/openrouter-promo are METERED here (not flat), so numeric ledger dollars
# fold as-is and the arm math is easy to assert.
export GARDEN_REP_FLAT_PROVIDERS=
# shellcheck source=../common.sh
source "$JOBS/common.sh"
# shellcheck source=../reputation.sh
source "$JOBS/reputation.sh"

git_id=(-c user.name=test -c user.email=test@localhost)
SCRIPT="$JOBS/rerecord-reputation-arm.sh"

OLD_KEY='openrouter-promo/openrouter-promo/openrouter-promo/openrouter/horizon-beta'
NEW_KEY='openrouter/openrouter/openrouter/z-ai/glm-5.2:free'

# seed a throwaway bare origin + a journal2 board with reputation dirs + a maintainer.
seed_board() {   # seed_board <tr>  -> echoes bare path
  local tr="$1" bare="$1/journal.git" seed="$1/seed" branch=journal2
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/bids msgs \
             reputation/events reputation/pending reputation/arms reputation/adjustments \
             reputation/verdicts reputation/reviews maintainers
    for d in jobs/todo jobs/doin jobs/tada jobs/bids reputation/events reputation/pending \
             reputation/arms reputation/adjustments reputation/verdicts reputation/reviews; do touch "$d/.gitkeep"; done
    printf 'kriskowal\n' > maintainers/allowlist )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$branch"
  printf '%s\n' "$bare"
}
verify_clone() { git clone -q --single-branch --branch journal2 "$1" "$2" 2>/dev/null; }

# mkev <seed-dir> <dir> <base> <kind> <provider> <model> <tht> <wc> <target> <accepted> <agg>
mkev() {
  cat > "$1/reputation/$2/$3.md" <<EOF
---
base: $3
kind: $4
provider: $5
model: $6
thoughtfulness: $7
work_class: $8
target: $9
accepted: ${10}
agentic_dollars: ${11}
human_dollars: 0
aggregate_dollars: ${11}
cost_source: ledger
attempts: 1
source: live
---
reputation event for $3: arm $5/$6/$7 work_class $8 target $9 accepted ${10}
EOF
}
reduce() { # reduce <bare> <tr> <tag>
  env GARDEN=rh GARDEN_STATE="$2/state-$3" JOURNAL_REMOTE="$1" JOURNAL_BRANCH=journal2 \
      "$JOBS/reputation-reduce.sh" > "$2/reduce-$3.log" 2>&1 || true
}
run_mig() { # run_mig <bare> <tr> <tag> [extra args...]  -> rc; log at <tr>/mig-<tag>.log
  local bare="$1" tr="$2" tag="$3"; shift 3
  local rc=0
  env GARDEN=rh GARDEN_STATE="$tr/mstate-$tag" GARDEN_PRODUCER_CLONE="$tr/pclone-$tag" \
      JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 \
      "$SCRIPT" "$@" > "$tr/mig-$tag.log" 2>&1 || rc=$?
  return $rc
}

# ============================================================================
hr; echo "ATTEST — maintainer attestation is required"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/rr-attest.XXXXXX")"
BARE="$(seed_board "$TR")"
S="$TR/inj"; verify_clone "$BARE" "$S"
mkev "$S" events promo1 openrouter-promo openrouter-promo openrouter-promo/openrouter/horizon-beta minion build:m main2 true 3
git -C "$S" add -A; git -C "$S" "${git_id[@]}" commit -q -m inj; git -C "$S" push -q origin journal2

run_mig "$BARE" "$TR" noby "$OLD_KEY" "$NEW_KEY" && bad "migration succeeded with NO --authorized-by" \
  || ok "refused with no --authorized-by ($(tail -1 "$TR/mig-noby.log"))"
run_mig "$BARE" "$TR" badby "$OLD_KEY" "$NEW_KEY" --authorized-by nobody && bad "migration accepted a non-maintainer" \
  || ok "refused authorized_by not on allowlist ($(tail -1 "$TR/mig-badby.log"))"
run_mig "$BARE" "$TR" same "$OLD_KEY" "$OLD_KEY" --authorized-by kriskowal && bad "accepted identical old==new keys" \
  || ok "refused identical old==new arm keys"
# a listed maintainer succeeds (and actually migrates the one event).
run_mig "$BARE" "$TR" okby "$OLD_KEY" "$NEW_KEY" --authorized-by kriskowal \
  && ok "accepted a maintainer on the allowlist" || bad "refused a valid maintainer ($(tail -2 "$TR/mig-okby.log" | tr '\n' '|'))"
rm -rf "$TR"

# ============================================================================
hr; echo "RENAME — relabel events; reducer re-projects; old arm GC'd"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/rr-rename.XXXXXX")"
BARE="$(seed_board "$TR")"
S="$TR/inj"; verify_clone "$BARE" "$S"
# stealth arm: 3 build:m@main2 events (2 accepted $2/$4, 1 rejected $6) -> mean=(2+4+6)/2=6
mkev "$S" events pA openrouter-promo openrouter-promo openrouter-promo/openrouter/horizon-beta minion build:m main2 true 2
mkev "$S" events pB openrouter-promo openrouter-promo openrouter-promo/openrouter/horizon-beta minion build:m main2 true 4
mkev "$S" events pC openrouter-promo openrouter-promo openrouter-promo/openrouter/horizon-beta minion build:m main2 false 6
git -C "$S" add -A; git -C "$S" "${git_id[@]}" commit -q -m inj; git -C "$S" push -q origin journal2
reduce "$BARE" "$TR" pre
Vp="$TR/vpre"; verify_clone "$BARE" "$Vp"
old_arm="reputation/arms/openrouter-promo/openrouter-promo/openrouter-promo-openrouter-horizon-beta/minion/build-m@main2.md"
new_arm="reputation/arms/openrouter/openrouter/openrouter-z-ai-glm-5.2-free/minion/build-m@main2.md"
[ -f "$Vp/$old_arm" ] && ok "pre-migration: stealth arm projection exists" || bad "stealth arm not projected pre-migration"

run_mig "$BARE" "$TR" go "$OLD_KEY" "$NEW_KEY" --authorized-by kriskowal \
  && ok "migration ran" || bad "migration failed ($(tail -2 "$TR/mig-go.log" | tr '\n' '|'))"
Vm="$TR/vmig"; verify_clone "$BARE" "$Vm"
# events relabeled?
[ "$(plan_field "$Vm/reputation/events/pA.md" kind)" = openrouter ] \
  && [ "$(plan_field "$Vm/reputation/events/pA.md" provider)" = openrouter ] \
  && [ "$(plan_field "$Vm/reputation/events/pA.md" model)" = 'openrouter/z-ai/glm-5.2:free' ] \
  && ok "event identity fields relabeled to the named model" || bad "event identity not relabeled"
[ "$(plan_field "$Vm/reputation/events/pA.md" work_class)" = build:m ] \
  && [ "$(plan_field "$Vm/reputation/events/pA.md" accepted)" = true ] \
  && [ "$(plan_field "$Vm/reputation/events/pA.md" aggregate_dollars)" = 2 ] \
  && ok "non-identity fields preserved verbatim" || bad "non-identity fields altered"
[ "$(plan_field "$Vm/reputation/events/pA.md" rerecorded_from)" = "$OLD_KEY" ] \
  && ok "provenance rerecorded_from stamped on the event" || bad "provenance not stamped"
# old projection subtree GC'd?
[ ! -d "$Vm/reputation/arms/openrouter-promo/openrouter-promo/openrouter-promo-openrouter-horizon-beta" ] \
  && ok "old stealth arm subtree removed (no stale projection)" || bad "old stealth arm subtree lingered"
# reducer re-projects onto the new arm with the FULL history.
reduce "$BARE" "$TR" post
Vr="$TR/vpost"; verify_clone "$BARE" "$Vr"
if [ -f "$Vr/$new_arm" ]; then
  ok "reducer projected the new (named) arm"
  read -r att acc mean m2 cen est <<<"$(rep_read_projection "$Vr" "$new_arm")"
  [ "$att" = 3 ] && ok "carried attempts=3" || bad "attempts=$att"
  [ "$acc" = 2 ] && ok "carried accepts=2" || bad "accepts=$acc"
  awk -v m="$mean" 'BEGIN{exit !(m>5.99 && m<6.01)}' && ok "carried mean cost-per-accepted=6.0" || bad "mean=$mean"
else
  bad "reducer did not project the new arm ($(tail -3 "$TR/reduce-post.log" | tr '\n' '|'))"
fi
[ ! -f "$Vr/$old_arm" ] && ok "old arm stays gone after a reducer tick (no regeneration)" || bad "old arm regenerated"
rm -rf "$TR"

# ============================================================================
hr; echo "MERGE — relabel onto a target arm that already has history"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/rr-merge.XXXXXX")"
BARE="$(seed_board "$TR")"
S="$TR/inj"; verify_clone "$BARE" "$S"
# stealth arm: 1 accepted $2. target named arm already has 1 accepted $4.
mkev "$S" events sX openrouter-promo openrouter-promo openrouter-promo/openrouter/horizon-beta minion build:m main2 true 2
mkev "$S" events nY openrouter openrouter openrouter/z-ai/glm-5.2:free minion build:m main2 true 4
git -C "$S" add -A; git -C "$S" "${git_id[@]}" commit -q -m inj; git -C "$S" push -q origin journal2
run_mig "$BARE" "$TR" merge "$OLD_KEY" "$NEW_KEY" --authorized-by kriskowal \
  && ok "merge migration ran" || bad "merge migration failed ($(tail -2 "$TR/mig-merge.log" | tr '\n' '|'))"
reduce "$BARE" "$TR" merge
Vg="$TR/vmerge"; verify_clone "$BARE" "$Vg"
new_arm="reputation/arms/openrouter/openrouter/openrouter-z-ai-glm-5.2-free/minion/build-m@main2.md"
read -r att acc mean m2 cen est <<<"$(rep_read_projection "$Vg" "$new_arm")"
{ [ "$att" = 2 ] && [ "$acc" = 2 ]; } && ok "merged attempts=2 accepts=2 (both histories folded)" || bad "merge folded wrong (att=$att acc=$acc)"
awk -v m="$mean" 'BEGIN{exit !(m>2.99 && m<3.01)}' && ok "merged mean cost-per-accepted=3.0 ((2+4)/2)" || bad "merged mean=$mean"
rm -rf "$TR"

# ============================================================================
hr; echo "PENDING — a not-yet-finalized pending event migrates too"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/rr-pending.XXXXXX")"
BARE="$(seed_board "$TR")"
S="$TR/inj"; verify_clone "$BARE" "$S"
mkev "$S" pending qP openrouter-promo openrouter-promo openrouter-promo/openrouter/horizon-beta minion build:m fork/pr true 5
git -C "$S" add -A; git -C "$S" "${git_id[@]}" commit -q -m inj; git -C "$S" push -q origin journal2
run_mig "$BARE" "$TR" pend "$OLD_KEY" "$NEW_KEY" --authorized-by kriskowal \
  && ok "pending migration ran" || bad "pending migration failed"
Vq="$TR/vpend"; verify_clone "$BARE" "$Vq"
[ "$(plan_field "$Vq/reputation/pending/qP.md" provider)" = openrouter ] \
  && [ "$(plan_field "$Vq/reputation/pending/qP.md" model)" = 'openrouter/z-ai/glm-5.2:free' ] \
  && ok "pending event relabeled in place (stays pending)" || bad "pending event not relabeled"
rm -rf "$TR"

# ============================================================================
hr; echo "RECORD + IDEMPOTENT — audit record written; a second run no-ops"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/rr-idem.XXXXXX")"
BARE="$(seed_board "$TR")"
S="$TR/inj"; verify_clone "$BARE" "$S"
mkev "$S" events rZ openrouter-promo openrouter-promo openrouter-promo/openrouter/horizon-beta minion build:m main2 true 2
git -C "$S" add -A; git -C "$S" "${git_id[@]}" commit -q -m inj; git -C "$S" push -q origin journal2
run_mig "$BARE" "$TR" first "$OLD_KEY" "$NEW_KEY" --authorized-by kriskowal >/dev/null
V1="$TR/v1"; verify_clone "$BARE" "$V1"
recf="$(ls "$V1/reputation/migrations/"*.md 2>/dev/null | head -1 || true)"
if [ -n "$recf" ]; then
  ok "migration record written ($(basename "$recf"))"
  { [ "$(plan_field "$recf" authorized_by)" = kriskowal ] \
    && [ "$(plan_field "$recf" old_model)" = 'openrouter-promo/openrouter/horizon-beta' ] \
    && [ "$(plan_field "$recf" new_model)" = 'openrouter/z-ai/glm-5.2:free' ] \
    && [ "$(plan_field "$recf" event_count)" = 1 ]; } \
    && ok "record captures by/old/new/count" || bad "record fields wrong"
else
  bad "no migration record written"
fi
head1="$(git -C "$V1" rev-parse HEAD)"
# a second identical run finds no old-arm events -> no new commit.
run_mig "$BARE" "$TR" second "$OLD_KEY" "$NEW_KEY" --authorized-by kriskowal \
  && ok "second run exits clean" || bad "second run errored"
V2="$TR/v2"; verify_clone "$BARE" "$V2"
[ "$(git -C "$V2" rev-parse HEAD)" = "$head1" ] && ok "idempotent — no new commit on a re-run" || bad "re-run churned the journal"
rm -rf "$TR"

# ============================================================================
hr
echo "rerecord-reputation-arm: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
