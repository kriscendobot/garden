---
title: Monorepo adoption: descriptor custody, consent to execute, and acceptance
source: docs/architecture/monorepo-adoption.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling]
status: current
---

> Abstract: Selection, source, bundle, and receipt reads bind an opened regular-file descriptor to the observed file and recheck custody afterward (no-follow, nonblocking, bounded reads), explicitly not a sandbox against a malicious same-user process; discovery never authorizes movement, a refined plan applies only with an explicit `--run-baseline` consent plus acknowledgement of the exact reviewed plan identity, and only a real multi-root first-change journey can close #365.

Selection, source, bundle, and receipt reads bind an opened regular-file descriptor to the observed named file before consuming bytes and recheck custody afterward. On platforms that provide them, no-follow and nonblocking open flags prevent a last-moment symlink or FIFO replacement from being followed or blocking the reader. Source hashing reads at most the initial observed size plus one detection byte; documents retain their existing size limits. Replacement, size/mode/time drift, or indirect ancestors refuse without publishing a successful observation. These checks do not constitute a sandbox against a malicious same-user process. Only a disposable directory created by the harness is canonicalized through host temporary-directory aliases; operator-supplied input paths are not silently resolved around these checks.

Candidate discovery and selection review do not authorize movement. A refined plan is applicable only when the operator also selects `--run-baseline`, which is explicit consent to execute every declared Component harness in a disposable retained-source copy before the first conversion mutation. Apply still requires acknowledgement and the exact reviewed onboarding plan identity. The mutator revalidates the reviewed identity, requires one passing retained receipt per Component, preserves the shared source layout and original Git history, and publishes source-free Component projections after the ordinary retained-wrapper lift-and-shift.

Acceptance requires a real multi-root first-change journey with independent Components, original commands, distinct receipt invalidation, and rollback. Planner unit tests alone cannot close #365 or qualify a 1.1 release.

Source: [docs/architecture/monorepo-adoption.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/monorepo-adoption.md) at commit `fcc40bc`.
