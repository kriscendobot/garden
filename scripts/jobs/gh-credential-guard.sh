#!/bin/bash
# gh-credential-guard.sh — deterministic per-host gh-credential health guard. NO LLM.
#
# Usage: gh-credential-guard.sh
#   exit 0 always (a detector must never fail its caller's tick).
#
# THE GAP THIS CLOSES. The fleet's every git/API write goes through the gh identity
# wrapper (scripts/jobs/bin/gh), which resolves the bot's LIVE token per call with
# `gh auth token --user <bot>` and, when that resolution fails on a state-changing
# call, correctly FAILS CLOSED rather than acting as the global active account
# (designs/fleet-gh-identity.md). That fail-closed is the right safety, but it is
# purely REACTIVE: a host whose kriscendobot login has lapsed looks completely
# healthy until some gardener finally needs to PUSH — at which point the write dies,
# the job stalls, and the role has to notice and hand-report to the maintainer.
#
# That is exactly what happened on 2026-09-04: the `minion-town-clip-content-store-gc-build`
# job committed and pushed its branch on kriscendobot/minion.town, then `ensure-pr.sh`
# could not open the draft PR because "this host cannot resolve a valid kriscendobot
# gh token, and the unauthenticated REST limit is also exhausted" — on the LEADER
# host endolin-garden-ece02cb4. The condition sat silent until a write job tripped it.
#
# This guard turns that silent, reactive gap into a PROACTIVE, deduped escalation:
# once per scaler tick, host-level, on EVERY host (leader and follower alike, since
# the scaler runs everywhere), it checks that this host can resolve the bot's gh
# credential the SAME way the wrapper does, and — best-effort — that the resolved
# token still AUTHENTICATES. On a genuine gap it posts ONE loud kind:error
# maintainer-inbox report naming the exact remedy (`gh auth login` on this host),
# deduped by a $GARDEN_STATE marker so it fires on tick 1 and stays quiet until the
# credential is restored or the failure shape changes.
#
# TWO conditions, deliberately shaped to be FALSE-POSITIVE-FREE:
#
#   * MISSING (network-free, alarm immediately). `gh auth token --user <bot>`
#     returns empty / non-zero. This reads gh's OWN local store — no network, no
#     flake — and is the definitive "this host has no usable <bot> login" signal.
#     It is the precise condition the wrapper fails a write closed on, and the
#     precise first clause of the 2026-09-04 report.
#
#   * REVOKED (present-but-rejected, persistence-gated). The token resolves locally
#     but an authenticated probe (`gh api user`) comes back with an auth-failure
#     signature (HTTP 401 / Bad credentials). GitHub emits SPURIOUS 401s during
#     token rotation and under load (see GARDEN_TRANSIENT_GH_API_SIGNATURES, which
#     lists `HTTP 401|Bad credentials` as TRANSIENT), so a single 401 must NOT
#     alarm. The guard counts CONSECUTIVE suspect ticks in a $GARDEN_STATE counter
#     and only escalates once it crosses GARDEN_GH_CRED_REVOKED_THRESHOLD (default
#     3 ≈ 3 minutes of a persistently-rejected token). Any other probe failure
#     (network / offline / non-auth) is INCONCLUSIVE: it neither alarms nor
#     increments, so an offline host never spuriously reports a credential gap.
#
# On a HEALTHY tick (token resolves AND either authenticates or the probe is merely
# inconclusive-but-not-auth-failing) the marker and the suspect counter are cleared,
# so a future regression fires fresh on its first tick.
#
# Wired as a gardener-scaler.sh preflight beside identity-drift-guard.sh, whose
# report/dedup/test-containment machinery this mirrors exactly. See CLAUDE.md
# § Host environment (the gh wrapper) and § Job system, designs/fleet-gh-identity.md.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="gh-credential-guard"

# The bot login whose credential every fleet write depends on (common.sh default:
# kriscendobot). The guard checks THIS login, exactly as the wrapper resolves it.
: "${GARDEN_GH_IDENTITY:=${GARDEN_BOT_LOGIN:-kriscendobot}}"

# Consecutive suspect (present-but-401) ticks required before the REVOKED escalation
# fires. Absorbs GitHub's spurious rotation/load 401s; small so a genuinely revoked
# token still surfaces within a few minutes of scaler ticks.
: "${GARDEN_GH_CRED_REVOKED_THRESHOLD:=3}"

# Per-host, outside any reset-prone worktree — same home the identity-drift guard
# uses for its marker. One records the last-reported failure signature (dedup); the
# other counts consecutive present-but-rejected ticks.
: "${GARDEN_GH_CRED_MARKER:=$GARDEN_STATE/gh-credential-reported}"
: "${GARDEN_GH_CRED_SUSPECT_COUNTER:=$GARDEN_STATE/gh-credential-suspect-count}"

host_short="$(hostname -s 2>/dev/null || echo host)"

