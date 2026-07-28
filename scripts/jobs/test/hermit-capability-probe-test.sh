#!/bin/bash
# hermit-capability-probe-test.sh — the hermit-failure capability probe + demerit
# (design hermit-failure-capability-demerit.md; maintainer directive 2026-07-27),
# exercised deterministically and hermetically (no live model, no systemd).
#
# Subtests:
#   SUCCESS   — a capable probe (fake claude that emits the completion marker)
#               COMPLETES the work the hermit failed; the probe writes a per-base
#               probe record (capable_succeeded=1) AND a demerit reputation event
#               (accepted:false) keyed to the LOCAL (hermit) arm.
#   FAIL      — a capable probe that does NOT emit the marker records the probe
#               (capable_succeeded=0) and NO demerit — an honest "a capable model
#               also could not do it" outcome.
#   DEDUP     — a second probe of the same base is a no-op (once-per-base marker).
#   GUARDS    — a non-hermit worker, and GARDEN_HERMIT_PROBE=0, both SKIP the probe
#               (no probe record written).
#   REDUCER   — the reducer folds the demerit into the local arm's projection:
#               attempts>=1, accepts=0, acceptance_rate=0 (the routing signal).
#
# Usage: hermit-capability-probe-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (this may run AS a board job under a live gardener).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_|AUCTION_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_ROOT="$ROOT" GARDEN_NO_MAINTAINER_ALERT=1
# shellcheck source=../common.sh
source "$JOBS/common.sh"
# shellcheck source=../auction.sh
source "$JOBS/auction.sh"

git_id=(-c user.name=test -c user.email=test@localhost)

# seed_board <tr> — throwaway bare origin + a journal2 board carrying reputation/.
# Echoes the bare path.
seed_board() {
  local tr="$1" bare="$1/journal.git" seed="$1/seed" branch=journal2
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada reputation/events reputation/pending \
             reputation/arms reputation/verdicts reputation/reviews reputation/probes entries
    for d in jobs/todo jobs/doin jobs/tada reputation/events reputation/pending \
             reputation/arms reputation/verdicts reputation/reviews reputation/probes entries; do
      touch "$d/.gitkeep"
    done )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m "seed"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$branch"
  printf '%s\n' "$bare"
}

# a throwaway GARDEN_ROOT git repo with a main2 branch, so worker_ensure_worktree can
# `git worktree add` a probe worktree off it (NEVER the real garden root).
seed_garden_root() {
  local gr="$1"
  git init -q "$gr"; git -C "$gr" checkout -q -b main2
  ( cd "$gr" && : > .gitkeep )
  git -C "$gr" add -A; git -C "$gr" "${git_id[@]}" commit -q -m "root"
}

# a fake `claude` that emits a JSON envelope. FAKE_MARKER=1 -> the .result ends with
# the completion marker (a genuine completion); else it does not.
make_fake_claude() {
  local path="$1"
  cat > "$path" <<'EOF'
#!/bin/bash
set -euo pipefail
if [ "${FAKE_MARKER:-0}" = 1 ]; then
  body="did the work in an isolated worktree; tests pass\n<<<GARDEN-JOB-COMPLETE>>>"
else
  body="attempted the work but could not finish; leaving unfinished"
fi
printf '{"result":"%s"}\n' "$body"
EOF
  chmod +x "$path"
}

verify_clone() { git clone -q --single-branch --branch journal2 "$1" "$2" 2>/dev/null; }

# run_probe <bare> <garden-root> <fakeclaude> <jobfile> <base> [extra env kv...] —
# invoke the probe as a subprocess in a hermetic env. Extra args are passed verbatim
# to `env` (e.g. GARDEN_WORKER_KIND=gardener, GARDEN_HERMIT_PROBE=0).
run_probe() {
  local bare="$1" gr="$2" fc="$3" jf="$4" base="$5"; shift 5
  env -i PATH="$PATH" HOME="$HOME" FAKE_MARKER="${FAKE_MARKER:-0}" \
    GARDEN=hp GARDEN_TEST=1 GARDEN_NO_MAINTAINER_ALERT=1 \
    GARDEN_ROOT="$gr" GARDEN_STATE="$gr/.garden-state" GARDEN_SCRATCH="$gr/scratch" \
    JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 \
    GARDEN_WORKER_KIND=hermit GARDEN_CLAUDE_BIN="$fc" \
    GARDEN_HERMIT_PROBE_TIMEOUT=60 GARDEN_FLEET_BRAKE_THRESHOLD=0 \
    "$@" \
    "$JOBS/hermit-capability-probe.sh" "$base" "$jf"
}

