I checked PR #1614 against the current `llm` branch and it may enter the gauntlet. I spent no clean, panel, fix or CI-wait budget.

- **PR state:** open, a draft, not merged. Head is `5baf731ee8`; base is the frozen `llm-9a14ddf` (`9a14ddf660`). It was opened at 2026-11-01T12:37Z with no comments or reviews yet.
- **What it does:** the eighth Ironhorse test262 coverage-crank slice (kriscendobot/garden#51). It changes `hoist_vars_to_global` so global declarations made by `eval` follow the spec. It also makes the eval-framing check in the differential run the harness setup first. Six rows go from fail to pass, 41 rows go from fail to an eval-framing skip, and nothing is lost.

Deciding question: Has `llm` gained any change since the PR's base `9a14ddf` that already does what this PR does (spec-order eval global declarations, or the harness replay for eval framing) or removes the need for it?

Evidence:
- **No newer base history:** comparing `9a14ddf` with `llm` shows `llm` 0 commits ahead, and nothing touched `ironhorse-vm/src/interp/environment.rs` on `llm` since 2026-10-28. The PR sits on the current tip.
- **No competing PR:** a search for related PRs turned up nothing that replaces this one. #1179 (merged) is the earlier Script top-level-declaration fix that this builds on. #1609 and #1610 (open) fix a different gap, the global object's prototype; the PR body already notes that whichever lands second may need a trivial merge of shared shard lines.
- **The need still holds:** the six failing test262 rows and the 41 misclassified eval-framing rows are still present on `llm`, and the coverage crank in garden#51 is still running.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1614-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (124906 cached reads)
- Output: 1470 tokens
- Cost: $0.4283572
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
