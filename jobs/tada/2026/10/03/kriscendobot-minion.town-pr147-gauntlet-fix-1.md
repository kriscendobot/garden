Fix round 1 for PR #147 is pushed and CI is green (3 of 3 checks passed, `ci-wait-merge` rc 0).

**PR:** https://github.com/kriscendobot/minion.town/pull/147, head `d2653c7` → `625d8b9`. That is one follow-up commit, pushed with `safe-push-pr-head.sh`. It only adds commits, so no history was rewritten.

**The two must-fix items (from the novice seat):**
- **Alternatives came too late.** The rejected alternatives (a `guide` tool, MCP Prompts, serving the garden skill verbatim) moved from § 8 into a new § 3.1 "Why resources". It now sits directly before the resource table, and the old § 3.1 became § 3.3 with all cross-references updated.
- **Undefined vocabulary.** § 1 now opens by defining capability, pet name, CapTP and its bootstrap, and CSP. The motivating examples that depend on those terms come after the definitions.

**Should-fix and comment-only items also applied:**
- **Index pointing at missing resources (critic):** each `getting-started` index entry for a gated resource now states its mount condition. The lint checks this, and the § 7 drift-guard probe must run with the clip tools mounted.
- **Clip advice in an always-mounted resource (ergonomist):** the clip-only troubleshooting entries moved from `guide/troubleshooting` into `guide/clips`. The mount rule now covers resource content, not just which resources are listed, and the lint enforces it.
- **Two scripts writing the same live directory (decomplector):**
  - Each deployed copy of the resources is now an immutable directory named for its resources commit, selected by a symlink.
  - Both deploy scripts swap the symlink only if the new commit descends from the live one, so an app deploy can't undo a resources hotfix.
  - The § 5 policy row no longer says "whoever deploys".
- **Untested resources (skeptic):** two new tasks cover them. T5 tests `guide/mail` by receiving and adopting a sent message; it needs a second sending principal, which ties it to § 9 question 1. If none is available it is reported as uncovered. T6 tests `guide/troubleshooting` with a name that doesn't exist.
- **Gate claims more than it measures (skeptic):** § 6.4 now says the gate covers one client (Claude Code) and the verdict claims no more than that.
- **Unverified present-tense claim (skeptic):** the § 7 sentence now cites the 2026-10-01 caution that is already in the garden skill. I checked that it is there.
- **Thin pass bar (critic, comment-only):** § 6.4 now says how ties and infrastructure failures are handled.
- **Novice should-fix items:** § 5 got a lead-in explaining the table, and § 6.1 states its premise before its conclusion.
- **Smaller edits:**
  - The URI naming convention (`guide/` vs `examples/`) is stated.
  - The diagram has a figure caption.
  - Two phrasings flagged by the copyeditor are fixed.
  - The authoring paragraph is shorter.
- **PR description (pruner):** I cut the section-by-section tour. That also removed the now-stale "four tasks" wording. The `garden-job` marker is kept.

**Not applied:** the pruner wanted the "tribal knowledge drifts" paragraph in § 1 removed. I kept it and defined its terms instead, because the novice's must-fix says this is the paragraph that justifies the whole design.

**Follow-up:** the design file fails a Prettier check, but so did the original, and CI doesn't run Prettier, so I left the formatting alone. The panel-2 rerun is up to the gauntlet driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (931467 cached reads)
- Output: 11386 tokens
- Cost: $1.0423574
- Wall-clock: 424s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