# ============================================================================
hr; echo "SUCCESS — capable probe completes -> probe record + demerit"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/hcp-success.XXXXXX")"
BARE="$(seed_board "$TR")"; GR="$TR/gr"; seed_garden_root "$GR"
FC="$TR/fake-claude.sh"; make_fake_claude "$FC"
JF="$TR/job.md"; printf -- '---\nrole: builder\ntarget: main2\n---\n# widget\n\nadd a widget\n' > "$JF"
FAKE_MARKER=1 run_probe "$BARE" "$GR" "$FC" "$JF" widget-job > "$TR/probe.log" 2>&1 || true
V="$TR/v"; verify_clone "$BARE" "$V"
if [ -f "$V/reputation/probes/widget-job.md" ]; then
  ok "probe record written (reputation/probes/widget-job.md)"
  [ "$(plan_field "$V/reputation/probes/widget-job.md" capable_succeeded)" = 1 ] \
    && ok "probe record capable_succeeded=1" || bad "capable_succeeded not 1 ($(plan_field "$V/reputation/probes/widget-job.md" capable_succeeded))"
else
  bad "no probe record written (log tail: $(tail -5 "$TR/probe.log" | tr '\n' '|'))"
fi
DEM="$V/reputation/events/widget-job.hermit-demerit.md"
if [ -f "$DEM" ]; then
  ok "demerit event written (events/widget-job.hermit-demerit.md)"
  [ "$(plan_field "$DEM" accepted)" = false ] && ok "demerit accepted=false" || bad "demerit accepted ($(plan_field "$DEM" accepted))"
  [ "$(plan_field "$DEM" provider)" = local ] && ok "demerit provider=local (hermit arm)" || bad "demerit provider ($(plan_field "$DEM" provider))"
  [ "$(plan_field "$DEM" kind)" = hermit ] && ok "demerit kind=hermit" || bad "demerit kind ($(plan_field "$DEM" kind))"
  [ "$(plan_field "$DEM" demerit)" = true ] && ok "demerit demerit=true" || bad "demerit flag ($(plan_field "$DEM" demerit))"
  # aggregate must be NON-censored so the reducer counts it as an attempt.
  agg="$(plan_field "$DEM" aggregate_dollars)"
  case "$agg" in ''|censored|*[!0-9.]*) bad "demerit aggregate_dollars not a positive number ($agg)" ;; *) ok "demerit aggregate_dollars is numeric ($agg) — folds as a counted attempt" ;; esac
else
  bad "no demerit event written"
fi
rm -rf "$TR"

# ============================================================================
hr; echo "FAIL — capable probe does NOT complete -> probe record, NO demerit"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/hcp-fail.XXXXXX")"
BARE="$(seed_board "$TR")"; GR="$TR/gr"; seed_garden_root "$GR"
FC="$TR/fake-claude.sh"; make_fake_claude "$FC"
JF="$TR/job.md"; printf -- '---\nrole: builder\ntarget: main2\n---\n# hard\n\nimpossible\n' > "$JF"
FAKE_MARKER=0 run_probe "$BARE" "$GR" "$FC" "$JF" hard-job > "$TR/probe.log" 2>&1 || true
V="$TR/v"; verify_clone "$BARE" "$V"
if [ -f "$V/reputation/probes/hard-job.md" ]; then
  ok "probe record written on a capable-fail"
  [ "$(plan_field "$V/reputation/probes/hard-job.md" capable_succeeded)" = 0 ] \
    && ok "probe record capable_succeeded=0" || bad "capable_succeeded not 0"
else
  bad "no probe record written (log tail: $(tail -5 "$TR/probe.log" | tr '\n' '|'))"
fi
[ ! -f "$V/reputation/events/hard-job.hermit-demerit.md" ] \
  && ok "NO demerit event on a capable-fail (no unfair blame)" || bad "demerit written despite capable-fail"
rm -rf "$TR"

