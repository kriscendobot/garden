**Clean stage done for kriscendobot/garden-book PR #16** ("Colophon: move how-the-book-was-made marginalia and prose into back matter"). I pushed nothing. The PR is a draft at head `fe9ece3`, and its base is the frozen branch `main-51f6c5d`.

**Coverage.** I worked in an isolated checkout of `kriscendobot/garden-book@garden-book-colophon-20261016`.
- `npm test`: 85 passed, 0 failed, 1 skipped (86 total).
- `node --test --experimental-test-coverage`:
  - `build/assemble-book.mjs` is fully covered (100% lines, branches and functions).
  - `build/render-book.mjs` is at 99.58% lines and 92.75% branches. Its only uncovered lines (103–104, 114, in `elementEnd`) are older code this PR doesn't touch.
  - The new code is exercised by the updated tests in `test/units.test.mjs` and `test/build.test.mjs`: the colophon replaces the provenance margin notes, the `{{PROVENANCE}}` table, the "Back matter" contents entries, and the removed `<footer>`. The illuminations test covers the no-colophon path.

**Dead code.** Nothing was left behind. No CSS still targets `marginnote provenance` or `footer`, and nothing in `tools/` refers to them. The PR already deletes the old footer CSS rule and the per-chapter provenance code.

**CI.** This repo has no GitHub Actions workflows (0 workflows, and the merged PRs #13–15 have no checks either), so the check list never fills in.
- The first `ci-wait-merge.sh --no-merge` run, without the opt-in, kept polling an empty check list. It would only have ended with still-pending (rc 4) at the deadline, so I stopped it.
- I re-ran it with `GARDEN_CI_ALLOW_NO_CHECKS=1`, the script's setting for repos with no checks, as the PR #15 clean stage did. It returned rc 0, "CI GREEN" with total=0.
- That green is a formality: the local test run above is the only real verification.

**Follow-up:** every garden-book gauntlet stage will need `GARDEN_CI_ALLOW_NO_CHECKS=1` until the repo gets a workflow that runs `npm test`. Adding one would give these stages real CI.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr16-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (705043 cached reads)
- Output: 3673 tokens
- Cost: $0.6400845999999999
- Wall-clock: 687s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
