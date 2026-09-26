Pushed cleanly to `main2` (`d486643cf..c9b828ac5`).

## Completion report

**Job:** `scripts/jobs/handlers/triager-claude.sh` — make a `garden-triager` handler failure diagnosable instead of an opaque `exit 1` with an empty tail.

**What I found:** The `claude -p` half of the spec was already done by earlier commits on `main2` (a8b87df68 / 921b8444f / d486643cf): the invocation already captures its exit code, redirects stderr to a temp file, logs an `stderr=[…] stdout=[…]` tail on failure, and wraps the call in a bounded retry with backoff before escalating to `die`. The one remaining gap the spec calls out was untouched: the JOB..ENDJOB parse loop still piped into `post-job.sh` bare under `set -euo pipefail`, so a single non-zero post aborted the whole loop silently — the same silent-abort class, one layer down.

**What I changed (1 file, +31/-5):**
- Wrapped the `post-job.sh` call so its exit code and stderr are captured per block (via a `postfile` temp, added to the `EXIT` trap alongside `errfile`).
- On a non-zero post: `log` the offending basename, the exit code, and a `tail -c 400` of its stderr; increment a `failed` counter and **keep posting the remaining blocks** (one bad block no longer swallows its siblings).
- After the loop, if any post failed, `die` — returning non-zero to `triager.sh` so the cursor stays unadvanced and the change re-triages, preserving the existing contract, but now the failure names its cause.
- Used `if cmd; then; else prc=$?` (no `!` negation) so `$?` carries `post-job.sh`'s real exit code, matching the pattern already established for the claude call.

**Verification:** Built a stub harness in the worktree (had to run in the executable worktree FS, not `/tmp`, which is mounted `noexec`). Confirmed three behaviors: (1) failing `post-job.sh` (exit 7) → diagnostic line names basename `test-basename-42`, exit code, stderr tail, then `FATAL … leaving cursor unadvanced to re-triage`, handler exits 1; (2) two successful posts → `posted 2 job(s)`, exit 0; (3) `bash -n` clean, shellcheck shows only pre-existing benign warnings (SC1091 sourcing, SC2034 GARDEN_TAG).

**Follow-ups:** None. The spec's suggested verification of forcing the claude call to fail is already satisfied by the existing retry/diagnostic code the earlier commits landed.