# ============================================================================
hr; echo "DEDUP — a second probe of the same base is a no-op"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/hcp-dedup.XXXXXX")"
BARE="$(seed_board "$TR")"; GR="$TR/gr"; seed_garden_root "$GR"
FC="$TR/fake-claude.sh"; make_fake_claude "$FC"
JF="$TR/job.md"; printf -- '---\nrole: builder\ntarget: main2\n---\n# dd\n\nwork\n' > "$JF"
FAKE_MARKER=1 run_probe "$BARE" "$GR" "$FC" "$JF" dd-job > "$TR/p1.log" 2>&1 || true
V1="$TR/v1"; verify_clone "$BARE" "$V1"
n1="$(git -C "$V1" rev-list --count HEAD)"
FAKE_MARKER=1 run_probe "$BARE" "$GR" "$FC" "$JF" dd-job > "$TR/p2.log" 2>&1 || true
V2="$TR/v2"; verify_clone "$BARE" "$V2"
n2="$(git -C "$V2" rev-list --count HEAD)"
[ "$n1" = "$n2" ] && ok "second probe pushed no new commit (dedup; $n1==$n2)" || bad "second probe advanced the board ($n1 -> $n2)"
c="$(ls "$V2"/reputation/events/dd-job.hermit-demerit.md 2>/dev/null | wc -l | tr -d ' ')"
[ "$c" = 1 ] && ok "exactly one demerit event after two probes" || bad "demerit count $c after dedup"
rm -rf "$TR"

# ============================================================================
hr; echo "GUARDS — non-hermit worker and GARDEN_HERMIT_PROBE=0 both skip"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/hcp-guard.XXXXXX")"
BARE="$(seed_board "$TR")"; GR="$TR/gr"; seed_garden_root "$GR"
FC="$TR/fake-claude.sh"; make_fake_claude "$FC"
JF="$TR/job.md"; printf -- '---\nrole: builder\ntarget: main2\n---\n# g\n\nwork\n' > "$JF"
FAKE_MARKER=1 run_probe "$BARE" "$GR" "$FC" "$JF" g1-job GARDEN_WORKER_KIND=gardener > "$TR/g1.log" 2>&1 || true
FAKE_MARKER=1 run_probe "$BARE" "$GR" "$FC" "$JF" g2-job GARDEN_HERMIT_PROBE=0 > "$TR/g2.log" 2>&1 || true
V="$TR/v"; verify_clone "$BARE" "$V"
[ ! -f "$V/reputation/probes/g1-job.md" ] && ok "non-hermit worker skips the probe (no local arm to score)" || bad "non-hermit worker probed"
[ ! -f "$V/reputation/probes/g2-job.md" ] && ok "GARDEN_HERMIT_PROBE=0 skips the probe" || bad "disabled probe still ran"
rm -rf "$TR"

# ============================================================================
hr; echo "REDUCER — demerit folds into the local arm (attempts>=1, accepts=0)"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/hcp-reduce.XXXXXX")"
BARE="$(seed_board "$TR")"; GR="$TR/gr"; seed_garden_root "$GR"
FC="$TR/fake-claude.sh"; make_fake_claude "$FC"
JF="$TR/job.md"; printf -- '---\nrole: builder\ntarget: main2\n---\n# r\n\nwork\n' > "$JF"
FAKE_MARKER=1 run_probe "$BARE" "$GR" "$FC" "$JF" red-job > "$TR/probe.log" 2>&1 || true
# run the reducer over the board.
env -i PATH="$PATH" HOME="$HOME" \
  GARDEN=hp GARDEN_TEST=1 GARDEN_NO_MAINTAINER_ALERT=1 \
  GARDEN_ROOT="$GR" GARDEN_STATE="$GR/.garden-state" GARDEN_SCRATCH="$GR/scratch" \
  JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
  "$JOBS/reputation-reduce.sh" > "$TR/reduce.log" 2>&1 || true
V="$TR/v"; verify_clone "$BARE" "$V"
arm="$(find "$V/reputation/arms/hermit/local" -name '*.md' 2>/dev/null | head -1)"
if [ -n "$arm" ] && [ -f "$arm" ]; then
  ok "local (hermit) arm projection written ($(printf '%s' "$arm" | sed "s#$V/##"))"
  [ "$(plan_field "$arm" attempts)" -ge 1 ] 2>/dev/null && ok "arm attempts>=1 (demerit counted)" || bad "arm attempts ($(plan_field "$arm" attempts))"
  [ "$(plan_field "$arm" accepts)" = 0 ] && ok "arm accepts=0 (demerit is an un-accepted attempt)" || bad "arm accepts ($(plan_field "$arm" accepts))"
  rate="$(plan_field "$arm" acceptance_rate)"
  awk -v r="$rate" 'BEGIN{exit !(r+0==0)}' && ok "arm acceptance_rate=0 (routing signal: local unfit)" || bad "arm acceptance_rate ($rate)"
else
  bad "no local arm projection (reduce log: $(tail -5 "$TR/reduce.log" | tr '\n' '|'))"
fi
rm -rf "$TR"

# ============================================================================
hr
echo "hermit-capability-probe: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
