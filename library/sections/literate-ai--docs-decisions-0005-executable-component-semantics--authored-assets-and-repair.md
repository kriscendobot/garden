---
title: "ADR 0005: Authored assets and fresh-workspace repair"
source: docs/decisions/0005-executable-component-semantics.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Authored binary assets remain content-locked authorized overlays outside the model-writable text tree, and each bounded repair attempt starts in a fresh empty workspace that replaces the whole generated tree rather than patching accepted output or learning hidden state from a failed candidate.

An `AuthoredBinaryAsset` is a content-locked blob with a portable destination path,
target identity, role, and authorization identity. It is assembled as an immutable
overlay after generation and is never placed in the model-writable generated-text tree.
This applies to images, fonts, fixtures, archives, and any other authored bytes.

Repair also preserves the authority boundary. A failed generation candidate may be
retained only as external runtime evidence. A repair attempt starts in a fresh empty
workspace and replaces the complete generated tree; it never patches the accepted tree
in place or learns hidden state from a failed candidate. The contract bounds repairs to
zero, one, or two attempts. Authored assets are overlaid unchanged on each candidate.

Source: [docs/decisions/0005-executable-component-semantics.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0005-executable-component-semantics.md) at commit `fcc40bc` (source lines 97–108).
