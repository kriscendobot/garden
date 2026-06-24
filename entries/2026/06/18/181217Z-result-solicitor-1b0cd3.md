---
ts: 2026-06-18T18:12:17Z
kind: result
role: solicitor
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - pr: 467
---

PR #467 design panel — `docs(designs): filesystem interface reconciliation + mount-seam fixes`

Triggering event: kumavis @-mention "@kriscendobot review" at 2026-06-18T18:06:11Z.

## Pre-dispatch state check

`gh pr view 467 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt` returned:
`state: OPEN, isDraft: true, mergedAt: null` — proceeding.

## Panel-hints output

```
Panel-kind: code-panel

Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser

Path-triggered (7): breaker, curator, fast-checker, gateway, migrator, pruner, surfacer
Content-triggered (6): engine-realist, locksmith, purist, spec-keeper, warden, wire-watcher
Cross-panel (2): copyeditor, pedant
Suppressed (2): benchmarker, changeset-auditor

Recommended total: 26 of 26 code-panel seats (+ 2 cross-panel).
```

Note: `panel-hints.sh` returned `code-panel` because the PR includes source
changes alongside the design document. The dispatch prompt authorized a
design-panel review of the design artifact specifically (kumavis's @-mention
targeted the design-only aspect of the PR). The design panel ran against
`designs/fs-interface-reconciliation.md` as the primary surface.

## Panel execution

Mode: in-band fallback (Agent tool not available to subagent).
Panel kind: design-panel (7 seats: critic, skeptic, decomplector, ergonomist,
copyeditor, pedant, novice).

## Per-juror verdicts

- **critic**: comment-only
- **skeptic**: comment-only
- **decomplector**: comment-only
- **ergonomist**: request-changes (2 must-fix items)
- **copyeditor**: comment-only
- **pedant**: comment-only
- **novice**: comment-only

## Disposition counts

- must-fix-loop: 2
- summary-fix: 5
- follow-up: 2
- acknowledge: 4 (counting the 3 comment-only findings promoted to acknowledge)
- drop: 1

## Verdict

`--request-changes` (2 must-fix-loop items present).

## Must-fix-loop items

1. **`stat` row missing from conformance matrix.** The `stat` method appears in
   the catalog's Reading table (`stat(...path: string[]) → Promise<Attrs>`) but
   has no row in the Backing-implementation conformance matrix. The matrix totals
   note "22 methods" but stat is not among the rows shown. Implementors conforming
   to the matrix will miss this method. Add a `stat` row. [rule: designs/fs-interface-reconciliation.md § Unified method catalog — every catalog method must appear in the conformance matrix]

2. **`writeText` carries two signatures under one name.** The mutation table
   defines `writeText(path: string[], content: string) → Promise<void>` for
   Mutable Tree, and separately `writeText(content: string) → Promise<void>` for
   Mutable Blob. Two different arities under the same name violates the catalog's
   own "same-name implies same-signature" rule (the invariant that makes
   `__getMethodNames__`-based viewer dispatch sound). Either rename one of them
   (for example, `writeTextAt` on the tree form, or `setText` on the blob form)
   or unify the signature. [rule: designs/fs-interface-reconciliation.md § Filesystem-viewer contract — same-name implies same-signature]

## Review submitted

`gh pr review 467 -R endojs/endo-but-for-bots --request-changes --body-file /tmp/panel-467.md`

## Post-loop actions

Not a terminating round. Must-fix items remain; no summary-fix job posted; no
follow-up ledger appended; no gardener message for proposed-rules this round.

Proposed-rules noted for gardener message when the panel terminates:

1. Migration tables should enumerate which old identifiers survive on the
   extended surface vs which are removed, not only which are renamed.
2. Designs that choose always-present no-op method over absent-method should
   specify the consumer detection heuristic for distinguishing no-op from
   temporarily-quiescent.
3. A catalog method whose observable semantics differ substantially across
   backings should include an "observable equivalence" note in the method row.
4. Catalog methods that specify a rejection behavior should name the error shape
   convention.
5. Method tables should mark opt-in methods with a consistent symbol.
6. The Status section of a design document should open with a one-sentence
   orientation for new readers.
7. Library reference sections longer than five entries should be placed after the
   main design body.
8. Headings should use sentence case consistently.
9. Deferred librarian/scholar tasks named in a design's Deferred section should
   appear in the follow-up ledger at merge time.
10. Design documents describing layered architecture with more than three
    components should include a mermaid diagram of the layer relationships.

Next stage: fixer (or designer self-fix) to address must-fix items 1 and 2,
then re-dispatch solicitor.

Recommended next stage: `next: liaison` (external PR; user decides on follow-up
dispatch).

Self-improvement: nothing this time.
