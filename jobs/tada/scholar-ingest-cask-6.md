# scholar-ingest-cask-6 (cask cycle 7) — done

Ingested kriskowal/cask `doc/design/cell-capabilities.md` (906 lines, the corpus's
largest doc; a full cycle on its own) at file-commit cdb975d8 (idempotency-checked,
not previously ingested).

Sources ingested: 1 (cell-capabilities.md → 11 sections).
Sections added: 11 (overview-and-background, information-hiding-and-honest-attenuations,
cas-couples-read-and-write, entry-type-is-the-capability, cell-path-descriptor-format,
blob-and-directory-types, cell-types-direct-and-indirect, content-model-changes,
command-vocabulary-and-examples, relationship-to-capability-map,
implementation-plan-and-open-questions).
Concepts added: 2 (cask-entry-type-capability, cask-cell-path-descriptor).
Indexes updated: sources/README.md (+1 row), topics/content-addressed-storage.md (+8),
topics/capability-security.md (+9), topics/data-structures.md (+2),
concepts/README.md (+2), keywords.md (+26 lines).

Lineage judgment: co-current lineage sibling of cells.md / cells-and-entries.md (entry
types are the structural+local capability layer; cells.md/ocaps.md the cryptographic+
network token layer; they compose as an intersection). No supersessions.

Library writes + result entry CAS-pushed to journal2 (commit 093a76d3).
Follow-on posted: scholar-ingest-cask-7 (next pick ocaps.md + caskroot-design.md).

Self-improvement: nothing structural. Sandbox note: gh repo clone --no-checkout failed
to init .git/config here; git clone --no-checkout --filter=blob:none is the reliable
sparse-scratch recipe. Also: check the push exit code directly, not piped through tail.
