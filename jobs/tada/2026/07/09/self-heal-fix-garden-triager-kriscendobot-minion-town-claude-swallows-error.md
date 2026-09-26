Fix pushed to `main2` (`03f33d7f1`).

## Completion report

**Job:** Harden `scripts/jobs/handlers/triager-claude.sh` so a failing `claude -p` invocation is diagnosed rather than silently swallowed.

**What was wrong:** Line 50, `out="$(claude -p … "$prompt")"`, ran under `set -euo pipefail`. A non-zero `claude` exit aborted the handler inside the command substitution with no diagnostic, so `triager.sh` reported only the generic "triage handler failed … leaving cursor at <none> to retry" — the opaque signature seen on `garden-triager@kriscendobot-minion.town`.

**What I changed:**
- Redirect `claude`'s stderr to a temp file (`mktemp`, cleaned via an `EXIT` trap) and test its exit status explicitly. On failure, `die "claude -p exited <rc> while triaging <slug>: <last 500 bytes of stderr>"` — surfacing whether the cause was network/DNS to `api.anthropic.com`, quota, or a malformed prompt.
- The success path and the non-advancing-cursor retry semantics are untouched, so a transient blip still leaves the cursor to retry while a deterministic error is now legible to a future self-heal responder.

**Deviation from the spec's suggested snippet (deliberate):** the spec proposed `if ! out="$(…)"; then rc=$?`. I verified that after a `!`-negated pipeline bash sets `$?` to the *logical negation* (0), not claude's real exit code — so that idiom would have logged `exited 0` for every failure. I used the `if … then : else rc=$? …` form instead and confirmed by test it captures the true status (e.g. 42). A comment records the gotcha.

**Verification:** `bash -n` clean; `shellcheck` shows only two pre-existing warnings (SC1091 sourced-file, SC2034 `GARDEN_TAG`), no new issues; the rc-capture semantics confirmed with a standalone bash test.

**Follow-ups:** none. (A separate self-heal *responder* that acts on these now-legible diagnostics — retry vs. post-a-fix — is out of scope for this job but is the natural next step the richer logging enables.)
