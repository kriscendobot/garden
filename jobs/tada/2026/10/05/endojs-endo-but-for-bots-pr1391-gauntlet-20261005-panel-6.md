Round 6 of the panel on endojs/endo-but-for-bots#1391 finished cleanly (`panel.sh` exit 0) with the verdict **must-fix**, and I posted it as a review on the PR.

**How it ran**
- **Checkout:** an isolated checkout of the PR head (`endojs/endo-but-for-bots`, branch `build/sturdyref-ses-accommodation`, head `68f2ff05a1`).
- **Base:** I passed the commit the PR targets, `ef4662f04b` (the frozen branch `build/sturdyref-shim-first-wins-ef4662f`), rather than the branch name.
- **Seats:** 33 seats ran. 3 requested changes (engine-realist, breaker, pruner), 6 left comments only, and the rest approved or found nothing in scope.

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1391#pullrequestreview-5418318702
- GitHub refused a request-changes review because the bot opened this PR, so it went up as a comment review, the same way rounds 1–5 were posted.
- The panel's full output was about 77K characters, over GitHub's 65,536 limit. The review therefore gives a must-fix summary, short one-line summaries for the approving seats, and the full text from every request-changes and comment-only seat.

**What needs fixing**
1. **engine-realist (must-fix):** In `packages/ses/src/global-object.js`, a Proxy can swap `globalThis.SturdyRef` partway through validation. When that happens, lockdown puts back the correct value but leaves it writable and configurable, so the "first one wins, then locked" guarantee is lost. The fix is to lock it on that path too, and to add an assertion on the property's attributes to `sturdyref-reentrant.test.js`.
2. **breaker:** The test copy `packages/ses/test/_sturdyref-shim-first.js` still looks up `Promise` and `TypeError` from the global each time it's called. The real shim now captures them once when it loads. Either make the copy do the same, or explain in its header why it doesn't.
3. **pruner:** The PR description is too long (403 words) and should be trimmed.

This is the sixth must-fix round in a row on this PR. Fixing is the next stage's job; I made no changes to the project and nothing on main2.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1064324 cached reads)
- Output: 6830 tokens
- Cost: $0.8803128000000001
- Wall-clock: 1307s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
