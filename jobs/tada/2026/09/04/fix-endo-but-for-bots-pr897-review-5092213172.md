Clean tree, local and remote heads match at `33f85365fb`.

## Completion report

Job: address kriskowal review 5092213172 (CHANGES_REQUESTED) on endojs/endo-but-for-bots PR #897 (head `fix/mount-glorp-713-followup`).

**Ask B — rename `search.glorpFiles` → `search.glorp` (DONE).**
Renamed the native fused search-engine member everywhere it appears, exhaustively verified (`grep` for `glorpFiles` returns nothing across js/ts/md and rust/json):
- `packages/platform/src/fs/search.js` — the `async function*`, its `harden`, the returned object member
- `packages/platform/src/fs/search-types.ts` — the interface member
- `packages/daemon/src/mount.js` — the `search.glorp !== undefined` dispatch, the `for await … search.glorp(` call, and both explanatory comments
- `packages/daemon/src/interfaces.js` + `packages/daemon/src/types.d.ts` — doc comments (reworded the types.d.ts sentence so "the mount's `glorp` dispatches to the engine's own `glorp` member" reads unambiguously)
- `packages/daemon/test/mount-glorp.test.js` — title, comments, mock member, assertions

Committed as `33f85365fb`, pushed to the fork PR head branch with `--force-with-lease`. Verified: daemon glorp/glob/grep tests (28 passed), platform search tests (11 passed), prettier clean on all touched files. Replied on thread 3916294319 citing the SHA.

**Ask A — remove the `entry` wrapper (deliberately deferred to a maintainer decision, per the job's judgment clause).**
Investigation showed `mount.entry()` is the **sole public minter** of `EndoMountEntry`, which the Git kit (`@endo/exo-git`) consumes as a **lineage-verified path capability** — `GitPathDesignator = string | PathEntry`, the Git `entries` option, and `git.js`'s internal string→entry resolution (`designatorsToRepoPaths` → `E(mount).entry(...)`). The `entry`/`EndoMountEntry` machinery predates this PR (it's in the `llm` base; this PR only added its help.md docs), and ~60 tests across the mount/git/endo suites construct paths via `mount.entry(...)`. Removing it therefore retires a whole cross-package capability, not a superfluous wrapper. Following the job's explicit "if removal entails a broader interface decision, reply with the specific question rather than force a risky change" guidance, I replied on thread 3916247285 asking kriskowal to confirm scope (full `EndoMountEntry`/`PathEntry` retirement vs. something narrower) and left `entry` in place. Also surfaced this to the maintainer over the message bus.

**Design-ask thread 3916282675** — posted a one-line acknowledgment pointing at the existing garden job `design-endo-but-for-bots-eliminate-single-segment-petname-paths`; not attempted here.

Also posted a top-level PR summary comment mapping all three items to outcomes. Reply bodies were passed via `--field body=@file`; verified backticks/inline-code survived intact on the Ask A reply.

**Follow-ups:** PR #897 still carries CHANGES_REQUESTED and is blocked on kriskowal's scope decision for the `entry`-removal question before Ask A can be executed (likely a separate fix job once he answers).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endo-but-for-bots-pr897-review-5092213172.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 154 tokens (6105344 cached reads)
- Output: 34977 tokens
- Cost: $4.555077000000001
- Wall-clock: 688s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
