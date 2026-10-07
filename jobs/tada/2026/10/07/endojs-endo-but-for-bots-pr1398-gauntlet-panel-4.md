I ran round 4 of the panel on endojs/endo-but-for-bots PR #1398 and posted the verdict: **must-fix**. The panel script exited 0, so this is a real verdict, not a panel error.

**How it ran**
- Isolated checkout of `endojs/endo-but-for-bots@build/sturdyref-daemon-formula` at head `3927fdd86e`.
- `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 1398 0e0b333c19dd…`, using the PR's base commit (`baseRefOid`) as the base ref. All 34 seats returned a result. Its last line was "code-panel single-round — must-fix".
- Two automatic checks fired before review:
  - The PR description is missing the template headings "Documentation Considerations" and "Testing Considerations". On its own this forces must-fix.
  - The same mechanism (`assertValidId`) drew must-fix findings in both rounds 2 and 3, so the panel added the decomplector's "is this mechanism needed?" question.

**Seat results**
- **Request changes (5):** integrator, prover, releaser, saboteur, wire-watcher.
- **Comment only:** 15 seats.
- **Approve:** 14 seats.

**What blocks the PR**
1. The tombstone tests run against a hand-copied version of `getFormulaForId`, not the real code in `manager.js`. Nothing checks the `settleDeletions` call in `manager.js`, and there is no test where a formula id is created again after its record is deleted (prover, integrator, wire-watcher).
2. The race the PR claims to fix is still open. `settleDeletions` clears the tombstone outside the graph lock, so a read that is already in progress can bring a collected formula back. Suggested fixes: compare a collection counter that only ever goes up, or never clear tombstones (wire-watcher, saboteur).
3. The changeset describes internal groundwork. It should be rewritten to name the user-visible symptom, or dropped if users can't reach the race yet (releaser).
4. The two missing template headings need restoring. The commits should also be regrouped, because two of them are named after panel rounds (integrator).

**Posted:** https://github.com/endojs/endo-but-for-bots/pull/1398#pullrequestreview-5440784369 — a COMMENTED review on head `3927fdd8`. GitHub refused request-changes because the bot account opened the PR, so the body states that the verdict is request-changes. The full panel output was 86 KB, over GitHub's 65,536-character review limit. The posted body is 62.6 KB: the five request-changes seats are in full, and some comment-only and approve seats are cut short.

Nothing was fixed or un-drafted.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (848921 cached reads)
- Output: 6723 tokens
- Cost: $0.8240521999999999
- Wall-clock: 670s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
