---
title: "ADR 0049: Repository-move continuity gap"
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

> Abstract: A sanitized move from an internal predecessor to a public successor leaves projects, installed self-updaters, contributor remotes, and historical tags pointing at different repository identities.

Literate AI moved from the internal `NVIDIA-dev/literate-ai` repository, now archived,
to the public `jordanhubbard/literate-ai` repository. The public repository starts from
a sanitized single-root snapshot; no earlier history or tags were copied.

Existing users carry the old location in three places:

- Projects record their initializing framework origin in
  `.literate/initialization-origin.json`. Update planning refuses an installed framework
  whose origin is a different repository (`project.update_origin_changed`).
- Self-update derives its release endpoint from the installed wheel's embedded origin.
  Releases 1.0.x instead hard-code
  `https://api.github.com/repos/NVIDIA-dev/literate-ai/releases/latest`.
- Contributor clones point at the old remote and hold the old tags.

Treating any two repositories as equivalent would weaken the origin check. Rewriting
recorded origins would destroy provenance.

Source: [docs/decisions/0049-repository-succession.md](https://github.com/jordanhubbard/literate-ai/blob/e797acdd6d8cf7254e38135f90b0421ad3ed4168/docs/decisions/0049-repository-succession.md) at commit `e797acdd`.
