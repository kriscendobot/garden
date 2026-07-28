#!/bin/bash
# quota-panel-test.sh — regression guard for the deterministic per-provider spend
# & quota panel (scripts/jobs/quota-panel.sh, rendered on the bulletin).
#
# THE BEHAVIOR: render_quota_panel emits a Markdown table with a row per provider
# (Claude, Codex), each showing token spend, dollar spend, and % of quota, from:
#   - Claude tokens  : meter_window_total over ~/.claude session logs (usage-meter).
#   - Claude dollars : those same per-model, per-class tokens × the rate card.
#   - Codex tokens   : billable last_token_usage over ~/.codex rollout logs.
#   - Codex quota %  : codex's OWN rate_limits.primary.used_percent (plan-metered).
# It is fully deterministic (NO claude/codex binary) and fail-open (a missing
# source renders "unavailable"/"n/a"/"no quota set", never a crash or a fake $).
#
# SUBTEST 1 — Claude row: known fixture turns price to an exact dollar figure and
#             token total; the quota % uses the meter status word.
# SUBTEST 2 — Codex row: billable tokens sum per-turn deltas in-window; the panel
#             surfaces codex's self-reported used_percent and the plan basis; the
#             ChatGPT-plan default renders NO per-token dollar figure.
# SUBTEST 3 — fail-open: absent log dirs and no quotas render the honest
#             placeholders and exit 0 (never a crash).
# SUBTEST 4 — window scoping: a turn stamped before the cutoff is excluded.
#
# Usage: quota-panel-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# Results are recorded to a file, not shell vars, because each subtest runs in a
# ( … ) subshell for env isolation (each sources the helpers under a different
# fixture env) and a var increment there would not survive to the parent — which
# would silently mask a failing assertion. RESULTS is set before the first
# subshell so every ok/bad appends to the same file.
RESULTS="$(mktemp)"
ok()  { echo "  PASS: $*"; echo PASS >> "$RESULTS"; }
bad() { echo "  FAIL: $*"; echo FAIL >> "$RESULTS"; }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job cannot
# splice its own GARDEN_* state (or a real ~/.claude quota) underneath the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

command -v jq >/dev/null 2>&1 || { echo "SKIP: jq absent (quota-panel needs jq to parse logs)"; exit 0; }

TR="$(mktemp -d)"; trap 'rm -rf "$TR" "$RESULTS"' EXIT

# Freeze the clock so window math is deterministic. Anchor to the REAL current
# epoch: usage-meter's find prunes candidate logs by mtime (-newermt @cutoff), and
# the fixtures are touched at the real now, so a fixed future NOW would place the
# whole window ahead of the files' mtime and exclude everything. Anchoring NOW to
# real time keeps cutoff in the past while the in-log timestamps below decide
# window membership deterministically.
NOW="$(date +%s)"
WIN=604800                       # 7 days
CUTOFF=$(( NOW - WIN ))
IN_TS="$(date -u -d "@$(( NOW - 3600 ))"   +%FT%TZ)"   # 1h ago  -> in window
OLD_TS="$(date -u -d "@$(( NOW - 700000 ))" +%FT%TZ)"  # ~8d ago -> out of window

# --- Claude fixture: two turns, one in-window, one out ------------------------
# In-window opus turn: 1,000,000 input + 1,000,000 output, no cache.
#   billable tokens = in + out + cache_creation = 2,000,000
#   dollars = (1e6 * $5/MTok input) + (1e6 * $25/MTok output) = $30.00
CLAUDE_DIR="$TR/claude/projects/p"
mkdir -p "$CLAUDE_DIR"
{
  printf '{"type":"assistant","timestamp":"%s","message":{"id":"m1","model":"claude-opus-4-8","usage":{"input_tokens":1000000,"output_tokens":1000000,"cache_creation_input_tokens":0,"cache_read_input_tokens":0}}}\n' "$IN_TS"
  # out-of-window turn: must NOT be counted
  printf '{"type":"assistant","timestamp":"%s","message":{"id":"m2","model":"claude-opus-4-8","usage":{"input_tokens":9000000,"output_tokens":9000000,"cache_creation_input_tokens":0,"cache_read_input_tokens":0}}}\n' "$OLD_TS"
} > "$CLAUDE_DIR/session.jsonl"
touch "$CLAUDE_DIR/session.jsonl"   # mtime = now, so find -newermt keeps it

