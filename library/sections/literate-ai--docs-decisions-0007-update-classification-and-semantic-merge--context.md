---
title: "ADR 0007: Context for update classification and semantic merge"
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

> Abstract: A downstream update falsely labeled 33 files as conflicts because it compared catalog-inherited content with an installed scaffold template rather than the resolved parent catalog, while genuine local/upstream/baseline divergence still lacked a framework-assisted semantic resolution path.

- Status: Accepted
- Date: 2026-08-19
- Accepted: 2026-08-28
- Decision owners: literate-ai maintainers
- Roadmap: `UPDATE-CLASSIFICATION-001` (bug fix, no ADR required), `UPDATE-MERGE-001`
  (this ADR's capability)
- Filed from: an anonymized downstream Physics Workbench report,
  [issue #141](https://github.com/NVIDIA-dev/literate-ai/issues/141)

A downstream project (Physics Workbench sample) reparented to Literate AI `v0.5.0` and ran `litai
update --apply`. 33 framework files were classified `conflict` and refused. Manual
inspection showed most of those 33 were **not** real product drift: their local bytes
already matched the parent repository's catalog copy at the resolved tag (`79ba1409`)
byte-for-byte — `litai update` was comparing them against the **installed wheel's
`literate_ai.project_template` init-template snapshot** instead, and that template can
legitimately differ from the same-revision catalog copy (a catalog file changes after
the template that scaffolded a project was captured, without every downstream project
re-running `init`). Byte-identity mismatch against the wrong reference was reported as
an uninterpreted `conflict`, indistinguishable from a project that had genuinely and
deliberately diverged.

Batch-overwriting those 33 files with template bytes would have been actively harmful:
it would downgrade several already-current inherited catalog files to a stale template
snapshot, and it would silently replace real Physics Workbench sample product overlays (`docs/README.md`,
`docs/user/getting-started.md`, `literate.release.json`'s project-specific fields) with
generic scaffold content. The operator's own words, carried over verbatim from the
originating direction: downstream Component/Flavor/skill drift does not always imply
the file is completely divorced from its parent, but it does mean the drift needs
analysis carefully — deciding whether the correct merge outcome favors the parent's
content or the downstream project's — rather than a byte-only overwrite-or-refuse
decision.

This surfaces two distinct problems, one a bug and one a missing capability:

1. **Wrong comparison reference.** `litai update`'s classifier should be comparing
   local bytes against the resolved parent catalog's identity at the update's target
   revision, not the installed wheel's init-template identity, for any file whose
   provenance is catalog-inherited rather than template-scaffolded. This is a
   correctness bug in existing classification logic, not a new capability — it does not
   need its own ADR and is tracked directly as `UPDATE-CLASSIFICATION-001`.
2. **No semantic path for genuine conflicts.** Once the comparison reference is fixed,
   some files will still be genuine three-way conflicts: local overlay vs. newer
   upstream vs. recorded baseline, all three different. Today `litai update` can only
   refuse those and leave a human to resolve them by hand, file by file, with no
   framework-assisted way to ask "does this specific divergence still make sense
   against the new upstream, or should it be reconciled?"

Source: [docs/decisions/0007-update-classification-and-semantic-merge.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0007-update-classification-and-semantic-merge.md) at commit `2820f853` (source lines 1–50).
