---
ts: 2026-05-23T00:02:01Z
kind: result
role: weaver
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/22/235601Z-dispatch-general-contractor-61b316.md
---

PR #356 rebased onto `origin/llm` via the frozen-base convention.

Outcome:

- Old head `64313361d` (CONFLICTING against moving `llm`) became `76dafb2da` on frozen base `llm-b1c3f4d` (which already existed at `origin/llm` tip from prior work and was reused per the skill's collision rule).
- PR base updated `llm` → `llm-b1c3f4d` via `gh pr edit 356 --base llm-b1c3f4d`. `mergeable: MERGEABLE` post-update.
- Net diff invariant: 4 design files (gateway-package.md + gateway-packaging-ci.md + gateway-aws-deployment.md + gateway-aws-attuned.md) plus README updates plus endo-gateway.md status change, matching the original two-commit intent.

Conflicts resolved (all in `designs/README.md`, both commits):

- Commit 1 (PR 343 inherited): four hunks. README preamble had grown extensively on `llm` (a multi-paragraph "Recently added or revised" block through 2026-05-20) so the resolution kept HEAD's structure and folded gateway-package into the "Recently added" list. Summary-table conflict took PR 343's two rows (endo-gateway → Superseded + new gateway-package) while keeping HEAD's `unhandled-rejection-display` Complete row. Totals reconciled to HEAD's 125+1 = 126 designs, Superseded 1+1, Proposed 20+1. Mermaid Remote Access subgraph: dropped the old `egate[endo-gateway]` node entirely in favor of PR 343's `egw[<i>SUPERSEDED</i>]` + `gpkg` rewrite.
- Commit 2 (PR 356 own): three hunks. Preamble "See also" prefix was replaced by HEAD's "Recently added or revised:" prefix; the three new design entries (aws-attuned, aws-deployment, packaging-ci) were spliced in honoring HEAD's structure. Table-row conflict added the three new rows while keeping HEAD's unhandled-rejection-display Complete. Totals: 126+3 = 129 designs, Proposed 21+3 = 24. Mermaid additions (gpkgci/gawsdep/gawsatt nodes and four edges) and Milestone 1 + per-design estimate table additions merged cleanly.

No `--ours`/`--theirs` used. The dropped `egate` node was a renaming-by-supersession that PR 343 had intended; keeping HEAD's `egate` definition would have left a dangling node referenced only by edges PR 343 deleted.

Notes:

- PR #343 (stacked parent) was not in this dispatch's scope. It is still on base `llm` (moving) and still CONFLICTING per gh; the parent dispatcher may want a separate `weave #343` to also pin its base to `llm-b1c3f4d` and rebase the single commit it carries.
- Forced-update push: `64313361d → 76dafb2da` (force-with-lease against the old head SHA). GitHub vulnerability banner appeared but is unrelated to this push.

Self-improvement: nothing this time.
