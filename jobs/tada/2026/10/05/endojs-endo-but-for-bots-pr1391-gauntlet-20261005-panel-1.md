I ran panel round 1 on endojs/endo-but-for-bots#1391 ("feat(ses): permit and share a pre-lockdown SturdyRef shim"). The verdict is **must-fix**.

**What I did**
- Made an isolated project checkout of the head branch `build/sturdyref-ses-accommodation` (head 14381fc8f5). The frozen base is `build/sturdyref-shim-first-wins-ef4662f`, and I passed its exact SHA `ef4662f04b5` to `panel.sh`. The diff is 31 files, +671/−29.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh`. It exited 0 with disposition `must-fix`, and every seat returned a verdict (no seat errors). Two pre-passes added seats: the PR-body template check found invented headings and forced the integrator, and the PR-body length probe forced the pruner over the description.
- Posted the aggregate as review 5413714365 (https://github.com/endojs/endo-but-for-bots/pull/1391#pullrequestreview-5413714365).
  - **It went up as COMMENTED, not request-changes.** GitHub refuses request-changes on a PR the bot itself opened. The review title still says **must-fix**, but the next-stage-owed check may need to read that title rather than the review state.
  - **It is shortened.** The full aggregate is about 76.6k characters, over GitHub's 65,536 limit. I posted a 35.8k version: a header listing all 32 seats and their verdicts, the full text of the 15 seats that did not approve, and only the names of the 17 that approved.

**Verdicts:** 5 request-changes (packager, saboteur, spec-keeper, integrator, pruner), 10 comment-only, 17 approve.

**Main must-fix items:**
1. **Unrelated daemon commits (packager and integrator).** Three `test(daemon)` commits (e703fad05d, d6d07ab446, 14381fc8f5) rework the orphan-daemon teardown test's IPC handshake and polling. That has nothing to do with the SturdyRef/SES change, so they should move to their own PR. If they stay, squash them into one commit.
2. **Over-broad `catch {}` (saboteur).** The bare `catch {}` in `packages/daemon/test/_orphan-daemon-launcher.js:44-46` also hides failures it isn't meant to catch, such as a bad pid value.
3. **Should-fix items:**
   - **Engine-specific error text (spec-keeper):** new tests check the exact wording of a `TypeError` message, which varies by JavaScript engine.
   - **SturdyRef shape check (saboteur):** `sampleSturdyRef`'s shape check can see different results from proxy traps than `completePrototypes()` later does.
4. **PR description (pruner and integrator):** "Relation to other SturdyRef work" and the Upgrade, Compatibility and Testing Considerations sections are too long or repeat the changeset.

I made no fixes, did not un-draft the PR, and committed nothing to the garden repo. The fix-loop stage owns the items above.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (956354 cached reads)
- Output: 5060 tokens
- Cost: $0.7420388
- Wall-clock: 606s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
