from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-21T22:05:29Z
doom_base: fix-subscription-model-deploy-gate-regression
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-21T22:05:29Z
last_seen: 2026-09-21T22:05:29Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/fix-subscription-model-deploy-gate-regression; it stays HELD until a human promotes it
(promote-plan.sh fix-subscription-model-deploy-gate-regression) or removes it, so nothing is lost.
Original job base: fix-subscription-model-deploy-gate-regression

--- original job body ---
---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix deploy-gate regression from subscription-based-budget-model

This is blocking deploys FLEET-WIDE. garden2's deploy attempt on 2026-09-20
(candidate `6c7e49cab6`) and the leader's deploy attempt just now on
2026-09-21 (candidate `7070fc7e9c`) both rejected on the SAME three suites:
`signal-kill-classifier-test.sh`, `retry-narrowing-test.sh`,
`provider-cooldown-test.sh`. This has been silently stalling the fleet's
deploy pipeline for at least two days.

## Strong lead: this is fallout from `subscription-based-budget-model`

`provider-cooldown-test.sh` subtest 9 fails with:

```
unrecognized inference source unknown:anthropic:envelopehost:gardener;
treat it as depleted and ask the maintainer for a token count and target
spend date before enabling it
```

That is the EXACT "ask before an unknown token source" refusal gate added
by `subscription-based-budget-model` (job tada report:
`jobs/tada/2026/09/20/subscription-based-budget-model.md` if still flat, or
search sharded — grep for "real code gates refusing unknown token sources").
That gate is correctly firing — the test's own fixture uses a placeholder
pool name (`envelopehost`) that was never one of the four real registered
subscriptions (`claude-endolin1`, `claude-endolin2`, `claude-oros`,
`codex-endolin`) and was never updated when the gate landed. **The gate's
behavior is not the bug — the stale test fixture is.**

The other two failing suites (`signal-kill-classifier-test.sh`,
`retry-narrowing-test.sh`) both exercise `doin`/claim/retry/reap mechanics —
plausibly hitting the SAME new admission-gate code path from a different
angle, since that job's own report says it added gates in `claim-job.sh`
and "provider handlers" too, not just the budget layer. Trace this
precisely rather than assuming; don't just patch the one confirmed case and
hope the other two are unrelated coincidences on the same day.

## Full diagnostic logs (already captured, don't re-run to reproduce first — read these)

- `.garden-state/deploy/candidate-gate-diagnostics/7070fc7e9c786255915e5f93cdc10455ec785d5b/02-scripts_jobs_test_signal-kill-classifier-test.sh.log`
- `.garden-state/deploy/candidate-gate-diagnostics/7070fc7e9c786255915e5f93cdc10455ec785d5b/04-scripts_jobs_test_retry-narrowing-test.sh.log`
- `.garden-state/deploy/candidate-gate-diagnostics/7070fc7e9c786255915e5f93cdc10455ec785d5b/09-scripts_jobs_test_provider-cooldown-test.sh.log`

(host-local on `endolin-garden-ece02cb4`, this host; if claimed elsewhere,
re-run the three suites locally against `main2` tip to reproduce — they
should fail identically, this is not a flake, it's failed reproducibly
across two different candidates two days apart.)

signal-kill-classifier-test.sh specifics worth noting: "handler sentinel
empty/absent", "job not left in doin (doin=n tada=n)", "no reap-now hint on
the doin claim", "doom-cycle counter NOT stamped on the requeued hinted
job" — 5/17 subtests fail. retry-narrowing-test.sh: "plain retry was
claimable before not-before", `awk: cannot open "jobs/doin/plain.md"`,
"retry policy decision ledger rows are missing or malformed" — 4/16
subtests fail.

## Fix

For the confirmed case: update `provider-cooldown-test.sh`'s fixture to use
a real subscription id (or a test-harness-recognized synthetic-but-allowed
marker, if one exists/should exist for hermetic tests specifically — check
whether the new admission gate has or needs a test-mode escape hatch
distinct from silently exempting real unknown-source traffic, which must
stay refused). Do NOT weaken the actual refusal gate's production behavior
to make the test pass — the gate protecting against silently-enabled
unknown token sources is exactly what the maintainer asked for; fix the
test's stale fixture, not the gate.

For the other two suites: trace to the actual root cause (likely the same
admission-gate change reached through `claim-job.sh`, per the above) and
fix precisely — again, fix test fixtures/harness setup that predates the
new gate, don't weaken the gate itself, unless you find a GENUINE bug in
the gate's own logic (not just a stale fixture), in which case fix that
and say so explicitly in your report.

## Verify and report

Full local test suite green, not just these three. Confirm which of the
two "unconfirmed" suites actually share the root cause with the confirmed
one, and which (if any) turn out to be unrelated — say so plainly either
way, don't just assume. This unblocks deploys on EVERY host once it lands
and rolls out — say that explicitly in your completion report so its
priority is clear to whoever reads it next.
