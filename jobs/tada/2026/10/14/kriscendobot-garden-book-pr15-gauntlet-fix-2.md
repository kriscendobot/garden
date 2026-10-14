# Gauntlet fix round 2: kriscendobot/garden-book PR #15

I applied all six must-fix items from the panel-2 verdict and pushed them to the PR head (`7ad6fef..c0ff773`). The CI wait returned green (rc 0), but this repo has no CI workflows at all, so no checks actually ran. I had to set `GARDEN_CI_ALLOW_NO_CHECKS=1` to get a green; without it the wait just sat on the empty rollup until I killed it after 590s.

## What changed (4 follow-up commits)

1. **The book can be published again (must-fix 1).**
   - **Plates:** I re-encoded the 25 plates from the 1200-pixel originals, which stay in git history at `340dba1`. They are now 480 pixels on the longest side, all at WebP quality 0.18. Together they are about 394 KB, down from 7.8 MB.
   - **Publish size:** the full edition now encodes to 1,943,167 bytes. The limit is 2,097,152, so there is about 150 KB to spare.
   - **Supporting edits:** I updated the image dimensions in `build/illuminations.mjs` and the size bounds in the illustrations test.
   - **Quality cost:** the plates are visibly softer on high-resolution desktop screens. At 1x they look acceptable in the screenshots I checked.
2. **The size guard measures the real request body (must-fix 2).**
   - **What it measures now:** `publishRequestBytes` in `build/publish-book.mjs` measures the full request as the minion bridge sends it. The bridge re-serializes with Python's `json.dumps`, which adds spaces after separators and escapes non-ASCII characters. I checked that the count matches Python byte for byte.
   - **New tests:** a clip exactly at the limit publishes, and one byte over is refused before anything is written. A third test pins the non-ASCII byte counting. A fourth builds the real book and fails if it no longer fits the limit.
3. **One browser check instead of two (must-fix 4).**
   - `tools/browser-check.mjs` now serves the built `out/` locally with the published site's security policy (CSP) and fails on any CSP violation.
   - I deleted `tools/illumination-check.mjs` and its copied helpers.
   - I also fixed the Chromium lookup so it finds the arm64 headless shell.
   - A test run with images blocked by the CSP failed every configuration, so the check catches what it should. The real CSP passes at phone and desktop widths in both light and dark.
4. **Docs (must-fix 3).** I reconciled `build/README.md` with what ships: the publish steps, the browser check, and the old SVG edition, now marked historical. I updated `art/illumination-redraw-evidence.md`, `art/MANIFEST.md` and `art/OPENAI-ILLUMINATIONS.md` to match.
5. **PR body (must-fix 5 and 6).** I cut it to essentials and added a note that `browser-check.mjs`'s browser-side code is covered by running the tool on a built edition, not by c8.

## Tests

Locally 62 of 63 tests pass. The failing one, `equilibrium.test.mjs` "analyze.mjs prints no journal or review prose…", fails because git refuses to commit in this host's temp directory ("dubious ownership"). I didn't touch that test and the failure isn't in the code: it passed on my first run.

## Follow-ups (not done)

- **Publish headroom:** there is about 150 KB to spare. If the book's text grows past that, the plates will need another squeeze; the new test will flag it. minion.town also plans to shrink the publish limit to about 64 KB, and in-band plates won't survive that.
- **Should-fix items left open:** publishing picks up stale `illumination-*.webp` files left in the output directory (for now the README says to build into a fresh directory). There are no escaping tests for alt text, and no test checks that each image's declared ratio matches its dimensions.
- **Setup note:** I created the bare clone `worktrees/kriscendobot-garden-book.git`, because the project-worktree script needed it and it didn't exist on this host.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (5286502 cached reads)
- Output: 30588 tokens
- Cost: $2.6989964
- Wall-clock: 1376s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
