Viability decision for endojs/endo-but-for-bots#1398: **proceed**. The PR is open, unmerged, still a draft, and nothing newer has replaced it.

**PR:** "feat(daemon): layer 8 — a SturdyRef for a formula without incarnation". It was opened 2026-09-30T08:29Z. The head is `build/sturdyref-daemon-formula` @ `1d4d84b7`. The base is `build/sturdyref-ocapn-enliven-f212191`, a frozen snapshot of layer 7's head, and it still points at the recorded `f2121918`.

Deciding question: Is #1398 still the current, unreplaced delivery of layer 8 (the daemon mints a SturdyRef for a formula without incarnating it) in the SturdyRef layering stack kriskowal asked for on #695, and is that capability still missing from `llm`?
Answer: yes.

Evidence:
- **The motivation holds.** kriskowal requested the layering stack on #695, and it is running as orchestration `ebfb-sturdyref-layering-20260930`, tracked in kriscendobot/garden#47. Design PR #695 is still open, and `llm`'s `packages/daemon/src` has no SturdyRef module yet.
- **Nothing replaces it.** Every layer of the stack was opened today and all are open: #774 and #1391 through #1397 below it, and layer 9's design #1399 (08:38Z) above it. #1399 builds on this layer rather than replacing it.
- **The older daemon SturdyRef PRs don't overtake it.** #541 and #701 through #704 date from June and July. They are open, and the PR body cites them only as prior art ("drew on but did not rebase").
- **Nothing has been lost yet.** There are no reviews or comments, and the change is small: 8 files, a new daemon module plus tests and wiring.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (116466 cached reads)
- Output: 1272 tokens
- Cost: $0.3989092
- Wall-clock: 19s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
