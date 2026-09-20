Pushed cleanly. Work complete.

## Completion report

**Job:** `improve-candidate-gate-flake-retry` — make the deploy candidate gate tolerant of a one-off host-side test flake instead of rejecting a good candidate.

**What I did**

Modified `scripts/jobs/deploy-garden.sh`'s candidate gate (`run_candidate_gate`):

- **Retry logic:** When the *only* attempt-1 failures are suite executions (a plausible host-side flake), the gate now retries **only those failed suites once**, in a **fresh gate root** (a new `mktemp` unpack of the candidate archive, not attempt-1's tree). If all retried suites pass, the candidate is **accepted** and the attempt-1 failure is logged as a transient flake — the deploy is no longer blocked. If any suite fails again, the candidate is **rejected** as a real regression.
- **Deterministic failures are never retried:** `bash -n` syntax errors, missing suites, and total-wall-clock timeouts make the run retry-ineligible (they inflate `failed` past `failed_suites`), so they reject on the first attempt exactly as before.
- **Both attempts' diagnostics preserved:** `persist_candidate_gate_diagnostic` now takes an `attempt` label and writes `attempt<N>-<ordinal>-<suite>.log`, so a retry never clobbers attempt-1's capture.
- Refactored the suite-execution loop into `execute_gate_suites` (reused across both attempts) and the unpack into `unpack_candidate_gate_tree`. Updated the step-0 header comment.

**Tests** (`scripts/jobs/test/deploy-garden-test.sh`): added STATIC assertions for the retry path and per-attempt diagnostic labelling; a flake-retry PASS case (suite fails once via an external counter then passes → deploy proceeds, ran exactly twice, attempt-1 diagnostic retained); a real-regression case (fails both attempts → rejected, both attempt diagnostics preserved); and a bash-n case proving deterministic failures aren't retried. Updated the existing failing-suite case to reference attempt-2's diagnostic. Full suite: **148 passed, 0 failed.**

**Changed:** `scripts/jobs/deploy-garden.sh`, `scripts/jobs/test/deploy-garden-test.sh`. Committed `c66038fb38` and pushed to `main2`.

**Follow-ups:** None required. The retry adds at most one extra bounded gate pass to a deploy that would otherwise have failed; the drained-deploy window is unaffected on the clean path.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-candidate-gate-flake-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2323858 cached reads)
- Output: 28177 tokens
- Cost: $2.7826319999999996
- Wall-clock: 435s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
