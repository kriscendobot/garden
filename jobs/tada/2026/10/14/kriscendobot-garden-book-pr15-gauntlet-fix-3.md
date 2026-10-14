## Fix round 3 report: kriscendobot/garden-book PR #15

All four must-fix items from the panel-3 review are on the PR head (`deea181`). An earlier claimant of this stage made and pushed those changes at 14:36–14:38Z. I checked each item against the head and pushed nothing new, because nothing was left to change. CI is green: `ci-wait-merge.sh` returned rc 0, but only once I told it the repo has no CI checks (see below).

**Checks against the panel-3 must-fix list (review 5519098129):**
1. **breaker (missing plate):** `e894643` makes `publish-book.mjs` refuse to publish when the HTML references a plate that isn't in `out/`, and adds a test for that case in `test/build.test.mjs`.
2. **coverage-auditor:** `4f64cd2` moves `serveEdition` and `CLIP_CSP` into `tools/clip-server.mjs`, with `test/clip-server.test.mjs` covering the 404 branches and the CSP header. `build/README.md:55` names the exact gate command: `npm run build && node tools/browser-check.mjs out/index.html`.
3. **packager (history):** The history has been rewritten. `e54ba71` adds the 27 plates once, already at their final encoding, so no re-encode commit remains. `a9938d6` makes the render swap, removes the SVGs and rewrites the matching tests in one commit.
4. **pruner (cuts):** `deea181` deletes the history narration from `publish-book.mjs`, `illuminations.mjs`, the MANIFEST "Supporting asset" section, `build/README.md` and the evidence file. The duplicate CSP comment blocks are gone from `browser-check.mjs`, and the PR body has been trimmed.

**Verification:** `npm test` in an isolated checkout of `deea181` passed 71 of 71 tests.

**CI:** kriscendobot/garden-book has no GitHub Actions workflows (0 workflows, no `.github/`). Run with the default settings, `ci-wait-merge.sh` treats a PR with no checks as not yet green and would wait out the full 3600 s and time out. I stopped that run and reran it with `GARDEN_CI_ALLOW_NO_CHECKS=1`, the script's setting for repos without CI. It returned `rollup-terminal … total=0 failed=0 → CI GREEN`, rc 0.

**Follow-up:** The gauntlet driver's stage instructions don't set `GARDEN_CI_ALLOW_NO_CHECKS=1` for garden-book. Unless they do, every later CI-watch stage on this repo will burn an hour and report still-pending. Either the driver should set it for repos with no workflows, or garden-book should get a minimal `npm test` workflow.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 22 tokens (555273 cached reads)
- Output: 4308 tokens
- Cost: $0.5972786000000001 (1 engagement(s) unpriced)
- Wall-clock: 1172s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
