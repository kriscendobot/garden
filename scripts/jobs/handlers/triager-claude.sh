#!/bin/bash
# triager-claude.sh — default triage handler: decide jobs via `claude -p`.
#
# Invoked by triager.sh as: triager-claude.sh <slug> <old-sha> <new-sha> <bare>
# Wears the triager role, inspects what changed on the repo between old..new,
# and emits zero or more jobs for gardeners. The triager role brief lives at
# roles/triager/AGENT.md.
#
# Contract with claude: emit each job as a block
#     JOB <basename>
#     <body lines...>
#     ENDJOB
# This handler posts each block via post-job.sh. The basename must be
# deterministic from the change (e.g. <slug>-pr<N>-<shorthash>) so re-triage is
# idempotent. The test harness overrides GARDEN_TRIAGE_HANDLER with a stub.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="triage-claude"

slug="${1:?slug}"; old="${2:-}"; new="${3:?new}"; bare="${4:?bare}"
role_brief="$GARDEN_ROOT/roles/triager/AGENT.md"

range="${old:+$old..}$new"
# Select the git-log range without EVER handing `git log` an empty revision.
# The old `"${old:+$old..$new}"` expansion collapsed to the empty string on a
# cold start (empty $old, i.e. no cursor yet), so `git log --stat ""` failed with
# `fatal: ambiguous argument ''` (exit 128) — which, in the pipe below, pipefail
# propagates. That crashed the FIRST triage of any repo (observed on
# garden-triager@kriscendobot-minion.town the day repos/ gained its first
# auto-provisioned own fork, 2026-07-09) and froze the cursor at <none> so it
# recurred every restart. When $old is set, diff old..new; when empty, describe
# just the new tip (-1 $new) — a real cold-start change summary, never "".
#
# `|| true`: under `set -euo pipefail`, `git log | head -400` dies of SIGPIPE
# whenever the log outruns head's 400-line cap. head's truncation is the intent,
# not an error, and a genuine git failure degrades to empty $changes (which the
# prompt tolerates — the triager just sees an empty change list) rather than
# aborting the handler with no captured stderr.
if [ -n "$old" ]; then
  changes="$(git --git-dir="$bare" log --no-merges --stat "$old..$new" 2>/dev/null | head -400 || true)"
else
  changes="$(git --git-dir="$bare" log --no-merges --stat -1 "$new" 2>/dev/null | head -400 || true)"
fi

prompt="$(cat <<EOF
You are a garden triager (role brief: $role_brief) for repository '$slug'.
The repository advanced over range '$range'. The change summary follows. Decide
what work, if any, gardeners should pick up. Emit zero or more job blocks in
EXACTLY this format and nothing else:

JOB <short-filesystem-safe-basename, deterministic from the change>
<one or more body lines describing the job for a gardener>
ENDJOB

----- CHANGES -----
$changes
----- END CHANGES -----
EOF
)"

