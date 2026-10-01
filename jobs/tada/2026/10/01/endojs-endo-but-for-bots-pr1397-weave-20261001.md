PR #1397 has been rebased onto a new pinned base and is mergeable again, and its gauntlet is running again from the `clean` stage.

**Where the PR was when I started.** GitHub already reported #1397 as `MERGEABLE`/`CLEAN` against its pinned base `build/sturdyref-captp-construct-14e9810`. An earlier rebase (head `0e0b333c19`) had cleared the original conflict. But the PR it's stacked on, #1396 (`build/sturdyref-captp-construct`), had moved two commits past that base, to `b0778fab75`. One of them, `95f2122c0a` ("scope SturdyRef data to the minting client"), conflicts with this PR. So I wove onto #1396's current tip.

**What I did:**
- **New pinned base:** pushed `build/sturdyref-captp-construct-b0778fa` at `b0778fab75`.
- **Rebase:** ran `git rebase --onto b0778fa 14e9810` on the PR's head. There was one conflict, in `packages/ocapn/src/client/sturdyrefs.js` inside `makeSturdyRefTracker`. I kept #1396's changes (the `minted` set that tracks which refs this tracker created, and `getDetails`). I also kept this PR's change, which moves the lookup code into a shared `lookupSwissnum` helper.
- **Scope check:** the diff against the new base is only this PR's three files (`.changeset/sturdyref-ocapn-enliven.md`, `sturdyrefs.js`, `test/sturdyref-enliven.test.js`).
- **Local checks:** all 572 `@endo/ocapn` tests pass, and the package's `tsc --noEmit` is clean. ESLint gives one warning (`safe-await-separator`, line 217), which comes from this PR's own code, not from my conflict fix.
- **Push:** force-pushed the head with a lease, from `0e0b333c19` to `1eb434a3e8`, and moved the PR's base to `build/sturdyref-captp-construct-b0778fa`. GitHub then reported `mergeable=MERGEABLE`.
- **Gauntlet:** ran `gauntlet.sh --resume-from-stage ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet clean`. The driver confirms it resumed at `clean` (iteration 0), and that stage is now in flight.

**Follow-ups:**
- If #1396 gets new commits again, this PR will need another weave.
- I hit the GitHub REST rate limit for this bot account while checking state; the GraphQL calls still worked.
- `yarn install` in the project checkout touched `packages/relay-server/src/index.js` without changing its contents. I reverted it and nothing stray was pushed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1397-weave-20261001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1304810 cached reads)
- Output: 7112 tokens
- Cost: $0.9023220000000002
- Wall-clock: 153s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
