Panel round 4 for endojs/endo-but-for-bots#1391 is done. The verdict is **must-fix**, and it is posted on the PR.

**What I did**
- Made an isolated checkout of the PR head (`endojs/endo-but-for-bots`, branch `build/sturdyref-ses-accommodation`, head `d0057d62b4`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's actual base commit, `ef4662f04b` (`build/sturdyref-shim-first-wins-ef4662f`). It exited 0 with disposition `must-fix` after 30 seats ran.
- Posted the result as a PR review (https://github.com/endojs/endo-but-for-bots/pull/1391, 2026-10-05T15:19:49Z), headed "## Garden panel — round 4 (single-round): **must-fix**", the same heading shape round 3 used. GitHub won't let the bot request changes on its own PR, so it went up as COMMENTED, as round 3 did. The full aggregate was 82 KB, over GitHub's limit for a review body. The review therefore carries the template pre-pass and every seat that did not approve in full, and lists the 17 approving seats by name only.

**Why it is must-fix**
- **PR-body template check (automatic, not a seat):** it failed because the PR body is missing the "Scaling Considerations" and "Documentation Considerations" headings. That alone forces must-fix.
- **prover (request-changes):** the tests in `packages/ses/test/sturdyref-shimmed.test.js` (lines 10–32) stay green when the code they cover is reverted, so they don't prove anything. All the other new tests failed under a revert, as they should.
- **integrator (request-changes):**
  - Must-fix: the two missing template headings.
  - Should-fix: three `test(daemon)` commits that a later commit (`0ebeab85eb`) reverts, so the history adds and removes them for no net change. It also suggests squashing review-follow-up commits into the commits they fix.
- **coverage-auditor (request-changes):** `@endo/sturdyref` stubs out its XS tests (`test:xs: exit 0`). It wants the PR body's Testing Considerations section to say that the XS smoke test in `packages/ses` covers it.
- **Comment-only:** stylist, locksmith, saboteur, breaker, purist, spec-keeper, engine-realist, gateway, corner-prober.

**Changes:** none to the garden repo; the review is the only output. No fix and no un-draft, as the job required.

**Follow-ups:** the gauntlet's fix-loop stage gets the items above.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (830799 cached reads)
- Output: 4963 tokens
- Cost: $0.6673158000000001
- Wall-clock: 446s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
