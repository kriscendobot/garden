# Gauntlet FIX round 2 — kriscendobot/minion.town#216

I fixed all three must-fix items, pushed them to the PR head (`e4b699e3..201f52b3`), and CI is green: `ci-wait-merge` returned 0 with 2/2 Actions runs passing. Locally, typecheck passes and the suite passes except one host-only test failure, described under Verification.

No pre-pass block came with this job, so I worked from the latest panel review on the PR (03:59:46Z, comment review headed "Must-fix before merge").

## Must-fix items
- **migrator #1** — the API now accepts a guest credential only while the daemon names its agent `web-<uuid>-agent`, and only a runbook step guarded against locking guests out. Commit `201f52b3` (`fix(deploy)`) makes `deploy-app.sh` run that audit on the box before it promotes the artifact:
  - The deploy is refused while any `web-<uuid>` handle has no `-agent` name.
  - `ACCEPT_UNREACHABLE_GUESTS=1` lets the operator accept the loss and deploy anyway.
  - If the daemon's names can't be listed, the deploy stops.
  - A box with no daemon socket passes, since it has no guests to lock out.
  - `DEPLOYMENT.md` now describes the gate, and the new `test/deploy-guest-credential-gate.test.ts` covers each branch (7 tests).
- **duality-auditor #1** — commit `4419973e` renames `unbondGuest` to `closeGuestBonds` across src and tests. The doc now says the call is terminal and that `unbondIdentity` is the real inverse of `bondGuest`. The same commit also:
  - fixes the docs that still claimed an atomic close-and-read (breaker #2, a should-fix);
  - drops the "Phase C" comment clause (pruner #2).
- **integrator #1** — I rewrote the PR body. It now opens with what #200 does, then lists each commit and names both production defects (the bare reserved word `sub`, and the `ALL_NEW` return that IAM refuses). It also takes the pruner's cuts. The `garden-job` marker is kept.

The scribe asked for a completion summary, which I posted: https://github.com/kriscendobot/minion.town/pull/216#issuecomment-6332943412

## Verification
- `npm run typecheck` passes.
- `npm test` passes 1489 tests with 1 failure: `test/git-remote/capability.test.ts`. That test passes 41/41 with system git, so the failure comes from the fleet's git wrapper on this host, not from the PR.

## Not addressed in this round
These were should-fix or comment-only, so I left them for panel-3 or the maintainer to decide:
- breaker #1: purge again after the handles are cut.
- locksmith #2 and #3.
- the ledger key-space and `PutItem` hardening items.
- pruner #3 to #6: cutting test comments.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr216-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (3464432 cached reads)
- Output: 18369 tokens
- Cost: $1.8549304000000002
- Wall-clock: 1580s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
