The requested hardening is already fully present on `main2`. Two commits already landed it:

- **03f33d7f1** — "triager-claude: log claude's exit code and stderr instead of swallowing the failure" — added the exact `mktemp` stderr capture + explicit exit-status check that this job specifies.
- **a8b87df68** (current HEAD) — "triager-claude: bounded retry around the claude -p triage call" — extended it with a bounded 3-attempt retry/backoff, still escalating via `die` (nonzero) with the stderr signature on persistent failure.

Checking the current file (`scripts/jobs/handlers/triager-claude.sh:64-94`) against the job's acceptance criteria:

- **stderr captured to a temp file** — yes, `errfile="$(mktemp …)"` with an `EXIT` trap cleanup (line 64-65).
- **explicit exit-status check instead of bare `set -e`** — yes, `if out="$(claude … 2>"$errfile")"; then break; else rc=$?; …` (line 82-85), and it even documents the `$?`-after-`!` pitfall the naive form in the job spec would hit.
- **distinct diagnostic signature (exit code + stderr head)** — yes, both the retry `log` (line 90) and the terminal `die` (line 87) emit `exited $rc … $(tail -c N "$errfile")`.
- **keeps the nonzero exit so triager.sh leaves the cursor to retry** — yes, `die` exits nonzero; retry/cursor semantics unchanged (documented at lines 62-63, 66-74).

There is nothing to change — the working tree is clean, HEAD matches `origin/main2`, and the fix (plus a strict superset of it) is deployed. No commit or push is warranted; opening a redundant one would only churn the file.

**Follow-up / note:** this self-heal job was posted against a snapshot that predates commit 03f33d7f1, so it was already obsolete when claimed. No action needed by the maintainer; the recurring blank-`FATAL` triage failure it targeted is already diagnosable in the deployed code (a genuine `claude -p` outage now emits `claude -p exited <rc> while triaging <slug> … <stderr head>`). If the blank-`FATAL` was still observed *after* main2 carried a8b87df68, that would point at a stale deployed garden root rather than at this handler — worth a `deploy-garden` check — but the code fix itself is complete.
