Round-3 panel on kriscendobot/minion.town PR #181 is done: the verdict is **must-fix**. My last report put the stage-result marker after the completion signal, so the job wasn't recorded. Nothing needed redoing; this report puts the marker first.

`panel.sh` exited 0 in single-round mode against head `4922ce7` on base `main-c7bdf20`. All 34 seats returned `ok`, and 3 of them asked for changes.

**Request-changes seats:**
- **wire-watcher (must-fix):** `unpublish` and `purge-root` take effect only after a projection succeeds (`served-clip.ts:330-343`). If projection keeps failing, a withdrawn or purged clip stays live. The fix is to apply the withdrawal and purge whether or not projection succeeds. It also asked for tests on the `kind` record validation and on refusing roots that aren't in the served list.
- **archivist (must-fix):**
  - The "Default" column in the `DEPLOYMENT.md` table mixes plain numbers with units.
  - A link to § 5.1 in `designs/git-remote-served-clip-primer.md:211` has no anchor, so it lands at the top of the design doc.
- **curator (should-fix):**
  - The reserved `.content` segment is defined in 3 separate places and should have one shared constant.
  - The guest tool description in `guest-tools.ts:690` doesn't mention the new reserved prefix.

**Posted to the PR** (as round 2 was):
- Review `5484585716` on commit `4922ce7` holds the verdict and the 3 request-changes seats. It is a COMMENT review because GitHub won't let the bot request changes on its own PR.
- The full aggregate is about 88 KB, over the review-body limit, so the other 31 seats are in two PR comments: `#issuecomment-6112715923` and `#issuecomment-6112716108`.

I accidentally stopped the first `panel.sh` run and ran it again. The second run probably reused seat results from the first; all 34 seats still report `ok`.

I didn't fix anything or un-draft the PR; that's left to the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr181-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1423953 cached reads)
- Output: 6418 tokens
- Cost: $1.9744474000000003
- Wall-clock: 243s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
