#!/bin/bash
# reroute-role-floor-test.sh — the reaper's one-hop model reroute must respect a
# per-ROLE tier FLOOR and must not BURN a tier that was only ever served at a lower
# one under the anthropic automatic-work cost ceiling.
#
# Motivating incident (job garden-reroute-respect-role-tier-floor, 2026-08-17): the
# DESIGNER job `proposal-compartments-xs-source-phase-design` failed once transiently,
# the reaper demoted it mentor -> minion (a tier no worker can DESIGN at), recorded
# `model-burned: mentor`, and then doomed it after four wasted impossible-tier cycles.
# Two distinct defects:
#
#   1. NO CANONICAL FLOOR. reroute_job_model advanced the pin down the fallback chain
#      with no regard to the job's role. skills/model-selection is explicit that
#      `designer`/`builder` ride the latest Opus (mentor); demoting below that makes
#      success impossible.  role_tier_floor now names the floor and reroute_job_model
#      refuses (rc 2) any below-floor demotion.
#   2. BURNING A TIER NEVER SERVED. The Claude handler serves an AUTOMATIC mentor job
#      at the MINION model (monk-claude.sh anthropic ceiling). A failure there is
#      evidence about minion, not mentor, so the reaper must NOT burn mentor / demote
#      on its strength when the failed claim was anthropic-served.
#
# Hermetic: throwaway bare git origins, no network, no systemd, no `claude`.

