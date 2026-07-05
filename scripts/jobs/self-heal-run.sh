#!/bin/bash
# self-heal-run.sh — the reusable self-healing wrapper for garden services.
#
# Usage:
#   self-heal-run.sh <context> [options] -- <command> [args...]
#
#   <context>   a short, stable slug naming WHAT is being healed (the service
#               identity), e.g. "garden-bulletin", "garden-foreman". It keys the
#               throttle state and the responder's task-specific role, so keep it
#               stable across restarts of the same service.
#   options (before the `--`):
#     --work-id <id>   an optional work item (PR id, %i instance, lane) folded
#                      into the capture brief and the escalation. Default: none.
#     --role <path>    role brief the responder wears. Default: the mentor role.
#     --expect <code>  an additional exit code to treat as a CLEAN exit (besides
#                      0 and the shutdown signals). Repeatable.
#
# What it does (the three parts of skills/self-healing-wrapper/SKILL.md):
#   1. Runs <command>, teeing its combined stdout+stderr to journald AND a
#      bounded capture file. Forwards SIGTERM/SIGINT to the child so a systemd
#      stop is a CLEAN shutdown, never a diagnosed "failure".
#   2. On an UNEXPECTED non-zero exit, hashes the capture tail into the git
#      content store (capture_blob) and hands ONLY the blob SHA — never the
#      inline log — to a task-specific `claude -p` debugging responder, which
#      diagnoses and posts a fix job or an inbox report.
#   3. Preserves the wrapped command's exit code so systemd's own Restart= /
#      OnFailure= / journal / central-mentor layers still see the failure. The
#      wrapper DIAGNOSES; systemd RESTARTS.
#
# Hard throttle (the token-burn / crash-loop guard): a service that crash-loops
# every few seconds must NOT spawn a `claude -p` every few seconds. The responder
# is rate-limited per (context, exit-code) signature — at most once per
# SELF_HEAL_THROTTLE_SECS (default 30m) and at most SELF_HEAL_DAILY_CAP (default
# 12) per UTC day. Throttle state lives OUTSIDE the unit, under
# $GARDEN_STATE/self-heal/, so it survives a restart and a stop.
#
# Best-effort everywhere: no branch of the self-heal path may crash the wrapper
# (and thus the wrapped service). Every escalation step OR-guards to a no-op.
#
# Exception (skills/self-healing-wrapper § When to use): a pure git/CAS primitive
# whose only failure mode is contention wants retry, not a responder — do NOT
# wrap it (or wrap with SELF_HEAL_CAPTURE_ONLY=1 for capture without a responder).

set -uo pipefail   # deliberately NOT -e: we must observe the child's rc, not die on it
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="self-heal"

# --- tunables (all overridable) ---------------------------------------------
: "${SELF_HEAL_THROTTLE_SECS:=1800}"   # min seconds between responders per signature
: "${SELF_HEAL_DAILY_CAP:=12}"         # max responders per signature per UTC day
: "${SELF_HEAL_CAPTURE_BYTES:=262144}" # tail bytes of the run hashed on failure
: "${SELF_HEAL_RESPONDER_TIMEOUT:=300}" # hard cap on the responder (a hung claude never wedges restart)
: "${SELF_HEAL_RESTART_BACKOFF:=0}"    # optional sleep before returning rc (systemd RestartSec usually suffices)
: "${SELF_HEAL_CAPTURE_ONLY:=0}"       # 1 → capture+escalate-by-inbox only, never invoke a responder
: "${SELF_HEAL_CLONE:=$GARDEN_STATE/self-heal/journal}"  # the local clone the blob is hashed into
: "${SELF_HEAL_HANDLER:=$HERE/handlers/self-heal-claude.sh}"
: "${SELF_HEAL_THROTTLE_DIR:=$GARDEN_STATE/self-heal/throttle}"

# --- argument parsing -------------------------------------------------------
context="${1:-}"
[ -n "$context" ] || { echo "usage: self-heal-run.sh <context> [--work-id ID] [--role PATH] [--expect CODE] -- <command...>" >&2; exit 64; }
case "$context" in --*) echo "self-heal-run.sh: first argument must be the <context> slug, not an option" >&2; exit 64;; esac
shift

work_id=""
role_brief="$GARDEN_ROOT/roles/mentor/AGENT.md"
declare -a expected_codes=()
while [ $# -gt 0 ]; do
  case "$1" in
    --work-id) work_id="${2:-}"; shift 2;;
    --role)    role_brief="${2:-}"; shift 2;;
    --expect)  expected_codes+=("${2:-}"); shift 2;;
    --)        shift; break;;
    *) echo "self-heal-run.sh: unknown option '$1' (did you forget the '--' before the command?)" >&2; exit 64;;
  esac
