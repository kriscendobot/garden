---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-17T22:05:59Z
---
---
kind: result
role: novice
repo: endojs/endo-but-for-bots
project: endo
---

Design-panel juror block for endojs/endo-but-for-bots PR #1024 (designs grooming: README verify/reorganize/archive plus a stale per-doc metadata sweep). Diff base origin/llm, head 84dc758dfc.

### novice (top-down clarity)

**Verdict:** request-changes

**Findings:**

- `designs/README.md:675-681` contradicts `designs/README.md:693` inside one screen. The blockquote says Milestone 2 "is the next archive candidate... it was left in place this pass only to keep the reorganization reviewable one milestone at a time", and the very next milestone heading reads "Milestone 2: Project Hygiene - **Complete**; archived to ARCHIVE.md." A new reader cannot tell whether M2 is archived, and the archive convention this PR introduces gives no way to resolve the conflict. Delete the candidate note (the second commit did the archiving). must-fix [rule: designs/AGENTS.md § Archiving Completed Milestones]
- The document states three different tenses for the same follow-on work. `designs/README.md:249` says the stale design docs were "swept in the stacked `groom-endo-stale-design-docs` follow-on (this PR)"; `designs/README.md:672-673` says "Sweeping these inline cells (and the stale design docs listed in the drift note) is the scoped follow-on `groom-endo-stale-design-docs` job"; `designs/README.md:193` says those docs are "listed there as a scoped follow-up, not silently rewritten in this pass". The diff does rewrite 19 design docs. Reduce to one statement: the per-doc metadata was swept here, the per-milestone inline Status cells were not. must-fix [rule: designs/AGENTS.md § Progress Tracking]
- `designs/README.md:197-204` promises "The four subsections immediately below", then five subsections follow (verification drift, expected landing order, planned-vs-actual, delivery-date estimates, velocity and timing basis). The reader counting along loses track of where the new material ends, and "the velocity calibration note" names two candidate sections. should-fix [proposed-rule: an enumerating sentence that counts sections must match the section count that follows it]
- `designs/README.md:259-266` tells the reader `namehub-interface-unification` is "likely-landed... needs confirmation", then three sentences later "was confirmed landed" and flipped to Complete. State the settled fact once; the intermediate doubt is process, not content. should-fix [rule: skills/gricean-maxims/SKILL.md]
- The document opens at `designs/README.md:1-6` with the title and then 185 table rows, no lede. A first-time reader meets Status values (`Reference`, `Active`, `Draft`, `Proposed (partially satisfied by ...)`) with no definition, and the vocabulary that defines them (`designs/AGENTS.md` § Status Values, new in this PR) is not linked until line 666. Two sentences above the table saying what a design document is and linking AGENTS.md, with the Totals line moved above the table, would carry the reader in. should-fix [proposed-rule: designs/README.md opens with a one-paragraph lede naming its purpose and linking designs/AGENTS.md before the summary table]
- New prose is unwrapped at `designs/README.md:193`, `:249-266`, and `:1731`: single lines of 200-plus words carrying five to eight sentences each. The Totals paragraph in particular is the one paragraph every reader reads, and it is the hardest to hold in mind. should-fix [rule: AGENTS.md § Markdown style]

**Notes (out of scope but worth flagging):**

- The Totals claim at `designs/README.md:193` says it was "recounted by tallying the summary table's Status column", but tallying the column gives 56 Complete/Implemented and 47 In Progress against the claimed 57 and 46 (185 rows total, which does check out). The gap is in the non-vocabulary cells (`Phase 1 implemented`, `In Progress (Phase 3)`, `In Progress (PR #284)`), which no stated rule assigns to a bucket. The assessor seat owns the arithmetic; the clarity point is that a reader told to reproduce a count needs the bucketing rule for parenthesized statuses. [proposed-rule: a Status cell in the summary table uses a designs/AGENTS.md vocabulary value, with any qualifier in a separate Notes column, so counts are reproducible]

Self-improvement: the novice's "assumed background" category caught the missing lede here only because I read the new `designs/AGENTS.md` first and noticed the README never links it; worth adding to `roles/jurors/novice/AGENT.md` that when a PR adds a conventions document, the novice should check whether the document a new reader actually opens first points at it.
