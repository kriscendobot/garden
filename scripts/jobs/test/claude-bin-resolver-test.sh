#!/bin/bash
# claude-bin-resolver-test.sh — regression guard for the agent-CLI resolver and
# the ENVIRONMENTAL failure classification (common.sh § agent-CLI resolution).
#
# Regression (the ps23 outage): every claude-driving handler opened with a bare
# `command -v claude >/dev/null || die` — a SINGLE probe of the INHERITED PATH,
# with zero tolerance, whose failure exited rc=1 and read to gardener.sh as a
# DETERMINISTIC defect in whatever job happened to be claimed at that instant.
# Two things were wrong with it:
#   * the PATH is not declared — `systemd --user` carries none, so a worker sees
#     whatever the user manager inherited at login, and an install outside that
#     accident (/usr/local/bin under a bare unit PATH, ~/.local/bin, the native
#     installer's ~/.claude/local) was invisible; and
#   * an in-place `npm install -g @anthropic-ai/claude-code` UNLINKS the global
#     bin for a window of seconds, so a single probe landing in that window is not
#     evidence of a missing install.
#
# SUBTESTS 1–3 drive the pure resolver helpers directly (mirroring the pure-helper
# coverage in empty-output-classifier-test.sh); SUBTEST 4 proves the caller idiom
# `cli="$(claude_bin)" || die_environmental …` actually EXITS the handler (the
# `exit`-inside-a-command-substitution pitfall) with the environmental rc; and
# SUBTEST 5 is an integration test: the REAL gardener.sh against a throwaway board
# with a handler that exits the environmental rc WITH non-empty output, asserting
# the job is left for the reaper rather than escalated as its own defect.
#
# Usage: claude-bin-resolver-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_*/SELF_HEAL_* state — clone, remote,
# offline rc, and any GARDEN_CLAUDE_BIN override — underneath the fixture; see
# run-test.sh § hermetic baseline).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

# shellcheck source=../common.sh
source "$JOBS/common.sh"   # sourced BEFORE the exec-base probe: it defines the
                           # GARDEN_SCRATCH fallback the probe needs after the scrub

