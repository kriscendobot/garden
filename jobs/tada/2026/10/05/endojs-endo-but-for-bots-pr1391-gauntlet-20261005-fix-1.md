**Fix round 1 for endojs/endo-but-for-bots#1391: done, CI green on new head `1730228a7b` (previous head `14381fc8f5`).**

I pushed two follow-up commits with `safe-push-pr-head.sh`, which only adds commits and doesn't rewrite history.

**Panel must-fix items:**
- **packager / integrator (unrelated daemon changes):** commit `0ebeab85eb` puts `packages/daemon/test/_orphan-daemon-launcher.js` and `daemon-teardown.test.js` back to how they are on the base branch. That backs out the three earlier `test(daemon)` commits. The macOS flake those commits were chasing is already fixed on `llm` by 892683f957 (`fix(daemon): record endo.pid before signalling ready`). This PR's frozen base predates that fix, so the PR picks it up at its next weave.
- **saboteur #1 (bare `catch {}` in the launcher):** no longer applies, because that file is no longer in the diff.
- **spec-keeper #1 (tests matched engine-specific error text):** commit `1730228a7b` changes `global-locked-universal`, `sturdyref-misshapen` and `sturdyref-writable` to check only for `TypeError`. This follows the existing `tame-domains-after-lockdown.test.js`. The three tests pass locally and eslint is clean on them.
- **pruner (PR body too long):** I cut the body from 401 to about 190 words. The template headings are all still there; the stack tour is now two sentences and Testing is one sentence.

**CI:** `ci-wait-merge` first came back red (rc 3) on `cover (24.x, ubuntu-latest)`. The failure was a randomized property test in `@endo/patterns` (`copySet › setIsSuperset`, seed -632459506, `-0` counterexample), which this diff doesn't touch. Every other check passed, including both macOS legs, so I treated it as a flake, reran the failed job, and the second wait returned rc 0: 24 checks passed, 9 skipped.

I posted a completion summary on the PR: https://github.com/endojs/endo-but-for-bots/pull/1391#issuecomment-5994147939

**Follow-ups:**
- The `copySet` test can apparently fail on a `-0` key with some random seeds. That points to a real bug in `@endo/patterns`, not just a test problem, and is worth its own job.
- Weaving this PR's base forward will bring in the daemon fix.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2387139 cached reads)
- Output: 11652 tokens
- Cost: $1.3904197999999999
- Wall-clock: 2766s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
