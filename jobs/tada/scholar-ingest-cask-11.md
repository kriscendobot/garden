# scholar-ingest-cask-11 done (cask ingest cycle 12)

Ingested the cask membership sub-cluster. 3 sources / 7 sections, 2 new concepts, 2 updated concepts, all indexes bumped. CAS-pushed to journal2 (verified landed). Follow-on `scholar-ingest-cask-12` posted for the blob/root/nursery/verbs + meta + comment-fragment remainder.

## Sources ingested

- `cask--membertable-design` (2 sections): structure-and-operations; cli-root-and-server-integration.
- `cask--membership-next-steps` (3 sections): three-gate-access-model; membership-mvp-roadmap; capability-gated-read-write.
- `cask--cluster-provisioning` (2 sections): problem-and-prior-ssh-approach; prerequisites-and-future-design.

All at file-commit `cdb975d8` (idempotency-checked; none previously ingested).

## Concepts

- New: `cask-three-gate-access`, `cask-cluster-provisioning`.
- Updated: `member-table-authorization` (+3 section rows, ~14 aliases, +4 see-also), `cask-caskhead-root` (+1 section row).

## Indexes

- topics: networking +7 (29→36), capability-security +5 (174→179), content-addressed-storage +2 (63→65), data-structures +1 (51→52).
- sources/README +3, concepts/README +2, keywords.md +41 lines.

## Corpus state

cask: 32 sources / 140 sections.

Result entry: `journal/entries/2026/06/25/001705Z-result-scholar-c12a4f.md`.

Self-improvement: nothing this time.
