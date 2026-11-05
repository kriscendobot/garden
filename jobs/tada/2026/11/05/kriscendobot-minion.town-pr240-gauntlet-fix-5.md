**Fix round 5, PR #240: all must-fix items are applied and pushed, and CI is green at `19050597`.** `ci-wait-merge` returned rc 0. The CI logs show the live-daemon and real-browser/Caddy suites ran and passed, including the new assertions; both skip locally on this host.

**Must-fix (decomplector 1 and 2), one locator grammar:**
- **Server:** `LOCATOR_SHAPE` and `isInvitationLocator` are gone from `capability-url.ts`. `isEndoLocator` now checks only the `endo://` scheme and the 4096-character limit, and `acceptLocal` still confines the locator's authority to this node. At the pinned Endo, the daemon's `parseLocator` and accept path do the rest of the validation.
- **Landing page:** `home.js` no longer has a copy of the grammar and treats a locator as opaque past its scheme. Only the fragment envelope is still parsed in both places, and a fixture table keeps the two in step; the differential property is removed.
- **Behaviour change:** a dead `endo://` link now reaches the accept card and reads as spent. It no longer gets the malformed notice, and a visitor with no guest gets one created first. The PR body and design doc record this.
- **Memory backend:** it now refuses non-invitation types, as the daemon does.
- **New test:** the live-daemon test checks that a wrong type, a bad or missing `from`, and an unknown number all return 404.

**Should-fix applied:**
- `localNode()` now keeps the first answer per connection, with a test (breaker 2).
- The misplaced `withoutHints` comment is fixed (breaker 3).
- All of the pruner's step-label comments are removed.

**Declined:**
- **Breaker 1 (refuse a foreign `fromNode`):** this would refuse every guest-minted locator, because a guest inviter's handle lives on its agent key. In the pinned daemon's `manager.js`, `fromNode` only names the correspondent's handle, and no route is written for it when the locator's authority is local. A code comment records this. Tests cover a foreign `fromNode` passing through, and the live test asserts that a real guest-minted locator carries a `fromNode` different from its host.
- **Decomplector 3 (separate locator route) and 4 (removal condition for `toEndoLocator`):** both are should-fix only and left as they are. A separate route would change the API, and the helper follows the maintainer's transition direction. The maintainer may want to decide these.

**Local tests:** `tsc` is clean and the full suite has one failure, `test/git-remote/capability.test.ts` ("propagates a git failure"). It is outside this diff, and CI's test workflow passed, but I didn't diagnose why it fails on this host.

Commits are `e27f303b` and `19050597`. I also updated the PR body's risks section.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr240-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1990688 cached reads)
- Output: 27575 tokens
- Cost: $1.9902456
- Wall-clock: 803s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
