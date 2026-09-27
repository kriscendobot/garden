---
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Make `scripts/jobs/test/triager-pacing-test.sh` hermetic against the
`cgroup reap skipped` WARN so the deploy candidate gate stops flaking on the
LEADER self-deploy path.

## The defect

Commit `6fc21936148` ("fix(triager): WARN when the cgroup straggler sweep skips
instead of no-opping silently") made the triager emit, on stderr/stdout:

    <4>[triager/...] WARN: cgroup reap skipped — leaf '<service>.service' is not a
    garden-triager@*.service cgroup (...)

whenever the pacing tick's cgroup straggler sweep runs OUTSIDE a
`garden-triager@*` cgroup. `triager-pacing-test.sh` captures the tick's combined
output and asserts on it with exact/dedup matching, so this WARN line
contaminates several assertions.

`fix-1570aa85` (commit `4692b4df0e7`) added a "test-only empty cgroup fixture"
that covers the case where the test runs inside a **cleric** service cgroup. It
does NOT cover the case where the test runs inside the **`rolling-deploy.service`**
cgroup — which is exactly the LEADER self-deploy gate path: `rolling-deploy.sh`
invokes `deploy-garden.sh` directly, so the candidate gate (and this test) inherit
`rolling-deploy.service`'s cgroup. There the WARN still fires and the suite fails.

## Evidence (leader endolin-garden-ece02cb4, target 7bd312a6379, 2026-09-27T18:03Z)

Gate diagnostic
`.garden-state/deploy/candidate-gate-diagnostics/7bd312a6379e0de6b290b270ff3b11245f7720b9/attempt2-01-scripts_jobs_test_triager-pacing-test.sh.log`
showed `3 passed, 11 failed`, every failure carrying the leaked line:

    WARN: cgroup reap skipped — leaf 'garden-rolling-deploy.service' is not a
    garden-triager@*.service cgroup (.../garden-rolling-deploy.service)

plus the cascade `awk: cannot open ".../handler-calls"` and
`line 154: [: : integer expression expected`.

It is INTERMITTENT, not a stable regression: the same gate PASSED this suite at
17:56:54Z, and the suite passes 14/14 standalone in a normal worktree. The gate's
attempt-1/attempt-2 retries ran ~2s apart in one load window, so its
flake-vs-regression discriminator misclassified it as a "real regression" and
aborted the deploy.

## What to fix

Make the test neutralize this WARN regardless of the AMBIENT service cgroup the
test process runs under (rolling-deploy.service, cleric, monk, or any non-triager
cgroup), not just via a cgroup fixture that happens to match one service. Options
to weigh: run the tick under a stubbed cgroup that IS a `garden-triager@*` leaf;
or make the harness point the sweep at a controlled empty fixture unconditionally;
or filter the known-benign `cgroup reap skipped` WARN out of the captured output
before asserting. Keep it a TEST-ONLY change unless you find a genuine runtime
bug. Verify by running the suite from inside a `garden-rolling-deploy.service`-like
cgroup (systemd-run --user --scope, or a mimicked cgroup path), not only a bare
shell — the bug only reproduces under a non-triager service cgroup.

## Context — why this matters now

The leader is stuck 47 commits behind main2 in a BOOTSTRAP TRAP: today's
deploy-robustness fixes (`improve-rolling-deploy-rejected-candidate-backoff`
b7e65392bd, this test's fixtures, the deferring-canary fix) are all on main2, but
the leader's OLD gate keeps flaking on this leak and cannot deploy the commits that
would fix it. This test fix removes the flake so the leader (and any host) can pass
the gate reliably. The immediate unstick of the leader itself is a separate
maintainer decision (emergency GARDEN_DEPLOY_TEST_OVERRIDE=1 deploy) escalated
separately by job upgrade-fleet-to-main2-uniform-20260918.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-27T18:26:14Z -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-27T18:26:23Z