# The stubs below are probed with `[ -x ]`, which honors a mount's noexec flag —
# and the sandbox mounts /tmp noexec, so a fixture there would read as "present but
# not runnable" and silently invert every assertion. Probe for an exec-allowed base
# exactly as gardener-worktree-test.sh does. Never $HOME: it is the garden repo root.
pick_exec_base() {
  local c probe rc
  for c in "${TMPDIR:-}" /tmp "${GARDEN_SCRATCH:-}" "${GARDEN_ROOT:+$GARDEN_ROOT/scratch}"; do
    [ -n "$c" ] || continue
    mkdir -p "$c" 2>/dev/null || true      # GARDEN_SCRATCH may not exist yet (gitignored)
    [ -d "$c" ] && [ -w "$c" ] || continue
    probe="$(mktemp -d "$c/cbr-probe.XXXXXX" 2>/dev/null)" || continue
    printf '#!/bin/sh\nexit 7\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null
    "$probe/x" >/dev/null 2>&1; rc=$?
    rm -rf "$probe"
    [ "$rc" -eq 7 ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}
EXEC_BASE="$(pick_exec_base)" || { echo "  SKIP: no exec-allowed temp base (needed for the -x probes)"; exit 0; }
TR="$(mktemp -d "$EXEC_BASE/garden-claudebin.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
REAL_PATH="$PATH"          # kept for the subtests that need real external tools

# SUBTEST 1 resolves a FICTITIOUS agent name. The candidate list includes absolute
# system locations (/usr/local/bin, /usr/bin) where a REAL claude is installed on
# any fleet host, so probing `claude` there would resolve the real binary and make
# every ordering assertion vacuous. A name nothing installs isolates the ordering;
# the candidate list itself is asserted for `claude` separately below.
AGENT=gtestcli

# A directory holding an executable stub named $2, printing $3 when run.
make_bin() {  # make_bin <dir> <name> <marker>
  mkdir -p "$1"
  printf '#!/bin/bash\nprintf %%s\\\\n "%s"\n' "$3" > "$1/$2"
  chmod +x "$1/$2"
}

# ============================================================================
hr; echo "SUBTEST 1 — resolution order: override, then PATH, then known locations"; hr

make_bin "$TR/onpath" "$AGENT" "on-path"
make_bin "$TR/home/.local/bin" "$AGENT" "home-local-bin"
make_bin "$TR/override" "$AGENT" "explicit-override"

# (a) PATH wins over the candidate list: a stub on PATH (a test fake, or an
# operator's deliberate install) must never be shadowed by a known location.
got="$(PATH="$TR/onpath:$REAL_PATH" HOME="$TR/home" agent_bin_probe "$AGENT" || true)"
if [ "$got" = "$TR/onpath/$AGENT" ]; then
  ok "PATH is probed FIRST (resolved $got)"
else
  bad "PATH not probed first: resolved '$got', expected $TR/onpath/$AGENT"
fi

# (b) PATH MISSES → the known install locations are probed. This is the half of
# the outage a bare `command -v` could never fix.
got="$(PATH="$TR/empty" HOME="$TR/home" agent_bin_probe "$AGENT" || true)"
if [ "$got" = "$TR/home/.local/bin/$AGENT" ]; then
  ok "PATH miss falls back to a known install location (resolved $got)"
else
  bad "PATH miss did not resolve ~/.local/bin: resolved '$got'"
fi

# (c) nothing anywhere → a clean rc=1, no output.
if got="$(PATH="$TR/empty" HOME="$TR/nohome" agent_bin_probe "$AGENT")"; then
  bad "probe SUCCEEDED with nothing installed anywhere (resolved '$got')"
else
  ok "probe returns non-zero when the CLI is genuinely absent"
fi

# (d) an explicit override beats both.
got="$(PATH="$TR/onpath:$REAL_PATH" HOME="$TR/home" \
       GARDEN_GTESTCLI_BIN="$TR/override/$AGENT" agent_bin_probe "$AGENT" || true)"
if [ "$got" = "$TR/override/$AGENT" ]; then
  ok "an explicit GARDEN_<NAME>_BIN override is authoritative (resolved $got)"
else
  bad "override ignored: resolved '$got', expected $TR/override/$AGENT"
fi

# (e) an UNRUNNABLE override FAILS CLOSED: never silently resolve some other
# binary than the one the operator pinned.
if got="$(PATH="$TR/onpath:$REAL_PATH" HOME="$TR/home" \
          GARDEN_GTESTCLI_BIN="$TR/nowhere/$AGENT" agent_bin_probe "$AGENT" 2>/dev/null)"; then
  bad "an unrunnable override fell through to '$got' instead of failing closed"
else
  ok "an unrunnable override fails closed (no silent fallback to another binary)"
fi

# (f) the resolver must work with NO external commands available at all — a
# thoroughly broken PATH is exactly when it is needed (no `tr`, no `sleep`).
got="$(PATH="" HOME="$TR/home" agent_bin_probe "$AGENT" || true)"
if [ "$got" = "$TR/home/.local/bin/$AGENT" ]; then
  ok "resolves with an EMPTY PATH (no external command required)"
else
  bad "empty-PATH resolution failed: resolved '$got'"
fi

# (g) the candidate list for the REAL agent names the documented locations, in
# the documented order — the image's npm -g prefix first.
cands="$(agent_bin_candidates claude)"
for want in /usr/local/bin/claude "$HOME/.local/bin/claude" "$HOME/.claude/local/claude"; do
  if printf '%s\n' "$cands" | grep -qxF "$want"; then
    ok "candidate list includes $want"
  else
    bad "candidate list is missing $want"
  fi
done
if [ "$(printf '%s\n' "$cands" | head -n 1)" = /usr/local/bin/claude ]; then
  ok "the image's npm -g prefix (/usr/local/bin) is the FIRST candidate"
else
  bad "first candidate is '$(printf '%s\n' "$cands" | head -n 1)', expected /usr/local/bin/claude"
fi

# ============================================================================
hr; echo "SUBTEST 2 — a MOMENTARY absence is retried, not fatal"; hr

# The npm-relink window, made deterministic: a probe stub that fails twice and
# then succeeds. agent_bin runs each probe in a command substitution (a subshell),
# so the attempt counter lives in a file rather than a variable.
counter="$TR/probes"; printf '0\n' > "$counter"
agent_bin_probe() {   # deliberate override of the real probe, for this subtest
  local n; n="$(cat "$counter")"; n=$((n + 1)); printf '%s\n' "$n" > "$counter"
  [ "$n" -ge 3 ] || return 1
  printf '/opt/relinked/claude\n'
}

got="$(agent_bin claude 5 0 2>/dev/null || true)"
if [ "$got" = "/opt/relinked/claude" ]; then
  ok "resolved after a momentary absence (the npm -g relink window)"
else
  bad "momentary absence not retried: resolved '$got'"
fi
if [ "$(cat "$counter")" = 3 ]; then
  ok "took exactly 3 probes (retry is real, not a lucky first hit)"
else
  bad "probe count was $(cat "$counter"), expected 3"
fi

# A GENUINE absence still fails — bounded, not forever.
printf '0\n' > "$counter"
agent_bin_probe() { local n; n="$(cat "$counter")"; printf '%s\n' "$((n + 1))" > "$counter"; return 1; }
if agent_bin claude 4 0 >/dev/null 2>&1; then
  bad "agent_bin SUCCEEDED though every probe failed"
else
  ok "agent_bin returns non-zero after exhausting its bounded attempts"
fi
if [ "$(cat "$counter")" = 4 ]; then
  ok "retry is BOUNDED at the requested attempts (4), not unbounded"
else
  bad "probe count was $(cat "$counter"), expected exactly 4"
fi

unset -f agent_bin_probe
# shellcheck source=../common.sh
source "$JOBS/common.sh"          # restore the real probe for the later subtests

# ============================================================================
hr; echo "SUBTEST 3 — is_environmental_rc classifies the environmental exit"; hr

assert_env() {    # assert_env <rc> <why>
  if is_environmental_rc "$1"; then ok "rc=$1 → environmental/transient ($2)"
  else bad "rc=$1 NOT classified environmental; expected transient ($2)"; fi
}
assert_notenv() { # assert_notenv <rc> <why>
  if is_environmental_rc "$1"; then bad "rc=$1 classified environmental ($2)"
  else ok "rc=$1 → not environmental ($2)"; fi
}
assert_env 75 "GARDEN_ENV_RC / GARDEN_OFFLINE_RC — EX_TEMPFAIL"
assert_notenv 1   "a bare failure is a real defect"
assert_notenv 2   "a usage error is a real defect"
assert_notenv 127 "missing external tool — the jq-outage signature, escalates now"
assert_notenv 143 "SIGTERM is a signal-kill (is_external_kill_rc's job, not this one)"
assert_notenv 124 "wall-clock timeout (is_handler_timeout_rc's job)"

# ============================================================================
hr; echo "SUBTEST 4 — the caller idiom EXITS the handler with the environmental rc"; hr

# `cli="$(claude_bin)" || die_environmental …` is subtle: die_environmental must
# run in the PARENT shell, or its `exit` would leave only the substitution's
# subshell and the handler would sail on to invoke an empty command. Drive the
# real idiom in a real script.
cat > "$TR/fixture.sh" <<FIXTURE
#!/bin/bash
set -euo pipefail
source "$JOBS/common.sh"
cli="\$(claude_bin 1 0)" || die_environmental "no claude anywhere; cannot run the fixture"
printf 'REACHED-THE-INVOCATION\n'
FIXTURE
chmod +x "$TR/fixture.sh"

# The fixture keeps a REAL PATH (common.sh needs git/date at source time) and is
# denied its CLI through the fail-closed override instead — the same resolution
# failure the outage produced, reached deterministically on a host that does have
# a real claude installed.
set +e
out="$(env GARDEN_CLAUDE_BIN="$TR/nowhere/claude" GARDEN_STATE="$TR/state" \
       GARDEN_NO_MAINTAINER_ALERT=1 \
       bash "$TR/fixture.sh" 2>"$TR/fixture.err")"
frc=$?
set -e

if [ "$frc" -eq "${GARDEN_ENV_RC:-75}" ]; then
  ok "the idiom exits GARDEN_ENV_RC ($frc), not a defect-shaped rc=1"
else
  bad "the idiom exited rc=$frc, expected ${GARDEN_ENV_RC:-75}; stderr: $(tail -2 "$TR/fixture.err")"
fi
if printf '%s' "$out" | grep -q 'REACHED-THE-INVOCATION'; then
  bad "execution continued past die_environmental (the subshell-exit pitfall)"
else
  ok "execution stopped at die_environmental (exit left the whole script)"
fi
if grep -q 'ENVIRONMENT:' "$TR/fixture.err"; then
  ok "the environmental cause is still written to the capture (diagnosable)"
else
  bad "no ENVIRONMENT diagnostic on stderr; the cause would be invisible"
fi

# ============================================================================
hr; echo "SUBTEST 5 — integration: rc=75 with NON-EMPTY capture → transient, no escalation"; hr

# The point of the whole change: an environmental failure must NOT be escalated as
# a defect in the job that happened to be claimed while the CLI was missing — even
# though die_environmental deliberately writes a diagnostic, so $capture is
# NON-EMPTY. Reuses the signal-kill stub, which takes its rc from the environment.
export PATH="$REAL_PATH"
BARE="$TR/journal.git"; BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '# envjob\n\ndo the work for envjob\n' > "jobs/todo/envjob.md" )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_TEST=1

