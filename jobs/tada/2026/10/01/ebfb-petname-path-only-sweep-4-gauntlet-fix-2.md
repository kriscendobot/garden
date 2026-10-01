# Fix round 2: endojs/endo-but-for-bots PR #1390

I applied the must-fix items from round 2 of the panel (review 5372723946) and pushed them to `build/pet-name-path-only`. CI is green on the current head `15f46bb218`, but only after I reran one failed leg; that head includes a peer job's later commits.

**Must-fix items:**
1. **`@endo/lal` bump:** no change needed. Head `082a97a1ee` already had `minor` (`f65b1bd9ae`). A peer job later raised it to `major` (`ae16de9b74`), following a different panel's verdict.
2. **Changeset front-matter:** added `@endo/endo-fs-exec`, `@endo/exo-zip`, `@endo/host-shell` and `@endo/space-floot` as `patch` (`4a60faefbe`).
3. **Flaky property test:** the expected hint in `packages/daemon/test/pet-name.test.js` is now built with `q([s])`, the same way production builds it (`d81e517f42`).
4. **Share-modal lookup test:** all three `lookup` mocks in `packages/chat/test/component/share-modal.test.js` now take one argument and reject anything that is not an array. The submit test also checks that the lookup received `[['my-thread']]` (`560d3d72fa`). I reverted the source to `.lookup(channelPetName)` and the test failed; I then restored it.
5. **Stale JSDoc and dead branch:** in `code-mode-provision-host.js`, `credentialPetName` is now documented as `string[]`, and the `typeof remote.credential === 'string'` branch is removed (`d078919c6e`). The branch was unreachable: stored records are run through `validateEndoProvisionPersistence` before lookup, which turns a bare-string credential into an array.
6. **Comment naming a deleted type:** this was partly wrong. The `NameOrPathShape` it mentions is the one in `@endo/platform`, which still exists. I reworded the comment in `interfaces.js` to say which one it means (`e927a65aac`).

**Not done:** the two lesser items. I kept the "remaining packages adapt their calls" line in the changeset, and the `'Canceled'` note was comment-only.

**Verification:**
- **Local tests:** the daemon `pet-name` tests (49), the chat `share-modal` tests (4) and the agentry `code-mode-provision-*` tests (36, plus 1 todo) pass.
- **Lint and formatting:** prettier is clean after formatting, and eslint shows no errors.
- **Push:** `safe-push-pr-head.sh` advanced the branch from `082a97a1ee` to `e927a65aac`.

**CI:**
- **First run, red:** `ci-wait-merge` returned rc 3 because the `test (22.x, macos-15)` leg failed. All 1357 tests passed; it failed on one unhandled `Termination requested` rejection in daemon `test/endo.test.js`, which happens when the daemon shuts down.
- **Why I treated it as a flake:** none of my commits touch daemon runtime code, and the peer's only daemon runtime change behaves the same.
- **Rerun, green:** I reran the failed leg once and it passed. A second `ci-wait-merge` returned rc 0 with 33 of 33 checks passing.

**Follow-ups:**
- **Overlapping gauntlets:** two other gauntlets are working this PR at the same time. A peer job pushed `6b99d28298`..`15f46bb218` on top of my commits, and a different gauntlet's round-5 panel (review 5372775984) has its own must-fix list, including the `@endo/lal` major bump.
- **Possible flake:** the macOS daemon "Termination requested" failure is worth watching if it comes back.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-4-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (3794242 cached reads)
- Output: 14924 tokens
- Cost: $1.7780323999999994
- Wall-clock: 5321s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
