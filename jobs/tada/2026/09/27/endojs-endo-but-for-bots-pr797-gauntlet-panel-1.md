I ran panel round 1 on endojs/endo-but-for-bots PR #797 ("design(daemon): Git-over-HTTP content data plane"). The verdict is **must-fix**, and it is posted on the PR.

**What I did**
- **Checkout:** made a separate checkout of the PR head (`endojs/endo-but-for-bots`, branch `design/endo-content-plane-git-http`, head `5635aefd20`) at `/home/kris/garden/scratch/project-wt-endojs--b9dde1db79bc-db7dd0f6`. The PR's diff is one file, `designs/endo-content-plane-git-http.md` (452 lines added).
- **Panel run:** ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh` against the PR's real merge-base `b43e801633`. It exited 0 and its last line was `design-panel single-round — must-fix`. Nine seats reviewed: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice, orthographer and thesaurus. Four asked for changes (critic, skeptic, ergonomist, copyeditor), the decomplector left comments only, and the novice and orthographer approved.
- **Review posted:** https://github.com/endojs/endo-but-for-bots/pull/797#pullrequestreview-5328846482. GitHub would not accept a request-changes review because the bot opened this PR, so it went up as a comment review instead. It has a "must-fix" header, the full combined panel output, and the marker `<!-- garden-panel-verdict: must-fix round=1 ... -->`.

**Main must-fix findings for the fix stage**
- **Dependency described as landed:** the design says the web-seed plane (#792) and `http-content-plane.js` have landed, but neither is in this PR's base.
- **Self-contradiction:** it claims to change no existing plane, yet it proposes changing `getPlaneForSource` to take `(letter, payload)`, and that function sits on the shared lookup path in `manager.js`.
- **Choosing a plane by prefix check and order:** it reuses `xs` and picks the plane by testing the payload's prefix, so the result depends on the order planes were registered. Seats also want the served `ref` pinned to a commit.
- **Sketched code inconsistent with itself and existing names:** `source(hash, …)` and `fetch(hint, hash, …)` order parameters differently, `sourcePlanes` is not in the existing type, and `serveTree` vs `fetchContent` don't follow the same naming.
- **Prose and style:** a doubled "design" in the preamble, more than 20 em-dashes, Unicode arrows, "analogue" should be "analog", and one heading is in sentence case.

**Follow-ups**
- The next stage (fix) owns these findings. I made no fixes, left the PR in draft, and changed nothing on garden main2.
- Because the posted review is a comment rather than a request-changes review, whatever decides the next stage needs to read the verdict from the review text or its marker.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr797-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 2 host(s)
- Input: 20 tokens (647497 cached reads)
- Output: 3369 tokens
- Cost: $0.7359914000000001
- Wall-clock: 379s
- Model(s): claude-opus-4-8 ×7, claude-opus-5-5 ×1

<!-- garden-usage-end -->
