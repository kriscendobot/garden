Viability decided: PR #695 should not enter the gauntlet; it has been overtaken. No clean, panel, fix, CI-wait or un-draft budget was spent, and no garden files, project repos or PRs were changed.

The last attempt reached the same verdict but put the marker line after the completion signal, which therefore was not the last line. This report puts the signal last.

**PR facts:** endojs/endo-but-for-bots#695, "design(sturdy-refs): agent provide/accept surface", is open, a draft and not merged. Its base is `llm-387ea66` and its head is `e22f7e5c`.

Deciding question: Is #695 still the live design for the SturdyRef agent provide/accept surface, with its premise intact, or has a newer design replaced it?

Evidence:
- **Maintainer deferred it (kriskowal, 2026-09-30, comment 5903472512).** Their words: "Let's return to this design when we've made more progress on the underlying SturdyRef layering." They set out a 9-layer stack, and revisiting the Agent API is the last layer, after layers 1–8.
- **A successor already exists: #1399** (`designs/sturdyref-agent-api.md`, open draft, stacked on layer 8 #1398). It says it "replaces the framing of #695" and includes a table giving each #695 element's fate.
- **The premise is gone.** #695 builds on the pre-layering `'sturdyref'` record from #737, which layers 1–8 replace (#1389, #1392, #1393, …).
- **History:** a maintainer CHANGES_REQUESTED review (4700861513) and more than 12 design-panel rounds, all must-fix, never converged.

Option: close as superseded

A caveat on that option: kriskowal said "return to this design", not "close it". They might want #695 kept as the historical record until #1399 is decided. Either way, a gauntlet on #695 now would be wasted, because the open questions for this surface now live on #1399.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-20260930-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (292802 cached reads)
- Output: 3096 tokens
- Cost: $1.0313316
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
