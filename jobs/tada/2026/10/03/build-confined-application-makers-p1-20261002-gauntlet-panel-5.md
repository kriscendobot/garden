I ran round 5 of the review panel on endojs/endo-but-for-bots PR #1417. The panel finished cleanly (exit 0) and the verdict is **must-fix**. I posted it as a review on the PR.

**How it ran.**
- I checked out the PR head (`e354acc765`, branch `llm-confined-application-makers-p1`) in a project worktree just for this job.
- The panel ran in single-round mode against the PR's pinned base (`e4fcd7b234`).
- All 33 seats returned a verdict, with no seat errors: 1 request-changes (warden), 17 comment-only, 15 approve. The run record is at `panel-runs/endojs-endo-but-for-bots-1417/33431f0ddfb1.md` on the journal.

**What was found.**
- **Round 4's must-fix items are closed:** `makeTreeReadPowers` now documents its return value, and the `tree` parameter is documented as a read-only tree.
- **One new must-fix (warden):** `toSegments` builds a path-segment array that is passed to `E(tree).lookup` without being frozen.
  - Against a remote tree such as `mount.readOnly()`, every `read` and `maybeRead` will throw, because CapTP refuses to send unfrozen arrays.
  - Against a same-vat tree, the tree could change the array after it was checked.
  - CI misses this because the tests use only same-vat wrappers. The fix is to freeze that array and add a test that goes through a CapTP loopback.
- **Ten should-fix items, summarized in the review:**
  - A raw lone surrogate is accepted by some functions and refused by others.
  - Raw tab, LF and CR are accepted in a path, so one location can name two different files.
  - Two separator checks have no test that fails without them.
  - Empty segments are handled two ways.
  - A published type depends on a dev-only dependency.
  - The confinement check duplicates `isPathWithin`.
  - A third rule decides file versus directory.
  - A lookup miss over CapTP costs several sequential round trips.
  - The "matches Node" escaping claim is only checked on Node 22 and 24.
  - The commits need regrouping before un-draft.

**The posted review.**
- GitHub refused a request-changes review because the bot opened this PR, so the review was posted as COMMENTED (review id 5402420023, on `e354acc765`). This matches how round 4 was posted.
- The body has the summary plus the marker `<!-- garden-panel-verdict: round=5 disposition=must-fix job=… -->`.
- The full per-seat write-ups (80 KB) are too large for a GitHub review, so they stay in the panel's run directory. The review says so.
- During the review, a seat's temporary test edit to the shared checkout was briefly visible. It is not part of the PR, the checkout was clean when the panel finished, and the review notes this.

I made no garden repo changes. As instructed, I did not fix anything or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p1-20261002-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 30 tokens (856744 cached reads)
- Output: 7005 tokens
- Cost: $0.8564727999999999
- Wall-clock: 460s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
