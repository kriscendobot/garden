The job is complete. Inbox is empty and the garden worktree is clean (this was a project-repo job on the agoric-sdk fork, so no `main2` push was needed).

## Completion report

**Job:** Dead-lettered pickup of a maintainer comment on kriskowal/garden#29 (originally addressed to the completed `issue-kriskowal-garden-29`). @mhofman asked to *prototype a cosmos upgrade that marks the running ymax contract vat (`v288`/ymax1 on agoric-3, `v320`/ymax0 on agoricdev-25) as `critical`*, with chain-specific upgrade logic and possibly an a3p test.

**What I did**
- Investigated the full issue thread and mapped the agoric-sdk upgrade machinery (Go upgrade handlers, `upgradeSwingset` schema migrations, vat-options kvStore surgery, dynamic-vat naming) via two Explore agents.
- Built the prototype on an isolated worktree of the maintainer-authorized `kriscendobot/agoric-sdk` fork and opened **draft PR kriscendobot/agoric-sdk#9** (branch `garden29-promote-ymax-critical`, base `master`).
- Replied on the issue thread: https://github.com/kriskowal/garden/issues/29#issuecomment-4900643943 (issue **not** closed).

**What changed (in the fork PR)**
- `packages/SwingSet/src/controller/upgradeSwingset.js` — new `version < 4` migration step promoting live ymax contract vats to `critical` in place, matched by `options.name` label (`-ymax0`/`-ymax1`) rather than a hardcoded vatID, skipping terminated incarnations; exported `CRITICAL_PROMOTION_LABELS`.
- `packages/SwingSet/src/kernel/state/kernelKeeper.js` — `CURRENT_SCHEMA_VERSION` 3→4 + schema-doc updates.
- `packages/SwingSet/test/upgrade-swingset.test.js` — new v4 promotion test (live promoted; terminated + unrelated untouched; idempotent) + v3 "DB too old" refusal test + version fixups.
- `packages/SwingSet/test/state.test.js` — schema-version fixups (3→4).
- `golang/cosmos/app/upgrade.go` — `switch ctx.ChainID()` recording the expected per-chain promotion target, mirroring the `terminationTargets` precedent (`3658973b8`) mhofman cited.

**Design rationale (in PR + reply):** the write can't be a core-eval (can't reach kernel kvStore) and no runtime path flips `critical` on a running vat, so it rides kernel-side as a schema migration on the upgrade binary; label-matching removes the need to know the vatID (directly answering mhofman's "I don't know the vatID"). Confirmed #9157 is irrelevant per mhofman's reasoning.

**Verification / caveats**
- All modified JS passes `node --check`; the diff was reviewed for correctness. **Unit tests were written but not executed** — the fork has no `yarn`/xsnap toolchain in this environment; fork CI / the SwingSet team runs the suite. Go toolchain also unavailable, so `upgrade.go` was reviewed by hand (no gofmt/build).

**Follow-ups (raised as open questions for the SwingSet team in the PR):** schema-version-bump vs. another one-shot vehicle; label-match vs. a pinned per-chain vatID (mainnet stale-ymax0 edge case); fresh-chain scope; and the preferred query path for an a3p test asserting `critical === true` post-upgrade (vat options aren't in vstorage).
