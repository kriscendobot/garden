#!/bin/bash
# kimi-opus-fallback-test.sh — prove the kimi-k3 → opus automatic fallback.
#
# Design: designs/kimi-k3-takes-opus-work-with-opus-fallback.md. The directive
# (kriskowal 2026-07-28) is "kimi k3 starts taking work away from opus, for
# evaluation, with an automatic opus retry if kimi fails." This test demonstrates
# the fallback the DoD requires — a deliberately-failed kimi job re-runs on opus,
# fresh-session, ONCE, bounded — across four hermetic parts:
#
#   A. reroute_job_model / kimi_fallback_enabled (pure functions).
#   B. the reaper re-route: a stale kimi-k3 claim carrying a fallback chain is
#      requeued as an OPUS job (model-burned recorded, reap counter reset, a kimi
#      arm failure reputation event written); gated OFF by the journal flag; and
#      bounded to ONE hop (an already-opus job with an empty chain is not re-routed).
#   C. eligibility: a mystic claims a kimi-k3 builder job ONLY when armed AND the
#      job carries a fallback chain; designer stays barred; a gardener claims the
#      re-routed opus job.
#   D. the correctness crux — after a re-route the opus handler runs FRESH (a
#      --session-id, never a --resume) in a CLEAN worktree, discarding kimi's
#      leftover session and worktree, by construction.
#
# Hermetic: throwaway bare git origins + a fake claude, no network, no systemd.

# shellcheck disable=SC2015,SC2016
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
STUB="$HERE/stub-handler.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { printf -- '----------------------------------------------------------------\n'; }
git_id=(-c user.name=test -c user.email=test@localhost)