# shellcheck disable=SC2015,SC2016
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { printf -- '----------------------------------------------------------------\n'; }
git_id=(-c user.name=test -c user.email=test@localhost)

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# An exec-allowed base (the sandbox mounts /tmp noexec).
pick_exec_base() {
  local c probe rc
  for c in "${TMPDIR:-}" /tmp /var/tmp "$HOME"; do
    [ -n "$c" ] && [ -d "$c" ] && [ -w "$c" ] || continue
    probe="$(mktemp -d "$c/rrf-probe.XXXXXX" 2>/dev/null)" || continue
    printf '#!/bin/sh\nexit 7\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null
    "$probe/x" >/dev/null 2>&1; rc=$?
    rm -rf "$probe"
    [ "$rc" -eq 7 ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}
EXEC_BASE="$(pick_exec_base)" || { echo "  SKIP: no exec-allowed temp base"; exit 0; }
TR="$(mktemp -d "$EXEC_BASE/.garden-test-rrf.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

# ============================================================================
hr; echo "PART A — role_tier_floor / tier_rank / reroute_job_model floor (pure)"; hr
# shellcheck source=../common.sh
source "$JOBS/common.sh"

# A1 — the floor map: design/build-heavy roles pin UP to mentor, all else minion.
a1=ok
for r in designer builder web-designer web-builder; do
  [ "$(role_tier_floor "$r")" = mentor ] || a1="role_tier_floor $r != mentor"
done
for r in fixer weaver shepherd botanist conductor "" bogus-role; do
  [ "$(role_tier_floor "$r")" = minion ] || a1="role_tier_floor '$r' != minion"
done
[ "$a1" = ok ] && ok "A1 role_tier_floor: designer/builder(+web)=mentor, everything else=minion" || bad "A1 $a1"

# A2 — tier_rank orders the closed vocabulary; a non-tier value is unranked (-1).
{ [ "$(tier_rank mentat)" = 0 ] && [ "$(tier_rank mentor)" = 1 ] \
  && [ "$(tier_rank minion)" = 2 ] && [ "$(tier_rank myrmidon)" = 3 ] \
  && [ "$(tier_rank opus)" = -1 ] && [ "$(tier_rank "")" = -1 ]; } \
  && ok "A2 tier_rank: mentat<mentor<minion<myrmidon; model id / empty = unranked (-1)" \
  || bad "A2 tier_rank ordering wrong"

route() { printf -- '%s' "$1" | reroute_job_model "$2"; }

# A3 — a designer at tier mentor with a fallback-tier of minion: below floor -> rc 2,
# body UNCHANGED (no demotion, no burn, chain intact).
db="$(printf -- '---\nrole: designer\ntier: mentor\nfallback-tier: minion\ndispatch: automatic\n---\nwork\n')"
out3="$(route "$db" mentor)"; rc3=$?
{ [ "$rc3" -eq 2 ] \
  && printf '%s' "$out3" | grep -q '^tier: mentor$' \
  && printf '%s' "$out3" | grep -q '^fallback-tier: minion$' \
  && ! printf '%s' "$out3" | grep -q '^model-burned:'; } \
  && ok "A3 designer mentor->minion REFUSED (rc2): tier/chain unchanged, nothing burned" \
  || bad "A3 designer floor not honoured (rc=$rc3): $out3"

# A4 — a fixer (floor minion) at tier mentor: minion == floor, NOT below -> rc 0,
# demoted with mentor burned and the chain emptied.
fb="$(printf -- '---\nrole: fixer\ntier: mentor\nfallback-tier: minion\ndispatch: automatic\n---\nwork\n')"
out4="$(route "$fb" minion)"; rc4=$?
{ [ "$rc4" -eq 0 ] \
  && printf '%s' "$out4" | grep -q '^tier: minion$' \
  && printf '%s' "$out4" | grep -q '^model-burned: mentor$'; } \
  && ok "A4 fixer mentor->minion ALLOWED (rc0): demoted to its floor, mentor burned" \
  || bad "A4 fixer demotion wrong (rc=$rc4): $out4"

# A5 — no floor argument preserves the historical two-value contract exactly.
out5="$(printf -- '%s' "$fb" | reroute_job_model)"; rc5=$?
{ [ "$rc5" -eq 0 ] && printf '%s' "$out5" | grep -q '^tier: minion$'; } \
  && ok "A5 no floor arg: backward-compatible rc0 demotion" || bad "A5 backcompat broke (rc=$rc5)"

# A6 — floor mentor but the chain head is a concrete model id (unranked): the floor
# never blocks the legacy model-pinned migration path.
mb="$(printf -- '---\nrole: designer\nmodel: kimi-k3\nfallback-model: opus\n---\nwork\n')"
out6="$(route "$mb" mentor)"; rc6=$?
{ [ "$rc6" -eq 0 ] && printf '%s' "$out6" | grep -q '^model: opus$'; } \
  && ok "A6 floor mentor + concrete-model chain head (opus): unranked, not blocked (rc0)" \
  || bad "A6 floor wrongly blocked a model-pinned reroute (rc=$rc6): $out6"

# ============================================================================
hr; echo "PART B — the reaper: floor honoured, and no burn of an unserved tier"; hr
# seed_and_reap <label> <role> <tier> <fallback-tier> <provider> — a stale claim in
# doin carrying a reap-now hint (requeued this tick), served by <provider>. Returns
# the verify clone path.
seed_and_reap() {
  local label="$1" role="$2" tier="$3" chain="$4" provider="$5"
  local root="$TR/reap-$label" bare branch=journal2
  bare="$root/journal.git"; local seed="$root/seed" base="rrf-$label"
  rm -rf "$root"; mkdir -p "$root"
  git init -q --bare "$bare"; git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan work inbox/maintainer/unread inbox/maintainer/read config entries reputation/events
    for d in jobs/todo jobs/doin jobs/tada jobs/plan work inbox/maintainer/unread inbox/maintainer/read config entries reputation/events; do touch "$d/.gitkeep"; done
    {
      printf -- '---\n'
      printf 'role: %s\n' "$role"
      printf 'tier: %s\n' "$tier"
      [ -n "$chain" ] && printf 'fallback-tier: %s\n' "$chain"
      printf 'dispatch: automatic\n'
      printf -- '---\n'
      printf '# %s\n\nthe original %s work body\n\n' "$base" "$role"
      printf -- '<!-- garden-reap-now -->\n'
      printf -- '---\nclaim:\n  host: testhost\n  gardener: 3\n  worker_kind: gardener\n  provider: %s\n  claimed_at: %s\n' \
        "$provider" "$(date -u -d '@'"$(( $(date -u +%s) - 3000 ))" +%FT%TZ)"
    } > "jobs/doin/$base.md"
    printf 'worktree_dir: %s\n' "$root/nonexistent-wt" > "work/$base" )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$branch"
  env GARDEN=reaphost GARDEN_STATE="$root/state" \
      JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$branch" \
      GARDEN_HANDLER_TIMEOUT=5 GARDEN_HANDLER_KILL_AFTER=1 GARDEN_REAP_SAFETY_SLACK=1 \
      GARDEN_CLAIM_TTL=10 GARDEN_KIMI_FALLBACK_AFTER=1 GARDEN_REAP_DOOM_THRESHOLD=5 \
      GARDEN_NO_MAINTAINER_ALERT=1 \
      "$JOBS/reaper.sh" > "$root/reap.log" 2>&1 || echo "    (reaper rc=$? — see $root/reap.log)"
  local v="$root/verify"; git clone -q --single-branch --branch "$branch" "$bare" "$v" 2>/dev/null
  printf '%s\n' "$v"
}

