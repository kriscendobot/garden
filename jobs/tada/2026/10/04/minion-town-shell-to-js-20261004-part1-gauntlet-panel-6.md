## Gauntlet panel round 6: kriscendobot/minion.town PR #151, must-fix

The round 6 review panel ran on PR #151 (31 code-review seats, head `0955bf9c10`, base `a378bb3dd5` / `main-a378bb3`). The panel script exited 0 with the verdict **must-fix**. Seats split 3 request-changes, 6 comment-only and 22 approve. I posted the verdict to the PR as review 5408082040, as a comment: GitHub won't let the bot request changes on its own PR. The review opens with `## Panel round 6 — must-fix`, followed by a summary and the full write-ups from every seat that didn't approve.

Last round's must-fix is closed: the Route53 module version is now checked against a strict `vX.Y.Z` pattern before it goes into the root SSM script, and there are tests that try to inject shell through it. The other round-5 must-fix (the scribe's missing completion-summary comments) can't be confirmed closed this round, because the scribe seat isn't in this panel.

**Must-fix:**
1. **The `replace` → `replaceAll` fix in `tools/vendor-endo-claude.js:127` has no test.** Reverting it still passes the whole test suite, because the vendored file contains the import only once. It needs a pure helper tested on a file with two or more occurrences.
2. **The commit history has a broken reference.** Commit `ff23336` renames the npm-registry preflight script from `.js` to `.mjs`, but `deploy-npm-registry.sh` keeps pointing at the old `.js` path until `383d20f`. Another seat also wants the 12 review-round fix commits regrouped into one commit per conversion, which would fix this too.
3. **The converted scripts skip `main()` and exit 0 when run through a symlink.** The check that decides whether the file was run directly compares against the path as typed, not the real path. So the "fail closed" preflight, the `inspect-image.js` CI gate and the Caddy installer would all report success without doing anything.

Should-fix items:
- `inspect-image.js` passes when its list of required flags is empty.
- The Route53 default version is written twice, and the unvalidated value is exported next to the validated one.
- `inspect-image.js` checks credentials one way in the image config and a narrower way inside the container.
- AGENTS.md doesn't say when a script should be `.js` versus `.mjs`.
- The PR description doesn't mention two operational changes: the npm-registry service now runs the preflight with Node, and `deploy-cd-iam.mjs` now imports from `lib/common.js`.

The comment-only items are listed in the review.

I didn't fix anything or take the PR out of draft, as the job specified. I didn't commit anything to the garden repo either.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part1-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (872903 cached reads)
- Output: 6491 tokens
- Cost: $0.8510166
- Wall-clock: 863s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
