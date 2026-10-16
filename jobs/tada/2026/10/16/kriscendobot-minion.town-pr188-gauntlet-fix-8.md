## Gauntlet fix round 8: kriscendobot/minion.town PR #188

I fixed the round-8 panel findings and pushed them to `clip-gutter-live-refresh` as follow-up commit `927047c` (head moved from `4a452a7`). CI is green: `ci-wait-merge.sh` returned rc 0. I deferred one item, regrouping the commits (below).

**Fixes (the four request-changes seats):**
- **saboteur #1:** each clip read now has a 10 s deadline (`timeout` option, using the timer passed in). A read that times out or is replaced by a newer one now ends as a failure. This holds even when the loader ignores the abort signal, so a stalled fetch can no longer keep the gutter and pane hidden.
- **saboteur #2:** `bootstrap` now un-hides the view in a `finally` block. A throwing apply step can no longer leave it hidden.
- **engine-realist #1/#2:** I removed the window `focus` trigger. It fired mid-click when focus came back from the clip frame, so hiding the gutter swallowed the click, and it also fired a network read on every focus return. The refresh button and the page-becomes-visible trigger remain. A test checks that no `focus` listener is wired.
- **integrator #1/#4 (plus curator):** the design's § 2 now holds the full refresh behavior: the triggers, hiding while a read is pending, the deadline, the `ClipSource.load` → `null` contract, the list of module exports, and `setConcealed`. Open questions item 3 keeps only the reason for that behavior.
- **integrator #2:** the PR description now explains that clips are hidden while a refresh is pending, and why.
- **pruner #1–#4:** I made all four prose cuts in the JSDoc, the test comment and the design doc.
- **Tests:** I added two tests (the timeout, and a replaced read whose loader ignores the signal) and updated the existing ones for the new timer behavior. `vitest` passes 55 of 55 in `test/shell-clip.test.ts`, and `tsc --noEmit` is clean.

I posted a round-8 summary comment on the PR.

**Follow-up:** integrator #3 and packager asked to regroup the nine review-churn commits into logical commits. This stage is limited to follow-up commits, so I didn't do it. The history needs a retcon before the PR is un-drafted.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr188-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2072569 cached reads)
- Output: 19855 tokens
- Cost: $1.5656057999999997
- Wall-clock: 1208s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
