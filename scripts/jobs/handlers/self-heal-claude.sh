#!/bin/bash
# self-heal-claude.sh — the default self-healing responder.
#
# Invoked by self-heal-run.sh as:
#   self-heal-claude.sh <sha> <clone-dir> <context> <rc> [<work-id>] [<role-brief>]
#
# The failed service's combined-output tail has been captured as a
# content-addressed git blob (<sha>) in <clone-dir>'s object DB. We hand the
# inner `claude -p` agent ONLY the SHA — never the inline log — so a large
# failure transcript never enters its context; it pulls just the slices it needs
# with `git cat-file -p <sha> | grep/sed/tail`. The agent wears a role fit for
# THIS service (the <role-brief>, default the mentor role) and is told what the
# service does, so the diagnosis is task-specific, not a generic fleet scan.
#
# The agent emits zero or more job blocks (JOB <base> … ENDJOB); this handler
# posts each to the board. If it emits a non-empty diagnosis but no job block,
# the diagnosis is escalated to the maintainer inbox (THROTTLED, cross-host
# visible) so the intent is never lost. Silent on a clean, no-opportunity run.
#
# Test harness overrides SELF_HEAL_HANDLER with a deterministic stub.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="self-heal-claude"

sha="${1:?usage: self-heal-claude.sh <sha> <clone-dir> <context> <rc> [work-id] [role-brief]}"
dir="${2:?missing <clone-dir>}"
context="${3:?missing <context>}"
rc="${4:-?}"
work_id="${5:-}"
role_brief="${6:-$GARDEN_ROOT/roles/mentor/AGENT.md}"

# A short, deterministic slug from the context for idempotent job/escalation keys.
ctx_slug="$(printf '%s' "$context" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9' '-' | sed 's/--*/-/g; s/^-//; s/-$//')"

prompt="$(cat <<EOF
You are a garden self-healing responder wearing this role brief: $role_brief.
A garden service just FAILED and systemd will restart it; your job is to
diagnose WHY and either post a concrete fix job or escalate a clear report —
not to restart it (systemd already does).

Service (context): $context
Exit code:         $rc
Work item:         ${work_id:-(none)}

The service's combined stdout+stderr tail was captured as ONE content-addressed
blob. It is NOT inlined here on purpose: read only the slices you need.

$(inspect_note "$sha" "$dir")

Narrow with a pipe rather than reading the whole blob, e.g.:
  git -C $dir cat-file -p $sha | tail -n 60
  git -C $dir cat-file -p $sha | grep -n -i -E 'error|fail|fatal|trace|exception'

Diagnose the failure. If there is a concrete, scoped fix (a script change, a
guard, a missing dependency, a unit tweak), emit a job block EXACTLY:

JOB self-heal-fix-${ctx_slug}-<short-deterministic-slug>
<what to change and why, naming the script/file and the failure signature>
ENDJOB

Use a DETERMINISTIC slug derived from the failure (so an identical recurring
failure posts the same idempotent basename, never a duplicate). Emit nothing if
the failure is transient/environmental with no code fix (e.g. a network blip);
in that case write a one-paragraph explanation and no JOB block.
EOF
)"

# Run the inner agent. Best-effort: a missing/failed claude must not error this
# handler in a way that masks the diagnosis attempt.
out=""
# Resolved through the shared resolver (PATH, then the known install locations —
# common.sh § agent-CLI resolution). Single probe, no retry: the diagnosis is
# best-effort and its absence is a soft skip.
if claude_cli="$(claude_bin_now)"; then
  # --dangerously-skip-permissions: autonomous headless context, no human
  # approver; matches the rest of the fleet (mentor-claude.sh). Requires non-root.
  out="$("$claude_cli" -p --dangerously-skip-permissions "$prompt" 2>/dev/null || true)"
else
  log "claude not found on PATH nor in any known install location; cannot diagnose '$context' (blob $sha left for the mentor)"
  exit 0
fi

[ -n "$out" ] || { log "responder produced no output for '$context'"; exit 0; }

# --- provider quota: ONE fleet condition, not one report per unit ------------
# When the account's usage/weekly cap is exhausted, `claude -p` does not diagnose
# anything — it REFUSES, and its refusal ("You've hit your weekly limit · resets
# 3am (UTC)") lands in $out. Escalating that as this unit's diagnosis produced 94
# near-identical maintainer messages over four days (2026-07-24..28), one per unit
# per throttle window, burying genuinely actionable mail. It is one ENVIRONMENTAL
# fact: report it once, fleet-level and coalescing, and say nothing per unit. The
# unit's own failure is not lost — its capture blob stays addressable, and the
# fleet notice names the latest context and blob.
if is_provider_quota_text "$out"; then
  note_provider_quota "$context" \
    "$(printf '%s' "$out" | head -c 400) — the responder could NOT diagnose $context (rc=$rc); its capture is blob $sha (git -C $dir cat-file -p $sha)."
  log "responder for '$context' was refused by the provider quota; folded into the fleet-level notice (no per-unit report)"
  exit 0
fi

# The provider ANSWERED, so any open fleet-level quota condition has ended. Cheap
# no-op (one file test) when none was ever raised on this host.
note_provider_ok "$context"

# Parse and post any JOB blocks (the mentor-claude.sh convention).
posted=0
base=""; body=""
while IFS= read -r line; do
  if [[ "$line" =~ ^JOB[[:space:]]+(.+)$ ]]; then
    base="${BASH_REMATCH[1]}"; body=""
  elif [ "$line" = "ENDJOB" ] && [ -n "$base" ]; then
    if printf '%s' "$body" | "$HERE/../post-job.sh" "$base" >/dev/null 2>&1; then
      log "posted fix job '$base' for '$context'"; posted=$((posted+1))
    else
      log "post of fix job '$base' failed (best-effort)"
    fi
    base=""; body=""
  elif [ -n "$base" ]; then
    body+="$line"$'\n'
  fi
done <<< "$out"

# No job block but a real diagnosis → escalate to the maintainer inbox, THROTTLED
# per context (alert_maintainer dedups + rate-limits) so a recurring transient
# never floods the inbox. The capture SHA travels with the report (same host).
if [ "$posted" -eq 0 ]; then
  alert_maintainer "self-heal-${ctx_slug}" \
    "self-heal: $context exited rc=$rc with no scoped fix. Capture: $sha (git -C $dir cat-file -p $sha). Diagnosis: $(printf '%s' "$out" | head -c 800)"
  log "no fix job for '$context'; escalated diagnosis to maintainer (throttled)"
fi

exit 0
