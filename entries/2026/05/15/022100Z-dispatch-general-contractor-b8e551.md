---
ts: 2026-05-15T02:21:00Z
kind: dispatch
role: general-contractor
to: fixer
project: endo-but-for-bots
worktree: dispatches/fixer--b8e551/project
refs:
  - entries/2026/05/15/021800Z-result-judge-60d499.md
  - entries/2026/05/15/021100Z-dispatch-general-contractor-60d499.md
---

# Dispatch fixer: address design panel verdict on PR #241 (slot 1)

Slot 1 advances: judge `60d499` returned with a design-panel verdict (review id `PRR_kwDORRE4FM7__WW7`, 1152 words) carrying three must-fix items and fifteen should-fix items. The PR is design-only on `llm` (two changed files: `designs/familiar-run-apps-vfs.md` added, `designs/README.md` modified).

Dispatch root: `dispatches/fixer--b8e551` (project worktree at `endojs/endo-but-for-bots@design/familiar-run-vfs-apps`).

## Must-fix items (load-bearing for the loop)

1. **`## Purpose` paragraph 1 restructure.** Paragraph 1 is a 165-word run-on with three topic shifts. Split into three short paragraphs (goal / case 1 / case 2). Move case 1's sub-case detail (the inner clarification) into `## Case 1` proper so the section that introduces case 1 actually contains its substance.
2. **Introduce load-bearing terms before first use.** `endor`, `XS worker`, `cap-std`, `formula`, and `Lal caplet` all appear before they are introduced. Either add a Vocabulary note at the top, or extend the Glossary at the bottom, naming each term briefly with a one-sentence definition. If `Lal caplet` is mentioned only in passing in an example, either introduce it properly or remove the mention.
3. **Resolve the no-lockfile-determinism contradiction.** The design claims no-lockfile reproducibility but the ingestion-on-miss mechanic implies time-dependent results (a registry change between two runs alters resolution). Pick one of: (a) name registry-table stability as a precondition for reproducible no-lockfile runs; (b) commit to `endor lock` as the default for reproducible runs; (c) explicitly accept time-dependence and name the failure mode.

## Should-fix items (substantive)

The full list lives in the PR review body (review `PRR_kwDORRE4FM7__WW7`). The fixer reads the review on the PR directly:

```sh
gh pr view 241 -R endojs/endo-but-for-bots --json reviews \
  --jq '.reviews[-1].body'
```

The fifteen should-fix items are organized in the body under per-seat sections (critic / skeptic / copyeditor / pedant / novice). Address each, replying on the review thread per `skills/pr-review-thread-replies/SKILL.md` (each thread reply cites the addressing commit SHA or the rationale for a verified-no-change).

## Out-of-scope items

The panel flagged six out-of-scope items (broader system questions, future-design items). The fixer does not address these in this pass; they are candidate follow-ups documented in the review body's "Out of scope / follow-up" section.

## Per-action authorization

Standing authorization for design-PR fixer work (forwarded by the contractor's adoption authority):

- Commits to the PR branch under the bot identity (implicit in the dispatch).
- Replies on each inline review thread per the skill above.
- A top-level summary comment on the PR after the revision pass lands, naming the addressing SHAs.

No upstream interaction; this is bot-fork-only work.

## Definition of done

- Each must-fix item addressed (a commit, or a thread reply justifying verified-no-change).
- Each should-fix item addressed (commit or thread reply).
- PR head moved to the new revision; CI re-running (expected to remain green on a design-only change).
- The contractor's next cycle re-evaluates next-stage-owed; with a fixer push since the last panel verdict, the heuristic returns "judge re-dispatch owed".

Report: the new head SHA, a one-line summary per must-fix item (addressed-by SHA or rationale), and a count of should-fix items addressed vs deferred. The orchestrator tears down your dispatch root on return.

Self-improvement: apply per `garden/skills/self-improvement/SKILL.md`.
