I pushed one follow-up commit to PR #1428 (endojs/endo-but-for-bots) and rewrote the PR description. CI is green on the new head `c6af9f0aa8` (14/14 checks pass, `ci-wait-merge` rc 0).

**Headline must-fix from saboteur: I did not apply it, because the change would cause the problem it claims to fix.** I tested each form with `git clean -nX` (dry run) in a real installed checkout (git 2.43.0):
- **Bare `-e node_modules` (current code):** saboteur is right that it does nothing beyond the `.gitignore` rule. But `node_modules/` still survives: without `-d`, `-fX` never removes an ignored directory as a whole. The dry run lists no path under `node_modules/`.
- **Negated `-e '!node_modules'` (the proposed fix):** git un-ignores the directory, goes into it, and lists ignored files under `node_modules/.store/` for removal. That would damage the install.
- **`.yarn/install-state.gz`:** it is a single file matched by `.yarn/*` in `.gitignore`, so only the negated `-e '!…'` form protects it. Both the unnegated form and leaving the exclude out list it for removal. The PR already gets this right.

**What I did change:**
1. **Code comment:** `scripts/pack-all.mjs` now has a comment in its file docstring explaining why the two excludes use opposite forms, so the next reviewer doesn't "fix" it. Prettier passes.
2. **Regression evidence (prover):** the commit message `docs(scripts): explain the opposite git clean exclude forms` records the dry-run results with and without the fix, for each form. It also notes that CI's `lint` job runs `yarn clean` and then `yarn docs`, which tests the install-state fix end to end. I did not add a new test file.
3. **PR description (pruner):** I removed the five "Considerations" sections that only said "None", kept Testing Considerations, and replaced the outdated "one empty commit" text with a summary of the actual fix commits. The `garden-job` marker is kept.
4. **Push:** the commit went to `fix-upstream-master-ci` via `safe-push-pr-head.sh`, which fast-forwarded the head from `e1279b7939` to `c6af9f0aa8`.

**Follow-ups:**
- The panel-2 round should see the evidence in the commit message that saboteur's must-fix is wrong.
- Saboteur's should-fix about smoke-testing `eshost-cli` with the major-version `configstore`/`nconf` resolutions was not a must-fix, and I did not act on it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1428-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1110738 cached reads)
- Output: 9117 tokens
- Cost: $0.9117436000000002
- Wall-clock: 584s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
