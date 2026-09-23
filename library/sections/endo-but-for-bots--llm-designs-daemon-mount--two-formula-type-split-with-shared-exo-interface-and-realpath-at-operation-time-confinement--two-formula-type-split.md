---
source: designs/daemon-mount.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-mount.md
source_path: designs/daemon-mount.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - patterns
genre: §endo-but-for-bots-design
cycle: 166
lane: designs
status: current
title: §Two-formula-type-split
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

```ts
type MountFormula = {
  type: 'mount';
  path: string;
  readOnly: boolean;
  parent?: FormulaIdentifier;
};

type ScratchMountFormula = {
  type: 'scratch-mount';
  readOnly: boolean;
  parent?: FormulaIdentifier;
};
```

§Mount captures an §absolute-host-path; §scratch-mount
captures §only-the-formula-number (backing path derived as
`{statePath}/mounts/{formulaNumber}`).

§Design-Decision-1: §two-formula-types-rather-than-one.
§Rationale: different §lifecycle-semantics — user-managed-
path vs daemon-managed-storage-with-GC-cleanup. §Separate-
formula-types-make-this-explicit-in-the-formula-store and
§avoid-conditional-logic-for-does-this-mount-own-its-
directory.

§Both-share-the-same-exo-interface-and-implementation. The
only difference is §how-the-mount-root-path-is-derived.
§Implementation-symmetry-but-lifecycle-asymmetry observation.
