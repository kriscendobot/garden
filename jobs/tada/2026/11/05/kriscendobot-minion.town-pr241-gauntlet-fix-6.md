---
orchestration-failed: true
---
**Fix round 6 for kriscendobot/minion.town#241 is pushed at `1c13a03f3c9`, but CI failed before any test ran, so this stage reports failure.** `ci-wait-merge` returned rc 3 (RED), and I don't have CI evidence for or against the code.

## CI failure
- **What happened:** [run 41982686751](https://github.com/kriscendobot/minion.town/actions/runs/41982686751) failed in about 2 seconds with 0 steps and no runner. I reran it once and attempt 2 failed the same way.
- **Other runs:** a run on another PR (`design/api-key-agent-directory-authorization`) failed the same way at 06:44Z. Scheduled runs on `main` passed at 06:46Z and 06:58Z, the 06:46Z one on the self-hosted runner.
- **Likely cause:** this matches the Actions billing block on hosted runners, but that is unconfirmed. The oros PAT gets 403 on the annotations, so rc 5 can't fire here, and I did not use the billing marker.
- **Maintainer:** alerted through the bus, with the resume command: `scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr241-gauntlet panel --iteration 7`.

## What changed
All panel-6 findings are addressed, in commits `de998e71` and `1c13a03f3c9`, plus edits to the PR body.

| Seat | Fix |
| --- | --- |
| locksmith, decomplector | A frozen deployment is now built without a connect-link registry, child creation, responder minting or delegation minting. A new `ChildGuestDirectory` can only look up, list and remove. |
| breaker, purist | The tree-wide `teardownEpoch` is gone, and a frozen `create` can no longer call `provideChild`. |
| engine-realist | A frozen `create` refuses a name already being torn down, and both race orderings are tested. |
| corner-prober, fast-checker | Added a `pending: true` test and a fast-check property (`numRuns: 50`). |
| packager | The changeset is back to `minor`. |
| integrator | Frozen evidence moved to § Frozen onboarding, stated as unit evidence only. The ledger regained its missing opening marker and now accounts for phases 1–6, all as not-applicable. |
| scribe | Posted the [completion summary](https://github.com/kriscendobot/minion.town/pull/241#issuecomment-6651880125). |

- **Gate result:** `phase-evidence-gate.sh` now returns rc 10 (`attention`) instead of rc 20 (`blocked`), so the integrator seat still compares the ledger to the design.
- **Extra fix, not raised by the panel:** a frozen `create` that faulted while minting the agent removed an existing child that the freeze can't recreate. It now gives back only its quota slot, and a test covers this.

## Local verification
- **Typecheck:** clean.
- **Full vitest:** 1700 passed, 14 skipped, 1 failed. The failure is `test/git-remote/capability.test.ts` › *propagates a git failure rather than reporting the ref absent*. This PR doesn't touch that test or `src/git-remote`, but I didn't run it on the base branch, so its cause is unconfirmed.
- **Daemon integration test:** skipped locally, so `lookupChild` has only run against test doubles, including the bridge's fake host, not a real daemon. I added assertions to that test for CI to run.
- **Timeouts under load:** in an earlier combined run, `test/endo-guest-lockdown.test.ts` failed 4 tests under the default 5s timeout, including `expected 400 to be 401` and a log assertion. It passed alone with a 60s timeout, and in the full run with that timeout. That points to load, but it could flake if CI is slow.

## Follow-ups
- **Resuming:** CI needs to start jobs again, either by clearing billing or by switching `CI_RUNS_ON` to the self-hosted runner, which the oros PAT can't do. Then rerun the failed run and resume at panel 7.
- **Changeset bump:** an earlier panel's changeset-auditor asked for `major`, and panel 6's packager asked for `minor`, so panel 7 could flip it again. I followed the latest verdict and noted this on the PR.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr241-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (3560178 cached reads)
- Output: 54201 tokens
- Cost: $3.1519996
- Wall-clock: 2019s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
