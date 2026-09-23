Inbox empty. The audit is complete. This is a post-only audit — no `main2` edits, so nothing to commit in my worktree; the deliverable is the posted job on the board.

## Completion report — librarian library audit

**Scope walked:** `library/sections/` (6,087 per-heading leaf extracts), `library/concepts/` (129 concept pages + README), `library/topics/` (44 topic pages + README), plus the three indexes `keywords.md` (13,807 lines), `topics/README.md`, and `sources/README.md`.

**Dimension 1 — oversize / concept-mixing documents:** No split jobs warranted.
- **Sections** are single-H2 leaf extracts by construction (`conventions.md` naming rule) — inherently fine-grained.
- **Concepts** top out at ~150 lines. I inspected the two largest (`passable-equality`, `space`); both are single coherent concepts with a predictive abstract-at-top and clean H2 partitioning — exemplary, not violations.
- **Topics** are routing indexes by design (each row is a one-line section abstract). The largest, `capability-security.md` (240 section rows), is long but satisfies the abstract-at-the-top contract — it is an index of many small files, not one long mixed document. *Observation, not a flagged violation:* if the taxonomy owner (scholar) later wants to sub-partition `capability-security`/`daemon`/`content-addressed-storage`, that's a `conventions.md`-governed taxonomy call, outside this audit's split criterion.

**Dimension 2 — index gaps:** One gap found and closed.
- Topics: all 44 files indexed in `topics/README.md` ✓
- Sources: all indexed in `sources/README.md`; the lone apparent miss (`erights-org--elang-intro.md`) is an **intentional `status: superseded` tombstone** redirecting to the canonical `erights--elang-intro.md` — correctly absent from the active index, not a gap.
- Concepts: **`e-data-types`** and **`polymorphic-operator`** are current concept pages (both in `concepts/README.md`) with **zero keyword routes** in `keywords.md` — unreachable by term search. Both carry rich `aliases:` frontmatter that is exactly the keyword set to index.

**Posted:** one librarian **index** job — `library-index-keywords-orphan-concepts` (`--role librarian`) — instructing the worker to add `<keyword> | <concept-id>` lines to `keywords.md` for both orphan concepts (drawn from their `aliases:` lists) and land the edit via `scripts/jobs/land-journal-edit.sh`.

**Follow-ups:** none blocking. Optional future taxonomy consideration: sub-partitioning the largest topic routing tables if they keep growing (scholar's call, not an audit split).
