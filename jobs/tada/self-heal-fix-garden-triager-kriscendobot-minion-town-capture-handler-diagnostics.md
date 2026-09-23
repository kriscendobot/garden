Empty inbox. Work is complete.

## Completion report

**Job:** Make `scripts/jobs/handlers/triager-claude.sh` diagnose `claude -p` failures instead of leaving an empty service-log tail (self-heal for the undiagnosable `kriscendobot-minion.town:main` triage failure, `<none> → 35e9b4a5`).

**What I found:** The two commits the job's "line 50" description predates (`03f33d7f1` log exit code/stderr, `a8b87df68` bounded retry) had already landed before this job was claimed, so the raw `out="$(claude -p …)"` was gone. But a genuine residual gap remained matching the job's exact "empty service-log tail" signature: the failure diagnostic captured **only stderr** (`2>"$errfile"`). `claude -p` frequently prints its error to **stdout**, so an error-to-stdout failure still produced a blank tail before triager.sh's FATAL.

**What I changed** (`scripts/jobs/handlers/triager-claude.sh`, diagnostics-only):
- The retry-log and terminal-`die` paths now build one combined diagnostic from **both** the stderr tail (`$errfile`) and the captured stdout tail (`$out`, which bash still assigns when the command substitution's command exits nonzero).
- Used `printf '%s' "$out" | tail -c 400` for the stdout tail rather than `${out: -400}` — testing revealed the latter's negative offset resolves before the string start and expands to the **empty string** whenever the message is shorter than 400 chars, which would have reproduced the very empty-tail signature this job exists to kill.

**Verification:**
- `bash -n` clean.
- End-to-end run with a stub `claude` that errors to stdout: the retry logs and the FATAL line now carry the real `API Error: 401 authentication_error …` text (previously `stdout=[]`).
- Success path (parse `JOB..ENDJOB` from clean stdout, post via `post-job.sh`), bounded retry, and non-advancing-cursor retry semantics all unchanged; existing `scripts/jobs/test/triager-test.sh` suite passes 21/21.

**Committed & pushed:** `921b8444f` → `origin/main2` (CAS push succeeded first attempt). No follow-ups; inbox drained empty.
