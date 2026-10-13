## Fix round 6: kriscendobot/minion.town PR #180

I applied the round-6 panel's must-fix items in one commit, `8dfe189`, pushed it, and CI is green.

**Migrator (request-changes):**
- **1. Guests provisioned before this deploy never get `git`:** this was already handled, but nothing tested it. `provideGuest` runs the git endowment every time it is called, and `guestFacetFor` calls it each time a guest's facet is resolved. So an existing guest gets `git` the next time its facet is resolved.
  - Added a comment in `src/endo/root-host-socket.ts` saying so.
  - Added a unit test in `test/endo-root-host-socket.test.ts`: a guest is provisioned without git, then provided again with git, and ends up bound.
  - Added a step to the pinned-daemon integration test (`test/endo-daemon-integration.test.ts`): ALICE's facet is resolved without git first, and the test checks `git` is absent before the git-enabled path runs.
- **2. Deploy order:** CD runs `deploy-app.sh` before `deploy-git-remote.sh`, so on a fresh host `minion-mcp` starts without the secret. `deploy-git-remote.sh` now runs `systemctl try-restart minion-mcp.service` when it first creates `control.env`. DEPLOYMENT.md states the order.
- **3. The control secret can't be rotated:** I documented it in DEPLOYMENT.md rather than adding a key-version prefix. Rotating is manual and invalidates every partition guests already hold; each guest's next facet resolution gives it `git` again under the new secret.

**Scribe:** posted a completion summary for head `8dfe189` (https://github.com/kriscendobot/minion.town/pull/180#issuecomment-6136698565). It maps each finding from rounds 4, 5 and 6 to its commit and says it replaces the earlier summary that declined the `isRecord` change.

**Pruner:** edited the PR body. The "Two docs stay as written" section is gone, Verification is cut to the regression note, and the body now mentions the per-owner partition cap, the rejection of owners containing NUL, and the backfill for pre-existing guests.

**Checks:**
- **Local:** `tsc` is clean. The new and nearby tests pass except `capability.test.ts > projectPartition > propagates a git failure…`, which fails locally. This round didn't touch that code, and I didn't confirm whether it also fails on the previous head.
- **CI:** green (`ci-wait-merge` rc 0). The first attempt came back red only because the live-daemon B1 step was cancelled after 41s on an ephemeral runner, with no failed assertions. I re-ran the failed job and it passed, including the new integration step.

**Follow-ups:** none. The driver re-posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3219949 cached reads)
- Output: 14409 tokens
- Cost: $1.6491937999999995
- Wall-clock: 1976s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
