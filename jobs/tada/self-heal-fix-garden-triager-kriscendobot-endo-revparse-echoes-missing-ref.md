All 29 assertions pass, including the E case this job specifies. No code change is needed — the work was already landed by prior commits. Nothing to commit or push.

## Completion report

**Job:** Fix the `refs/remotes/origin/$ref` echo-to-stdout bug in `scripts/jobs/triager.sh` and add test coverage for the fallback-resolution case.

**Finding: already fixed on `main2` — no work required.**

The buggy form quoted in the spec (bare `rev-parse … 2>/dev/null`) no longer exists. The current source (`scripts/jobs/triager.sh:59-61`) already implements the prescribed fix and more:
- Both rev-parse invocations use `--verify -q` (so a non-resolving primary ref prints nothing and exits non-zero cleanly instead of echoing its argument), and the redundant `2>/dev/null` redirects were dropped.
- A `^{commit}` peel normalizes annotated-tag refs before the downstream diff.
- A defense-in-depth tripwire (`[[ "$new_sha" =~ ^[0-9a-f]{40}$ ]]`) dies loudly on any future poisoned multi-line `new_sha`.

These landed via commits `469cab011` (the core `--verify -q` fix), `4ceaff391` (drop `2>/dev/null`), `7cc020469` (40-hex assert), and `80acdfce0` (`^{commit}` peel) — all present in `main2` (`git log -- scripts/jobs/triager.sh`).

The requested test coverage also already exists in `scripts/jobs/test/triager-test.sh`:
- **Case E** reproduces exactly the job's scenario — bare clone with `refs/heads/$ref` present but `refs/remotes/origin/$ref` absent — and asserts `new_sha` reaches the handler as a single clean 40-hex SHA (single CALL_LOG line = no injected newline).
- **Case F** verifies the multi-line guard fires loudly without reaching the handler.

**Verification:** ran the full suite — **29 passed, 0 failed**, including all of case E and F.

**Changes:** none. **Follow-ups:** none. This self-heal job appears to have been raised against a stale snapshot; the underlying triager FATAL is already resolved in the deployed line. No commit or push made.
