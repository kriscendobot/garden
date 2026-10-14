Clean stage done for kriscendobot/garden-book PR #15 ("Replace procedural plates with OpenAI illuminations"). I removed one leftover unused parameter, all tests pass, and the CI wait returned green — but only because this repo has no CI at all.

**What I did**
- Checked out the PR head (`kriscendobot/garden-book@garden-book-illuminations-republish-20261014`, starting at `bc42bef`) in an isolated project worktree.
- Coverage pass: `npm test` passes 59/59. The changed build code (`build/illuminations.mjs`, `build/tree-io.mjs` with its new `readBytes`/`writeBytes`, `build/node-tree.mjs`, `build/publish-book.mjs`, `build/assemble-book.mjs`, `build/render-book.mjs`) is covered by the updated tests. I found no gaps worth adding tests for.
- Dead-code sweep: switching from inline SVG to `<img>` left `illuminationFigure` in `build/render-book.mjs` with an unused `_source` parameter, so I removed it. The artwork lookup next to it still runs, and the build still fails if a plate's art is missing. I found nothing that still refers to the deleted SVGs or `generate-illuminations.mjs`. `inlineSvg` is still used by the equilibrium charts, and every `ratio-*` CSS class is still used.
- Committed and pushed `755ef9b` ("build: drop unused source parameter from illuminationFigure") with `safe-push-pr-head.sh` (bc42bef → 755ef9b). Tests still pass 59/59.

**CI**
- The repo has no Actions workflows, and no check runs are attached at `755ef9b`. A plain `ci-wait-merge.sh` would have polled an empty rollup until its deadline and returned "still pending".
- I reran it with `GARDEN_CI_ALLOW_NO_CHECKS=1` (the script's opt-in for repos without checks), and it returned rc 0, "CI GREEN" with total=0. The 59/59 local test run is the only real verification.

**Follow-ups**
- Later gauntlet stages on garden-book will need `GARDEN_CI_ALLOW_NO_CHECKS=1` too. The other option is adding a workflow to the repo that runs `npm test`.
- The PR is still a draft, as expected at this stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (840474 cached reads)
- Output: 3874 tokens
- Cost: $0.7709108000000001
- Wall-clock: 1238s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