# --- probes, overridable so the test drives the guard with NO real gh ----------
# GARDEN_GH_CRED_TOKEN_CMD prints the resolved token on stdout (empty ⇒ MISSING),
# mirroring the wrapper's `env -u GH_TOKEN gh auth token --user <id>`.
# GARDEN_GH_CRED_PROBE_CMD runs an authenticated liveness check with the resolved
# token in GH_TOKEN; its stdout+stderr and exit code are classified below.
: "${GARDEN_GH_CRED_TOKEN_CMD:=}"
: "${GARDEN_GH_CRED_PROBE_CMD:=}"

# Resolve the REAL gh, skipping the fleet wrapper (first on PATH), the same walk the
# wrapper itself uses to avoid recursing into itself.
_real_gh() {
  local self_dir cand
  self_dir="$(cd "$HERE/bin" 2>/dev/null && pwd || true)"
  while IFS= read -r cand; do
    case "$cand" in "$self_dir/gh") continue ;; esac
    printf '%s\n' "$cand"; return 0
  done < <(type -aP gh 2>/dev/null)
  return 1
}

resolve_token() {
  if [ -n "$GARDEN_GH_CRED_TOKEN_CMD" ]; then
    bash -c "$GARDEN_GH_CRED_TOKEN_CMD" 2>/dev/null || true
    return 0
  fi
  local real; real="$(_real_gh)" || return 0
  env -u GH_TOKEN "$real" auth token --user "$GARDEN_GH_IDENTITY" 2>/dev/null || true
}

# Echoes "healthy" | "authfail" | "inconclusive" for the token in $1.
probe_token() {
  local tok="$1" out rc
  if [ -n "$GARDEN_GH_CRED_PROBE_CMD" ]; then
    out="$(GH_TOKEN="$tok" bash -c "$GARDEN_GH_CRED_PROBE_CMD" 2>&1)"; rc=$?
  else
    local real; real="$(_real_gh)" || { echo inconclusive; return; }
    out="$(env -u GH_TOKEN GH_TOKEN="$tok" "$real" api user --jq .login 2>&1)"; rc=$?
  fi
  if [ "$rc" -eq 0 ] && [ -n "$out" ]; then echo healthy; return; fi
  # A definitive auth rejection — but 401/Bad credentials are ALSO transient, hence
  # the caller's persistence gate. Anything else (offline, 5xx, DNS) is inconclusive.
  if printf '%s' "$out" | grep -qiE 'HTTP 401|Bad credentials|401 Unauthorized'; then
    echo authfail; return
  fi
  echo inconclusive
}

# --- reporting sinks (mirror identity-drift-guard.sh, incl. test containment) ---
emit_sink() {
  local name="$1" override="$2"; shift 2
  if [ -n "$override" ]; then bash -c "$override"; return; fi
  if _in_test_context; then
    cat >/dev/null 2>&1 || true
    log "REFUSING to emit the $name report to the REAL bus from a TEST context (GARDEN_TEST=${GARDEN_TEST:-0} GARDEN_STATE=${GARDEN_STATE:-}) with no capture override set — a test must capture EVERY sink (mirrors identity-drift-guard containment, incident 2026-07-28)"
    return 1
  fi
  "$@"
}

: "${GARDEN_GH_CRED_GUARD_MAINTAINER_EMIT:=}"
emit_maintainer() {
  emit_sink maintainer-inbox "$GARDEN_GH_CRED_GUARD_MAINTAINER_EMIT" \
    env GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="gh-credential-guard:$host_short" \
        "$HERE/inbox-send.sh" maintainer
}
: "${GARDEN_GH_CRED_GUARD_EMIT:=}"
emit_error() {
  emit_sink journal-entry "$GARDEN_GH_CRED_GUARD_EMIT" \
    env GARDEN_ROLE="gardener-scaler" "$HERE/journal-entry.sh" error
}

clear_healthy() {
  rm -f "$GARDEN_GH_CRED_MARKER" "$GARDEN_GH_CRED_SUSPECT_COUNTER" 2>/dev/null || true
}

