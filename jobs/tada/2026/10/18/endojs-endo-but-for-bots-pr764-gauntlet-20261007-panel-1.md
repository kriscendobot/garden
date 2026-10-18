**Gauntlet panel round 1: endojs/endo-but-for-bots PR #764**

The panel ran and returned **must-fix**, but I couldn't post the review, so this round is marked `panel-error`.

**What I did**
- Made an isolated checkout of the PR head (`endojs/endo-but-for-bots`, branch `mirror/endo-2780-cache-globals`, head `02b806d2f4`, base `origin/master-2708cac`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh`. It exited 0 with disposition **must-fix**. All 33 seats returned ok, and the result is saved at `panel-runs/endojs-endo-but-for-bots-764/af7f6b1dca52.md`.
- Must-fix findings:
  1. The PR body doesn't follow the upstream template: all seven template headings are missing, and it adds two headings ("What it does", "Note") that aren't in it. This came from the deterministic check, with the integrator seat agreeing.
  2. `node-powers.js` still uses the global `URL` in `fakeFileURLToPath` and `fakePathToFileURL` (breaker).
  3. No test checks that the cached globals survive a global being replaced after import (prover).
- Should-fix findings:
  - Add a `@endo/compartment-mapper` patch changeset.
  - Either narrow the title to the three files covered, or extend the caching to the sibling files (`url.js`, `node-modules.js`, `search.js`) and the remaining bare globals.
  - Squash the `fixup!` commit into its parent.
  - Trim the PR body.
- Wrote a request-changes review: a summary followed by the full seat output, about 70 KB. The `gh` wrapper first refused it over a bare `#2780`; I changed that to `endojs/endo#2780`.

**Blocker**
- Posting the review failed with `addPullRequestReview` 403 "Resource not accessible by personal access token". This is the known limitation on host `oros-studio-garden-ce242c49`: the bot token has no pull-request write access on endojs. So the verdict was reached but is **not posted** on the PR.
- I'm marking the round `panel-error` so the driver re-posts it, ideally on an endolin host where the bot can post reviews. If the head is unchanged, the retry reuses the saved seat results instead of re-running them, as long as it can find the panel record (it is keyed by the worktree name, so another host may re-run the seats). The review body is at `scratch/tmpexec/pr764-panel1-review.md`; that file is local to this host.
- I added this occurrence to the `bot-pat-no-pr-write-endojs` memory note.

**Follow-ups**
- The lasting fix is to give the fleet's fine-grained token pull-request read and write on the endojs org.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr764-gauntlet-20261007-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1064566 cached reads)
- Output: 6128 tokens
- Cost: $0.8527931999999999
- Wall-clock: 273s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
