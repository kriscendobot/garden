`scripts/jobs/test/issue-inbox-watcher-test.sh` aborts a third of the way through
and reports the abort as success-shaped output. Fix the suite so it runs to
completion and so this failure mode cannot recur silently.

This is PRE-EXISTING — it reproduces identically on an unmodified tree — and was
found while doing the kriskowal/garden -> kriscendobot/garden transfer
follow-through, not caused by it.

## Symptom

    ./scripts/jobs/test/issue-inbox-watcher-test.sh; echo $?
    -> 21 PASS, 0 FAIL, rc=1, no RESULT/summary line

It stops inside section I ("reactji helper: the issue surface hits
/issues/<number>/reactions"), so section I's two assertions and ALL of sections J
onward (the file runs to line 384) never execute. Because nothing calls `bad`, the
output looks clean — 21 PASS and no failures — and only the exit code betrays it.
A reader skimming the tail sees passes.

## Root cause

The suite runs under `set -euo pipefail` (line 33). Line 264 invokes the handler
unguarded:

    PATH="$BIN:$PATH" "$JOBS/handlers/comment-reactji-gh.sh" "$REPO" issue 13 eyes >/dev/null 2>&1

`comment-reactji-gh.sh` exits 1 there, so `set -e` kills the suite at that line,
before the `grep`-based assertion on the NEXT line ever runs.

Confirmed directly:

    PATH="$BIN:$PATH" ./scripts/jobs/handlers/comment-reactji-gh.sh kriskowal/garden issue 13 eyes; echo rc=$?
    [comment-reactji] reactji POST failed on repos/kriskowal/garden/issues/13/reactions
    rc=1

## Two things to fix, not one

1. **The unguarded call.** The assertion is on the ARGUMENTS the stub logged, not
   on the handler's exit status, so the call should tolerate a non-zero exit
   (`|| true`). Both invocations (lines 264 and 267) have the same shape.

2. **The stub is inadequate, and that is the more interesting half.** The section's
   stub `gh` merely logs `$*` and exits 0, yet the handler still reports "reactji
   POST failed" — so the handler now checks something about the RESPONSE that a
   bare `exit 0` no longer satisfies. Just adding `|| true` would paper over that
   and leave the assertion passing for the wrong reason. Work out what the handler
   requires, make the stub emit it, and confirm the assertion then passes because
   the endpoint is right — not because the failure is being swallowed.

## Also worth closing

The suite has no final `RESULT:`/`N passed, M failed` summary line the way its
siblings do (`ci-watcher-test.sh`, `fork-watch-provisioner-test.sh`,
`journal-remote-origin-rewrite-guard-test.sh` all print one and exit non-zero on
FAIL>0). Adding one would have made this abort obvious immediately. Consider
whether other suites share the "dies under `set -e`, reports nothing" shape — a
grep for unguarded handler invocations inside `set -e` test files would tell you.

## Done when

The suite runs to the end, prints a summary, exits 0 with every section executed,
and each assertion passes for the right reason. Re-run and paste the tail as
evidence.

---
claim:
  host: ps23
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-28T06:43:35Z