done
[ $# -gt 0 ] || { echo "self-heal-run.sh: no command after '--'" >&2; exit 64; }

# Sanitize the context for use in filesystem keys (the human slug is preserved
# for prompts; the sanitized form keys throttle markers).
ctx_key="$(printf '%s' "$context" | tr -c 'A-Za-z0-9._-' '_')"

# --- run the wrapped command, capturing a bounded tail ----------------------
capture="$(mktemp "${TMPDIR:-/tmp}/self-heal-${ctx_key}.XXXXXX")"
got_signal=0
cleanup() { rm -f "$capture" 2>/dev/null || true; }
trap cleanup EXIT

# Run as a child so we can forward a stop signal (clean shutdown, not a failure).
# Combined stdout+stderr is tee'd to journald (our stdout) AND the capture file
# via process substitution, so tee is a separate process and a broken capture
# pipe can never SIGPIPE-kill the child.
"$@" > >(tee -a "$capture") 2>&1 &
child=$!
forward() { got_signal=1; kill -TERM "$child" 2>/dev/null || true; }
trap forward TERM INT
wait "$child"; rc=$?
trap - TERM INT
# Let the tee drain the last lines into the capture before we read it.
wait 2>/dev/null || true

# --- decide: clean exit vs. a failure worth diagnosing ----------------------
# GARDEN_OFFLINE_RC (75=EX_TEMPFAIL): sync_clone exits this code when it
# classified the tick as a transient connectivity/DNS outage. A network blip is
# NOT a unit failure — normalize it to a CLEAN exit 0 so systemd records success
# (no fleet-wide `Failed with result 'exit-code'` noise) and no responder spends
# on a self-resolving outage. Checked first, ahead of the generic clean-exit
# handling, because we deliberately rewrite the code to 0 rather than preserve it.
if [ "$rc" -eq "${GARDEN_OFFLINE_RC:-75}" ]; then
  log "transient connectivity outage; skipping responder"
  exit 0
fi

is_expected=0
clean_shutdown=0
[ "$rc" -eq 0 ] && is_expected=1
[ "$got_signal" -eq 1 ] && { is_expected=1; clean_shutdown=1; }  # systemd stop → clean
# 143=SIGTERM,130=SIGINT: a signalled shutdown is clean even without the flag.
case "$rc" in 143|130) is_expected=1; clean_shutdown=1;; esac
for code in "${expected_codes[@]:-}"; do [ -n "$code" ] && [ "$rc" = "$code" ] && is_expected=1; done

if [ "$is_expected" -eq 1 ]; then
  # Silent on the happy path: add zero context to the supervisor.
  # A signalled shutdown (a systemd stop/restart) is a CLEAN exit, so return 0
  # rather than the signal code: a literal `exit 143` makes systemd record
  # "Main process exited, code=exited, status=143" → "Failed with result
  # 'exit-code'" on EVERY stop/restart of a continuous unit, flapping it to a
  # false Failed state. A genuine non-signal --expect code still passes through
  # unchanged so its caller can distinguish it; real failures keep rc below.
  [ "$clean_shutdown" -eq 1 ] && exit 0
  exit "$rc"
fi

# Belt-and-suspenders: a path that hits a connectivity outage WITHOUT returning
# GARDEN_OFFLINE_RC (e.g. a raw `ssh … git fetch` outside journal_fetch, which
# exits 128) would otherwise be diagnosed as a real failure. Grep the FAILURE
# VICINITY — the last few lines, where a terminal connectivity diagnostic
# actually lands — for the connectivity signatures and short-circuit to a clean
# exit, so a DNS/GitHub blip never marks the unit failed or burns a responder.
# The window is LINES, not the whole 256KB capture tail: the signature set
# includes broad tokens (bare SSL/TLS, `HTTP 5[0-9][0-9]`, `RPC failed`), and a
# long transcript that merely QUOTED one — a retried-past gh blip logged
# minutes earlier, a job spec discussing networking — would otherwise convert a
# genuine rc!=0 crash into a silent exit 0: no responder, no capture, a unit
# that "succeeds" while crash-looping. The signature set is the canonical
# GARDEN_OFFLINE_SIGNATURES from common.sh, shared with
# _fetch_stderr_is_offline so the two lists can never drift.
: "${SELF_HEAL_OFFLINE_GREP_LINES:=25}"
if tail -n "$SELF_HEAL_OFFLINE_GREP_LINES" "$capture" 2>/dev/null \
     | grep -qiE "$GARDEN_OFFLINE_SIGNATURES"; then
  log "transient connectivity outage; skipping responder"
  exit 0
fi

log "wrapped '$context' exited rc=$rc; capturing + (maybe) diagnosing"

# --- Part 1: capture the failure into the git content store -----------------
# Hash only the bounded tail so a long-lived service's capture can never bloat
# the prompt or the object DB.
tailcap="$(mktemp "${TMPDIR:-/tmp}/self-heal-tail.XXXXXX")"
tail -c "$SELF_HEAL_CAPTURE_BYTES" "$capture" > "$tailcap" 2>/dev/null || cp "$capture" "$tailcap" 2>/dev/null || true

