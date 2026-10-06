## Panel round 1: endojs/endo-but-for-bots#1428, verdict must-fix

I ran one panel round on PR #1428, "chore: get upstream master 356d6e7 CI green". `panel.sh` finished successfully with **must-fix** and I posted the result to the PR. I didn't make any fixes and didn't un-draft the PR.

**How it ran:** I reviewed the PR head `e1279b7939` (branch `endojs/fix-upstream-master-ci`) in its own isolated checkout. I compared it against the base SHA `356d6e70af`, since the PR's base branch is the frozen `master-356d6e7`. All 33 seats ran without error.

**Seat results:**
- **Request-changes:** saboteur, prover, pruner.
- **Comment-only:** locksmith, corner-prober, fast-checker, coverage-auditor.
- **Approve:** the other 26.

**Findings:**
1. **saboteur (the must-fix):** `-e node_modules` doesn't stop `git clean -X` from deleting `node_modules`. The seat reproduced this. The fix is the negated form `-e '!node_modules'`, which the PR already uses for `.yarn/install-state.gz`. It's needed in the `clean` script in `package.json` and in both `git clean` calls in `scripts/pack-all.mjs`. The bug was there before this PR, but it undercuts what the PR is trying to fix.
2. **prover:** the fix ships without a regression test or a regression-evidence note. The repo already has a model for one: a test file next to the script, `scripts/*.test.mjs`, run with ava.
3. **pruner:** four "Considerations" sections in the PR description contain only "None"-style text and should be removed.

**Review posted:** It went up as a **comment** review (state COMMENTED, 2026-10-06T04:47:11Z), not request-changes. GitHub won't let this account request changes on a PR it opened itself. The review states the must-fix disposition up front and includes every seat's full write-up. The gauntlet driver moves on based on the marker line below, not on the review type, so this doesn't block the next stage.

**Follow-ups:** none. The gauntlet's next fix stage handles the items above.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1428-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (940827 cached reads)
- Output: 4380 tokens
- Cost: $0.7738294
- Wall-clock: 997s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