command -v claude >/dev/null 2>&1 || die "claude not on PATH; cannot triage $slug"
# --dangerously-skip-permissions: autonomous headless context, no human
# approver; the default permission gate would deny every tool call (the triager
# needs gh especially). Bypass is the intended fleet posture (operator
# pre-consents via skipDangerousModePermissionPrompt in ~/.claude). Non-root.
# Capture claude's exit status AND its combined stdout+stderr so a failure is
# diagnosable rather than an opaque abort inside the command substitution under
# `set -e`. stderr goes to $errfile (kept out of the success parse, which reads
# only clean stdout); on failure BOTH the stderr tail and the captured stdout
# tail ($out) are logged, because `claude -p` prints its error diagnostic to
# stdout as often as to stderr — capturing only stderr reproduced the very
# "empty service-log tail" that made kriscendobot-minion.town:main
# (<none> -> 35e9b4a5) undiagnosable. This also lets a self-heal responder
# distinguish a transient API/DNS/quota blip (leave the cursor to retry) from a
# deterministic error (post a fix). The success path and the non-advancing-cursor
# retry semantics are unchanged.
errfile="$(mktemp "${TMPDIR:-/tmp}/triage-claude.XXXXXX.err")"
trap 'rm -f "$errfile"' EXIT
# Bounded retry with a short backoff: a transient non-zero exit from `claude -p`
# (an API blip, a rate-limit, a momentary kill) is not a reason to fail the unit
# — triager.sh leaves the cursor unadvanced and re-triages on the next ~2-minute
# tick anyway, so the SAME prompt usually succeeds on a re-roll. Absorbing the
# blip in-tick avoids marking garden-triager@<repo> Failed and burning a
# self-heal responder on a fault that self-recovers seconds later. Only a
# genuinely PERSISTENT failure (all attempts exhausted) escalates to `die`, and
# then it carries claude's stderr into the failure path so a future self-heal
# diagnosis has a real signature instead of a blank 2-line capture.
attempts=3
delays=(3 9)   # backoff BETWEEN attempts: attempt1 -> 3s -> attempt2 -> 9s -> attempt3
attempt=1
while :; do
  # NB: capture rc in the `else` branch, not via `if ! ...; then rc=$?` — after a
  # `!`-negated pipeline `$?` is the logical negation (0), losing claude's real
  # exit code.
  if out="$(claude -p --dangerously-skip-permissions "$prompt" 2>"$errfile")"; then
    break
  else
    rc=$?
    # Combined diagnostic: stderr tail (from $errfile) AND stdout tail (from
    # $out, still assigned even when the command substitution's command exits
    # nonzero). Both via `tail -c`, which returns the whole string when it is
    # shorter than the cap — unlike `${out: -400}`, whose negative offset
    # resolves before the start and yields the EMPTY string for the common
    # short-message case, which would reproduce the very empty-tail signature
    # this handler exists to kill. Logging both closes the "empty service-log
    # tail" gap when claude errors to stdout instead of stderr.
    err_tail="$(tail -c 400 "$errfile" 2>/dev/null || true)"
    out_tail="$(printf '%s' "$out" | tail -c 400)"
    diag="stderr=[$err_tail] stdout=[$out_tail]"
    if [ "$attempt" -ge "$attempts" ]; then
      die "claude -p exited $rc while triaging $slug after $attempt attempt(s): $diag"
    fi
    delay="${delays[$((attempt-1))]:-9}"
    log "claude -p exited $rc while triaging $slug (attempt $attempt/$attempts); retrying in ${delay}s: $diag"
    sleep "$delay"
    attempt=$((attempt+1))
  fi
done

# parse JOB..ENDJOB blocks and post each.
# Post DELIBERATELY: capture post-job.sh's exit code and stderr rather than
# letting a single non-zero post abort the whole parse loop under `set -e` with
# no context (the same silent-abort class this handler exists to kill, one layer
# down from the `claude -p` call). A failing post names its offending basename +
# stderr tail and we keep posting the remaining blocks so one bad block does not
# swallow its siblings; if ANY post failed we `die` at the end, which returns
# non-zero to triager.sh so the cursor stays unadvanced and the change
# re-triages (contract preserved) — but now the failure names its cause.
postfile="$(mktemp "${TMPDIR:-/tmp}/triage-claude.XXXXXX.post")"
trap 'rm -f "$errfile" "$postfile"' EXIT
posted=0; failed=0; base=""; body=""
while IFS= read -r line; do
  if [[ "$line" =~ ^JOB[[:space:]]+(.+)$ ]]; then
    base="${BASH_REMATCH[1]}"; body=""
  elif [ "$line" = "ENDJOB" ] && [ -n "$base" ]; then
    # NB: `if cmd; then; else prc=$?` — no `!` negation, so `$?` in the else
    # branch is the pipeline's real exit code (pipefail carries post-job.sh's).
    if printf '%s' "$body" | "$HERE/../post-job.sh" "$base" 2>"$postfile"; then
      posted=$((posted+1))
    else
      prc=$?
      post_tail="$(tail -c 400 "$postfile" 2>/dev/null || true)"
      log "post-job.sh exited $prc for basename '$base' while triaging $slug: stderr=[$post_tail]"
      failed=$((failed+1))
    fi
    base=""; body=""
  elif [ -n "$base" ]; then
    body+="$line"$'\n'
  fi
done <<< "$out"
if [ "$failed" -gt 0 ]; then
  log "posted $posted job(s) from $slug triage ($failed post failure(s))"
else
  log "posted $posted job(s) from $slug triage"
fi
if [ "$failed" -gt 0 ]; then
  die "$failed job post(s) failed during $slug triage; leaving cursor unadvanced to re-triage"
fi