env GARDEN="envhost" GARDEN_STATE="$TR/gstate" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_STUB_RC=75 \
    GARDEN_STUB_SENTINEL="$TR/sentinel" \
    GARDEN_JOB_HANDLER="$HERE/signal-kill-handler-stub.sh" \
    "$JOBS/gardener.sh" 1 > "$TR/gardener.log" 2>&1 || true

CLONE="$TR/gstate/gardeners/1/journal"

if [ -s "$TR/sentinel" ]; then
  ok "handler ran and flushed non-empty output before the environmental exit"
else
  bad "handler sentinel empty/absent; the non-empty-capture path may not have run"
fi

if grep -Eq "transient.*rc=75|rc=75.*transient" "$TR/gardener.log"; then
  ok "rc=75 with non-empty capture logged as a transient outage"
else
  bad "rc=75 with non-empty capture NOT logged transient; log: $(grep -i 'handler' "$TR/gardener.log" | tail -2)"
fi

if [ -e "$CLONE/inboxes/envhost/gardener.md" ]; then
  bad "gardener inbox escalation created — an environmental failure was blamed on the job"
else
  ok "no gardener inbox escalation (the claimed job was not blamed)"
fi

V="$TR/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V" 2>/dev/null
if [ -f "$V/jobs/doin/envjob.md" ] && [ ! -f "$V/jobs/tada/envjob.md" ]; then
  ok "job left in doin for the reaper's requeue, not completed to tada"
else
  bad "job not left in doin (doin=$([ -f "$V/jobs/doin/envjob.md" ] && echo y || echo n) tada=$([ -f "$V/jobs/tada/envjob.md" ] && echo y || echo n))"
fi

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
