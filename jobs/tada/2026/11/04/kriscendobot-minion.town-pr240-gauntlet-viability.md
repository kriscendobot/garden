**Verdict: proceed.** PR #240 is open, still a draft, and nothing has replaced it. The need it addresses still exists on the base branch.

**PR state:** the head is `46ca5fda2c`. The base `main-9196892` is identical to current `main` (0 ahead, 0 behind). There are no reviews or comments, and it was opened today at 02:10Z.

Deciding question: Does current `main`, or any other open or merged PR, already give minion.town an https link form with the action in the path and the secret in the fragment, making #240 redundant? No, so the PR is not superseded and the need still holds.

Evidence:
- **Not on the base branch:**
  - `src/web/capability-url.ts` returns 404 on `main`.
  - Caddy has only `handle /`, with no `/accept` or `/adopt` route.
  - The latest `main` commit is the #234 merge (2026-11-03), which is the commit #240 is pinned to.
- **#239 overlaps but doesn't replace it:** #239 (draft, same base) adds `{ locator }` to the accept route and reads `/#v=1&locator=` on `/`. It has no grammar module, no path-based action and no Caddy change. It also leaves `invite` link minting alone.
- **#170 doesn't replace it:** this stale draft (last updated 2026-10-09) covers scrubbing and encrypting fragments through a bootstrap document, and keeps existing `#v=1` links. #240 leaves encryption to a later `v=2`.
- **Removing tools doesn't undercut it:** `build-minion-town-tool-removal-20261104` could remove the `invite` tool, but `evaluate`-minted invitations still need a link a browser can open. That is step 2 of the successor job.
- **The work is still active:** `build-minion-town-https-locators-proof-20261104` is in `jobs/todo` to finish this same branch.
- **Gap in the evidence:** I did not find the maintainer's original request in the journal, and the part of tracker #227 I read doesn't mention https locators. The need rests on the job chain and the code on `main`, not on a directive I could cite.

Risks for the gauntlet (nothing changed or posted):
1. **Same-branch collision:** the successor job pushes to `feat/https-capability-urls` while the gauntlet would be cleaning and fixing that branch. The panel would also review a slice the PR itself calls partial, with no `/adopt` page and no Playwright proof. Running the successor first, or holding this gauntlet until it finishes, would avoid wasted rounds.
2. **Conflict with #239:** both PRs edit the `home.js` fragment parsing and add a `locator=` form, on `/` in #239 and `/accept` in #240. Whichever lands second must reconcile them, and the successor's `locator=` handling should reuse #239's accept route.
3. **Possible duplicate work on `evaluate`:** #240's message about this to the tool-minimalism job was dead-lettered, because that job had already finished. Whichever job picks that message up could duplicate step 2.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr240-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (367185 cached reads)
- Output: 5345 tokens
- Cost: $0.669505
- Wall-clock: 150s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
