CI is fully green (17 pass, 18 intentionally skipped, 0 fail). The fixer round is complete and validated.

## Completion report

**Job:** Fix endojs/endo-but-for-bots PR #1591 containment findings (M3 shell-sandbox path).

**Resumed state:** My prior session had already pushed the round-2 fixes (head `5a9275120d`) and posted the summary comment; CI was still running. This session confirmed the push landed and drove CI to green.

**What changed** (head `5a9275120d`, on `fix/sandbox-bwrap-leader-exit-group-sweep`):
- `1f4ad4502e` — bwrap driver's `/proc/<pid>/stat` daemon-identity read now derives from the **injected `fs` capability** (ambient fallback only when none supplied), is **isolated in its own `try`** (procfs errors no longer misattributed to spawn), and **re-checks cancellation** after the possibly-yielding fallback and before `cp.spawn`. Added a **patch changeset** for `@endo/sandbox`.
- `5a9275120d` — added the **tolerated-`ESRCH` exit-sweep test** (asserts `wait()` resolves with the exit status), mirror of the non-`ESRCH` propagation test; renamed the test's `close` index to `closeParen`.

The job's originally-named deliverables (safe reaped-PGID signalling, non-`ESRCH` propagation, deterministic exit-sweep coverage) were already in the prior head `096c17adcf`; this round addressed the subsequent panel's capability/coverage/changeset findings.

**Declined / surfaced with rationale** (recorded in the PR summary comment): breaker's reap-before-settle (SIGKILL group delivery is synchronous; the polled membership is zombie reaping, not live containment), prover/breaker's surviving-member test (existing test already fail-closed to the sweep, round-1 verified), fast-checker's `@fast-check/ava` dependency (both partitions now deterministically covered), and the transient-retry / `/bin/sh` path / unrelated-base-commit items (follow-ups; the last is a frozen-base sweep artifact out of lane).

**Verification:** full CI matrix **green** — 17 checks pass (including `sandbox-drivers`, `lint`, `test-xs`, both macOS legs), 18 intentionally skipped, 0 failures. Local `eslint` + `tsc` clean; the three exit-sweep tests pass under both SES configurations.

**Follow-ups:** the surfaced/declined must-fix dispositions above may recur in the next panel round for a supervised fixer to resolve or ratify.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1591-20261117.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (1 unmetered)
- Input: 82 tokens (3926286 cached reads)
- Output: 35407 tokens
- Cost: $7.854713000000002 (1 engagement(s) unpriced)
- Wall-clock: 1272s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
