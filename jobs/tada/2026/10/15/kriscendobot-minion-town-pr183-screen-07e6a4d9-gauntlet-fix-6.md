## Gauntlet FIX round 6: kriscendobot/minion.town#183

I fixed both of round 16's must-fix items and some of the cheap should-fixes, then pushed. CI is green: `ci-wait-merge.sh` returned rc 0, with 3/3 checks passing and none failing.

**Must-fix items from round 16 (review 5531097168)**
- **archivist #1:** `DEPLOYMENT.md` said the token is stored through `@secrets/create`, which doesn't exist in the code. It now names the method the vault actually calls: `createBase64` on the root's `@secrets`.
- **migrator #1** (the facet break wasn't announced): I rewrote the "Breaking change" section of the PR description. It now says on purpose that facet-minted agents answer `needs-containment` instead of `ok`, and lists each caller that breaks:
  - the inbox responder caplet, including children restored from a saved `ChildRecord`
  - the inbox watch
  - the by-name `infer` behind `/_internal/claude/infer`
  - anyone holding an agent from `createClaudeAgent` or `adopt`

  The same section notes that the credential migration can't be rolled back. I folded the separate "New required handle member" section into it, as integrator #5 suggested. The "Containment refusal" bullet in `DEPLOYMENT.md` already announced the break, so that file needed no change for this item.

**Should-fix items also done**
- **wire-watcher #2:** `readLive` and `readSecret` now count a secret as live only when its catalog state is exactly `"active"`, which is the same test `putSecret` uses. Before, anything other than `"revoked"` counted as live, so a missing or unknown state did too. The log line now prints the actual state. I added a test where an `"expired"` entry reads as `needs-auth`.
- **archivist #2/#3:** I rewrapped the `credentials.ts` header so it describes the deployed store (token in `@secrets`, only token-free state on disk).
- **pruner #2, #3, #6:** I cut a field comment that just restated `storedAt` (kept the unit), a duplicate `findEntry` comment, and a test comment that repeated its assertion.

**Checks:** the vault tests pass (36/36) and `tsc --noEmit` is clean. Prettier isn't a CI gate here, and 15 files already fail it, so I didn't reformat anything. The fix is commit `ee31c6b`, pushed as a fast-forward with `safe-push-pr-head.sh` (`e376aae` → `ee31c6b`).

**Still open, for panel 7 to judge:**
- decomplector #2 / purist #2: the refusal is still enforced in two places.
- integrator #1: the 35 commits need regrouping.
- integrator #2: the live `CredentialVault` interface is still imported from the module marked legacy.
- wire-watcher #1: an old-format record could overwrite a different active secret.
- assessor #1: a missing `.catch` on `open.closed`.
- migrator #2: keeping a downgrade path for migrated credentials.

Each of these is a design or structural change, too big for this pass.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1729002 cached reads)
- Output: 8144 tokens
- Cost: $1.1253604
- Wall-clock: 970s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
