Confirmed: no PR opened. The impasse is surfaced to the maintainer with a decision-ready A/B choice. This is the correct terminal state for a builder facing contradictory architecture signals — proceeding either way would produce superseded or shape-incompatible work.

## Completion report

**Job:** Build the `snapshot-mapper` design (daemon-worker import-from-mount stack, M3) in `endojs/endo-but-for-bots`.

**Outcome: BLOCKED at an architecture impasse — surfaced to the maintainer, no PR opened.**

**What I did**
- Read `designs/snapshot-mapper.md` and traced the intended stack (registry-capability → mvs-resolver → snapshot-mapper).
- Found an existing daemon implementation on `build/snapshot-mapper` (`mapSnapshot`, `makeMountReadPowers`, a compartment-mapper `dependencyLocationHook` extension point, tests). Rebased it onto `origin/build/mvs-resolver` and **verified it end-to-end**: 2 map-snapshot tests, 12 registry-mvs tests, 905 compartment-mapper tests (+12 known failures) pass; prettier clean; eslint 0 errors; `tsc` clean for both packages. Also aligned the changeset to include `@endo/daemon` and reset authorship to the bot identity.
- Before opening a PR, ran the builder's design-drift pre-flight and uncovered a three-way contradiction (below), so I stopped rather than build against either side.

**Why blocked — the discrepancy**
1. **`@endo/exo-npm` (endojs/endo-but-for-bots#403, OPEN, stalled 2026-06-29)** consolidates registry + mvs + snapshot-mapper and **already contains a complete, maintainer-reviewed 424-line `snapshot-mapper.js`** (solving the workspace-member-bytes case). This is the home the old daemon PR was closed in favor of.
2. **`@endo/daemon` (endojs/endo-but-for-bots#671, gauntleted TODAY)** lands registry + mvs-resolver but **has no snapshot-mapper**, and its `RegistryResolution` shape (`{name,version,treeRef,integrity}`; workspace members keyed `name@version` with `treeRef:undefined`; no `packageJson`/`workspace` flag; flattened diagnostics) is **incompatible** with the daemon snapshot-mapper design.
3. The old daemon snapshot-mapper (endojs/endo-but-for-bots#565) was **closed as superseded**; its mvs-resolver sibling (#564) too.

The design doc says daemon; the recorded #565→#403 decision says exo-npm; but exo-npm stalled while the daemon registry path was revived today with a shape the daemon design doesn't fit. Choosing the package boundary and resolution shape is a maintainer decision, not a builder's.

**Sent to maintainer** (`inbox/maintainer` 20260711T155204Z-924e58): a decision-ready A/B — **(A)** un-stall/refresh #403's already-complete exo-npm snapshot-mapper (my recommendation), or **(B)** build a daemon snapshot-mapper stacked on #671, which requires extending that PR's just-gauntleted resolution shape.

**Follow-ups**
- Awaiting maintainer's A/B; their reply will spawn a fresh, correctly-scoped job.
- Left `build/snapshot-mapper` rebased onto current `origin/build/mvs-resolver` (no open PR references it; #565 is closed). Harmless; can be discarded or reused depending on the decision.