# --- Codex fixture: two in-window token_count turns + one old --------------
# per-turn last_token_usage: input 100000, cached 40000, output 10000
#   billable/turn = (100000 - 40000) + 10000 = 70000 ; two in-window => 140000
# latest rate_limits.primary.used_percent = 25.0, plan_type "free"
CODEX_DIR="$TR/codex/sessions/2026/07/13"
mkdir -p "$CODEX_DIR"
codex_turn() { # <ts> <used_percent>
  printf '{"type":"event_msg","timestamp":"%s","payload":{"type":"token_count","info":{"last_token_usage":{"input_tokens":100000,"cached_input_tokens":40000,"output_tokens":10000,"reasoning_output_tokens":100,"total_tokens":110000}},"rate_limits":{"primary":{"used_percent":%s,"window_minutes":43200,"resets_at":1786575997},"plan_type":"free"}}}\n' "$1" "$2"
}
{
  codex_turn "$IN_TS" 20.0
  codex_turn "$(date -u -d "@$(( NOW - 60 ))" +%FT%TZ)" 25.0   # freshest reading
  codex_turn "$OLD_TS" 99.0                                    # out of window (tokens dropped)
} > "$CODEX_DIR/rollout.jsonl"
touch "$CODEX_DIR/rollout.jsonl"

# Source under the fixture environment.
setup_env() {
  export GARDEN_USAGE_NOW="$NOW"
  export GARDEN_TOKEN_WINDOW_SECS="$WIN"
  export GARDEN_QUOTA_PANEL_WINDOW_SECS="$WIN"
  export GARDEN_CCUSAGE_LOGDIR="$TR/claude/projects"
  export GARDEN_CODEX_LOGDIR="$TR/codex/sessions"
  export GARDEN_STATE="$TR/state"; mkdir -p "$GARDEN_STATE"
  # shellcheck disable=SC1090
  source "$JOBS/usage-meter.sh"
  # shellcheck disable=SC1090
  source "$JOBS/quota-panel.sh"
}

hr; echo "SUBTEST 1: Claude row (tokens, dollars, quota %)"
( setup_env
  export GARDEN_TOKEN_WEEKLY_QUOTA=4000000    # billable 2M => 50%
  out="$(render_quota_panel)"
  echo "$out" | sed 's/^/    | /'
  ct="$(meter_window_total)"
  [ "$ct" = "2000000" ] && ok "Claude billable tokens = 2,000,000 (in-window only)" || bad "Claude tokens: got '$ct'"
  echo "$out" | grep -qE '\| Claude \| 2\.0M \| \$30\.00 _\(notional, rate-card\)_ \| 50% of 4\.0M' \
    && ok "Claude row: 2.0M tokens, \$30.00 rate-card dollars, 50% of quota" \
    || bad "Claude row not as expected"
) || true

hr; echo "SUBTEST 2: Codex row (billable, self-reported %, plan basis)"
( setup_env
  out="$(render_quota_panel)"
  echo "$out" | grep -qE '\| Codex \| 140\.0k _\(\+80\.0k cached\)_ \|' \
    && ok "Codex billable = 140.0k (two in-window turns), cached surfaced" \
    || bad "Codex token cell not as expected"
  echo "$out" | grep -qE '\| Codex \|.*n/a _\(ChatGPT free plan' \
    && ok "Codex dollars honestly 'n/a', naming the codex-reported plan (no fake \$)" \
    || bad "Codex dollar basis not labeled"
  echo "$out" | grep -qE '25% _\(plan; codex-reported\)_' \
    && ok "Codex quota % = codex's own freshest reported used_percent (25%)" \
    || bad "Codex used_percent not surfaced from the freshest reading"
) || true

hr; echo "SUBTEST 3: fail-open (no logs, no quotas)"
( setup_env
  export GARDEN_CCUSAGE_LOGDIR="$TR/nonexistent-claude"
  export GARDEN_CODEX_LOGDIR="$TR/nonexistent-codex"
  export GARDEN_TOKEN_WEEKLY_QUOTA=0
  export GARDEN_CODEX_WEEKLY_QUOTA=0
  if out="$(render_quota_panel)"; then
    ok "render_quota_panel exits 0 with sources absent (fail-open)"
  else
    bad "render_quota_panel crashed with sources absent"
  fi
  echo "$out" | grep -qE '\| Claude \|.*\| no quota set \|' \
    && ok "Claude quota shows 'no quota set' when unconfigured" \
    || bad "Claude quota placeholder missing"
  echo "$out" | grep -qE '\| Codex \| unavailable \|' \
    && ok "Codex token cell shows 'unavailable' when logs absent" \
    || bad "Codex unavailable placeholder missing"
) || true

hr; echo "SUBTEST 4: window scoping (old turn excluded)"
( setup_env
  # meter_window_total already asserted 2M (subtest 1) = the in-window turn only;
  # re-assert the codex old turn (used_percent 99, tokens) is NOT summed.
  x="$(_qp_codex_scan "$GARDEN_CODEX_LOGDIR" "$CUTOFF")"
  bill="$(echo "$x" | awk '{print $1}')"
  [ "$bill" = "140000" ] && ok "Codex old (out-of-window) turn excluded from token sum" \
    || bad "Codex window scoping wrong: billable='$bill'"
) || true

hr
PASS="$(grep -c '^PASS' "$RESULTS" 2>/dev/null || true)"
FAIL="$(grep -c '^FAIL' "$RESULTS" 2>/dev/null || true)"
echo "quota-panel-test: PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && [ "$PASS" -gt 0 ]