# Hermetic scrub, exactly like the other job-system tests.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# An exec-allowed base (the sandbox mounts /tmp noexec, which breaks a fake claude).
pick_exec_base() {
  local c probe rc
  for c in "${TMPDIR:-}" /tmp /var/tmp "$HOME"; do
    [ -n "$c" ] && [ -d "$c" ] && [ -w "$c" ] || continue
    probe="$(mktemp -d "$c/kof-probe.XXXXXX" 2>/dev/null)" || continue
    printf '#!/bin/sh\nexit 7\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null
    "$probe/x" >/dev/null 2>&1; rc=$?
    rm -rf "$probe"
    [ "$rc" -eq 7 ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}
EXEC_BASE="$(pick_exec_base)" || { echo "  SKIP: no exec-allowed temp base"; exit 0; }
TR="$(mktemp -d "$EXEC_BASE/.garden-test-kof.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

# ============================================================================
hr; echo "PART A — reroute_job_model + kimi_fallback_enabled (pure)"; hr
# shellcheck source=../common.sh
source "$JOBS/common.sh"

route() { printf -- '%s' "$1" | reroute_job_model; }

b1="$(printf -- '---\nrole: builder\nmodel: kimi-k3\nfallback-model: opus\n---\n# body\nwork\n')"
out1="$(route "$b1")"; rc1=$?
{ [ "$rc1" -eq 0 ] \
  && printf '%s' "$out1" | grep -q '^model: opus$' \
  && printf '%s' "$out1" | grep -q '^model-burned: kimi-k3$'; } \
  && ok "A1 kimi-k3 + [opus] -> model: opus, burned kimi-k3 (rc0)" \
  || bad "A1 single-hop re-route wrong (rc=$rc1): $out1"

b2="$(printf -- '---\nrole: builder\nmodel: kimi-k3\nfallback-model: opus, sonnet\nmodel-burned: prior\n---\nx\n')"
out2="$(route "$b2")"; rc2=$?
{ [ "$rc2" -eq 0 ] \
  && printf '%s' "$out2" | grep -q '^model: opus$' \
  && printf '%s' "$out2" | grep -q '^fallback-model: sonnet$' \
  && printf '%s' "$out2" | grep -q '^model-burned: prior kimi-k3$'; } \
  && ok "A2 chain [opus,sonnet] -> opus picked, sonnet remains, burn appended" \
  || bad "A2 multi-entry chain wrong (rc=$rc2): $out2"

b3="$(printf -- '---\nrole: builder\nmodel: kimi-k3\n---\nx\n')"
route "$b3" >/dev/null; rc3=$?
[ "$rc3" -eq 1 ] && ok "A3 no fallback chain -> no-op (rc1)" || bad "A3 expected rc1, got $rc3"

# The ping-pong bound: an already-opus job with an empty chain never re-routes back.
b4="$(printf -- '---\nrole: builder\nmodel: opus\nfallback-model:\nmodel-burned: kimi-k3\n---\nx\n')"
route "$b4" >/dev/null; rc4=$?
[ "$rc4" -eq 1 ] && ok "A4 opus + empty chain -> no-op (ping-pong bound: never back to kimi)" \
  || bad "A4 expected rc1, got $rc4"

# kimi_fallback_enabled: env override, then a flag file in a named clone dir.
GARDEN_KIMI_FALLBACK_ENABLED=on  kimi_fallback_enabled && ok "A5 env=on -> enabled"  || bad "A5 env=on should enable"
GARDEN_KIMI_FALLBACK_ENABLED=off kimi_fallback_enabled && bad "A6 env=off should disable" || ok "A6 env=off -> disabled"
cdir="$TR/flagclone"; mkdir -p "$cdir/config"
printf 'off\n' > "$cdir/config/kimi-takes-opus-work"
kimi_fallback_enabled "$cdir" && bad "A7 flag file off should disable" || ok "A7 flag file off -> disabled"
printf 'on\n'  > "$cdir/config/kimi-takes-opus-work"
kimi_fallback_enabled "$cdir" && ok "A8 flag file on -> enabled" || bad "A8 flag file on should enable"

# ============================================================================
hr; echo "PART B — the reaper re-route (board state + reputation + flag gate + bound)"; hr
# seed_reaper_board <flag on|off|none> <doin-frontmatter-and-body-writer-func>
# Builds a bare origin with a stale kimi claim, runs the reaper, returns the verify clone.
seed_and_reap() {  # seed_and_reap <label> <flag> <model> <chain> <burned>
  local label="$1" flag="$2" model="$3" chain="$4" burned="$5"
  local root="$TR/reap-$label"
  local bare="$root/journal.git" seed="$root/seed" branch=journal2
  local base="kf-$label"
  rm -rf "$root"; mkdir -p "$root"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan work inbox/maintainer/unread inbox/maintainer/read config entries reputation/events
    for d in jobs/todo jobs/doin jobs/tada jobs/plan work inbox/maintainer/unread inbox/maintainer/read config entries reputation/events; do touch "$d/.gitkeep"; done
    [ "$flag" != none ] && printf '%s\n' "$flag" > config/kimi-takes-opus-work
    # A stale claim in doin carrying a reap-now hint so it is requeued this tick.
    {
      printf -- '---\n'
      printf 'role: builder\n'
      printf 'model: %s\n' "$model"
      [ -n "$chain" ]  && printf 'fallback-model: %s\n' "$chain"
      [ -n "$burned" ] && printf 'model-burned: %s\n' "$burned"
      printf -- '---\n'
      printf '# %s\n\nthe original builder work body\n\n' "$base"
      printf -- '<!-- garden-reap-now -->\n'
      printf -- '---\nclaim:\n  host: testhost\n  gardener: 3\n  worker_kind: mystic\n  claimed_at: %s\n' \
        "$(date -u -d '@'"$(( $(date -u +%s) - 3000 ))" +%FT%TZ)"
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

# B1: armed + kimi-k3 + [opus] -> re-routed to opus.
V="$(seed_and_reap on-route on kimi-k3 opus '')"; base=kf-on-route
[ -f "$V/jobs/todo/$base.md" ] && ok "B1 re-routed job requeued to todo" || bad "B1 not in todo: $(ls "$V/jobs/todo" 2>/dev/null)"
grep -q '^model: opus$'        "$V/jobs/todo/$base.md" 2>/dev/null && ok "B1 model: pin advanced kimi-k3 -> opus" || bad "B1 model not opus"
grep -q '^model-burned: kimi-k3$' "$V/jobs/todo/$base.md" 2>/dev/null && ok "B1 kimi-k3 recorded in model-burned:" || bad "B1 burn not recorded"
grep -q '<!-- garden-reaped: 0 -->' "$V/jobs/todo/$base.md" 2>/dev/null && ok "B1 reap counter RESET to 0 (fresh opus budget)" || bad "B1 reap counter not reset: $(grep garden-reaped "$V/jobs/todo/$base.md" 2>/dev/null)"
ev="$(ls "$V/reputation/events/"*kimi-fallback.md 2>/dev/null | head -1)"
{ [ -n "$ev" ] && grep -q '^accepted: false$' "$ev" && grep -q '^model: kimi-k3$' "$ev"; } \
  && ok "B1 kimi arm reputation event: accepted:false (evaluation charges the fallback to kimi)" \
  || bad "B1 kimi-fallback reputation event missing/wrong: $ev"

# B2: flag OFF -> NO re-route (bar intact); the claim requeues unchanged as kimi-k3.
V="$(seed_and_reap off-noroute off kimi-k3 opus '')"; base=kf-off-noroute
grep -q '^model: kimi-k3$' "$V/jobs/todo/$base.md" 2>/dev/null && ok "B2 flag off: model stays kimi-k3 (no re-route)" || bad "B2 flag off re-routed anyway"
ls "$V/reputation/events/"*kimi-fallback.md >/dev/null 2>&1 && bad "B2 flag off wrote a fallback event" || ok "B2 flag off: no fallback event"

# B3: the ping-pong bound end to end — an already-opus job with an empty chain is
# requeued normally, NEVER re-routed back to kimi.
V="$(seed_and_reap bound on opus '' kimi-k3)"; base=kf-bound
grep -q '^model: opus$' "$V/jobs/todo/$base.md" 2>/dev/null && ok "B3 opus job with empty chain stays opus (one hop, no cycle)" || bad "B3 bound violated"
ls "$V/reputation/events/"*kimi-fallback.md >/dev/null 2>&1 && bad "B3 re-routed an opus job" || ok "B3 no second hop"

# ============================================================================
hr; echo "PART C — eligibility (mystic claims only armed+fallback builder; gardener claims re-routed opus)"; hr
# Mirrors worker-spine-kinds-test.sh elig_case, adding the kimi-fallback dimension.
elig_case() {  # elig_case <kind> <base> <front> <flag on|off|none> <expect claimed|left>
  local kind="$1" base="$2" front="$3" flag="$4" expect="$5"
  local root="$TR/elig-$base"
  local bare="$root/journal.git" seed="$root/seed" branch=journal2
  rm -rf "$root"; mkdir -p "$root"
  git init -q --bare "$bare"; git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada work config entries msgs hosts
    for d in jobs/todo jobs/doin jobs/tada work config entries msgs hosts; do touch "$d/.gitkeep"; done
    [ "$flag" != none ] && printf '%s\n' "$flag" > config/kimi-takes-opus-work
    { printf -- '---\n%s\n---\n# %s\n\nwork\n' "$front" "$base"; } > "jobs/todo/$base.md" )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$branch"
  env GARDEN=ehost GARDEN_STATE="$root/state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$branch" \
      GARDEN_WORKER_KIND="$kind" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_JOB_HANDLER="$STUB" \
      GARDEN_NO_MAINTAINER_ALERT=1 \
      "$JOBS/gardener.sh" 1 > "$root/worker.log" 2>&1 || true
  local v="$root/verify"; git clone -q --single-branch --branch "$branch" "$bare" "$v" 2>/dev/null
  local claimed=no; { [ -f "$v/jobs/tada/$base.md" ] || [ -e "$v/jobs/doin/$base.md" ]; } && claimed=yes
  if [ "$expect" = claimed ] && [ "$claimed" = yes ]; then ok "C $kind claimed '$base' ($expect)"
  elif [ "$expect" = left ] && [ "$claimed" = no ] && [ -f "$v/jobs/todo/$base.md" ]; then ok "C $kind left '$base' in todo ($expect)"
  else bad "C $kind eligibility wrong for '$base': expect=$expect claimed=$claimed"; fi
}

elig_case mystic   c-armed-fb   $'role: builder\nmodel: kimi-k3\nfallback-model: opus' on   claimed
elig_case mystic   c-armed-nofb $'role: builder\nmodel: kimi-k3'                        on   left
elig_case mystic   c-off-fb     $'role: builder\nmodel: kimi-k3\nfallback-model: opus' off  left
elig_case mystic   c-designer   $'role: designer\nmodel: kimi-k3\nfallback-model: opus' on   left
elig_case gardener c-opus-route $'role: builder\nmodel: opus\nmodel-burned: kimi-k3'    on   claimed

# ============================================================================
hr; echo "PART D — the correctness crux: opus runs FRESH in a CLEAN worktree after a re-route"; hr
if ! command -v python3 >/dev/null 2>&1; then
  echo "  SKIP-D: python3 absent (the deterministic session id / resume probe needs it)"
else
  GROOT="$TR/dgarden"; ORIGIN="$TR/dorigin.git"; SCRATCH="$GROOT/scratch"
  git init -q --bare "$ORIGIN"
  mkdir -p "$GROOT/scripts/jobs/handlers" "$GROOT/roles/gardener"
  git -C "$GROOT" init -q; git -C "$GROOT" config user.email t@localhost; git -C "$GROOT" config user.name test
  cp "$JOBS/common.sh" "$JOBS/usage-meter.sh" "$JOBS/quota-panel.sh" "$JOBS/reputation.sh" "$GROOT/scripts/jobs/" 2>/dev/null
  cp "$JOBS/handlers/gardener-claude.sh" "$JOBS/handlers/worker-common.sh" "$GROOT/scripts/jobs/handlers/"
  chmod +x "$GROOT/scripts/jobs/handlers/gardener-claude.sh"
  printf '# gardener role (test stub)\n' > "$GROOT/roles/gardener/AGENT.md"
  printf '/scratch/\n' > "$GROOT/.gitignore"
  git -C "$GROOT" add -A; git -C "$GROOT" commit -qm init; git -C "$GROOT" branch -M main2
  git -C "$GROOT" remote add origin "$ORIGIN"; git -C "$GROOT" push -q -u origin main2; git -C "$GROOT" fetch -q origin

  FAKEDIR="$TR/bin"; mkdir -p "$FAKEDIR"
  cat > "$FAKEDIR/claude" <<'FAKE'
#!/bin/bash
set -uo pipefail
sid=""; mode="fresh"; model=""; prev=""
for a in "$@"; do
  case "$prev" in
    --session-id) sid="$a"; mode="fresh" ;;
    --resume)     sid="$a"; mode="resume" ;;
    --model)      model="$a" ;;
  esac
  prev="$a"
