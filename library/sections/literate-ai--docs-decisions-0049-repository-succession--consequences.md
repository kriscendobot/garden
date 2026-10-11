---
title: "ADR 0049: Consequences"
source: docs/decisions/0049-repository-succession.md
source_repo: jordanhubbard/literate-ai
source_commit: e797acdd6d8cf7254e38135f90b0421ad3ed4168
source_date: 2026-10-05
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [repository-governance, signed-updates]
status: current
---

> Abstract: Successor-built CLIs can update predecessor-initialized projects and future self-updates target the successor, while each additional move still requires explicit review.

- Projects initialized from the predecessor plan updates with a successor-built CLI
  without manual edits.
- Self-update reaches the successor from either recorded origin.
- The bridge is a one-time release task for 1.1.0; later releases publish only to the
  successor. Because the predecessor is not public, 1.0.x prefix installs still
  reinstall manually once (see the amendment above).
- Adding another move requires an explicit declaration and review, never inference
  from names.

Source: [docs/decisions/0049-repository-succession.md](https://github.com/jordanhubbard/literate-ai/blob/e797acdd6d8cf7254e38135f90b0421ad3ed4168/docs/decisions/0049-repository-succession.md) at commit `e797acdd`.
