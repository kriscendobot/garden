Fix round 3 for kriscendobot/minion.town PR #200 was already done and pushed by an earlier claimant of this job, so I pushed nothing new. I read the panel-3 review and the "Fix round 3" comment on the PR. The comment lists every must-fix item as applied, in `f6a927c`, `333d531` and `f26ce02`. The head is `f26ce020`.

- **Applied:**
  - Durable tombstone and audit appends, with fsync of the file and of the directory on creation.
  - A malformed tombstone line now fails the load with file and line.
  - Bond-versus-deletion race handling: the tombstone is re-checked after a bond lands, and a strongly consistent `unbondIdentity` removes bonds the index missed.
  - Bond administration moved to a `GuestBondAdmin` facet that only the guest router receives.
  - The client requires and submits the exact typed confirmation.
  - A `createApp` + `STATE_DIRECTORY` integration test that a deletion stays refused after the app is rebuilt.
  - Production startup refuses to run without the fingerprint index.
  - Design prose updated for the settings menu and deletion contract.
  - `cmd` and `dir` spelled out in two tests.
- **Not applied:** the purist's `@endo/sha256`/`@endo/hex` swap. It was a should-fix, and those packages are unpublished here.
- **CI:** `ci-wait-merge.sh` returned rc 0, with all 3 checks passing at `f26ce020`.

The driver can re-post panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 188 tokens (9667827 cached reads)
- Output: 56536 tokens
- Cost: $4.4728418
- Wall-clock: 8430s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
