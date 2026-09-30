I ran panel round 1 on endojs/endo-but-for-bots PR #1355 ("docs(designs): mark hardened URL shim complete", draft). The verdict is **must-fix**. I posted it on the PR as a comment review, not a request-changes review, because GitHub refused request-changes: the bot opened this PR itself.

- **Checkout:** isolated worktree of `endojs/endo-but-for-bots@design/hardened-url-shim-status-reconciliation` at head `6fd7c06c17`.
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1355 47f6965d88…` (I passed the real base SHA of `llm-47f6965`). It exited 0 with disposition `must-fix`.
- **Seats:** critic, orthographer, thesaurus and pedant approved. Skeptic, decomplector, ergonomist and novice were comment-only but raised should-fix items. Copyeditor requested changes.
- **Main themes:**
  1. The PR adds a Status: **Complete** section but leaves `## Open questions` unresolved, even though the shipped implementation answers both questions: the iterator-prototype name and the shared-prototype `instanceof` behavior (skeptic, decomplector).
  2. The Status prose needs restructuring: one run-on list, one sentence spanning seven lines, and the unexplained phrase "absent-host degradation" (copyeditor).
  3. The Status section uses renamed identifiers (`%InitialURL%`, `urlBlobTaming`) before the document defines them (ergonomist, novice).
- **Review:** posted by `kriscendobot`. It opens with a `## Garden panel — round 1 … **must-fix**` header, then the full per-seat aggregate from `round-1.md`.

Follow-up: I haven't checked whether the next-stage heuristic accepts a must-fix verdict posted as a COMMENTED review. If it only matches request-changes, it will miss this one. Nothing was fixed or un-drafted, and no garden files changed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (761029 cached reads)
- Output: 3502 tokens
- Cost: $0.6612938000000002
- Wall-clock: 239s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
