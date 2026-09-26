Work complete. Here's my report.

---

## Completion report

**Job intent (dead-lettered pickup):** A new comment from @dckc on kriskowal/garden#29 gave concrete design direction on the in-flight PoC PR **kriscendobot/agoric-sdk#9** (promote the ymax contract vat to `critical` at chain upgrade). dckc asked for a **migration-less** approach — "not a schema change, merely a value change" — applied while processing `AG_COSMOS_INIT` in the upgrade case, mirroring core-proposals handling, with **all chainID decisions on the cosmos side** and none in JavaScript. I folded this into the PR and replied on the issue thread as instructed.

**What I did — reworked the prototype (commit `c69f782`, pushed to `garden29-promote-ymax-critical`):**
- **Dropped the v3→v4 SwingSet schema migration entirely.** Reverted `CURRENT_SCHEMA_VERSION` to `3`, removed the v4 `upgradeSwingset()` step, the directive key, and the schema-doc churn.
- **Replaced it with a version-less `applyVatOptionUpdates(kvStore, updates)` helper** (`packages/SwingSet/src/controller/upgradeSwingset.js`) that read-modify-writes `${vatID}.options` in place — idempotent, with the live/non-terminated/dynamic/`zcf`-contract guards preserved so a stale or mis-chained vatID fails loudly.
- **Applied it in `launch-chain.js`'s `AG_COSMOS_INIT` handler**, merging two channels like coreProposals: structured `upgradeDetails.vatOptionUpdates` (bulletproof) + parsed `upgradePlan.info.vatOptionUpdates` (flexible).
- **Moved all chain selection cosmos-side:** new `VatOptionUpdates` field on the `upgradeDetails` struct (`app.go`), populated per-chain in the upgrade handler under `switch ctx.ChainID()` (`upgrade.go`): `agoric-3→v288`, `agoricdev-25→v320`. JS makes no chainID decision.
- **Replaced the migration tests** with direct `applyVatOptionUpdates` coverage (in-place promotion with no `version` key; guards; idempotency; empty no-op).

**Verification:** JS files pass `node --check`. Go toolchain and yarn/xsnap are unavailable in the worktree, so `go build`/`go vet` and the ava tests were **not run** — same constraint the prior PoC noted; I flagged this in both replies. Go formatting checked by hand (gofmt unavailable).

**Replies posted (as kriscendobot):**
- Issue thread: https://github.com/kriskowal/garden/issues/29#issuecomment-4911446185
- PR review thread r3538524116 (which had explicitly asked "which vehicle do you prefer?"): https://github.com/kriscendobot/agoric-sdk/pull/9#discussion_r3541261377

**Open follow-ups (surfaced to the SwingSet team, not blocking):**
1. One design question left for their confirmation: applying the write in the `AG_COSMOS_INIT` handler lands it *after* `makeSwingsetController()` rather than at the pre-controller reboot point. I argued it's safe (`critical` is read fresh by `terminateVat`, no terminate runs during init, commits on the consensus key at `COMMIT_BLOCK`) and offered to thread it into `buildSwingset()` for strict pre-controller timing if they prefer.
2. Tests need a real fork-CI / toolchain run.
3. Structure named generally (`vatOptionUpdates: [{vatID, critical}]`) rather than critical-only — offered to narrow if preferred.

No garden-repo (`main2`) changes were needed; all work was on the agoric-sdk fork.
