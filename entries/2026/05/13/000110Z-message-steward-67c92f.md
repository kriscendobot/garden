---
ts: 2026-05-13T00:01:10Z
kind: message
role: steward
project: endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/13/000016Z-message-steward-cf7b09.md
---

# Mirrored: process/GROOM-OPEN-QUESTIONS.md + process/GROOM-ANSWERS.md

Two open questions from the 2026-05-05 grooming pass. The maintainer
answered both in `GROOM-ANSWERS.md`; the steward should treat both as
resolved (no further work needed in this generation of the garden,
since the per-PR roles are not active here yet). Mirrored verbatim
below.

---

## process/GROOM-OPEN-QUESTIONS.md

# Open questions for the user

Latest grooming pass: 2026-05-05.

## 2026-05-05 grooming pass

First groom dispatch since the design pipeline began.
Reconciled `designs/README.md` against three merges of 2026-05-04 to
2026-05-05: PRs #50 (error-tracing, informational), #85
(daemon-rename-to-manager), and #86 (cbors plus deprecated syrups).
The reconciliation diff was small (one row's Updated date, the
totals line, the header date, the trailing progress sentence) and
shipped as PR #90 against `bots-ssh/llm`.

### Status drift

- **cbors**: README's Updated date is 2026-05-05 (the day PR #86
  merged), but the design file `designs/cbors.md` metadata block
  still says `Updated: 2026-05-04` (the day the author wrote it).
  No content drift; just the date convention.
  Recommended action: leave as-is.
  The README tracks "last roadmap-relevant touch", which is the
  merge; the design file tracks "last authoring touch".
  Both readings are defensible.
  Awaiting confirmation that no sweep of Updated-field semantics is
  wanted across the corpus.

### Roadmap shape

- **Stale totals predate this pass.** The Totals line under the
  summary table was off by 4 to 9 in several categories before this
  groom pass, suggesting prior PRs added rows without refreshing
  the line.
  This pass refreshed it; future grooms should do the same as the
  last step before bumping the "Progress as of" footer.
  No user decision needed; logged for the next groom's awareness.

- **`docs/error-tracing-design.md` lives outside `designs/`.**
  PR #50 placed the error-tracing design under `docs/`, not
  `designs/`.
  It is therefore not tracked in the README's summary table.
  Recommended action: leave as-is unless the maintainer wants the
  tracing design promoted into `designs/` and reflected in the
  roadmap.
  Awaiting decision.

---

## process/GROOM-ANSWERS.md


Please generally treat the most recent data that a document was edited as the
updated date, not the date action was taken on the document. It however follows
that when action is taken that pertains to a document, like `designs/*.md`,
that document should be updated, and consequently the date should reflect the
date the work was acknowledged.

Pleaes move the error tracing design into the designs document and propagate
those changes.

