---
ts: 2026-05-15T03:08:26Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/15/025337Z-dispatch-liaison-9a5955.md
  - entries/2026/05/15/030128Z-result-investigator-9a5955.md
---

# Dispatch: investigator narrows the node-20-macos flake — same-hash retry-divergence cases only

Dispatch root: `dispatches/investigator--70017a/`. Project worktree on `endojs/endo-but-for-bots@llm` for CI log access.

Maintainer feedback on [issue #260 comment 4456539689](https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4456539689) (2026-05-15T03:07:50Z): *"Please narrow this down by looking for specific cases where a macos job ran multiple times on the same hash and alternately failed and succeeded."*

The prior investigator survey (`9a5955`) reported 13 macos-15 failures clustered into 6 signatures, but only ~2 looked like true flakes. The maintainer wants a sharper test: **same-hash retry divergence** — the gold-standard evidence of nondeterminism. A job that fails once and passes once on the same SHA is unambiguously flaky regardless of error signature.

## Per-action authorization

Standing on endo-but-for-bots: read CI logs, comment on issue #260. READ-ONLY on endojs/endo.

## Task

1. **Survey runs of `test (20.x, macos-15)` over the same window** (~48h). For each branch-tip SHA where this check ran, collect ALL `gh run rerun` retries (the `gh api repos/endojs/endo-but-for-bots/actions/runs?per_page=100` listing includes retries; the `head_sha` plus `run_attempt` distinguishes them).

2. **Identify same-hash divergence cases**: SHAs where the check ran ≥2 times and had ≥1 SUCCESS *and* ≥1 FAILURE across the attempts.

3. **For each divergence case** (probably few — that's the maintainer's hypothesis worth confirming):
   - Cite the SHA + branch.
   - List each attempt's conclusion and timestamp.
   - Pull the failing attempt's log tail; describe the error signature.
   - Note whether the same signature recurs across multiple SHAs (= a recurrent flake) or is one-off.

4. **Compose a follow-up comment on issue [#260](https://github.com/endojs/endo-but-for-bots/issues/260)**:
   - Cite the prior comment (4456539689) and what was looked for.
   - Report: N divergence cases found out of M same-hash double-runs in the window. (If N=0, that's the substantive answer: no true flake evidence.)
   - For each divergence case, the SHA + signature + recurrence note.
   - Revised proposed next steps in light of the narrower data.

5. **Update issue #260's body or labels** if the new finding materially changes the analysis (e.g., "narrower investigation shows 0 same-hash flakes; cluster A and C from the prior report were not actually divergence-confirmed").

## Out of scope

- No new issues opened.
- No PR edits.
- No upstream interaction.

## Report

≤ 400 words: N (divergence cases found), M (total same-hash double-runs in window), top-2 divergence-case summaries, comment URL, one-line `Self-improvement: ...`.
