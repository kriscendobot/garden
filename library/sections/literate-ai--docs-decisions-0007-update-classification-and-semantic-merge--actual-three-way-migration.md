---
title: "ADR 0007: Actual three-way migration completion"
source: docs/decisions/0007-update-classification-and-semantic-merge.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: The completion amendment retains digest-bound base bytes, applies clean UTF-8 three-way merges mechanically, and accepts reviewed conflict resolutions only through an exact saved envelope whose identities, paths, text, and transaction remain fail-closed and rollback-safe across consecutive updates.

The original UX-275 migration requirement includes applying clean merges and reviewed
semantic resolutions. The August plan-only implementation did not complete that
requirement. The maintainer requested completion and a release on 2026-09-29.

Initialization retains content-addressed base bytes in `.literate/update-bases.json`.
Updates recover legacy bases from the exact recorded Git revision without checkout,
filters, or hooks, and use recovered bytes only when their digest equals recorded
provenance. Missing or binary bases remain explicit unresolved conflicts. A clean
UTF-8 Git three-way merge is classified `mergeable`, binds its base and result text
into the plan identity, and is included by `--apply`. Planning never writes the project.

Overlapping edits remain conflicts. `--review-conflicts` includes verified base text
and binds every proposed decision to its exact file-plan identity. Operators save the
JSON envelope, review the decisions and merged text, then pass `--apply --resolutions
FILE`. This explicit application supports framework and catalog conflicts alike.
Unknown or duplicate paths, stale identities, malformed decisions, and input drift
fail before writes. Unselected conflicts retain their prior baseline and source.

The transaction advances each accepted path to its upstream bytes as the next base;
it never promotes the merged local overlay to upstream authority. Merged catalog
paths remain local overlays rather than falsely claiming exact import parity.
Files, provenance, lineage, and baseline metadata roll back when validation fails.
Consecutive-update proofs are required alongside clean-merge, overlap, reviewed
resolution, binary/unavailable-base, stale-input, path-safety and rollback tests.
Post-update build/test/receipt qualification remains separately authorized lifecycle
work; successful text merging alone is not application acceptance.

Source: [docs/decisions/0007-update-classification-and-semantic-merge.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0007-update-classification-and-semantic-merge.md) at commit `2820f853` (source lines 145–172).