done
printf '%s\n' "$mode"  > "$FAKE_MODE_OUT"
printf '%s\n' "$model" > "$FAKE_MODEL_OUT"
[ -e "$PWD/kimi-leftover" ] && printf 'present\n' > "$FAKE_LEFTOVER_OUT" || printf 'absent\n' > "$FAKE_LEFTOVER_OUT"
if [ -n "$sid" ]; then
  pd="$HOME/.claude/projects/$(printf '%s' "$PWD" | sed 's#/#-#g')"
  mkdir -p "$pd"; printf '{"transcript":"stub"}\n' >> "$pd/$sid.jsonl"
fi
printf 'job done\n'
[ -n "${FAKE_COMPLETION_MARKER:-}" ] && printf '%s\n' "$FAKE_COMPLETION_MARKER"
FAKE
  chmod +x "$FAKEDIR/claude"
  MARKER="$(sed -n "s/^GARDEN_COMPLETION_MARKER='\(.*\)'\$/\1/p" "$JOBS/common.sh" | head -1)"

  BASE="kf-crux"; WT="$SCRATCH/gardener-wt-$BASE"
  # Simulate kimi having run this base: a leftover worktree at the stable per-base
  # path (with an alien uncommitted file) and a private KIMI_CODE_HOME — but NO
  # Claude transcript (kimi writes none). This is exactly the state after a re-route.
  mkdir -p "$WT"; printf 'alien kimi edit\n' > "$WT/kimi-leftover"
  mkdir -p "$TR/dhome/.mystic-state/kimi/$BASE"
  # The re-routed job: opus-pinned, kimi-k3 burned (as the reaper leaves it).
  JOB="$TR/$BASE.job"
  printf -- '---\nrole: builder\nmodel: opus\nmodel-burned: kimi-k3\n---\n# %s\n\nbuilder work\n' "$BASE" > "$JOB"
  REPORT="$TR/dreport.txt"; SENTINEL="$TR/dsentinel"
  rm -f "$SENTINEL"
  HOME="$TR/dhome" PATH="$FAKEDIR:$PATH" \
    GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$TR/dstate" \
    GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STALE_HANDLER_KILL_GRACE=1 \
    GARDEN_COMPLETION_SENTINEL="$SENTINEL" GARDEN_USAGE_FILE="$TR/dusage.json" FAKE_COMPLETION_MARKER="$MARKER" \
    FAKE_MODE_OUT="$TR/dmode.out" FAKE_MODEL_OUT="$TR/dmodel.out" FAKE_LEFTOVER_OUT="$TR/dleftover.out" \
    bash "$GROOT/scripts/jobs/handlers/gardener-claude.sh" "$BASE" "$JOB" "$REPORT"; drc=$?

  [ "$drc" -eq 0 ] && ok "D handler exits 0 on the re-routed opus job" || bad "D handler rc=$drc"
  [ "$(cat "$TR/dmode.out" 2>/dev/null)" = fresh ] \
    && ok "D opus starts a FRESH session (--session-id, not --resume) — kimi's session is not inherited" \
    || bad "D opus did not run fresh: $(cat "$TR/dmode.out" 2>/dev/null)"
  [ "$(cat "$TR/dmodel.out" 2>/dev/null)" = "$(resolve_model_tier anthropic opus)" ] \
    && ok "D opus handler resolved --model $(resolve_model_tier anthropic opus)" \
    || bad "D wrong model: $(cat "$TR/dmodel.out" 2>/dev/null)"
  [ "$(cat "$TR/dleftover.out" 2>/dev/null)" = absent ] \
    && ok "D worktree RESET clean — kimi's alien uncommitted edit was discarded" \
    || bad "D kimi's leftover worktree file survived into the opus run"
fi

# ============================================================================
hr; echo "RESULTS: $PASS passed, $FAIL failed"; hr
[ "$FAIL" -eq 0 ]