sha=""
if [ -s "$tailcap" ]; then
  # ensure_clone/capture_blob are best-effort; a self-heal that cannot capture
  # must still return the child's rc, never crash the service.
  if ensure_clone "$SELF_HEAL_CLONE" 2>/dev/null; then
    sha="$(capture_blob "$tailcap" "$SELF_HEAL_CLONE" 2>/dev/null || true)"
  fi
fi
rm -f "$tailcap" 2>/dev/null || true

if [ -z "$sha" ]; then
  log "capture failed (no journal clone or empty output); returning rc=$rc without a responder"
  [ "$SELF_HEAL_RESTART_BACKOFF" -gt 0 ] 2>/dev/null && sleep "$SELF_HEAL_RESTART_BACKOFF"
  exit "$rc"
fi

# --- the hard throttle (per context+rc signature) ---------------------------
# Returns 0 (throttled → skip) or 1 (allowed → record + proceed). Never fails.
throttle_allows() {
  local sig="${ctx_key}:rc${rc}"
  local dir="$SELF_HEAL_THROTTLE_DIR" now today last cnt cnt_day
  now="$(date -u +%s 2>/dev/null || echo 0)"
  today="$(date -u +%Y%m%d 2>/dev/null || echo 0)"
  mkdir -p "$dir" 2>/dev/null || { return 0; }   # cannot record → fail safe: throttle
  local last_f="$dir/${sig}.last" day_f="$dir/${sig}.day" cnt_f="$dir/${sig}.count"
  # Window: at most once per SELF_HEAL_THROTTLE_SECS.
  if [ -f "$last_f" ]; then
    last="$(cat "$last_f" 2>/dev/null || echo 0)"
    [ "$(( now - last ))" -lt "$SELF_HEAL_THROTTLE_SECS" ] && return 0
  fi
  # Daily cap: reset the counter when the UTC day rolls.
  cnt_day="$(cat "$day_f" 2>/dev/null || echo '')"
  cnt="$(cat "$cnt_f" 2>/dev/null || echo 0)"
  [[ "$cnt" =~ ^[0-9]+$ ]] || cnt=0
  if [ "$cnt_day" != "$today" ]; then cnt=0; fi
  [ "$cnt" -ge "$SELF_HEAL_DAILY_CAP" ] && return 0
  # Allowed: record the new window + bump the day counter.
  printf '%s\n' "$now"   > "$last_f" 2>/dev/null || true
  printf '%s\n' "$today" > "$day_f"  2>/dev/null || true
  printf '%s\n' "$(( cnt + 1 ))" > "$cnt_f" 2>/dev/null || true
  return 1
}

if [ "$SELF_HEAL_CAPTURE_ONLY" = 1 ]; then
  log "capture-only mode: blob $sha captured for '$context' (no responder); returning rc=$rc"
  [ "$SELF_HEAL_RESTART_BACKOFF" -gt 0 ] 2>/dev/null && sleep "$SELF_HEAL_RESTART_BACKOFF"
  exit "$rc"
fi

if throttle_allows; then
  log "responder throttled for '$context' (rc=$rc, sig captured as $sha); returning rc=$rc"
  [ "$SELF_HEAL_RESTART_BACKOFF" -gt 0 ] 2>/dev/null && sleep "$SELF_HEAL_RESTART_BACKOFF"
  exit "$rc"
fi

# --- Parts 2 & 3: hand the SHA to the responder; it diagnoses + escalates ----
# Synchronous but hard-bounded by timeout: systemd may KILL the cgroup (and any
# backgrounded child) the instant the wrapper returns, so we cannot background
# the responder the way the now-removed long-lived driver loop did. Best-effort: a failed,
# missing, or hung responder never blocks the restart and never crashes us.
log "diagnosing '$context' failure via responder (blob $sha, role $(basename "$role_brief"))"
if command -v timeout >/dev/null 2>&1; then
  timeout "$SELF_HEAL_RESPONDER_TIMEOUT" \
    "$SELF_HEAL_HANDLER" "$sha" "$SELF_HEAL_CLONE" "$context" "$rc" "$work_id" "$role_brief" \
    >/dev/null 2>&1 || log "responder for '$context' failed or timed out (best-effort; ignored)"
else
  "$SELF_HEAL_HANDLER" "$sha" "$SELF_HEAL_CLONE" "$context" "$rc" "$work_id" "$role_brief" \
    >/dev/null 2>&1 || log "responder for '$context' failed (best-effort; ignored)"
fi

[ "$SELF_HEAL_RESTART_BACKOFF" -gt 0 ] 2>/dev/null && sleep "$SELF_HEAL_RESTART_BACKOFF"
exit "$rc"