# report <condition> <detail-markdown> — post ONE deduped kind:error escalation for
# the given failure signature, gating the dedup marker on the maintainer report so a
# failed push retries next tick rather than going silently unreported.
report() {
  local condition="$1" detail="$2"
  local sig="host=$host_short|id=$GARDEN_GH_IDENTITY|condition=$condition"
  log "ERROR gh-credential: identity=$GARDEN_GH_IDENTITY condition=$condition on host=$host_short"
  local prev=""
  [ -f "$GARDEN_GH_CRED_MARKER" ] && prev="$(head -1 "$GARDEN_GH_CRED_MARKER" 2>/dev/null || true)"
  [ "$sig" = "$prev" ] && return 0   # already reported this exact state; stay quiet

  local body maintainer_body
  body="$(cat <<EOF
# gh credential UNRESOLVABLE on host \`$host_short\` (deterministic guard)

This host **cannot use the \`$GARDEN_GH_IDENTITY\` GitHub credential** every fleet
git/API **write** depends on. Until it is restored, any job on this host that pushes
a branch, opens a PR (\`ensure-pr.sh\`), comments, reviews, or merges will **fail
closed** at the gh identity wrapper — the job stalls rather than acting under the
wrong identity.

**Condition:** $detail

**Fix (needs maintainer credentials — no agent can supply them):** on host
\`$host_short\`, log the bot in and confirm:

\`\`\`sh
gh auth login --hostname github.com --git-protocol https   # as $GARDEN_GH_IDENTITY
# or, if the login exists but the token lapsed:
gh auth refresh --hostname github.com
# verify the wrapper's resolution path now works:
env -u GH_TOKEN gh auth token --user $GARDEN_GH_IDENTITY >/dev/null && echo OK
\`\`\`

Grounding: the 2026-09-04 \`minion-town-clip-content-store-gc-build\` stall on
endolin-garden-ece02cb4 ("cannot resolve a valid kriscendobot gh token"). The gh
wrapper's fail-closed is the correct safety; this guard is the proactive alert so
the gap surfaces BEFORE a write job trips it.

Posted once per distinct failure state by \`scripts/jobs/gh-credential-guard.sh\`
(gardener-scaler preflight). It will not repeat until the credential is restored or
the failure shape changes.
EOF
)"
  maintainer_body="kind: error"$'\n\n'"$body"
  if printf '%s\n' "$maintainer_body" | emit_maintainer; then
    log "posted gh-credential kind:error maintainer-inbox report (sig=$sig)"
    printf '%s\n' "$body" | emit_error \
      && log "posted gh-credential kind:error journal entry (sig=$sig)" \
      || log "WARN failed to post gh-credential journal entry (maintainer report landed); continuing"
    mkdir -p "$(dirname "$GARDEN_GH_CRED_MARKER")" 2>/dev/null || true
    printf '%s\n' "$sig" > "$GARDEN_GH_CRED_MARKER" 2>/dev/null || true
  else
    log "WARN failed to post gh-credential maintainer-inbox report; will retry next tick"
  fi
}

# --- the check ----------------------------------------------------------------
tok="$(resolve_token)"

if [ -z "$tok" ]; then
  # MISSING — definitive, network-free. Alarm on tick 1.
  report missing \
    "\`gh auth token --user $GARDEN_GH_IDENTITY\` resolves NO token on this host — the \`$GARDEN_GH_IDENTITY\` account is not logged in here (or its stored token was removed). This is a purely local check against gh's own credential store; it is definitive, not a network blip."
  exit 0
fi

verdict="$(probe_token "$tok")"
case "$verdict" in
  healthy)
    clear_healthy
    exit 0
    ;;
  inconclusive)
    # Token resolves locally; the liveness probe could not reach a verdict (offline,
    # 5xx, DNS). Do NOT alarm and do NOT count it against the token — an offline host
    # is not a credential gap. Leave any existing suspect counter as-is (a prior real
    # 401 streak should survive a single network blip), but a fresh healthy resolution
    # of the token is a good sign, so clear a stale dedup marker if the previously
    # reported condition was MISSING (the token is back).
    if [ -f "$GARDEN_GH_CRED_MARKER" ] && grep -q 'condition=missing' "$GARDEN_GH_CRED_MARKER" 2>/dev/null; then
      rm -f "$GARDEN_GH_CRED_MARKER" 2>/dev/null || true
    fi
    log "gh-credential: token for $GARDEN_GH_IDENTITY resolves; liveness probe inconclusive (offline/transient), no escalation"
    exit 0
    ;;
  authfail)
    # Present but rejected. Count consecutive suspect ticks; only escalate past the
    # persistence threshold, since 401/Bad credentials are also transient.
    n=0
    [ -f "$GARDEN_GH_CRED_SUSPECT_COUNTER" ] && n="$(head -1 "$GARDEN_GH_CRED_SUSPECT_COUNTER" 2>/dev/null || echo 0)"
    case "$n" in ''|*[!0-9]*) n=0 ;; esac
    n=$((n + 1))
    mkdir -p "$(dirname "$GARDEN_GH_CRED_SUSPECT_COUNTER")" 2>/dev/null || true
    printf '%s\n' "$n" > "$GARDEN_GH_CRED_SUSPECT_COUNTER" 2>/dev/null || true
    if [ "$n" -ge "$GARDEN_GH_CRED_REVOKED_THRESHOLD" ]; then
      report revoked \
        "\`gh auth token --user $GARDEN_GH_IDENTITY\` returns a token, but an authenticated probe (\`gh api user\`) has been REJECTED with HTTP 401 / Bad credentials for $n consecutive checks (threshold $GARDEN_GH_CRED_REVOKED_THRESHOLD) — the stored token is revoked or expired, not a transient rotation blip."
    else
      log "gh-credential: token for $GARDEN_GH_IDENTITY present but probe returned 401 (suspect tick $n/$GARDEN_GH_CRED_REVOKED_THRESHOLD); tolerating as possibly-transient"
    fi
    exit 0
    ;;
esac
exit 0
