---
title: Repository inheritance: precedence, trust boundary, and parent contribution checkouts
source: docs/architecture/repository-inheritance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: Repository inheritance is reusable authority, not remote code execution: the selected repository is more specific than its ancestors, local edits more specific than inherited bytes, and a composite update settles parent catalogs before re-planning the framework scaffold. The lineage cache is only an optimization; exact commits, manifest and lineage-node identities, imported file hashes, and compare-and-swap guards are the durable trust boundary. Contributing to a parent is a separate path: `litai project parent checkout` clones it under the excluded `parents/<id>/` prefix, and changes go back as tracker PRs/MRs, never direct pushes to the parent's default branch.

**Precedence and trust boundary.** Repository inheritance is reusable authority, not remote code execution. The selected repository is more specific than its ancestors; local project edits remain more specific than inherited bytes. The installed framework still owns its packaged scaffold, so a composite update settles parent catalogs first and then re-plans the framework-template half. This preserves parent and local authority when paths overlap.

The repository-lineage cache is only an optimization. Exact commits, manifest content identities, lineage-node identities, imported file hashes, and compare-and-swap guards are the durable trust boundary.

**Parent contribution checkouts.** Lineage resolution never checks out a working tree. Searching a parent, updating it, or filing issues and review requests against it is a different path: run `litai project parent checkout URL[#REVISION]` in the *current* project. That command clones or updates the parent at `parents/<id>/`, initializes submodules, and pulls Git LFS when pointers are present. Do not clone parents into `/tmp` or extra Git worktrees. `parents/` is a working checkout prefix, not catalog authority; it is excluded from the current repository's Git index via `.git/info/exclude`.

Contribute back with the tracker CLI from `litai project tracker inspect` (`gh pr` or `glab mr`) from that checkout. Never push the parent's default branch directly.

Source: [docs/architecture/repository-inheritance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/repository-inheritance.md) at commit `fcc40bc`.
