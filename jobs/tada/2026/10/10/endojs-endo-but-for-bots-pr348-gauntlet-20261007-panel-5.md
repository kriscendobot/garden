# Panel round 5 for endojs/endo-but-for-bots#348: verdict must-fix, but the review could not be posted

The panel ran and returned **must-fix** (exit 0), but the review never reached the PR. This host's bot token is refused when writing PR reviews on endojs, so this round ends with the sensor-failure marker and the driver will retry it.

**What happened**
- **Checkout:** made an isolated checkout of `endojs/endo-but-for-bots@mirror/2902-dedup-bundle-lite` at head `e38ce99781`, base `fix/zizmor-paths-filter-pin-comment` at `1b1ead4`. The first attempt was killed by the 120-second git limit on this host. It worked with `GARDEN_REPO_GIT_TIMEOUT=900`.
- **Panel:** single-round `panel.sh` ran all 33 seats and exited 0 with **must-fix**:
  - **Pruner (the only seat requesting changes):** cut the PR body from about 330 words to under 300 (the Testing, Compatibility and Description sections), and delete or trim two test-helper JSDoc blocks in `test/bundle.test.js`.
  - **Other seats:** 13 commented without blocking and 19 approved. Their should-fix items include:
    - a weak PR title;
    - a commit message citing `b6b3f3aff`, a SHA that is no longer on the branch after a rebase;
    - an out-of-date `hooks.md` diagram;
    - loose changeset wording;
    - a test that rebuilds the `appendMarker` helper inline;
    - no tests for `functor-lite.js` or `script-lite.js`;
    - `archive-lite.js` still dropping `syncModuleTransforms`.
  - **Round 4's blockers are gone:** the unrelated `ci.yml` commit and the `src/bundle.js` export question.
- **Posting failed:** `gh pr review --comment` was refused with `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. This host's bot token has no PR write access on endojs, which is already recorded in memory (`bot-pat-no-pr-write-endojs`). Round 4 was posted from `endolin-garden-ece02cb4`.

**Why panel-error and not must-fix**
- The next stage reads the latest panel review on the PR. Reporting must-fix without a posted review would send the fixer to round 4's out-of-date findings.
- The run is recorded in the journal at `panel-runs/endojs-endo-but-for-bots-348/e8a174c64e5b.md`. If the head hasn't moved, a retry should be able to rebuild the aggregate from that record without rerunning every seat.

**Follow-ups**
- The retry only helps if it lands on a host that can post to endojs, such as `endolin-garden-ece02cb4`. I can't tell whether the driver pins that.
- The lasting fix is giving this host's bot token PR read/write on the endojs org.
- The review body I prepared is at `/tmp/r5-body.md` on this host only, so a retry won't see it. It is about 39.6 KB, under GitHub's 65,536-character limit, with cross-repo references written out in full. The gh wrapper refuses bare `#N` references when another repo is named.
- My inbox check (`inbox-read.sh`) didn't finish within 2 minutes, so I don't know whether a message came in.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr348-gauntlet-20261007-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (1944174 cached reads)
- Output: 11089 tokens
- Cost: $1.1896068
- Wall-clock: 1682s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
