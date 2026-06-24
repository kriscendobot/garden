---
ts: 2026-05-14T22:20:16Z
kind: result
role: gardener
project: garden
to: liaison
refs:
  - entries/2026/05/14/221534Z-dispatch-liaison-319706.md
---

# Result: verb-vocabulary encoded on liaison + steward + CLAUDE.md

Three commits on `main` (pushed to `origin/main` at `c51271d`):

1. `2e5ef9d` `roles/liaison/AGENT.md` — added `## Vocabulary` section immediately after the existing `## Vocabulary: the gamut`. Six subsections: *Direct-dispatch verbs* (12 rows), *Compound chain idioms* (4 rows), *Garden-meta phrases* (5 rows), *Bulletin and journal phrases* (4 rows), *Authorization shapes* (3 rows), *Negation and discipline observations* (3 rows), *Bring-up-to-date* (1 row), *Disambiguation notes* (4 bullets covering ferry vs carry-feedback, cleanup vs wrap-up, encode-rule vs encode-lesson). Ferry is marked canonical at the top of the direct-dispatch table.

2. `3d1eed0` `roles/steward/AGENT.md` — added `## Vocabulary` section after the existing `## Vocabulary: the gamut`. Subsections: *Direct-dispatch verbs* (12 rows, same set as liaison with steward-specific notes about identity-switch forwarding and the one-cleaner/one-conductor caps), *Compound chain idioms* (4 rows), *Bring-up-to-date* (1 row), *Negation patterns* (3 rows with *never* always escalating a `message` to liaison), and a closing *Out of scope for the steward* paragraph that names the liaison-only categories (bulletin/journal, authorization shapes, garden-meta) and tells the steward to route them back to liaison rather than acting.

3. `c51271d` `CLAUDE.md` — expanded `### Orchestrator vocabulary` from a one-line glossary into a short 9-row table covering the gamut and the most common direct-dispatch verbs (ferry, shepherd, judge, build, design, fix, weave, merge). Trailing paragraph names the role files as the full table and lists the categories they additionally cover.

Ferry's promotion is explicit at three sites: row 1 of the liaison's direct-dispatch table (marked "canonical" with synonyms below), row 1 of the steward's direct-dispatch table (same shape), and row 2 of the CLAUDE.md glossary (with the maintainer-reaffirmed-2026-05-14 note).

Maintainer framing for the gardener notebook: the user confirmed the verb-vocabulary list and promoted *ferry* to first-class on 2026-05-14; the precipitating conversation routed through the dispatch entry `221534Z-dispatch-liaison-319706.md`. The vocabulary table makes the gardener's role / skill / inventory translations grep-able from the orchestrator's prompt-reading code path, rather than relying on each session's recall of the role roster.

Routing confirmation: the next user prompt containing any of the recognized verbs (e.g. "ferry #123", "judge #45", "build a PR for X") will match the liaison's *Vocabulary* table and dispatch the named role; an inbox `message: liaison → steward` carrying the same verb routes through the steward's subset. The liaison's *Operating norms* § *Translate user prompts to a role* matching procedure now has the vocabulary table as its first lookup before the role-name scan.

Self-improvement: nothing this time. The dispatch was specific, the categories were already worked out by the maintainer, and the encoding was straightforward authorship. No recurring lesson surfaced in writing it that would warrant a further role / skill change.
