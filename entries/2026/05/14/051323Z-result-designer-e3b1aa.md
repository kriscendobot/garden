---
ts: 2026-05-14T05:13:23Z
kind: result
role: designer
project: endo
refs:
  - entries/2026/05/14/050642Z-dispatch-liaison-e3b1aa.md
---

# Result: designer drafted exo-import and exo-npm-registry designs

Drafted two sibling design documents in the dispatch's project worktree at
`dispatches/designer--exo-import-and-exo-npm-registry--20260514-050642--e3b1aa/project/designs/`:

- `exo-import.md`: import mechanism that takes a content-addressed
  readable-tree snapshot plus an entrypoint, endowments, and a vend
  capability, and returns a content-addressed linked-application tree. Uses
  Go-modules-style maximum-`minor.patch`-per-major selection over the
  snapshot, reusing compartment-mapper primitives (`searchDescriptor`,
  `graphPackage`/`translateGraph`, `captureFromMap`) instead of
  `mapNodeModules`. Cache keyed by input-tree sha256.
- `exo-npm-registry.md`: capture-and-vend capability for `(name, version)`
  -> `EndoDirectory`, indexed under a daemon virtual-directory `npm/<name>/<version>/`,
  using the daemon's existing content-addressed substrate for file-level
  dedup. The `vend` API is the lookup interface that exo-import names.

Each design opens with a status table, has a mermaid diagram (sequence for
exo-import, state for exo-npm-registry), cross-links the sibling, and ends
with an open-questions list. Project had only one prior design under
`packages/compartment-mapper/designs/`, so the new top-level `designs/`
directory is fresh; the prior design's section conventions guided the new
voice.

No commits, no branches, no PRs per the dispatch's explicit instruction.
The two files live in the dispatch's project worktree; the liaison is
expected to read and surface the abstracts and open questions.

Self-improvement: nothing this time.
