---
ts: 2026-05-22T05:00:04Z
kind: result
role: designer
project: endo-but-for-bots
refs:
  - entries/2026/05/22/044847Z-dispatch-liaison-68b800.md
---

# Result: designer drafts daemon-worker-import-from-mount

## Deliverables

- **PR**: <https://github.com/endojs/endo-but-for-bots/pull/358> (DRAFT, base `llm`, head `design/daemon-worker-import-from-mount`).
- **Head SHA**: `9ac8f99c6229327056b4769d2efdece5dc82b298`.
- **Design file**: `designs/daemon-worker-import-from-mount.md` (~410 lines).
- **README sync**: new summary-table row, M1 milestone assignment with M-L (1.5-2 weeks) size estimate, Capability System dependency-graph nodes/edges to `daemon-mount`, `daemon-mount-capabilities`, `daemon-make-archive`, `endor-npm-registry-proxy`, `endor-run-expanded`, `daemon-cas-management`. Totals updated to 21 Proposed / 126 designs and M1 remaining-items from 10 to 11.

## Sibling vs supersede decision

**Sibling**, not supersedor. Rationale: `daemon-make-archive` § Phase 7 (`makeFromTree`) handles trees whose root is `compartment-map.json` (closed-world, pre-resolved). The new design (`makeFromPackage`) handles trees whose root is `package.json` and drives resolution through `@registry` before the worker runs. The two cases converge inside `compartment-mapper` with a synthesised `ReadPowers`; the difference is whether the package graph arrives pre-walked (Phase 7) or is walked at start time (new design). Adding a `Superseded by` link to Phase 7 would overstate the relationship since both methods land on the same worker bootstrap with different `ReadPowers` and different resolution pre-steps.

## Chosen API name

`makeFromPackage(workerPetName, mountName, options)`. Follows the source-shape naming convention established by `daemon-make-archive.md` § Phase 7 (`makeArchive` / `makeFromTree` / `makeUnconfined` / `makeUnconfinedFromTree`). The distinguishing axis is what kind of root manifest the source carries: ZIP archive / `compartment-map.json` tree / `package.json` tree / filesystem path.

## Four key design decisions

1. **Snapshot the mount before resolution, not live read.** Running modules against a live filesystem produces subtle bugs (a partially-written file mid-import surfaces as an opaque syntax error). The snapshot-before-import pattern is already established in `daemon-make-archive.md` § Phase 8 for the unconfined Node bridge; reusing it here keeps the lifetime contract uniform across all `make*` shapes. Cost is one tree-walk per invocation, same as `makeArchive` already incurs.
2. **Eager resolution, not lazy per-import.** `EndoRegistry.resolve` returns the full transitive closure of selected packages before the worker begins `importLocation`. Per-import lazy resolution would add one bus round-trip per imported package and defeat the resolution-hash cache key for `makeMountReadPowers`. Also matches the Rust-side `endor run` flow where the compartment-mapper walks once and the import hook then reads by hash.
3. **MVS-then-lockfile, not lockfile-then-MVS.** When a `package-lock.json` (or `yarn.lock`) is present, MVS is constrained to its versions; when absent, MVS runs freely. Lockfile is consultative not authoritative: the resolver still validates each `(name, version, integrity)` against the configured registry; a tampered lockfile fails cleanly. Composes with `--offline` so a lockfile makes offline runs deterministic without a separate "frozen" flag.
4. **`@registry` is host-scoped, required field on `HostFormula`** (following the `@node` precedent from `daemon-make-archive.md` § Phase 6). Each host carries a `registry` field populated at formulation time from a daemon-default capability; the host's owner can swap the registry (e.g., to point at a private mirror) without re-formulating the host. Guests do not see `@registry` directly; a guest that needs a package goes through the host.

## Open questions surfaced

Six in the design: (1) per-condition resolution (`import`/`browser`/`endo` conditions on `package.json#exports`); (2) workspace-protocol (`workspace:^`) resolution against the entry mount; (3) private-registry credentials, daemon-wide vs per-host (composes with the `endo-gateway` multi-tenant story); (4) `peerDependencies` and `optionalDependencies` enforcement vs the silent-ignore default the Rust side currently has; (5) `makeMountReadPowers` cache ownership keyed by `resolutionHash`; (6) re-resolution on mid-run lockfile change (out of scope here; track on the agent-tooling roadmap).

## Phased implementation

Six phases inside the design:
- Phase 1: `EndoRegistry` capability and `@registry` special name.
- Phase 2: `makeMountReadPowers` and worker dispatch.
- Phase 3: `makeFromPackage` host method and CLI (`endo run <mount>`).
- Phase 4: Snapshot-before-import with caplet-scoped lifetime.
- Phase 5: Lockfile honoring (MVS-then-lockfile semantics).
- Phase 6: XS-hosted compartment-mapper (deferred; tracked under `endor-run-expanded.md` § Phase 4/5).

## Self-improvement

`Self-improvement: nothing this time.` The dispatch brief was precise about the four prior designs to read and the sibling-vs-supersede decision the designer had to make, which made the synthesis efficient. One small operational note: the dispatch named a journal entry path that did not yet exist when the subagent started (the dispatch-prepare timing race; the dispatch journal entry was being written by the liaison in parallel), so the subagent could not read it. The other context the dispatch reproduced inline (the four prior designs, the 14-section structural breakdown) compensated. Future dispatch prompts that reference journal entries by exact path could either inline the salient contents or accept that the entry may not yet be readable to the just-dispatched subagent.
