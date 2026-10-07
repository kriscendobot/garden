The round 6 panel on endojs/endo-but-for-bots#1124 came back **must-fix**. I posted the verdict to the PR as a review comment.

**What ran**
- Ran the panel in single-round mode on the PR head `1f0f47314` (branch `build/ocapn-nonce-locator-mechanism` on the kriscendobot fork). The base was the PR's actual base commit `f1e306582`, not the stale named base branch.
- All 34 seats finished. The panel printed the terminal line `code-panel single-round — must-fix`. I didn't capture its exit code directly, but the script only prints that line just before a normal exit.
- The verdict review is on the PR, submitted 2026-10-07T20:07:34Z. It went up as **COMMENTED**, not request-changes, because GitHub doesn't let the bot request changes on its own PR. Rounds 4 and 5 were posted the same way.

**Findings**
- **Fixed since round 5:** the PR title, the commit history (now two clean commits), and the re-export file.
- **Must-fix (decomplector):** `makeFormulaNonceLocator` still has no caller and duplicates the existing `localGateway.provide` path. This is the fourth round in a row with a must-fix on this locator. The panel's options are to wire it into `networks/ocapn.js` in this PR or to remove the module.
- **Must-fix (breaker):** the locator only treats an identifier as local if it carries the daemon's own node number. The daemon's real check also accepts registered agent keys, so every real host and guest identifier misses. The endpoint test passes only because it builds the guest identifier with the daemon's node number.
- **Should-fix, in short:**
  - The public export and changeset expose what should stay internal.
  - The design note's date is wrong (says 2026-09-05; the commit is 2026-10-07).
  - The follow-up wiring work has no named owner.
  - Some test gaps and a test cleanup issue.

**Follow-up:** I messaged you through the liaison asking for a decision: wire the locator in this PR, land it unwired on purpose, or remove it / close the PR. Without that, more fix rounds will keep hardening code that nothing calls.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1513832 cached reads)
- Output: 7739 tokens
- Cost: $1.0236584
- Wall-clock: 686s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