# B1 (bug #1) — a DESIGNER mentor job that failed on a TRUE-mentor provider (openai,
# not the anthropic ceiling) is NOT demoted below its mentor floor.
V="$(seed_and_reap designer designer mentor minion openai)"; base=rrf-designer
J="$V/jobs/todo/$base.md"
[ -f "$J" ] && ok "B1 designer job requeued to todo" || bad "B1 not in todo: $(ls "$V/jobs/todo" 2>/dev/null)"
grep -q '^tier: mentor$'         "$J" 2>/dev/null && ok "B1 tier stays mentor (floor honoured, not demoted to minion)" || bad "B1 tier demoted: $(grep '^tier:' "$J" 2>/dev/null)"
grep -q '^fallback-tier: minion$' "$J" 2>/dev/null && ok "B1 fallback chain intact (no hop spent)" || bad "B1 chain consumed"
grep -q '^model-burned:'          "$J" 2>/dev/null && bad "B1 burned a tier that was refused" || ok "B1 nothing burned"
ls "$V/reputation/events/"*kimi-fallback.md >/dev/null 2>&1 && bad "B1 wrote a fallback event on a refused reroute" || ok "B1 no fallback reputation event"

# B2 (bug #2) — a FIXER mentor job whose failed claim was ANTHROPIC-served (the
# minion-model ceiling): mentor was never actually tried, so it is NOT burned and the
# job stays at mentor for a true-mentor provider.
V="$(seed_and_reap anthropic fixer mentor minion anthropic)"; base=rrf-anthropic
J="$V/jobs/todo/$base.md"
grep -q '^tier: mentor$' "$J" 2>/dev/null && ok "B2 anthropic-served mentor job stays mentor (ceiling-suppress)" || bad "B2 tier changed: $(grep '^tier:' "$J" 2>/dev/null)"
grep -q '^model-burned:' "$J" 2>/dev/null && bad "B2 burned mentor though it was served at the minion model" || ok "B2 mentor NOT burned (unserved tier)"
ls "$V/reputation/events/"*kimi-fallback.md >/dev/null 2>&1 && bad "B2 wrote a fallback event under the ceiling" || ok "B2 no fallback reputation event"

# B3 (control) — a FIXER mentor job that failed on a TRUE-mentor provider (openai) IS
# demoted to its floor (minion), mentor burned, chain emptied: the genuine, intended
# reroute still fires for a role whose floor permits it.
V="$(seed_and_reap fixer fixer mentor minion openai)"; base=rrf-fixer
J="$V/jobs/todo/$base.md"
grep -q '^tier: minion$'        "$J" 2>/dev/null && ok "B3 fixer demoted mentor->minion (floor permits; genuine reroute)" || bad "B3 not demoted: $(grep '^tier:' "$J" 2>/dev/null)"
grep -q '^model-burned: mentor$' "$J" 2>/dev/null && ok "B3 mentor burned (a true-mentor provider genuinely failed)" || bad "B3 burn not recorded"
grep -q '<!-- garden-reaped: 0 -->' "$J" 2>/dev/null && ok "B3 reap counter reset (fresh floor-tier budget)" || bad "B3 counter not reset"

# ============================================================================
hr; echo "RESULTS: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
